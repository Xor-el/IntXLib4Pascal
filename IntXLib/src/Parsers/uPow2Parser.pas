unit uPow2Parser;

{$I ..\Include\IntXLib.inc}

interface

uses
{$IFDEF DELPHI}
  Generics.Collections,
{$ENDIF DELPHI}
{$IFDEF FPC}
  fgl,
{$ENDIF FPC}
  uIParser,
  uXBits,
  uConstants,
  uStrRepHelper,
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Provides special fast (with linear time) parsing if base is pow of 2.
  /// </summary>

  TPow2Parser = class sealed(TInterfacedObject, IIParser)

  public

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="numberBase">Number base.</param>
    /// <param name="charToDigits">Char->digit dictionary.</param>
    /// <param name="checkFormat">Boolean that indicates if to check Input Format.</param>
    /// <returns>Big Integer value.</returns>

    function Parse(const value: String; numberBase: UInt32;
      charToDigits: TDictionary<Char, UInt32>; checkFormat: Boolean)
      : TIntX; overload;
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

    function Parse(const value: String; startIndex: Integer; endIndex: Integer;
      numberBase: UInt32; charToDigits: TDictionary<Char, UInt32>;
      digitsRes: TIntXLibUInt32Array): UInt32; overload;
  end;

implementation

function TPow2Parser.Parse(const value: String; numberBase: UInt32;
  charToDigits: TDictionary<Char, UInt32>; checkFormat: Boolean): TIntX;
begin

  result := Default (TIntX);
  Exit;
end;

function TPow2Parser.Parse(const value: String; startIndex: Integer;
  endIndex: Integer; numberBase: UInt32;
  charToDigits: TDictionary<Char, UInt32>;
  digitsRes: TIntXLibUInt32Array): UInt32;
var
  bitsInChar, initialShift, i: Integer;
  valueLength, digitsLength, digitIndex, digit: UInt32;
  valueBitLength: UInt64;
begin
  // Calculate length of input string
  bitsInChar := TBits.Msb(numberBase);
  valueLength := UInt32(endIndex - startIndex + 1);
  valueBitLength := UInt64(valueLength) * UInt64(bitsInChar);

  // Calculate needed digits length and first shift
  digitsLength := UInt32(valueBitLength div TConstants.DigitBitCount) + 1;
  digitIndex := digitsLength - 1;
  initialShift := Integer(valueBitLength mod TConstants.DigitBitCount);

  // Probably correct digits length
  if (initialShift = 0) then
  begin
    Dec(digitsLength);
  end;

  // Do parsing in big cycle
  i := startIndex;
  while i <= (endIndex) do
  begin
    digit := TStrRepHelper.GetDigit(charToDigits, value[i], numberBase);

    // Correct initial digit shift
    if (initialShift = 0) then
    begin
      // If shift is equals to zero then char is not on digit elements bounds,
      // so just go to the previous digit
      initialShift := TConstants.DigitBitCount - bitsInChar;
      Dec(digitIndex);
    end
    else
    begin
      // Here shift might be negative, but it's okay
      initialShift := initialShift - bitsInChar;
    end;

    // Insert new digit in correct place
    if initialShift < 0 then
      digitsRes[digitIndex] := digitsRes[digitIndex] or
        (digit shr - initialShift)
    else
      digitsRes[digitIndex] := digitsRes[digitIndex] or
        (digit shl initialShift);

    // In case if shift was negative we also must modify previous digit
    if (initialShift < 0) then
    begin
      initialShift := initialShift + TConstants.DigitBitCount;
      Dec(digitIndex);
      digitsRes[digitIndex] := digitsRes[digitIndex] or
        (digit shl initialShift);

    end;
    Inc(i);

  end;

  if (digitsRes[digitsLength - 1] = 0) then
  begin
    Dec(digitsLength);
  end;
  result := digitsLength;
end;

end.
