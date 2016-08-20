unit uPow2StringConverter;

{$I ..\Include\IntXLib.inc}

interface

uses
  uIStringConverter,
  uConstants,
  uXBits,
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Provides special fast (with linear time) ToString converting if base is pow of 2.
  /// </summary>

  TPow2StringConverter = class sealed(TInterfacedObject, IIStringConverter)

  public
    /// <summary>
    /// Converts digits from internal representaion into given base.
    /// </summary>
    /// <param name="IntX">Big Integer.</param>
    /// <param name="numberBase">Base to use for output.</param>
    /// <param name="alphabet">alphabet array to use.</param>
    /// <returns>Conversion result.</returns>
    function ToString(IntX: TIntX; numberBase: UInt32;
      alphabet: TIntXLibCharArray): String; reintroduce; overload;

    /// <summary>
    /// Converts digits from internal representaion into given base.
    /// </summary>
    /// <param name="digits">Big integer digits.</param>
    /// <param name="mlength">Big integer length.</param>
    /// <param name="numberBase">Base to use for output.</param>
    /// <param name="outputLength">Calculated output length (will be corrected inside).</param>
    /// <returns>Conversion result (later will be transformed to string).</returns>

    function ToString(digits: TIntXLibUInt32Array; mlength: UInt32;
      numberBase: UInt32; var outputLength: UInt32): TIntXLibUInt32Array;
      reintroduce; overload;

  end;

implementation

function TPow2StringConverter.ToString(IntX: TIntX; numberBase: UInt32;
  alphabet: TIntXLibCharArray): String;
begin
  result := '';
  Exit;
end;

function TPow2StringConverter.ToString(digits: TIntXLibUInt32Array;
  mlength: UInt32; numberBase: UInt32; var outputLength: UInt32)
  : TIntXLibUInt32Array;
var
  bitsInChar, nextDigitShift, initialShift: Integer;
  digitsBitLength: UInt64;
  realOutputLength, digitBitMask, outputDigit, outputIndex, digitIndex: UInt32;
  outputArray: TIntXLibUInt32Array;

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
