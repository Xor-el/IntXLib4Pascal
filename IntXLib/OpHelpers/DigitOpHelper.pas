unit DigitOpHelper;

{
  * Copyright (c) 2015 Ugochukwu Mmaduekwe ugo4brain@gmail.com

  *   This Source Code Form is subject to the terms of the Mozilla Public License
  * v. 2.0. If a copy of the MPL was not distributed with this file, You can
  * obtain one at http://mozilla.org/MPL/2.0/.

  *   Neither the name of Ugochukwu Mmaduekwe nor the names of its contributors may
  *  be used to endorse or promote products derived from this software without
  *  specific prior written permission.

}

{$POINTERMATH ON}

interface

uses
  Constants, DTypes, DigitHelper;

type
  /// <summary>
  /// Contains helping methods for operations over <see cref="IntX" /> digits as arrays.
  /// </summary>

  TDigitOpHelper = class

  public

    class function Add(digits1: TMyUInt32Array; length1: UInt32;
      digits2: TMyUInt32Array; length2: UInt32; digitsRes: TMyUInt32Array)
      : UInt32; Overload; static;

    class function Add(digitsPtr1: PMyUInt32; length1: UInt32;
      digitsPtr2: PMyUInt32; length2: UInt32; digitsResPtr: PMyUInt32): UInt32;
      Overload; static;

    class function Sub(digits1: TMyUInt32Array; length1: UInt32;
      digits2: TMyUInt32Array; length2: UInt32; digitsRes: TMyUInt32Array)
      : UInt32; Overload; static;

    class function Sub(digitsPtr1: PMyUInt32; length1: UInt32;
      digitsPtr2: PMyUInt32; length2: UInt32; digitsResPtr: PMyUInt32): UInt32;
      Overload; static;

    class function DivMod(digits1: TMyUInt32Array; length1: UInt32;
      int2: UInt32; divRes: TMyUInt32Array; out modRes: UInt32): UInt32;
      Overload; static;

    class function DivMod(digitsPtr1: PMyUInt32; length1: UInt32; int2: UInt32;
      divResPtr: PMyUInt32; out modRes: UInt32): UInt32; Overload; static;

    class function Modulus(digits1: TMyUInt32Array; length1: UInt32;
      int2: UInt32): UInt32; Overload; static;

    class function Modulus(digitsPtr1: PMyUInt32; length1: UInt32; int2: UInt32)
      : UInt32; Overload; static;

    class function Cmp(digits1: TMyUInt32Array; length1: UInt32;
      digits2: TMyUInt32Array; length2: UInt32): Integer; Overload; static;

    class function Cmp(digitsPtr1: PMyUInt32; length1: UInt32;
      digitsPtr2: PMyUInt32; length2: UInt32): Integer; Overload; static;

    class function CmpLen(length1: UInt32; length2: UInt32): Integer; static;

    class procedure ShiftRight(digits: TMyUInt32Array; offset: UInt32;
      mlength: UInt32; digitsRes: TMyUInt32Array; resOffset: UInt32;
      rightShift: Integer); Overload; static;

    class function ShiftRight(digitsPtr: PMyUInt32; mlength: UInt32;
      digitsResPtr: PMyUInt32; rightShift: Integer; resHasOffset: Boolean)
      : UInt32; Overload; static;

    class procedure BitwiseOr(digits1: TMyUInt32Array; length1: UInt32;
      digits2: TMyUInt32Array; length2: UInt32;
      digitsRes: TMyUInt32Array); static;

    class function BitwiseAnd(digits1: TMyUInt32Array; digits2: TMyUInt32Array;
      mlength: UInt32; digitsRes: TMyUInt32Array): UInt32; static;

    class function ExclusiveOr(digits1: TMyUInt32Array; length1: UInt32;
      digits2: TMyUInt32Array; length2: UInt32; digitsRes: TMyUInt32Array)
      : UInt32; static;

    class function OnesComplement(digits: TMyUInt32Array; mlength: UInt32;
      digitsRes: TMyUInt32Array): UInt32; static;

  end;

implementation

/// <summary>
/// Adds two big integers.
/// </summary>
/// <param name="digits1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="digits2">Second big integer digits.</param>
/// <param name="length2">Second big integer length.</param>
/// <param name="digitsRes">Resulting big integer digits.</param>
/// <returns>Resulting big integer length.</returns>

class function TDigitOpHelper.Add(digits1: TMyUInt32Array; length1: UInt32;
  digits2: TMyUInt32Array; length2: UInt32; digitsRes: TMyUInt32Array): UInt32;
