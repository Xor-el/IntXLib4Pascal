unit ClassicParser;

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
  ParserBase, IParser, Generics.Collections, DTypes, StrRepHelper;

type
  /// <summary>
  /// Classic parsing algorithm using multiplication (O[n^2]).
  /// </summary>

  TClassicParser = class sealed(TParserBase)

  public
    constructor Create(pow2Parser: IIParser);
    destructor Destroy(); override;
    function Parse(value: String; startIndex: Integer; endIndex: Integer;
      numberBase: UInt32; charToDigits: TDictionary<Char, UInt32>;
      digitsRes: TMyUint32Array): UInt32; override;

  end;

implementation

/// <summary>
/// Creates new <see cref="ClassicParser" /> instance.
/// </summary>
/// <param name="pow2Parser">Parser for pow2 case.</param>

constructor TClassicParser.Create(pow2Parser: IIParser);
begin
  Inherited Create(pow2Parser);
end;

destructor TClassicParser.Destroy();
begin
  Inherited Destroy;
end;

/// <summary>
/// Parses provided string representation of <see cref="IntX" /> object.
/// </summary>
/// <param name="value">Number as string.</param>
/// <param name="startIndex">Index inside string from which to start.</param>
/// <param name="endIndex">Index inside string on which to end.</param>
/// <param name="numberBase">Number base.</param>
/// <param name="charToDigits">Char->digit dictionary.</param>
/// <param name="digitsRes">Resulting digits.</param>
/// <returns>Parsed integer length.</returns>

function TClassicParser.Parse(value: String; startIndex: Integer;
  endIndex: Integer; numberBase: UInt32;
  charToDigits: TDictionary<Char, UInt32>; digitsRes: TMyUint32Array): UInt32;
var
  newLength, j: UInt32;
  numberBaseLong, digit: UInt64;
  i: Integer;
begin
  newLength := Inherited Parse(value, startIndex, endIndex, numberBase,
    charToDigits, digitsRes);

  // Maybe base method already parsed this number
  if (newLength <> 0) then
  begin
    result := newLength;
    Exit;
  end;

  // Do parsing in big cycle
  numberBaseLong := numberBase;
  i := startIndex;
  while i <= (endIndex) do
  begin
    digit := TStrRepHelper.GetDigit(charToDigits, value[i], numberBase);

    // Next multiply existing values by base and add this value to them
    if (newLength = 0) then
    begin
      if (digit <> 0) then
      begin
        digitsRes[0] := UInt32(digit);
        newLength := 1;
      end;
    end
    else
    begin
      j := 0;
      while j < (newLength) do
      begin
        digit := digit + digitsRes[j] * numberBaseLong;
        digitsRes[j] := UInt32(digit);
        digit := digit shr 32;
        Inc(j);
      end;

      if (digit <> 0) then
      begin

        digitsRes[newLength] := UInt32(digit);
        Inc(newLength);
      end
    end;

    Inc(i);
  end;

  result := newLength;
end;

end.
