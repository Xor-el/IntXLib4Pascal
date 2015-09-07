unit Pow2StringConverter;

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
  IStringConverter, DTypes, SysUtils, Constants, Bits, IntX;

type
  /// <summary>
  /// Provides special fast (with linear time) ToString converting if base is pow of 2.
  /// </summary>

  TPow2StringConverter = class sealed(TInterfacedObject, IIStringConverter)

  public
    function ToString(IntX: TIntX; numberBase: UInt32; alphabet: array of Char)
      : String; reintroduce; overload;
    function ToString(digits: TMyUInt32Array; mlength: UInt32;
      numberBase: UInt32; var outputLength: UInt32): TMyUInt32Array;
      reintroduce; overload;

  end;

implementation

// Not needed in this implementation

function TPow2StringConverter.ToString(IntX: TIntX; numberBase: UInt32;
  alphabet: array of Char): String;
begin
  result := '';
  Exit;
end;

/// <summary>
/// Converts digits from internal representaion into given base.
/// </summary>
/// <param name="digits">Big integer digits.</param>
/// <param name="length">Big integer length.</param>
/// <param name="numberBase">Base to use for output.</param>
/// <param name="outputLength">Calculated output length (will be corrected inside).</param>
/// <returns>Conversion result (later will be transformed to string).</returns>

function TPow2StringConverter.ToString(digits: TMyUInt32Array; mlength: UInt32;
  numberBase: UInt32; var outputLength: UInt32): TMyUInt32Array;
var
  bitsInChar, nextDigitShift, initialShift: Integer;
  digitsBitLength: UInt64;
  realOutputLength, digitBitMask, outputDigit, outputIndex, digitIndex: UInt32;
  outputArray: TMyUInt32Array;

begin
  // Calculate real output length

  bitsInChar := TBits.Msb(numberBase);
  digitsBitLength := UInt64(mlength - 1) * TConstants.DigitBitCount +
    UInt64(TBits.Msb(digits[mlength - 1])) + UInt64(1);
  realOutputLength := UInt32(digitsBitLength) div UInt64(bitsInChar);
  if (digitsBitLength mod UInt64(bitsInChar) <> 0) then
  begin
    Inc(realOutputLength);
  end;

  // Prepare shift variables
  nextDigitShift := TConstants.DigitBitCount - bitsInChar;
  // after this shift next digit must be used
  initialShift := 0;

  // We will also need bitmask for copying digits
  digitBitMask := numberBase - 1;

  // Create an output array for storing of number in other base
  SetLength(outputArray, realOutputLength);
  outputIndex := 0;
  digitIndex := 0;
  // Walk through original digits and fill output
  while outputIndex < (realOutputLength) do
  begin
    // Get part of current digit
    outputDigit := digits[digitIndex] shr initialShift;

    // Maybe we need to go to the next digit
    if (initialShift >= nextDigitShift) then
    begin
      // Go to the next digit
      Inc(digitIndex);

      // Maybe we also need a part of the next digit
      if ((initialShift <> nextDigitShift) and (digitIndex < mlength)) then
      begin
        outputDigit := outputDigit or
          (digits[digitIndex] shl (TConstants.DigitBitCount - initialShift));
      end;

      // Modify shift so that it will be valid for the next digit
      initialShift := (initialShift + bitsInChar) mod TConstants.DigitBitCount;
    end
    else
    begin
      // Modify shift as usual
      initialShift := initialShift + bitsInChar;
    end;

    // Write masked result to the output
    outputArray[outputIndex] := outputDigit and digitBitMask;
    Inc(outputIndex);
  end;

  outputLength := realOutputLength;
  result := outputArray;
end;

end.
