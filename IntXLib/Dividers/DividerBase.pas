unit DividerBase;

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
  SysUtils, IDivider, Strings, DTypes, DigitOpHelper, DigitHelper, Enums,
  Constants, IntX;

type
  /// <summary>
  /// Base class for dividers.
  /// Contains default implementation of divide operation over <see cref="IntX" /> instances.
  /// </summary>

  TDividerBase = class abstract(TInterfacedObject, IIDivider)

  public
    function DivMod(int1: TIntX; int2: TIntX; out modRes: TIntX;
      resultFlags: TDivModResultFlags): TIntX; overload; virtual;

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
    /// <param name="cmpResult">Big integers comparsion result (pass -2 if omitted).</param>
    /// <returns>Resulting big integer length.</returns>

    function DivMod(digits1: TMyUInt32Array; digitsBuffer1: TMyUInt32Array;
      var length1: UInt32; digits2: TMyUInt32Array;
      digitsBuffer2: TMyUInt32Array; length2: UInt32; digitsRes: TMyUInt32Array;
      resultFlags: TDivModResultFlags; cmpResult: Integer): UInt32; overload;
      virtual; abstract;

    function DivMod(digitsPtr1: PMyUInt32; digitsBufferPtr1: PMyUInt32;
      var length1: UInt32; digitsPtr2: PMyUInt32; digitsBufferPtr2: PMyUInt32;
      length2: UInt32; digitsResPtr: PMyUInt32; resultFlags: TDivModResultFlags;
      cmpResult: Integer): UInt32; overload; virtual;

  end;

implementation

/// <summary>
/// Divides one <see cref="IntX" /> by another.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <param name="modRes">Remainder big integer.</param>
/// <param name="resultFlags">Which operation results to return.</param>
/// <returns>Divident big integer.</returns>
/// <exception cref="EArgumentNilException"><paramref name="int1" /> or <paramref name="int2" /> is a null reference.</exception>
/// <exception cref="EDivByZero"><paramref name="int2" /> equals
// zero.</exception>

function TDividerBase.DivMod(int1: TIntX; int2: TIntX; out modRes: TIntX;
  resultFlags: TDivModResultFlags): TIntX;
var
  divNeeded, modNeeded, resultNegative: Boolean;
  compareResult: Integer;
  modLength, divLength: UInt32;
  divRes: TIntX;
  digibuf, digires: TMyUInt32Array;

begin
  // Null reference exceptions

  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' int1');
  if TIntX.CompareRecords(int2, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' int2');

  // Check if int2 equals zero
  if (int2._length = 0) then
  begin
    raise EDivByZero.Create(DivideByZero);
  end;

  // Get flags
  divNeeded := (Ord(resultFlags) and Ord(TDivModResultFlags.dmrfDiv)) <> 0;
  modNeeded := (Ord(resultFlags) and Ord(TDivModResultFlags.dmrfMod)) <> 0;

  // Special situation: check if int1 equals zero; in this case zero is always returned
  if (int1._length = 0) then
  begin

    if modNeeded then
      modRes := TIntX.Create(0)
    else

      modRes := Default (TIntX);

    if divNeeded then
    begin
      result := TIntX.Create(0);
      Exit;
    end
    else
    begin

      result := Default (TIntX);
      Exit;
    end;
  end;

  // Special situation: check if int2 equals one - nothing to divide in this case
  if ((int2._length = 1) and (int2._digits[0] = 1)) then
  begin
    if modNeeded then
      modRes := TIntX.Create(0)
    else

      modRes := Default (TIntX);
    if divNeeded then
    begin

      if int2._negative then
      begin
        result := -int1;
        Exit;
      end
      else
      begin
        result := +int1;
        Exit;
      end;

    end
    else
    begin

      result := Default (TIntX);
      Exit;
    end;

  end;

  // Get resulting sign
  resultNegative := int1._negative xor int2._negative;

  // Check if int1 > int2
  compareResult := TDigitOpHelper.Cmp(int1._digits, int1._length, int2._digits,
    int2._length);
  if (compareResult < 0) then
  begin
    if modNeeded then
    begin
      modRes := TIntX.Create(int1);
    end
    else
    begin

      modRes := Default (TIntX);
    end;
    if divNeeded then
    begin
      result := TIntX.Create(0);
      Exit;
    end
    else
    begin

      result := Default (TIntX);
      Exit;
    end;

  end;
  if (compareResult = 0) then
  begin
    if modNeeded then
      modRes := TIntX.Create(0)
    else
    begin
      modRes := Default (TIntX);
    end;
    if divNeeded then
    begin
      if resultNegative then
      begin
        result := TIntX.Create(-1);
        Exit;
      end
      else
      begin
        result := TIntX.Create(1);
        Exit;
      end;
    end
    else
    begin

      result := Default (TIntX);
      Exit;
    end;

  end;

  //
  // Actually divide here (by Knuth algorithm)
  //

  // Prepare divident (if needed)

  divRes := Default (TIntX);
  if (divNeeded) then
  begin
    divRes := TIntX.Create(int1._length - int2._length + UInt32(1),
      resultNegative);
  end;

  // Prepare mod (if needed)
  if (modNeeded) then
  begin
    modRes := TIntX.Create(int1._length + UInt32(1), int1._negative);
  end
  else
  begin

    modRes := Default (TIntX);
  end;

  if modNeeded then
    digibuf := modRes._digits
  else
    digibuf := Nil;

  if divNeeded then
    digires := divRes._digits
  else
    digires := Nil;

  // Call procedure itself
  modLength := int1._length;

  divLength := DivMod(int1._digits, digibuf, modLength, int2._digits, Nil,
    int2._length, digires, resultFlags, compareResult);

  // Maybe set new lengths and perform normalization
  if (divNeeded) then
  begin
    divRes._length := divLength;
    divRes.TryNormalize();
  end;
  if (modNeeded) then
  begin
    modRes._length := modLength;
    modRes.TryNormalize();
  end;

  // Return div
  result := divRes;

