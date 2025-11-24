program Murphy.Demos.Primer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Samples.Retry in 'Samples.Retry.pas',
  Samples.CircuitBreaker in 'Samples.CircuitBreaker.pas',
  Samples.Fallback in 'Samples.Fallback.pas',
  Samples.RateLimit in 'Samples.RateLimit.pas',
  Samples.Timeout in 'Samples.Timeout.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  try

    while True do
    begin
      Writeln('--------------------');
      Writeln('C) Circuit Breaker');
      Writeln('F) Fallback');
      Writeln('L) Rate Limit');
      Writeln('R) Retry');
      Writeln('T) Timeout');
      Writeln('             Q) quit');
      Writeln('--------------------');
      Writeln;

      var LInput: string;
      Readln(LInput);

      var LCommand := UpperCase(LInput);

      if Length(LCommand) <= 0 then
        Continue;

      if LCommand = 'Q' then
        Break;

      Writeln;
      Writeln;

      case LCommand.Chars[0] of
        'C': RunCircuitBreakerSample;
        'F': RunFallbackSample;
        'L': RunRateLimitSample;
        'R': RunRetrySample;
        'T': RunTimeoutSample;
      end;

    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Writeln;
  Writeln('Press enter to end...');
  Readln;
end.