var
  digitsPtr1, digitsPtr2, digitsResPtr: PMyUInt32;
begin

  digitsPtr1 := @digits1[0];
  digitsPtr2 := @digits2[0];
  digitsResPtr := @digitsRes[0];
  result := Add(digitsPtr1, length1, digitsPtr2, length2, digitsResPtr);
end;

/// <summary>
/// Adds two big integers using pointers.
/// </summary>
/// <param name="digitsPtr1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="digitsPtr2">Second big integer digits.</param>
/// <param name="length2">Second big integer length.</param>
/// <param name="digitsResPtr">Resulting big integer digits.</param>
/// <returns>Resulting big integer length.</returns>

class function TDigitOpHelper.Add(digitsPtr1: PMyUInt32; length1: UInt32;
  digitsPtr2: PMyUInt32; length2: UInt32; digitsResPtr: PMyUInt32): UInt32;
var
  lengthTemp, i: UInt32;
  c: UInt64;
  ptrTemp: PMyUInt32;

begin
  c := 0;

  if (length1 < length2) then
  begin
    // First must be bigger - swap
    lengthTemp := length1;
    length1 := length2;
    length2 := lengthTemp;

    ptrTemp := digitsPtr1;
    digitsPtr1 := digitsPtr2;
    digitsPtr2 := ptrTemp;
  end;

  // Perform digits adding

  i := 0;
  while i < (length2) do
  begin

    c := c + UInt64(digitsPtr1[i]) + digitsPtr2[i];
    digitsResPtr[i] := UInt32(c);
    c := c shr 32;
    Inc(i);
  end;

  // Perform digits + carry moving
  // for (uint i = length2; i < length1; ++i)
  i := length2;
  while i < (length1) do
  begin

    c := c + UInt64(digitsPtr1[i]);
    digitsResPtr[i] := UInt32(c);
    c := c shr 32;
    Inc(i);
  end;

  // Account last carry
  if (c <> 0) then
  begin

    digitsResPtr[length1] := UInt32(c);
    Inc(length1);
  end;

  result := length1;

end;

/// <summary>
/// Subtracts two big integers.
/// </summary>
/// <param name="digits1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="digits2">Second big integer digits.</param>
/// <param name="length2">Second big integer length.</param>
/// <param name="digitsRes">Resulting big integer digits.</param>
/// <returns>Resulting big integer length.</returns>

class function TDigitOpHelper.Sub(digits1: TMyUInt32Array; length1: UInt32;
  digits2: TMyUInt32Array; length2: UInt32; digitsRes: TMyUInt32Array): UInt32;
var
  digitsPtr1, digitsPtr2, digitsResPtr: PMyUInt32;
begin

  digitsPtr1 := @digits1[0];
  digitsPtr2 := @digits2[0];
  digitsResPtr := @digitsRes[0];
  result := Sub(digitsPtr1, length1, digitsPtr2, length2, digitsResPtr);
end;

/// <summary>
/// Subtracts two big integers using pointers.
/// </summary>
/// <param name="digitsPtr1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="digitsPtr2">Second big integer digits.</param>
/// <param name="length2">Second big integer length.</param>
/// <param name="digitsResPtr">Resulting big integer digits.</param>
/// <returns>Resulting big integer length.</returns>

class function TDigitOpHelper.Sub(digitsPtr1: PMyUInt32; length1: UInt32;
  digitsPtr2: PMyUInt32; length2: UInt32; digitsResPtr: PMyUInt32): UInt32;
var
  c: UInt64;
  i: UInt32;

begin
  c := 0;

  // Perform digits subtraction

  i := 0;
  while i < (length2) do
  begin

    c := UInt64(digitsPtr1[i]) - digitsPtr2[i] - c;
    digitsResPtr[i] := UInt32(c);
    c := c shr 63;
    Inc(i);
  end;

  // Perform digits + carry moving

  i := length2;
  while i < (length1) do
  begin

    c := digitsPtr1[i] - c;
    digitsResPtr[i] := UInt32(c);
    c := c shr 63;
    Inc(i);
  end;

  result := TDigitHelper.GetRealDigitsLength(digitsResPtr, length1);
end;

/// <summary>
/// Divides one big integer represented by it's digits on another one big integer.
/// Reminder is always filled (but not the result).
/// </summary>
/// <param name="digits1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="int2">Second integer.</param>
/// <param name="divRes">Div result (can be null - not filled in this case).</param>
/// <param name="modRes">Remainder (always filled).</param>
/// <returns>Result length (0 if result is null).</returns>