end;

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
/// <param name="cmpResult">Big integers comparsion result (pass -2 if omitted).</param>
/// <returns>Resulting big integer length.</returns>

function TDividerBase.DivMod(digitsPtr1: PMyUInt32; digitsBufferPtr1: PMyUInt32;
  var length1: UInt32; digitsPtr2: PMyUInt32; digitsBufferPtr2: PMyUInt32;
  length2: UInt32; digitsResPtr: PMyUInt32; resultFlags: TDivModResultFlags;
  cmpResult: Integer): UInt32;
var
  divNeeded, modNeeded: Boolean;
  modRes: UInt32;
begin
  // Base implementation covers some special cases

  divNeeded := ((Ord(resultFlags) and Ord(TDivModResultFlags.dmrfDiv)) <> 0);
  modNeeded := ((Ord(resultFlags) and Ord(TDivModResultFlags.dmrfMod)) <> 0);

  //
  // Special cases
  //

  // Case when length1 == 0
  if (length1 = 0) then
  begin
    result := 0;
    Exit;
  end;

  // Case when both lengths are 1
  if ((length1 = 1) and (length2 = 1)) then
  begin
    if (divNeeded) then
    begin
      digitsResPtr^ := digitsPtr1^ div digitsPtr2^;
      if (digitsResPtr^ = 0) then
      begin
        length2 := 0;
      end;
    end;
    if (modNeeded) then
    begin
      digitsBufferPtr1^ := digitsPtr1^ mod digitsPtr2^;
      if (digitsBufferPtr1^ = 0) then
      begin
        length1 := 0;
      end;
    end;

    result := length2;
    Exit;
  end;

  // Compare digits first (if was not previously compared)
  if (cmpResult = -2) then
  begin
    cmpResult := TDigitOpHelper.Cmp(digitsPtr1, length1, digitsPtr2, length2);
  end;

  // Case when first value is smaller then the second one - we will have remainder only
  if (cmpResult < 0) then
  begin
    // Maybe we should copy first digits into remainder (if remainder is needed at all)
    if (modNeeded) then
    begin
      TDigitHelper.DigitsBlockCopy(digitsPtr1, digitsBufferPtr1, length1);
    end;

    // Zero as division result
    result := 0;
    Exit;
  end;

  // Case when values are equal
  if (cmpResult = 0) then
  begin
    // Maybe remainder must be marked as empty
    if (modNeeded) then
    begin
      length1 := 0;
    end;

    // One as division result
    if (divNeeded) then
    begin
      digitsResPtr^ := 1;
    end;

    result := 1;
    Exit;
  end;

  // Case when second length equals to 1
  if (length2 = 1) then
  begin
    // Call method basing on fact if div is needed

    if (divNeeded) then
    begin

      length2 := TDigitOpHelper.DivMod(digitsPtr1, length1, digitsPtr2^,
        digitsResPtr, modRes);
    end
    else
    begin
      modRes := TDigitOpHelper.Modulus(digitsPtr1, length1, digitsPtr2^);
    end;

    // Maybe save mod result
    if (modNeeded) then
    begin
      if (modRes <> 0) then
      begin
        length1 := 1;
        digitsBufferPtr1^ := modRes;
      end
      else
      begin
        length1 := 0;
      end;
    end;

    result := length2;
    Exit;
  end;

  // This is regular case, not special
  result := TConstants.MaxUInt32Value;
end;

end.