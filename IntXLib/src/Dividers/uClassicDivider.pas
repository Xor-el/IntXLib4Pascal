unit uClassicDivider;

{$I ..\Include\IntXLib.inc}

interface

uses
  uDividerBase,
  uDigitHelper,
  uDigitOpHelper,
  uXBits,
  uEnums,
  uConstants,
  uUtils,
  uIntXLibTypes;

type
  /// <summary>
  /// Divider using "classic" algorithm.
  /// </summary>

  TClassicDivider = class sealed(TDividerBase)

  public

    /// <summary>
    /// Divides two big integers.
    /// Also modifies <paramref name="digits1" /> and <paramref name="length1"/> (it will contain remainder).
    /// </summary>
    /// <param name="digits1">First big integer digits.</param>
    /// <param name="digitsBuffer1">Buffer for first big integer digits. May also contain remainder. Can be null - in this case it's created if necessary.</param>
    /// <param name="length1">First big integer length.</param>
    /// <param name="digits2">Second big integer digits.</param>
    /// <param name="digitsBuffer2">Buffer for second big integer digits. Only temporarily used. Can be null - in this case it's created if necessary.</param>
    /// <param name="length2">Second big integer length.</param>
    /// <param name="digitsRes">Resulting big integer digits.</param>
    /// <param name="resultFlags">Which operation results to return.</param>
    /// <param name="cmpResult">Big integers comparison result (pass -2 if omitted).</param>
    /// <returns>Resulting big integer length.</returns>

    function DivMod(digits1: TIntXLibUInt32Array;
      digitsBuffer1: TIntXLibUInt32Array; var length1: UInt32;
      digits2: TIntXLibUInt32Array; digitsBuffer2: TIntXLibUInt32Array;
      length2: UInt32; digitsRes: TIntXLibUInt32Array;
      resultFlags: TDivModResultFlags; cmpResult: integer): UInt32;
      overload; override;

    /// <summary>
    /// Divides two big integers.
    /// Also modifies <paramref name="digitsPtr1" /> and <paramref name="length1"/> (it will contain remainder).
    /// </summary>
    /// <param name="digitsPtr1">First big integer digits.</param>
    /// <param name="digitsBufferPtr1">Buffer for first big integer digits. May also contain remainder.</param>
    /// <param name="length1">First big integer length.</param>
    /// <param name="digitsPtr2">Second big integer digits.</param>
    /// <param name="digitsBufferPtr2">Buffer for second big integer digits. Only temporarily used.</param>
    /// <param name="length2">Second big integer length.</param>
    /// <param name="digitsResPtr">Resulting big integer digits.</param>
    /// <param name="resultFlags">Which operation results to return.</param>
    /// <param name="cmpResult">Big integers comparison result (pass -2 if omitted).</param>
    /// <returns>Resulting big integer length.</returns>

    function DivMod(digitsPtr1: PCardinal; digitsBufferPtr1: PCardinal;
      var length1: UInt32; digitsPtr2: PCardinal; digitsBufferPtr2: PCardinal;
      length2: UInt32; digitsResPtr: PCardinal; resultFlags: TDivModResultFlags;
      cmpResult: integer): UInt32; overload; override;

  end;

implementation

function TClassicDivider.DivMod(digits1: TIntXLibUInt32Array;
  digitsBuffer1: TIntXLibUInt32Array; var length1: UInt32;
  digits2: TIntXLibUInt32Array; digitsBuffer2: TIntXLibUInt32Array;
  length2: UInt32; digitsRes: TIntXLibUInt32Array;
  resultFlags: TDivModResultFlags; cmpResult: integer): UInt32;
var
  digitsPtr1, digitsBufferPtr1, digitsPtr2, digitsBufferPtr2, digitsResPtr,
    tempA: PCardinal;