class function TDigitOpHelper.DivMod(digits1: TMyUInt32Array; length1: UInt32;
  int2: UInt32; divRes: TMyUInt32Array; out modRes: UInt32): UInt32;
var
  digits1Ptr, divResPtr: PMyUInt32;
begin
  digits1Ptr := @digits1[0];
  divResPtr := @divRes[0];

  result := DivMod(digits1Ptr, length1, int2, divResPtr, modRes);
end;

/// <summary>
/// Divides one big integer represented by it's digits on another one big integer.
/// Reminder is always filled (but not the result).
/// </summary>
/// <param name="digitsPtr1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="int2">Second integer.</param>
/// <param name="divResPtr">Div result (can be null - not filled in this case).</param>
/// <param name="modRes">Remainder (always filled).</param>
/// <returns>Result length (0 if result is null).</returns>

class function TDigitOpHelper.DivMod(digitsPtr1: PMyUInt32; length1: UInt32;
  int2: UInt32; divResPtr: PMyUInt32; out modRes: UInt32): UInt32;
var
  c: UInt64;
  index, res: UInt32;
begin
  c := 0;

  index := length1 - 1;
  while index < (length1) do
  begin

    c := (c shl TConstants.DigitBitCount) + digitsPtr1[index];
    res := UInt32(c div int2);
    c := c - UInt64(res) * int2;

    divResPtr[index] := res;
    Dec(index);
  end;

  modRes := UInt32(c);

  if ((divResPtr[length1 - 1]) = 0) then
  begin
    result := length1 - UInt32(1);
    Exit;
  end
  else
    result := length1 - UInt32(0);
end;

/// <summary>
/// Divides one big integer represented by it's digits on another one big ingeter.
/// Only remainder is filled.
/// </summary>
/// <param name="digits1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="int2">Second integer.</param>
/// <returns>Remainder.</returns>

class function TDigitOpHelper.Modulus(digits1: TMyUInt32Array; length1: UInt32;
  int2: UInt32): UInt32;
var
  digitsPtr1: PMyUInt32;
begin
  digitsPtr1 := @digits1[0];
  result := Modulus(digitsPtr1, length1, int2);
end;

/// <summary>
/// Divides one big integer represented by it's digits on another one big ingeter.
/// Only remainder is filled.
/// </summary>
/// <param name="digitsPtr1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="int2">Second integer.</param>
/// <returns>Remainder.</returns>

class function TDigitOpHelper.Modulus(digitsPtr1: PMyUInt32; length1: UInt32;
  int2: UInt32): UInt32;
var
  c: UInt64;
  res: UInt32;
  ptr1: PMyUInt32;
begin
  c := 0;
  ptr1 := digitsPtr1 + length1 - 1;
  while (ptr1) >= digitsPtr1 do
  begin
    c := (c shl TConstants.DigitBitCount) + ptr1^;
    res := UInt32(c div int2);
    c := c - UInt64(res) * int2;
    Dec(ptr1);
  end;

  result := UInt32(c);
end;

/// <summary>
/// Compares 2 <see cref="IntX" /> objects represented by digits only (not taking sign into account).
/// Returns "-1" if <paramref name="digits1" /> &lt; <paramref name="digits2" />, "0" if equal and "1" if &gt;.
/// </summary>
/// <param name="digits1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="digits2">Second big integer digits.</param>
/// <param name="length2">Second big integer length.</param>
/// <returns>Comparsion result.</returns>

class function TDigitOpHelper.Cmp(digits1: TMyUInt32Array; length1: UInt32;
  digits2: TMyUInt32Array; length2: UInt32): Integer;
var
  digitsPtr1, digitsPtr2: PMyUInt32;
begin
  // Always compare length if one of the integers has zero length
  if (length1 = 0) or (length2 = 0) then
  begin
    result := CmpLen(length1, length2);
    Exit;
  end;

  digitsPtr1 := @digits1[0];
  digitsPtr2 := @digits2[0];

  result := Cmp(digitsPtr1, length1, digitsPtr2, length2);
end;

/// <summary>
/// Compares 2 <see cref="IntX" /> objects represented by pointers only (not taking sign into account).
/// Returns "-1" if <paramref name="digitsPtr1" /> &lt; <paramref name="digitsPtr2" />, "0" if equal and "1" if &gt;.
/// </summary>
/// <param name="digitsPtr1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="digitsPtr2">Second big integer digits.</param>
/// <param name="length2">Second big integer length.</param>
/// <returns>Comparsion result.</returns>

