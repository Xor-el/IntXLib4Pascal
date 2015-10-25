unit ParserBase;

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
  IParser, SysUtils, Math, RegularExpressions, Generics.Collections, Strings,
  Constants, DTypes, Bits, Utils, IntX;

type
  /// <summary>
  /// Base class for parsers.
  /// Contains default implementations of parse operation over <see cref="TIntX" /> instances.
  /// </summary>

  TParserBase = class abstract(TInterfacedObject, IIParser)

  const
    /// <summary>
    /// Regex pattern used on parsing stage to determine number sign and/or base
    /// </summary>
    ParseRegexPattern: String = '(?<Sign>[+-]?)((?<BaseHex>\$)|(?<BaseOct>0))?';

  private
    /// <summary>
    /// parser for pow2 case
    /// </summary>
    F_pow2Parser: IIParser;

  public
    /// <summary>
    /// Checks if Input Char is WhiteSpace
    /// </summary>
    /// <param name="Value">Input Char.</param>
    class function IsWhiteSpace(const Value: Char): Boolean; inline;
    /// <summary>
    /// Creates new <see cref="ParserBase" /> instance.
    /// </summary>
    /// <param name="pow2Parser">Parser for pow2 case.</param>
    constructor Create(pow2Parser: IIParser);
    /// <summary>
    /// Destructor.
    /// </summary>
    destructor Destroy(); override;

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="numberBase">Number base.</param>
    /// <param name="charToDigits">Char->digit dictionary.</param>
    /// <param name="checkFormat">Check actual format of number (0 or $ at start).</param>
    /// <returns>Parsed object.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>
    /// <exception cref="EArgumentException"><paramref name="numberBase" /> is less then 2 or more then 16.</exception>
    /// <exception cref="EFormatException"><paramref name="value" /> is not in valid format.</exception>

    function Parse(Value: String; numberBase: UInt32;
      charToDigits: TDictionary<Char, UInt32>; checkFormat: Boolean): TIntX;
      overload; virtual;

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="startIndex">Index inside string from which to start.</param>
    /// <param name="endIndex">Index inside string on which to end.</param>
    /// <param name="numberBase">Number base.</param>
    /// <param name="charToDigits">Char->digit dictionary.</param>
    /// <param name="digitsRes">Resulting digits.</param>
    /// <returns>Parsed integer length.</returns>

    function Parse(Value: String; startIndex: Integer; endIndex: Integer;
      numberBase: UInt32; charToDigits: TDictionary<Char, UInt32>;
      digitsRes: TMyUint32Array): UInt32; overload; virtual;

  end;

implementation

class function TParserBase.IsWhiteSpace(const Value: Char): Boolean;
begin
  Result := Length(Trim(Value)) = 0;
end;

constructor TParserBase.Create(pow2Parser: IIParser);
begin
  Inherited Create;
  F_pow2Parser := pow2Parser;
end;

destructor TParserBase.Destroy();
begin
  F_pow2Parser := Nil;
  Inherited Destroy;
end;

{$IFNDEF _FIXINSIGHT_}  // tells FixInsight to Ignore this Function

function TParserBase.Parse(Value: String; numberBase: UInt32;
  charToDigits: TDictionary<Char, UInt32>; checkFormat: Boolean): TIntX;
var
  startIndex, endIndex, valueLength: Integer;
  negative, stringNotEmpty: Boolean;
  digitsLength: UInt32;
  newInt: TIntX;
  ParseRegex: TRegEx;
  sMatch: TMatch;

begin
  // Exceptions
  if (Value = '') then
  begin
    raise EArgumentNilException.Create('value');
  end;

  if (charToDigits = Nil) then
  begin
    raise EArgumentNilException.Create('charToDigits');
  end;

  if ((numberBase < UInt32(2)) or (numberBase > UInt32(charToDigits.Count)))
  then
  begin
    raise EArgumentException(Strings.ParseBaseInvalid + ' numberBase');
  end;

  // Initially determine start and end indices (Trim is too slow)
  // if Zero-Based Indexed String, use startIndex := 0;
  startIndex := 1;
  while ((startIndex < (Length(Value))) and
    (IsWhiteSpace(Value[startIndex]))) do
  begin

    Inc(startIndex);
  end;
  // if Zero-Based Indexed String, replace with endIndex := Length(Value) - 1;
  endIndex := Length(Value);

  while (((endIndex) >= startIndex) and (IsWhiteSpace(Value[endIndex]))) do
  begin

    Dec(endIndex);
  end;
  negative := False; // number sign
  stringNotEmpty := False; // true if string is already guaranteed to
  // be non-empty
  // Regex object used on parsing stage to determine number sign and/or base
  // ParseRegex := TRegEx.Create(ParseRegexPattern, [roNotEmpty, roCompiled]);
  ParseRegex := TRegEx.Create(ParseRegexPattern, [roCompiled]);

  // Determine sign and/or base
  sMatch := ParseRegex.Match(Value, startIndex, endIndex - startIndex + 1);

  // using try and except to swallow exception(s) raised by Delphi's TRegex.
  try
    if (sMatch.Groups['Sign'].Value = '-') then
    begin
      negative := True;
    end;

    if (sMatch.Groups['BaseHex'].Length <> 0) then
    begin
      if (checkFormat) then
      begin
        // $ before the number - this is hex number
        numberBase := UInt32(16);
      end
      else
      begin
        // This is an error
        raise EFormatException.Create(Strings.ParseInvalidChar);
      end
    end

    else

      if (sMatch.Groups['BaseOct'].Length <> 0) then
    begin
      if (checkFormat) then
      begin
        // 0 before the number - this is octal number
        numberBase := UInt32(8);
      end;

      stringNotEmpty := True;
    end;

  except
    // do nothing if exception occurs
  end;

  // Skip leading sign and format
  startIndex := startIndex + sMatch.Length;
  // If at this stage string is empty, this may mean an error
  if ((startIndex > endIndex) and (not stringNotEmpty)) then
  begin
    raise EFormatException.Create(Strings.ParseNoDigits);
  end;
  // Iterate through string and skip all leading zeroes
  while ((startIndex <= (endIndex)) and (Value[startIndex] = '0')) do
  begin
    Inc(startIndex);
  end;

  // Return zero if length is zero
  if (startIndex > endIndex) then
  begin
    Result := TIntX.Create(0);
    Exit;
  end;
  // Determine length of new digits array and create new TIntX object with given length

  valueLength := endIndex - startIndex + 1;
  digitsLength := UInt32(Ceil(Ln(numberBase) / TConstants.DigitBaseLog *
    valueLength));
  newInt := TIntX.Create(digitsLength, negative);

  // Now we have only (in)valid string which consists from numbers only.
  // Parse it
  newInt._length := Parse(Value, startIndex, endIndex, numberBase, charToDigits,
    newInt._digits);

  Result := newInt;
end;

{$ENDIF}

function TParserBase.Parse(Value: String; startIndex: Integer;
  endIndex: Integer; numberBase: UInt32;
  charToDigits: TDictionary<Char, UInt32>; digitsRes: TMyUint32Array): UInt32;
begin
  // Default implementation - always call pow2 parser if numberBase is pow of 2
  if numberBase = UInt32(1) shl TBits.Msb(numberBase) then
  begin
    Result := F_pow2Parser.Parse(Value, startIndex, endIndex, numberBase,
      charToDigits, digitsRes);
    Exit;
  end
  else
  begin
    Result := 0;
    Exit;
  end;

end;

end.
