unit uDigitHelper;

{$I ..\Include\IntXLib.inc}

interface

uses
  uConstants,
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Contains big integer <see cref="TIntXLibUInt32Array" /> digits utilitary methods.
  /// </summary>

  TDigitHelper = class sealed(TObject)

  public

    /// <summary>
    /// Returns real length of digits array (excluding leading zeroes).
    /// </summary>
    /// <param name="digits">Big integer digits.</param>
    /// <param name="mlength">Initial big integers length.</param>
    /// <returns>Real length.</returns>

    class function GetRealDigitsLength(digits: TIntXLibUInt32Array;
      mlength: UInt32): UInt32; overload; static;

    /// <summary>
    /// Returns real length of digits array (excluding leading zeroes).
    /// </summary>
    /// <param name="digits">Big integer digits.</param>
    /// <param name="mlength">Initial big integers length.</param>
    /// <returns>Real length.</returns>

    class function GetRealDigitsLength(digits: PCardinal; mlength: UInt32)
      : UInt32; overload; static;

    /// <summary>
    /// Determines <see cref="TIntX" /> object with lower length.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <param name="smallerInt">Resulting smaller big integer (by length only).</param>
    /// <param name="biggerInt">Resulting bigger big integer (by length only).</param>

    class procedure GetMinMaxLengthObjects(int1: TIntX; int2: TIntX;
      out smallerInt: TIntX; out biggerInt: TIntX); static;

    /// <summary>
    /// Converts Integer value to UInt32 digit and value sign.
    /// </summary>
    /// <param name="value">Initial value.</param>
    /// <param name="resultValue">Resulting unsigned part.</param>
    /// <param name="negative">Resulting sign.</param>
    /// <param name="zeroinithelper">Indicates if <see cref="TIntX" /> was initialized from Zero or not.</param>

    class procedure ToUInt32WithSign(value: Integer; out resultValue: UInt32;
      out negative: Boolean; out zeroinithelper: Boolean); static;

    /// <summary>
    /// Converts Int64 value to UInt64 digit and value sign.
    /// </summary>
    /// <param name="value">Initial value.</param>
    /// <param name="resultValue">Resulting unsigned part.</param>
    /// <param name="negative">Resulting sign.</param>
    /// <param name="zeroinithelper">Indicates if <see cref="TIntX" /> was initialized from Zero or not.</param>

    class procedure ToUInt64WithSign(value: Int64; out resultValue: UInt64;
      out negative: Boolean; out zeroinithelper: Boolean); static;

    /// <summary>
    /// Sets digits in given block to given value.
    /// </summary>
    /// <param name="block">Block start pointer.</param>
    /// <param name="blockLength">Block length.</param>
    /// <param name="value">Value to set.</param>

    class procedure SetBlockDigits(block: PCardinal; blockLength: UInt32;
      value: UInt32); overload; static;

    /// <summary>
    /// Sets digits in given block to given value.
    /// </summary>
    /// <param name="block">Block start pointer.</param>
    /// <param name="blockLength">Block length.</param>
    /// <param name="value">Value to set.</param>

    class procedure SetBlockDigits(block: PDouble; blockLength: UInt32;
      value: Double); overload; static;

    /// <summary>
    /// Copies digits from one block to another.
    /// </summary>
    /// <param name="blockFrom">From block start pointer.</param>
    /// <param name="blockTo">To block start pointer.</param>
    /// <param name="count">Count of dwords to copy.</param>

    class procedure DigitsBlockCopy(blockFrom: PCardinal; blockTo: PCardinal;
      count: UInt32); static;

  end;

implementation

class function TDigitHelper.GetRealDigitsLength(digits: TIntXLibUInt32Array;
  mlength: UInt32): UInt32;
begin
  while ((mlength) > 0) and (digits[mlength - 1] = 0) do
  begin
    Dec(mlength);
  end;
  result := mlength;
end;

class function TDigitHelper.GetRealDigitsLength(digits: PCardinal;
  mlength: UInt32): UInt32;
begin
  while ((mlength) > 0) and (digits[mlength - 1] = 0) do
  begin
    Dec(mlength);
  end;
  result := mlength;
end;

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

class procedure TDigitHelper.ToUInt32WithSign(value: Integer;
  out resultValue: UInt32; out negative: Boolean; out zeroinithelper: Boolean);
begin
  negative := value < 0;
  zeroinithelper := value = 0;

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

class procedure TDigitHelper.ToUInt64WithSign(value: Int64;
  out resultValue: UInt64; out negative: Boolean; out zeroinithelper: Boolean);
begin

  negative := value < 0;
  zeroinithelper := value = 0;

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
      resultValue := UInt64(TConstants.MaxInt64Value) + UInt64(1);
    end;

  end;
end;

class procedure TDigitHelper.SetBlockDigits(block: PCardinal;
  blockLength: UInt32; value: UInt32);
var
  blockEnd: PCardinal;
begin
  blockEnd := block + blockLength;
  while block < (blockEnd) do
  begin
    block^ := value;
    Inc(block);
  end;

end;

class procedure TDigitHelper.SetBlockDigits(block: PDouble; blockLength: UInt32;
  value: Double);
var
  blockEnd: PDouble;
begin
  blockEnd := block + blockLength;

  while block < (blockEnd) do
  begin
    block^ := value;
    Inc(block);
  end;

end;

class procedure TDigitHelper.DigitsBlockCopy(blockFrom: PCardinal;
  blockTo: PCardinal; count: UInt32);
var
  blockFromEnd: PCardinal;
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
