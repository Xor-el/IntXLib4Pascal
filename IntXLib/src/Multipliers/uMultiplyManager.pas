unit uMultiplyManager;

{$I ..\Include\IntXLib.inc}

interface

uses
  uIMultiplier,
  uClassicMultiplier,
  uAutoFhtMultiplier,
  uEnums,
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Used to retrieve needed multiplier.
  /// </summary>

  TMultiplyManager = class sealed(TObject)

  public
    /// <summary>
    /// Constructor.
    /// </summary>
    class constructor Create();

    /// <summary>
    /// Returns multiplier instance for given multiply mode.
    /// </summary>
    /// <param name="mode">Multiply mode.</param>
    /// <returns>Multiplier instance.</returns>
    /// <exception cref="EArgumentOutOfRangeException"><paramref name="mode" /> is out of range.</exception>

    class function GetMultiplier(mode: TMultiplyMode): IIMultiplier; static;

    /// <summary>
    /// Returns current multiplier instance.
    /// </summary>
    /// <returns>Current multiplier instance.</returns>

    class function GetCurrentMultiplier(): IIMultiplier; static;

  class var

    /// <summary>
    /// Classic multiplier instance.
    /// </summary>

    FClassicMultiplier: IIMultiplier;

    /// <summary>
    /// FHT multiplier instance.
    /// </summary>

    FAutoFhtMultiplier: IIMultiplier;

  end;

implementation

// static class constructor
class constructor TMultiplyManager.Create();
var
  mclassicMultiplier: IIMultiplier;
begin

  // Create new classic multiplier instance
  mclassicMultiplier := TClassicMultiplier.Create;

  // Fill publicity visible multiplier fields
  FClassicMultiplier := mclassicMultiplier;
  FAutoFhtMultiplier := TAutoFhtMultiplier.Create(mclassicMultiplier);
end;

class function TMultiplyManager.GetMultiplier(mode: TMultiplyMode)
  : IIMultiplier;
begin
  case (mode) of

    TMultiplyMode.mmAutoFht:
      begin
        result := FAutoFhtMultiplier;
        Exit;
      end;

    TMultiplyMode.mmClassic:
      begin
        result := FClassicMultiplier;
        Exit;
      end;
  else
    begin

      raise EArgumentOutOfRangeException.Create('mode');
    end;

  end;
end;

class function TMultiplyManager.GetCurrentMultiplier(): IIMultiplier;
begin
  result := GetMultiplier(TIntX.GlobalSettings.MultiplyMode);
end;

end.
