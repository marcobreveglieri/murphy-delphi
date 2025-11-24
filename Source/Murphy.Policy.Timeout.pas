unit Murphy.Policy.Timeout;

interface

uses
  System.Classes,
  System.SysUtils,
  System.TimeSpan,
  System.Threading,
  Murphy.Base.Policy;

type

{ ETimeoutRejectedException }

  /// <summary>
  ///  Exception raised when an operation exceeds its timeout duration.
  /// </summary>
  ETimeoutRejectedException = class(Exception);

{ TTimeoutContext }

  /// <summary>
  ///  Contains information about the timeout that occurred,
  ///  including elapsed time and configured timeout duration.
  /// </summary>
  TTimeoutContext = class(TObject)
  private
    FElapsedTime: TTimeSpan;
    FTimeoutDuration: TTimeSpan;
  public
    property ElapsedTime: TTimeSpan read FElapsedTime;
    property TimeoutDuration: TTimeSpan read FTimeoutDuration;
  end;

{ ITimeoutPolicy }

  /// <summary>
  ///  Represents the interface of the "Timeout" policy pattern.
  /// </summary>
  ITimeoutPolicy = interface(IPolicy)
    ['{8B3E9F12-4A7C-4D1E-9B5A-2E8C7F6D4A91}']
    procedure Execute(AProc: TProc);
    function After(ADuration: TTimeSpan): ITimeoutPolicy;
    function OnTimeout(ACallback: TProc<TTimeoutContext>): ITimeoutPolicy;
  end;

{ TTimeoutPolicy }

  /// <summary>
  ///  Represents the concrete implementation of "Timeout" policy pattern.
  /// </summary>
  TTimeoutPolicy = class(TPolicy, ITimeoutPolicy)
  private
    FTimeoutDuration: TTimeSpan;
    FOnTimeoutCallback: TProc<TTimeoutContext>;
  public
    constructor Create(AExceptionTypes: TArray<ExceptClass>); override;
    procedure Execute(AProc: TProc);
    function After(ADuration: TTimeSpan): ITimeoutPolicy;
    function OnTimeout(ACallback: TProc<TTimeoutContext>): ITimeoutPolicy;
  end;

{ TTimeoutBuilder }

  /// <summary>
  ///  Represents an helper to create "Timeout" policy instances.
  /// </summary>
  TTimeoutBuilder = class sealed (TPolicyBuilder<ITimeoutPolicy>)
  public
    class function Handle(AExceptionTypes: TArray<ExceptClass>): ITimeoutPolicy; override;
  end;

implementation

uses
  Murphy.Services.Schedulers,
  Murphy.Resources.Strings;

{ TTimeoutPolicy }

constructor TTimeoutPolicy.Create(AExceptionTypes: TArray<ExceptClass>);
begin
  inherited Create(AExceptionTypes);
  FTimeoutDuration := TTimeSpan.FromSeconds(30);
end;

procedure TTimeoutPolicy.Execute(AProc: TProc);
begin
  var LStartTime := Scheduler.Now;
  var LExceptionObj: TObject := nil;
  var LTaskCompleted := False;
  var LTask := TTask.Create(
    procedure
    begin
      try
        AProc;
        LTaskCompleted := True;
      except
        on E: Exception do
        begin
          // Acquire the exception object (takes ownership)
          LExceptionObj := AcquireExceptionObject;
          // Don't re-raise - let the task complete normally
        end;
      end;
    end);
  try
    LTask.Start;

    // Poll task completion with timeout monitoring
    var LPollInterval := TTimeSpan.FromMilliseconds(100);
    while LTask.Status <> TTaskStatus.Completed do
    begin
      // Calculate elapsed time and convert to TTimeSpan
      var LElapsedDays := Scheduler.Now - LStartTime;
      var LElapsedTime := TTimeSpan.FromDays(LElapsedDays);

      // Check if timeout has been exceeded
      if LElapsedTime.TotalMilliseconds > FTimeoutDuration.TotalMilliseconds then
      begin
        // Execute timeout callback if assigned
        if Assigned(FOnTimeoutCallback) then
        begin
          var LContext := TTimeoutContext.Create;
          try
            LContext.FElapsedTime := LElapsedTime;
            LContext.FTimeoutDuration := FTimeoutDuration;
            FOnTimeoutCallback(LContext);
          finally
            LContext.Free;
          end;
        end;

        // Free the exception object if captured (we're not re-raising it)
        if Assigned(LExceptionObj) then
          LExceptionObj.Free;

        // Raise timeout exception
        raise ETimeoutRejectedException.Create(StrErrTimeoutExceeded);
      end;

      // Wait before next poll
      Scheduler.WaitFor(LPollInterval);
    end;

    // Task completed - check if there was an exception
    if Assigned(LExceptionObj) then
    begin
      // Re-raise the task exception
      // Note: Handle() filtering is not applied to timeout monitoring itself,
      // only to exceptions that emerge from the operation
      raise LExceptionObj;
    end;

  finally
    // Task cleanup is handled automatically by reference counting
  end;
end;

function TTimeoutPolicy.After(ADuration: TTimeSpan): ITimeoutPolicy;
begin
  FTimeoutDuration := ADuration;
  Result := Self;
end;

function TTimeoutPolicy.OnTimeout(ACallback: TProc<TTimeoutContext>): ITimeoutPolicy;
begin
  FOnTimeoutCallback := ACallback;
  Result := Self;
end;

{ TTimeoutBuilder }

class function TTimeoutBuilder.Handle(AExceptionTypes: TArray<ExceptClass>): ITimeoutPolicy;
begin
  Result := TTimeoutPolicy.Create(AExceptionTypes);
end;

end.