begin

  // Create some buffers if necessary
  if (digitsBuffer1 = Nil) then
  begin
    SetLength(digitsBuffer1, length1 + 1);
  end;

  if (digitsBuffer2 = Nil) then
  begin
    SetLength(digitsBuffer2, length2);
  end;
  digitsPtr1 := @digits1[0];
  digitsBufferPtr1 := @digitsBuffer1[0];
  digitsPtr2 := @digits2[0];
  digitsBufferPtr2 := @digitsBuffer2[0];

  if digitsRes <> Nil then
    digitsResPtr := @digitsRes[0]
  else
    digitsResPtr := @digits1[0];
  if (digitsResPtr = digitsPtr1) then

    tempA := Nil
  else
  begin
    tempA := digitsResPtr;
  end;

  Result := DivMod(digitsPtr1, digitsBufferPtr1, length1, digitsPtr2,
    digitsBufferPtr2, length2, tempA, resultFlags, cmpResult);

end;

function TClassicDivider.DivMod(digitsPtr1: PCardinal;
  digitsBufferPtr1: PCardinal; var length1: UInt32; digitsPtr2: PCardinal;
  digitsBufferPtr2: PCardinal; length2: UInt32; digitsResPtr: PCardinal;
  resultFlags: TDivModResultFlags; cmpResult: integer): UInt32;
var
  resultLength, divRes, lastDigit2, preLastDigit2, maxLength, i, iLen2, j,
    ji: UInt32;
  divNeeded, modNeeded, isMaxLength: Boolean;
  shift1, rightShift1: integer;
  longDigit, divEst, modEst, mulRes: UInt64;
  k, t, tempAsr: Int64;
