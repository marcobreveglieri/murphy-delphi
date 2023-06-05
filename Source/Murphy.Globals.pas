unit Murphy.Globals;

interface

var
  /// <summary>
  ///  This flag can be set to enable test mode.
  /// </summary>
  /// <remarks>
  ///  When test mode is enabled, all the services
  ///  are replaced by virtual (or mocked) instances.
  /// </remarks>
  MurphyTestModeEnabled: Boolean;

implementation

initialization

  MurphyTestModeEnabled := False;

end.
