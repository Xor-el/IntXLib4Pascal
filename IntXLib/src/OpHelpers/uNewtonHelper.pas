unit uNewtonHelper;

{$I ..\Include\IntXLib.inc}

interface

uses
  Math,
  uXBits,
  uConstants,
  uDigitOpHelper,
  uDigitHelper,
  uIMultiplier,
  uMultiplyManager,
  uIntXLibTypes;

type
  /// <summary>
  /// Contains helping methods for fast division
  /// using Newton approximation approach and fast multiplication.
  /// </summary>

  TNewtonHelper = class sealed(TObject)

  public

    /// <summary>
    /// Generates integer opposite to the given one using approximation.
    /// Uses algorithm from Knuth vol. 2 3rd Edition (4.3.3).
    /// </summary>
    /// <param name="digitsPtr">Initial big integer digits.</param>
    /// <param name="mlength">Initial big integer length.</param>
    /// <param name="maxLength">Precision length.</param>
    /// <param name="bufferPtr">Buffer in which shifted big integer may be stored.</param>
    /// <param name="newLength">Resulting big integer length.</param>
    /// <param name="rightShift">How much resulting big integer is shifted to the left (or: must be shifted to the right).</param>
    /// <returns>Resulting big integer digits.</returns>

    class function GetIntegerOpposite(digitsPtr: PCardinal;
      mlength, maxLength: UInt32; bufferPtr: PCardinal; out newLength: UInt32;
      out rightShift: UInt64): TIntXLibUInt32Array; static;
  end;

implementation

class function TNewtonHelper.GetIntegerOpposite(digitsPtr: PCardinal;
  mlength, maxLength: UInt32; bufferPtr: PCardinal; out newLength: UInt32;
  out rightShift: UInt64): TIntXLibUInt32Array;
var
  msb, LeftShift, lengthLog2, lengthLog2Bits, nextBufferTempShift, k: Integer;
  newLengthMax, resultLength, resultLengthSqr, resultLengthSqrBuf,
    bufferDigitN1, bufferDigitN2, nextBufferTempStorage, nextBufferLength,
    shiftOffset: UInt32;
  bitsAfterDotResult, bitsAfterDotResultSqr, bitsAfterDotNextBuffer,
    bitShift: UInt64;
  resultDigits, resultDigitsSqr, resultDigitsSqrBuf,
    tempDigits: TIntXLibUInt32Array;
  resultPtrFixed, resultSqrPtrFixed, resultSqrBufPtr, resultPtr, resultSqrPtr,
    nextBufferPtr, tempPtr: PCardinal;
  multiplier: IIMultiplier;