class function TDigitOpHelper.Cmp(digitsPtr1: PMyUInt32; length1: UInt32;
  digitsPtr2: PMyUInt32; length2: UInt32): Integer;
var
  res: Integer;
  index: UInt32;
begin
  // Maybe length comparing will be enough
  res := CmpLen(length1, length2);

  if (res <> -2) then
  begin
    result := res;
    Exit;
  end;

  index := length1 - 1;

  while index < (length1) do
  begin
    if (digitsPtr1[index] <> digitsPtr2[index]) then
    begin
      if digitsPtr1[index] < digitsPtr2[index] then
      begin
        result := -1;
        Exit;
      end
      else
      begin
        result := 1;
        Exit;
      end;
    end;
    Dec(index);
  end;
  result := 0;
  Exit;
end;

/// <summary>
/// Compares two integers lengths. Returns -2 if further comparing is needed.
/// </summary>
/// <param name="length1">First big integer length.</param>
/// <param name="length2">Second big integer length.</param>
/// <returns>Comparsion result.</returns>

class function TDigitOpHelper.CmpLen(length1: UInt32; length2: UInt32): Integer;
begin
  if (length1 < length2) then
  begin
    result := -1;
    Exit;
  end;
  if (length1 > length2) then
  begin
    result := 1;
    Exit;
  end;
  if length1 = 0 then
  begin
    result := 0;
    Exit;
  end
  else
  begin
    result := -2;
    Exit;
  end;
end;

/// <summary>
/// Shifts big integer.
/// </summary>
/// <param name="digits">Big integer digits.</param>
/// <param name="offset">Big integer digits offset.</param>
/// <param name="mlength">Big integer length.</param>
/// <param name="digitsRes">Resulting big integer digits.</param>
/// <param name="resOffset">Resulting big integer digits offset.</param>
/// <param name="rightShift">Shift to the right (always between 1 an 31).</param>

class procedure TDigitOpHelper.ShiftRight(digits: TMyUInt32Array;
  offset: UInt32; mlength: UInt32; digitsRes: TMyUInt32Array; resOffset: UInt32;
  rightShift: Integer);
var
  digitsPtr, digitsResPtr: PMyUInt32;
begin
  digitsPtr := @digits[0];
  digitsResPtr := @digitsRes[0];

  ShiftRight(digitsPtr + offset, mlength, digitsResPtr + resOffset, rightShift,
    resOffset <> 0);

end;

/// <summary>
/// Shifts big integer.
/// </summary>
/// <param name="digitsPtr">Big integer digits.</param>
/// <param name="mlength">Big integer length.</param>
/// <param name="digitsResPtr">Resulting big integer digits.</param>
/// <param name="rightShift">Shift to the right (always between 1 an 31).</param>
/// <param name="resHasOffset">True if <paramref name="digitsResPtr" /> has offset.</param>
/// <returns>Resulting big integer length.</returns>

class function TDigitOpHelper.ShiftRight(digitsPtr: PMyUInt32; mlength: UInt32;
  digitsResPtr: PMyUInt32; rightShift: Integer; resHasOffset: Boolean): UInt32;
var
  rightShiftRev: Integer;
  digitsPtrEndPrev, digitsPtrNext: PMyUInt32;
  lastValue: UInt32;
begin
  rightShiftRev := TConstants.DigitBitCount - rightShift;

  // Shift first digit in special way
  if (resHasOffset) then
  begin
    (digitsResPtr - 1)^ := digitsPtr[0] shl rightShiftRev;
  end;

  if (rightShift = 0) then
  begin
    // Handle special situation here - only memcpy is needed (maybe)
    if (digitsPtr <> digitsResPtr) then
    begin
      TDigitHelper.DigitsBlockCopy(digitsPtr, digitsResPtr, mlength);
    end;
  end
  else
  begin
    // Shift all digits except last one
    digitsPtrEndPrev := digitsPtr + mlength - 1;

    digitsPtrNext := digitsPtr + 1;

    while digitsPtr < (digitsPtrEndPrev) do
    begin

      digitsResPtr^ := digitsPtr^ shr rightShift or
        digitsPtrNext^ shl rightShiftRev;
      Inc(digitsPtr);
      Inc(digitsPtrNext);
      Inc(digitsResPtr);
    end;

    // Shift last digit in special way

    lastValue := digitsPtr^ shr rightShift;
    if (lastValue <> 0) then
    begin
      digitsResPtr^ := lastValue;
    end
    else
    begin
      Dec(mlength);
    end;
  end;

  result := mlength;