begin
  // Call base (for special cases)

  resultLength := inherited DivMod(digitsPtr1, digitsBufferPtr1, length1,
    digitsPtr2, digitsBufferPtr2, length2, digitsResPtr, resultFlags,
    cmpResult);
  if (resultLength <> TConstants.MaxUInt32Value) then
  begin
    Result := resultLength;
    Exit;
  end;

  divNeeded := (Ord(resultFlags) and Ord(TDivModResultFlags.dmrfDiv)) <> 0;
  modNeeded := (Ord(resultFlags) and Ord(TDivModResultFlags.dmrfMod)) <> 0;

  //
  // Prepare digitsBufferPtr1 and digitsBufferPtr2
  //

  shift1 := 31 - TBits.Msb(digitsPtr2[length2 - 1]);
  if (shift1 = 0) then
  begin
    // We don't need to shift - just copy
    TDigitHelper.DigitsBlockCopy(digitsPtr1, digitsBufferPtr1, length1);

    // We also don't need to shift second digits
    digitsBufferPtr2 := digitsPtr2;
  end
  else
  begin
    rightShift1 := TConstants.DigitBitCount - shift1;

    // We do need to shift here - so copy with shift - suppose we have enough storage for this operation
    length1 := TDigitOpHelper.ShiftRight(digitsPtr1, length1,
      digitsBufferPtr1 + 1, rightShift1, True) + UInt32(1);

    // Second digits also must be shifted
    TDigitOpHelper.ShiftRight(digitsPtr2, length2, digitsBufferPtr2 + 1,
      rightShift1, True);
  end;

  //
  // Division main algorithm implementation
  //

  // Some digits2 cached digits
  lastDigit2 := digitsBufferPtr2[length2 - 1];
  preLastDigit2 := digitsBufferPtr2[length2 - 2];

  // Main divide loop
  maxLength := length1 - length2;
  i := maxLength;
  iLen2 := length1;

  while i <= (maxLength) do
  begin
    isMaxLength := iLen2 = length1;

    // Calculate estimates
    if (isMaxLength) then
    begin
      longDigit := digitsBufferPtr1[iLen2 - 1];
    end
    else
    begin
      longDigit := UInt64(digitsBufferPtr1[iLen2])
        shl TConstants.DigitBitCount or digitsBufferPtr1[iLen2 - 1];
    end;
    divEst := longDigit div lastDigit2;
    modEst := longDigit - divEst * lastDigit2;

    // Check estimate (maybe correct it)
    while True do
    begin

      if ((divEst = TConstants.BitCountStepOf2) or
        (divEst * preLastDigit2 > ((modEst shl TConstants.DigitBitCount) +
        digitsBufferPtr1[iLen2 - 2]))) then

      begin
        Dec(divEst);
        modEst := modEst + lastDigit2;
        if (modEst < TConstants.BitCountStepOf2) then
          continue;
      end;
      break;
    end;

    divRes := UInt32(divEst);

    // Multiply and subtract
    k := 0;
    j := 0;
    ji := i;
    while j < (length2) do
    begin
      mulRes := UInt64(divRes) * digitsBufferPtr2[j];
      t := digitsBufferPtr1[ji] - k - Int64(mulRes and $FFFFFFFF);
      digitsBufferPtr1[ji] := UInt32(t);

      // http://galfar.vevb.net/wp/2009/shift-right-delphi-vs-c/
      // 'SHR' treats its first operand as unsigned value even though it is a
      // variable of signed type whereas '>>' takes the sign bit into account.
      // Since 't' is an Int64 (meaning it can hold -ve numbers (signed type), we are going
      // to do an arithmetic shift right to handle such instances.

      { k := Int64(mulRes shr TConstants.DigitBitCount) -
        (t shr TConstants.DigitBitCount); } // <== produces different result

      k := Int64(mulRes shr TConstants.DigitBitCount);
      tempAsr := TUtils.Asr64(t, TConstants.DigitBitCount);
      k := UInt32(k - tempAsr);

      Inc(j);
      Inc(ji);
    end;

    if (not isMaxLength) then
    begin
      t := digitsBufferPtr1[iLen2] - k;
      digitsBufferPtr1[iLen2] := UInt32(t);
    end
    else
    begin
      t := -k;
    end;

    // Correct result if subtracted too much
    if (t < 0) then
    begin
      Dec(divRes);

      k := 0;
      j := 0;
      ji := i;
      while j < (length2) do
      begin
        t := Int64(digitsBufferPtr1[ji]) + digitsBufferPtr2[j] + k;
        digitsBufferPtr1[ji] := UInt32(t);

        // http://galfar.vevb.net/wp/2009/shift-right-delphi-vs-c/
        // 'SHR' treats its first operand as unsigned value even though it is a
        // variable of signed type whereas '>>' takes the sign bit into account.
        // Since 't' is an Int64 (meaning it can hold -ve numbers (signed type), we are going
        // to do an arithmetic shift right to handle such instances.

        // k := t shr TConstants.DigitBitCount; <== produces different result
        k := TUtils.Asr64(t, TConstants.DigitBitCount);
        Inc(j);
        Inc(ji);
      end;

      if (not isMaxLength) then
      begin
        digitsBufferPtr1[iLen2] := UInt32(k + digitsBufferPtr1[iLen2]);
      end;
    end;

    // Maybe save div result
    if (divNeeded) then
    begin

      digitsResPtr[i] := divRes;
    end;
    Dec(i);
    Dec(iLen2);
  end;
  if (modNeeded) then
  begin
    // First set correct mod length
    length1 := TDigitHelper.GetRealDigitsLength(digitsBufferPtr1, length2);
    // Next maybe shift result back to the right
    if ((shift1 <> 0) and (length1 <> 0)) then
    begin
      length1 := TDigitOpHelper.ShiftRight(digitsBufferPtr1, length1,
        digitsBufferPtr1, shift1, false);
    end;
  end;

  // Finally return length

  if not divNeeded then
  begin
    Result := 0;
    Exit;
  end
  else
  begin
    if digitsResPtr[maxLength] = 0 then
    begin
      Result := maxLength;
      Exit;
    end
    else
    begin
      Inc(maxLength);
      Result := maxLength;
      Exit;
    end;
  end;

end;

end.
