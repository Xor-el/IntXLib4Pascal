unit uStringConvertManager;

{$I ..\Include\IntXLib.inc}

interface

uses
  uIStringConverter,
  uEnums,
  uClassicStringConverter,
  uFastStringConverter,
  uPow2StringConverter,
  uIntXLibTypes;

type
  /// <summary>
  /// Used to retrieve needed ToString converter.
  /// </summary>

  TStringConvertManager = class sealed(TObject)

  public
    /// <summary>
    /// Constructor.
    /// </summary>
    class constructor Create();

    /// <summary>
    /// Returns ToString converter instance for given ToString mode.
    /// </summary>
    /// <param name="mode">ToString mode.</param>
    /// <returns>Converter instance.</returns>
    /// <exception cref="EArgumentOutOfRangeException"><paramref name="mode" />is out of range.</exception>

    class function GetStringConverter(mode: TToStringMode)
      : IIStringConverter; static;

  class var

    /// <summary>
    /// Classic converter instance.
    /// </summary>
    FClassicStringConverter: IIStringConverter;

    /// <summary>
    /// Fast converter instance.
    /// </summary>
    FFastStringConverter: IIStringConverter;

  end;

implementation

// static class constructor
class constructor TStringConvertManager.Create();
var
  Pow2StringConverter: IIStringConverter;
  mclassicStringConverter: IIStringConverter;
begin
  // Create new pow2 converter instance
  Pow2StringConverter := TPow2StringConverter.Create;

  // Create new classic converter instance
  mclassicStringConverter := TClassicStringConverter.Create
    (Pow2StringConverter);

  // Fill publicity visible converter fields
  FClassicStringConverter := mclassicStringConverter;
  FFastStringConverter := TFastStringConverter.Create(Pow2StringConverter,
    mclassicStringConverter);
end;

class function TStringConvertManager.GetStringConverter(mode: TToStringMode)
  : IIStringConverter;
begin
  case (mode) of
    TToStringMode.tsmFast:
      begin
        result := FFastStringConverter;
        Exit;
      end;
    TToStringMode.tsmClassic:
      begin
        result := FClassicStringConverter;
        Exit;
      end
  else
    begin
      raise EArgumentOutOfRangeException.Create('mode');
    end;

  end;
end;

end.
