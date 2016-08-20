unit uParseManager;

{$I ..\Include\IntXLib.inc}

interface

uses
  SysUtils,
  uIParser,
  uEnums,
  uPow2Parser,
  uClassicParser,
  uFastParser,
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Used to retrieve needed parser.
  /// </summary>

  TParseManager = class sealed(TObject)

  public
    /// <summary>
    /// Constructor.
    /// </summary>
    class constructor Create();

    /// <summary>
    /// Returns parser instance for given parse mode.
    /// </summary>
    /// <param name="mode">Parse mode.</param>
    /// <returns>Parser instance.</returns>
    /// <exception cref="EArgumentOutOfRangeException"><paramref name="mode" /> is out of range.</exception>

    class function GetParser(mode: TParseMode): IIParser;

    /// <summary>
    /// Returns current parser instance.
    /// </summary>
    /// <returns>Current parser instance.</returns>

    class function GetCurrentParser(): IIParser;

  class var
    /// <summary>
    /// Classic parser instance.
    /// </summary>

    FClassicParser: IIParser;

    /// <summary>
    /// Fast parser instance.
    /// </summary>

    FFastParser: IIParser;

  end;

implementation

// static class constructor
class constructor TParseManager.Create();
var
  Pow2Parser: IIParser;
  mclassicParser: IIParser;
begin
  // Create new pow2 parser instance
  Pow2Parser := TPow2Parser.Create();

  // Create new classic parser instance
  mclassicParser := TClassicParser.Create(Pow2Parser);

  // Fill publicity visible parser fields
  FClassicParser := mclassicParser;
  FFastParser := TFastParser.Create(Pow2Parser, mclassicParser);
end;

class function TParseManager.GetParser(mode: TParseMode): IIParser;
begin
  case (mode) of
    TParseMode.pmFast:
      begin
        result := FFastParser;
        Exit;
      end;
    TParseMode.pmClassic:
      begin
        result := FClassicParser;
        Exit;
      end
  else
    begin
      raise EArgumentOutOfRangeException.Create('mode');
    end;
  end;
end;

class function TParseManager.GetCurrentParser(): IIParser;
begin
  result := GetParser(TIntX.GlobalSettings.ParseMode);
end;

end.
