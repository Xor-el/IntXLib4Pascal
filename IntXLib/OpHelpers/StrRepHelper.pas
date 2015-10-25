unit StrRepHelper;

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
  Generics.Collections, SysUtils, Strings, Utils, IntX;

type
  /// <summary>
  /// Helps to work with <see cref="TIntX" /> string representations.
  /// </summary>

  TStrRepHelper = class

  private

    Const
    NullString = '';

  public

    /// <summary>
    /// Returns char array for given string.
    /// </summary>
    /// <param name="InString">input string.</param>

    class function ToCharArray(InString: String): TCharArray; static;

    /// <summary>
    /// Returns digit for given char.
    /// </summary>
    /// <param name="charToDigits">Char->digit dictionary.</param>
    /// <param name="ch">Char which represents big integer digit.</param>
    /// <param name="numberBase">String representation number base.</param>
    /// <returns>Digit.</returns>
    /// <exception cref="EFormatException"><paramref name="ch" /> is not in valid format.</exception>

    class function GetDigit(charToDigits: TDictionary<Char, UInt32>; ch: Char;
      numberBase: UInt32): UInt32; static;

    /// <summary>
    /// Verfies string alphabet provider by user for validity.
    /// </summary>
    /// <param name="alphabet">Alphabet.</param>
    /// <param name="numberBase">String representation number base.</param>

    class procedure AssertAlphabet(alphabet: String;
      numberBase: UInt32); static;

    /// <summary>
    /// Generates char->digit dictionary from alphabet.
    /// </summary>
    /// <param name="alphabet">Alphabet.</param>
    /// <param name="numberBase">String representation number base.</param>
    /// <param name="FcharDigits">Already existing dictionary to work on.</param>
    /// <returns>Char->digit dictionary.</returns>

    class function CharDictionaryFromAlphabet(alphabet: String;
      numberBase: UInt32; var FcharDigits: TDictionary<Char, UInt32>)
      : TDictionary<Char, UInt32>; static;

  end;

implementation

class function TStrRepHelper.ToCharArray(InString: String): TCharArray;

begin
  SetLength(result, Length(InString));

  // Move the string contents to a char array
  Move((PChar(InString))^, result[0], Length(InString) * SizeOf(Char));

end;

class function TStrRepHelper.GetDigit(charToDigits: TDictionary<Char, UInt32>;
  ch: Char; numberBase: UInt32): UInt32;
var
  digit: UInt32;
begin
  if (charToDigits = Nil) then
  begin
    raise EArgumentNilException.Create('charToDigits');
  end;

  // Try to identify this digit

  if (not charToDigits.TryGetValue(ch, digit)) then
  begin
    raise EFormatException.Create(Strings.ParseInvalidChar);
  end;
  if (digit >= numberBase) then
  begin
    raise EFormatException.Create(Strings.ParseTooBigDigit);
  end;
  result := digit;
end;

class procedure TStrRepHelper.AssertAlphabet(alphabet: String;
  numberBase: UInt32);
var
  sortedChars: TCharArray;
  i: Integer;

begin
  if (alphabet = NullString) then
  begin
    raise EArgumentNilException.Create('alphabet');
  end;

  // Ensure that alphabet has enough characters to represent numbers in given base
  if (UInt32(Length(alphabet)) < numberBase) then
  begin

    raise EArgumentException.Create(Format(Strings.AlphabetTooSmall,
      [numberBase], TIntX._FS) + ' alphabet');

  end;

  // Ensure that all the characters in alphabet are unique
  sortedChars := ToCharArray(alphabet);
  TArray.Sort<Char>(sortedChars);

  i := 0;
  while i < (Length(sortedChars)) do

  begin
    if ((i > 0) and (sortedChars[i] = sortedChars[i - 1])) then
    begin
      raise EArgumentException.Create(Strings.AlphabetRepeatingChars +
        ' alphabet');
    end;
    Inc(i);
  end;
end;

class function TStrRepHelper.CharDictionaryFromAlphabet(alphabet: String;
  numberBase: UInt32; var FcharDigits: TDictionary<Char, UInt32>)
  : TDictionary<Char, UInt32>;
var
  i: Integer;

begin

  AssertAlphabet(alphabet, numberBase);
  FcharDigits.Clear;
  i := 0;
  while UInt32(i) < numberBase do

  begin
    FcharDigits.Add(alphabet[i + 1], UInt32(i));
    Inc(i);
  end;
  result := FcharDigits;
end;

end.