end;

/// <summary>
/// Performs bitwise OR for two big integers.
/// </summary>
/// <param name="digits1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="digits2">Second big integer digits.</param>
/// <param name="length2">Second big integer length.</param>
/// <param name="digitsRes">Resulting big integer digits.</param>

class procedure TDigitOpHelper.BitwiseOr(digits1: TMyUInt32Array;
  length1: UInt32; digits2: TMyUInt32Array; length2: UInt32;
  digitsRes: TMyUInt32Array);
var
  digitsPtr1, digitsPtr2, digitsResPtr: PMyUInt32;
  i: UInt32;
begin
  digitsPtr1 := @digits1[0];
  digitsPtr2 := @digits2[0];
  digitsResPtr := @digitsRes[0];
  i := 0;
  while i < (length2) do
  begin
    digitsResPtr[i] := digitsPtr1[i] or digitsPtr2[i];
    Inc(i);
  end;

  TDigitHelper.DigitsBlockCopy(digitsPtr1 + length2, digitsResPtr + length2,
    length1 - length2);

end;

/// <summary>
/// Performs bitwise AND for two big integers.
/// </summary>
/// <param name="digits1">First big integer digits.</param>
/// <param name="digits2">Second big integer digits.</param>
/// <param name="length">Shorter big integer length.</param>
/// <param name="digitsRes">Resulting big integer digits.</param>
/// <returns>Resulting big integer length.</returns>

class function TDigitOpHelper.BitwiseAnd(digits1: TMyUInt32Array;
  digits2: TMyUInt32Array; mlength: UInt32; digitsRes: TMyUInt32Array): UInt32;
var
  digitsPtr1, digitsPtr2, digitsResPtr: PMyUInt32;
  i: UInt32;
begin
  digitsPtr1 := @digits1[0];
  digitsPtr2 := @digits2[0];
  digitsResPtr := @digitsRes[0];
  i := 0;
  while i < (mlength) do
  begin
    digitsResPtr[i] := digitsPtr1[i] and digitsPtr2[i];
    Inc(i);
  end;

  result := TDigitHelper.GetRealDigitsLength(digitsResPtr, mlength);

end;

/// <summary>
/// Performs bitwise XOR for two big integers.
/// </summary>
/// <param name="digits1">First big integer digits.</param>
/// <param name="length1">First big integer length.</param>
/// <param name="digits2">Second big integer digits.</param>
/// <param name="length2">Second big integer length.</param>
/// <param name="digitsRes">Resulting big integer digits.</param>
/// <returns>Resulting big integer length.</returns>

class function TDigitOpHelper.ExclusiveOr(digits1: TMyUInt32Array;
  length1: UInt32; digits2: TMyUInt32Array; length2: UInt32;
  digitsRes: TMyUInt32Array): UInt32;
var
  digitsPtr1, digitsPtr2, digitsResPtr: PMyUInt32;
  i: UInt32;
begin
  digitsPtr1 := @digits1[0];
  digitsPtr2 := @digits2[0];
  digitsResPtr := @digitsRes[0];
  i := 0;
  while i < (length2) do
  begin
    digitsResPtr[i] := digitsPtr1[i] xor digitsPtr2[i];
    Inc(i);
  end;

  TDigitHelper.DigitsBlockCopy(digitsPtr1 + length2, digitsResPtr + length2,
    length1 - length2);

  result := TDigitHelper.GetRealDigitsLength(digitsResPtr, length1);

end;

/// <summary>
/// Performs bitwise NOT for big integer.
/// </summary>
/// <param name="digits">Big integer digits.</param>
/// <param name="length">Big integer length.</param>
/// <param name="digitsRes">Resulting big integer digits.</param>
/// <returns>Resulting big integer length.</returns>

class function TDigitOpHelper.OnesComplement(digits: TMyUInt32Array;
  mlength: UInt32; digitsRes: TMyUInt32Array): UInt32;
var
  digitsPtr, digitsResPtr: PMyUInt32;
  i: UInt32;
begin
  digitsPtr := @digits[0];
  digitsResPtr := @digitsRes[0];
  i := 0;
  while i < (mlength) do
  begin
    digitsResPtr[i] := not digitsPtr[i];
    Inc(i);
  end;

  result := TDigitHelper.GetRealDigitsLength(digitsResPtr, mlength);

end;

end.
