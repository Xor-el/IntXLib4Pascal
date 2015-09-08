unit DigitHelper;

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
  DTypes, Constants, IntX;

type
  /// <summary>
  /// Contains big integer UInt32[] digits utilitary methods.
  /// </summary>

  TDigitHelper = class

  public
    class function GetRealDigitsLength(digits: TMyUInt32Array; mlength: UInt32)
      : UInt32; Overload; static;

    class function GetRealDigitsLength(digits: PMyUInt32; mlength: UInt32)
      : UInt32; Overload; static;

    class procedure GetMinMaxLengthObjects(int1: TIntX; int2: TIntX;
      out smallerInt: TIntX; out biggerInt: TIntX); static;

    class procedure ToUInt32WithSign(value: Integer; out resultValue: UInt32;
      out negative: Boolean; out zeroinithelper: Boolean); static;

    class procedure ToUInt64WithSign(value: Int64; out resultValue: UInt64;
      out negative: Boolean; out zeroinithelper: Boolean); static;

    class procedure SetBlockDigits(block: PMyUInt32; blockLength: UInt32;
      value: UInt32); Overload; static;

    class procedure SetBlockDigits(block: PMyDouble; blockLength: UInt32;
      value: Double); Overload; static;

    class procedure DigitsBlockCopy(blockFrom: PMyUInt32; blockTo: PMyUInt32;
      count: UInt32); static;
  end;

implementation

/// <summary>
/// Returns real length of digits array (excluding leading zeroes).
/// </summary>
/// <param name="digits">Big ingeter digits.</param>
/// <param name="mlength">Initial big integers length.</param>
/// <returns>Real length.</returns>

class function TDigitHelper.GetRealDigitsLength(digits: TMyUInt32Array;
  mlength: UInt32): UInt32;
begin
  while ((mlength) > 0) and (digits[mlength - 1] = 0) do
  begin
    Dec(mlength);
  end;
  result := mlength;
end;

/// <summary>
/// Returns real length of digits array (excluding leading zeroes).
/// </summary>
/// <param name="digits">Big integer digits.</param>
/// <param name="mlength">Initial big integers length.</param>
/// <returns>Real length.</returns>

class function TDigitHelper.GetRealDigitsLength(digits: PMyUInt32;
  mlength: UInt32): UInt32;
begin
  while ((mlength) > 0) and (digits[mlength - 1] = 0) do
  begin
    Dec(mlength);
  end;
  result := mlength;
end;

/// <summary>
/// Determines <see cref="TIntX" /> object with lower length.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <param name="smallerInt">Resulting smaller big integer (by length only).</param>
/// <param name="biggerInt">Resulting bigger big integer (by length only).</param>

class procedure TDigitHelper.GetMinMaxLengthObjects(int1: TIntX; int2: TIntX;
  out smallerInt: TIntX; out biggerInt: TIntX);
begin
  if (int1._length < int2._length) then
  begin
    smallerInt := int1;
    biggerInt := int2;
  end
  else
  begin
    smallerInt := int2;
    biggerInt := int1;
  end;
end;

/// <summary>
/// Converts Integer value to UInt32 digit and value sign.
/// </summary>
/// <param name="value">Initial value.</param>
/// <param name="resultValue">Resulting unsigned part.</param>
/// <param name="negative">Resulting sign.</param>

class procedure TDigitHelper.ToUInt32WithSign(value: Integer;
  out resultValue: UInt32; out negative: Boolean; out zeroinithelper: Boolean);
begin
  negative := value < 0;

  if not negative then
  begin
    resultValue := UInt32(value);
  end
  else
  begin
    if value <> TConstants.MinIntValue then
    begin
      resultValue := UInt32(-value);
    end
    else
    begin
      resultValue := UInt32(TConstants.MaxIntValue) + UInt32(1);
    end;

  end;

end;

/// <summary>
/// Converts Int64 value to UInt64 digit and value sign.
/// </summary>
/// <param name="value">Initial value.</param>
/// <param name="resultValue">Resulting unsigned part.</param>
/// <param name="negative">Resulting sign.</param>

class procedure TDigitHelper.ToUInt64WithSign(value: Int64;
  out resultValue: UInt64; out negative: Boolean; out zeroinithelper: Boolean);
begin

  negative := value < 0;

  if not negative then
  begin
    resultValue := UInt64(value);
  end
  else
  begin
    if value <> TConstants.MinInt64Value then
    begin
      resultValue := UInt64(-value);
    end
    else
    begin
      resultValue := TConstants.MaxInt64Value + UInt64(1);
    end;

  end;
end;

/// <summary>
/// Sets digits in given block to given value.
/// </summary>
/// <param name="block">Block start pointer.</param>
/// <param name="blockLength">Block length.</param>
/// <param name="value">Value to set.</param>

class procedure TDigitHelper.SetBlockDigits(block: PMyUInt32;
  blockLength: UInt32; value: UInt32);
var
  blockEnd: PMyUInt32;
begin
  blockEnd := block + blockLength;
  while block < (blockEnd) do
  begin
    block^ := value;
    Inc(block);
  end;

end;

/// <summary>
/// Sets digits in given block to given value.
/// </summary>
/// <param name="block">Block start pointer.</param>
/// <param name="blockLength">Block length.</param>
/// <param name="value">Value to set.</param>

class procedure TDigitHelper.SetBlockDigits(block: PMyDouble;
  blockLength: UInt32; value: Double);
var
  blockEnd: PMyDouble;
begin
  blockEnd := block + blockLength;

  while block < (blockEnd) do
  begin
    block^ := value;
    Inc(block);
  end;

end;

/// <summary>
/// Copies digits from one block to another.
/// </summary>
/// <param name="blockFrom">From block start pointer.</param>
/// <param name="blockTo">To block start pointer.</param>
/// <param name="count">Count of dwords to copy.</param>

class procedure TDigitHelper.DigitsBlockCopy(blockFrom: PMyUInt32;
  blockTo: PMyUInt32; count: UInt32);
var
  blockFromEnd: PMyUInt32;
begin
  blockFromEnd := blockFrom + count;
  while blockFrom < (blockFromEnd) do
  begin
    blockTo^ := blockFrom^;
    Inc(blockTo);
    Inc(blockFrom);

  end;
end;

end.
