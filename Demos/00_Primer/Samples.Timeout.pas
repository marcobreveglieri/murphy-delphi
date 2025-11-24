unit Samples.Timeout;

interface

procedure RunTimeoutSample;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.TimeSpan,
  Murphy.Policy.Timeout;

procedure RunTimeoutSample;
begin
  Writeln('=== Timeout Policy Sample ===');
  Writeln;

  // Example 1: Operation that completes before timeout
  Writeln('Example 1: Fast operation (should complete)');
  try
    TTimeoutBuilder.Handle([ETimeoutRejectedException])
      .After(TTimeSpan.FromSeconds(3))
      .Execute(
        procedure
        begin
          Writeln('Executing fast operation...');
          TThread.Sleep(500); // 500ms operation
          Writeln('Operation completed successfully!');
        end
      );
  except
    on E: ETimeoutRejectedException do
      Writeln('Timeout occurred: ', E.Message);
  end;

  Writeln;

  // Example 2: Operation that exceeds timeout
  Writeln('Example 2: Slow operation (should timeout)');
  try
    TTimeoutBuilder.Handle([ETimeoutRejectedException])
      .After(TTimeSpan.FromSeconds(2))
      .OnTimeout(
        procedure(AContext: TTimeoutContext)
        begin
          Writeln('*** Timeout callback executed ***');
          Writeln('Configured timeout: ', AContext.TimeoutDuration.TotalSeconds:0:2, ' seconds');
          Writeln('Elapsed time: ', AContext.ElapsedTime.TotalSeconds:0:2, ' seconds');
        end)
      .Execute(
        procedure
        begin
          Writeln('Executing slow operation...');
          TThread.Sleep(5000); // 5 seconds operation
          Writeln('This should not be printed!');
        end
      );
  except
    on E: ETimeoutRejectedException do
      Writeln('Timeout exception raised: ', E.Message);
  end;

  Writeln;

  // Example 3: Simulating a long-running database query
  Writeln('Example 3: Simulated database query with timeout');
  try
    var LQueryResult := '';
    TTimeoutBuilder.Handle([ETimeoutRejectedException])
      .After(TTimeSpan.FromMilliseconds(1500))
      .OnTimeout(
        procedure(AContext: TTimeoutContext)
        begin
          Writeln('Database query timed out after ',
                  AContext.ElapsedTime.TotalMilliseconds:0:0, 'ms');
        end)
      .Execute(
        procedure
        begin
          Writeln('Executing database query...');
          // Simulate a slow database query
          TThread.Sleep(2000);
          LQueryResult := 'Query results';
        end
      );
    Writeln('Query result: ', LQueryResult);
  except
    on E: ETimeoutRejectedException do
      Writeln('Could not complete query within timeout period');
  end;

  Writeln;
  Writeln('=== End of Timeout Sample ===');
end;

end.
