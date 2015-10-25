unit MultiplyManager;

{
  * Copyright (c) 2015 Ugochukwu Mmaduekwe ugo4brain@gmail.com

  *   This Source Code Form is subject to the terms of the Mozilla Public License
  * v. 2.0. If a copy of the MPL was not distributed with this file, You can
  * obtain one at http://mozilla.org/MPL/2.0/.

  *   Neither the name of Ugochukwu Mmaduekwe nor the names of its contributors may
  *  be used to endorse or promote products derived from this software without
  *  specific prior written permission.

}

interface

uses
  SysUtils, IMultiplier, ClassicMultiplier, AutoFhtMultiplier, Enums, Utils,
  IntX;

type
  /// <summary>
  /// Used to retrieve needed multiplier.
  /// </summary>

  TMultiplyManager = class

  public
    /// <summary>
    /// Constructor.
    /// </summary>
    class constructor Create();
    /// <summary>
    /// Destructor.
    /// </summary>
    class destructor Destroy();

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

class destructor TMultiplyManager.Destroy();
begin

  FClassicMultiplier := Nil;
  FAutoFhtMultiplier := Nil;
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
