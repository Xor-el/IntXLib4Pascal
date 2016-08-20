unit uStrRepHelper;

{$I ..\Include\IntXLib.inc}

interface

uses
{$IFDEF DELPHI}
  Generics.Collections,
{$ENDIF DELPHI}
  SysUtils,
  uStrings,
  uUtils,
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Helps to work with <see cref="TIntX" /> string representations.
  /// </summary>

  TStrRepHelper = class sealed(TObject)

  private

    const

    NullString = String('');

  public

    /// <summary>
    /// Returns char array for given string.
    /// </summary>
    /// <param name="InString">input string.</param>

    class function ToCharArray(const InString: String): TIntXLibCharArray;
      inline; static;

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

    class procedure AssertAlphabet(const alphabet: String;
      numberBase: UInt32); static;

    /// <summary>
    /// Generates char->digit dictionary from alphabet.
    /// </summary>
    /// <param name="alphabet">Alphabet.</param>
    /// <param name="numberBase">String representation number base.</param>
    /// <returns>Char->digit dictionary.</returns>

    class function CharDictionaryFromAlphabet(const alphabet: String;
      numberBase: UInt32): TDictionary<Char, UInt32>; static;
  end;

implementation

class function TStrRepHelper.ToCharArray(const InString: String)
  : TIntXLibCharArray;

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
  digit := 0;
  if (charToDigits = Nil) then
  begin
    raise EArgumentNilException.Create('charToDigits');
  end;
  // Try to identify this digit

{$IFDEF DELPHI}
  if (not charToDigits.TryGetValue(ch, digit)) then
{$ENDIF DELPHI}
{$IFDEF FPC}
    if (not charToDigits.Find(UpCase(ch), Integer(digit))) then
{$ENDIF FPC}
    begin
      raise EFormatException.Create(uStrings.ParseInvalidChar);
    end;

  if (digit >= numberBase) then
  begin
    raise EFormatException.Create(uStrings.ParseTooBigDigit);
  end;
  result := digit;
end;

class procedure TStrRepHelper.AssertAlphabet(const alphabet: String;
  numberBase: UInt32);
var
  sortedChars: TIntXLibCharArray;
  i: Integer;

begin
  if (alphabet = NullString) then
  begin
    raise EArgumentNilException.Create('alphabet');
  end;

  // Ensure that alphabet has enough characters to represent numbers in given base
  if (UInt32(Length(alphabet)) < numberBase) then
  begin

    raise EArgumentException.Create(Format(uStrings.AlphabetTooSmall,
      [numberBase], TIntX._FS) + ' alphabet');

  end;

  // Ensure that all the characters in alphabet are unique
  sortedChars := ToCharArray(alphabet);

  TUtils.QuickSort(sortedChars, Low(sortedChars), High(sortedChars));

  i := 0;
  while i < (Length(sortedChars)) do

  begin
    if ((i > 0) and (sortedChars[i] = sortedChars[i - 1])) then
    begin
      raise EArgumentException.Create(uStrings.AlphabetRepeatingChars +
        ' alphabet');
    end;
    Inc(i);
  end;
end;

class function TStrRepHelper.CharDictionaryFromAlphabet(const alphabet: String;
  numberBase: UInt32): TDictionary<Char, UInt32>;

var
  i: Integer;
  LCharDigits: TDictionary<Char, UInt32>;

begin

  AssertAlphabet(alphabet, numberBase);
{$IFDEF DELPHI}
  LCharDigits := TDictionary<Char, UInt32>.Create(Integer(numberBase));
{$ENDIF DELPHI}
{$IFDEF FPC}
  LCharDigits := TDictionary<Char, UInt32>.Create();
  LCharDigits.Capacity := Integer(numberBase);
{$ENDIF FPC}
  i := 0;
  while UInt32(i) < numberBase do

  begin
    LCharDigits.Add(alphabet[i + 1], UInt32(i));
    Inc(i);
  end;
  result := LCharDigits;
end;

end.
