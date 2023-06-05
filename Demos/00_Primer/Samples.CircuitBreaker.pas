unit Samples.CircuitBreaker;

interface

procedure RunCircuitBreakerSample;

implementation

uses
  System.IOUtils,
  System.SysUtils,
  System.TimeSpan,
  System.Rtti,
  Murphy.Policy.CircuitBreaker;

procedure RunCircuitBreakerSample;
begin
  var LCounter := 0;

  var LPolicy := TCircuitBreakerBuilder
    .Handle(ENotImplemented)
    .Fail(2)
    .Within(TTimeSpan.FromSeconds(5));

  while LCounter < 100 do
  begin

    Inc(LCounter);
    Writeln('Tentativo n. ', LCounter);
    Writeln('Stato before:', TRttiEnumerationType.GetName<TCircuitState>(LPolicy.CircuitState));

    try
      LPolicy.Execute(
        procedure
        begin
          Writeln('Stato middle:', TRttiEnumerationType.GetName<TCircuitState>(LPolicy.CircuitState));
          if LCounter < 3 then
            raise ENotImplemented.Create('Not implemented');
          Writeln('Eseguito  n. ', LCounter);
        end
      );
    except on E: Exception do
      Writeln('E: ', E.Message);
    end;

    Writeln('Stato after :', TRttiEnumerationType.GetName<TCircuitState>(LPolicy.CircuitState));

    if (LCounter > 10) then
      LPolicy.Isolate;

    Sleep(1000);
    Writeln('------------');
  end;
end;

end.
