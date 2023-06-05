unit Murphy.Services.Schedulers;

interface

uses
  System.TimeSpan;

type

{ IScheduler }

  IScheduler = interface
    ['{B34F083C-F7B9-4439-8656-ED7C8B0CD54F}']
    function Now: TDateTime;
    procedure WaitFor(const ATimeSpan: TTimeSpan);
  end;

{ Routines }

  function Scheduler: IScheduler;

implementation

uses
  System.Classes,
  System.DateUtils,
  System.SysUtils,
  Murphy.Globals;

type

{ TConcreteScheduler }

  /// <summary>
  ///  Represents a concrete implementation of scheduler service.
  /// </summary>
  TConcreteScheduler = class (TInterfacedObject, IScheduler)
  public
    function Now: TDateTime;
    procedure WaitFor(const ATimeSpan: TTimeSpan);
  end;

{ TTestScheduler }

  /// <summary>
  ///  Represents a test mocked implementation of scheduler service.
  /// </summary>
  TTestScheduler = class (TInterfacedObject, IScheduler)
  public
    function Now: TDateTime;
    procedure WaitFor(const ATimeSpan: TTimeSpan);
  end;

{ TConcreteScheduler }

function TConcreteScheduler.Now: TDateTime;
begin
  Result := TDateTime.Now;
end;

procedure TConcreteScheduler.WaitFor(const ATimeSpan: TTimeSpan);
begin
  var LMilliseconds := Trunc(ATimeSpan.TotalMilliseconds);
  TThread.Sleep(LMilliseconds);
end;

{ TTestScheduler }

function TTestScheduler.Now: TDateTime;
begin
  Result := EncodeDateTime(1900, 1, 1, 0, 0, 0, 0);
end;

procedure TTestScheduler.WaitFor(const ATimeSpan: TTimeSpan);
begin
  // No action.
end;

{ Routines }

function Scheduler: IScheduler;
begin
  if MurphyTestModeEnabled then
    Result := TTestScheduler.Create
  else
    Result := TConcreteScheduler.Create;
end;

end.
