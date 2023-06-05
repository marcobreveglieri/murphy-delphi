unit Samples.Fallback;

interface

procedure RunFallbackSample;

implementation

uses
  System.IOUtils,
  System.SysUtils,
  System.TimeSpan,
  System.Rtti,
  Murphy.Policy.Fallback;

procedure RunFallbackSample;
begin
  var LPolicy := TFallbackBuilder<string>
    .Handle(ENotImplemented)
    .Fallback(
      function (): string
      begin
        Result := 'default';
      end
    );

  var LResult: string;

  LResult := LPolicy.Execute(
    function (): string
    begin
      Result := 'Valid!';
    end
  );

  Writeln(LResult);


  LResult := LPolicy.Execute(
    function (): string
    begin
      Result := 'Invalid!';
      raise ENotImplemented.Create('This time we get the default value');
    end
  );

  Writeln(LResult);



  LResult := LPolicy.Execute(
    function (): string
    begin
      Result := 'Valid again!';
    end
  );

  Writeln(LResult);


  LResult := LPolicy.Execute(
    function (): string
    begin
      Result := 'A new exception...';
      raise ENotSupportedException.Create('This time we get an exception...');
    end
  );

  Writeln(LResult);
end;

end.
