unit StringConvertManager;

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
  SysUtils, IStringConverter, Enums, ClassicStringConverter,
  FastStringConverter, Pow2StringConverter;

type
  /// <summary>
  /// Used to retrieve needed ToString converter.
  /// </summary>

  TStringConvertManager = class

  public
    class constructor Create();
    class destructor Destroy();
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

class destructor TStringConvertManager.Destroy();
begin
  FClassicStringConverter := Nil;
  FFastStringConverter := Nil;
end;

/// <summary>
/// Returns ToString converter instance for given ToString mode.
/// </summary>
/// <param name="mode">ToString mode.</param>
/// <returns>Converter instance.</returns>
/// <exception cref="ArgumentOutOfRangeException"><paramref name="mode" />is out of range.</exception>

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
