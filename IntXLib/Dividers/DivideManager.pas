unit DivideManager;

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

  SysUtils, IDivider, Enums, ClassicDivider, AutoNewtonDivider;

type
  /// <summary>
  /// Used to retrieve needed divider.
  /// </summary>

  TDivideManager = class

  public

    class constructor Create();
    class destructor Destroy();
    class function GetDivider(mode: TDivideMode): IIDivider;
    class function GetCurrentDivider(): IIDivider;

  class var
    /// <summary>
    /// Classic divider instance.
    /// </summary>

    FClassicDivider: IIDivider;

    /// <summary>
    /// Newton divider instance.
    /// </summary>

    FAutoNewtonDivider: IIDivider;

  end;

implementation

uses
  IntX;

// static class constructor
class constructor TDivideManager.Create();
var
  mclassicDivider: IIDivider;
begin
  // Create new classic divider instance
  mclassicDivider := TClassicDivider.Create;

  // Fill publicity visible divider fields
  FClassicDivider := mclassicDivider;
  FAutoNewtonDivider := TAutoNewtonDivider.Create(mclassicDivider);
end;

class destructor TDivideManager.Destroy();
begin

  FClassicDivider := Nil;
  FAutoNewtonDivider := Nil;
end;

/// <summary>
/// Returns divider instance for given divide mode.
/// </summary>
/// <param name="mode">Divide mode.</param>
/// <returns>Divider instance.</returns>
/// <exception cref="EArgumentOutOfRangeException"><paramref name="mode" /> is out of range.</exception>

class function TDivideManager.GetDivider(mode: TDivideMode): IIDivider;
begin
  case (mode) of

    TDivideMode.dmAutoNewton:
      begin
        result := FAutoNewtonDivider;
        Exit;
      end;
    TDivideMode.dmClassic:
      begin
        result := FClassicDivider;
        Exit;
      end
  else
    begin
      raise EArgumentOutOfRangeException.Create('mode');
    end;

  end;

end;

/// <summary>
/// Returns current divider instance.
/// </summary>
/// <returns>Current divider instance.</returns>

class function TDivideManager.GetCurrentDivider(): IIDivider;
begin
  result := GetDivider(TIntX.GlobalSettings.DivideMode);
end;

end.