begin

  msb := TBits.msb(digitsPtr[mlength - 1]);
  rightShift := UInt64(mlength - 1) * TConstants.DigitBitCount + UInt64(msb) +
    UInt32(1);

  if (msb <> 2) then
  begin
    LeftShift := (2 - msb + TConstants.DigitBitCount)
      mod TConstants.DigitBitCount;
    mlength := TDigitOpHelper.ShiftRight(digitsPtr, mlength, (bufferPtr + 1),
      (TConstants.DigitBitCount - LeftShift), True) + UInt32(1);
  end
  else
  begin
    bufferPtr := digitsPtr;
  end;

  // Calculate possible result length
  lengthLog2 := TBits.CeilLog2(maxLength);
  newLengthMax := UInt32(1) shl (lengthLog2 + 1);
  lengthLog2Bits := lengthLog2 + TBits.msb(TConstants.DigitBitCount);

  // Create result digits
  SetLength(resultDigits, newLengthMax);

  // Create temporary digits for squared result (twice more size)
  SetLength(resultDigitsSqr, newLengthMax);

  // Create temporary digits for squared result * buffer
  SetLength(resultDigitsSqrBuf, (newLengthMax + mlength));

  // We will always use current multiplier
  multiplier := TMultiplyManager.GetCurrentMultiplier();

  resultPtrFixed := @resultDigits[0];
  resultSqrPtrFixed := @resultDigitsSqr[0];
  resultSqrBufPtr := @resultDigitsSqrBuf[0];

  resultPtr := resultPtrFixed;
  resultSqrPtr := resultSqrPtrFixed;

  // Cache two first digits

  bufferDigitN1 := bufferPtr[mlength - 1];
  bufferDigitN2 := bufferPtr[mlength - 2];

  // Prepare result.
  // Initially result = floor(32 / (4*v1 + 2*v2 + v3)) / 4
  // (last division is not floored - here we emulate fixed point)
  resultDigits[0] := 32 div bufferDigitN1;
  resultLength := 1;

  // Prepare variables
  nextBufferTempStorage := 0;
  nextBufferLength := UInt32(1);
  nextBufferPtr := @nextBufferTempStorage;

  // Iterate 'till result will be precise enough

  k := 0;
  while k < (lengthLog2Bits) do

  begin

    // Get result squared
    resultLengthSqr := multiplier.Multiply(resultPtr, resultLength, resultPtr,
      resultLength, resultSqrPtr);

    // Calculate current result bits after dot
    bitsAfterDotResult := (UInt64(1) shl k) + UInt64(1);
    bitsAfterDotResultSqr := bitsAfterDotResult shl 1;

    // Here we will get the next portion of data from bufferPtr
    if (k < 4) then
    begin
      // For now buffer intermediate has length 1 and we will use this fact
      nextBufferTempShift := 1 shl (k + 1);
      nextBufferTempStorage := bufferDigitN1 shl nextBufferTempShift or
        bufferDigitN2 shr (TConstants.DigitBitCount - nextBufferTempShift);

      // Calculate amount of bits after dot (simple formula here)
      bitsAfterDotNextBuffer := UInt64(nextBufferTempShift) + UInt64(3);
    end
    else
    begin
      // Determine length to get from bufferPtr
      nextBufferLength := Min(Int64(UInt32(1) shl (k - 4)) + UInt32(1),
        mlength);
      nextBufferPtr := bufferPtr + (mlength - nextBufferLength);

      // Calculate amount of bits after dot (simple formula here)
      bitsAfterDotNextBuffer := UInt64(nextBufferLength - UInt32(1)) *
        TConstants.DigitBitCount + UInt64(3);
    end;

    // Multiply result  2 and nextBuffer + calculate new amount of bits after dot
    resultLengthSqrBuf := multiplier.Multiply(resultSqrPtr, resultLengthSqr,
      nextBufferPtr, nextBufferLength, resultSqrBufPtr);

    bitsAfterDotNextBuffer := bitsAfterDotNextBuffer + bitsAfterDotResultSqr;

    // Now calculate 2 * result - resultSqrBufPtr
    Dec(bitsAfterDotResult);
    Dec(bitsAfterDotResultSqr);

    // Shift result on a needed amount of bits to the left
    bitShift := bitsAfterDotResultSqr - bitsAfterDotResult;
    shiftOffset := UInt32(bitShift div TConstants.DigitBitCount);
    resultLength := shiftOffset + UInt32(1) + TDigitOpHelper.ShiftRight
      (resultPtr, resultLength, resultSqrPtr + shiftOffset + UInt32(1),
      TConstants.DigitBitCount -
      Integer(bitShift mod TConstants.DigitBitCount), True);

    // Swap resultPtr and resultSqrPtr pointers
    tempPtr := resultPtr;
    resultPtr := resultSqrPtr;
    resultSqrPtr := tempPtr;

    tempDigits := resultDigits;
    resultDigits := resultDigitsSqr;
    resultDigitsSqr := tempDigits;

    TDigitHelper.SetBlockDigits(resultPtr, shiftOffset, UInt32(0));

    bitShift := bitsAfterDotNextBuffer - bitsAfterDotResultSqr;
    shiftOffset := UInt32(bitShift div TConstants.DigitBitCount);

    if (shiftOffset < resultLengthSqrBuf) then
    begin
      // Shift resultSqrBufPtr on a needed amount of bits to the right
      resultLengthSqrBuf := TDigitOpHelper.ShiftRight
        (resultSqrBufPtr + shiftOffset, resultLengthSqrBuf - shiftOffset,
        resultSqrBufPtr, Integer(bitShift mod TConstants.DigitBitCount), False);

      // Now perform actual subtraction
      resultLength := TDigitOpHelper.Sub(resultPtr, resultLength,
        resultSqrBufPtr, resultLengthSqrBuf, resultPtr);
    end
    else
    begin
      // Actually we can assume resultSqrBufPtr = 0 here and have nothing to do
    end;
    Inc(k);
  end;
  rightShift := rightShift + (UInt64(1) shl lengthLog2Bits) + UInt64(1);
  newLength := resultLength;
  result := resultDigits;

end;

end.
