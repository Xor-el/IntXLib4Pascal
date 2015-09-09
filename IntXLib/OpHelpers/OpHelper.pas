unit OpHelper;

{
  * Copyright (c) 2015 Ugochukwu Mmaduekwe ugo4brain@gmail.com

  *   This Source Code Form is subject to the terms of the Mozilla Public License
  * v. 2.0. If a copy of the MPL was not distributed with this file, You can
  * obtain one at http://mozilla.org/MPL/2.0/.

  *   Neither the name of Ugochukwu Mmaduekwe nor the names of its contributors may
  *  be used to endorse or promote products derived from this software without
  *  specific prior written permission.

}

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
  IntX, Constants, DigitHelper, Strings, SysUtils, DigitOpHelper, Bits, Enums,
  IMultiplier, MultiplyManager, DTypes;

type
  /// <summary>
  /// Contains helping methods for operations over <see cref="TIntX" />.
  /// </summary>

  TOpHelper = class sealed

  strict private
    class function Guesser(n: TIntX; g: TIntX; last: TIntX): TIntX; static;

  public
    class function Add(int1: TIntX; int2: TIntX): TIntX; static;
    class function Sub(int1: TIntX; int2: TIntX): TIntX; static;
    class function AddSub(int1: TIntX; int2: TIntX; subtract: Boolean)
      : TIntX; static;
    class function Pow(value: TIntX; power: UInt32; multiplyMode: TMultiplyMode)
      : TIntX; static;
    class function AbsoluteValue(value: TIntX): TIntX; static;
    class function LogN(base: TIntX; number: TIntX): TIntX; static;
    class function Square(value: TIntX): TIntX; static;
    class function SquareRoot(value: TIntX): TIntX; static;
    class function Factorial(value: TIntX): TIntX; static;
    class function GCD(int1: TIntX; int2: TIntX): TIntX; static;
    class function InvMod(int1: TIntX; int2: TIntX): TIntX; static;
    class function Bézoutsidentity(int1: TIntX; int2: TIntX; out bezOne: TIntX;
      out bezTwo: TIntX): TIntX; static;
    class function Cmp(int1: TIntX; int2: TIntX; throwNullException: Boolean)
      : Integer; overload; static;
    class function Cmp(int1: TIntX; int2: Integer): Integer; overload; static;
    class function Cmp(int1: TIntX; int2: UInt32): Integer; overload; static;
    class function Sh(IntX: TIntX; shift: Int64; toLeft: Boolean)
      : TIntX; static;
    class function BitwiseOr(int1: TIntX; int2: TIntX): TIntX; static;
    class function BitwiseAnd(int1: TIntX; int2: TIntX): TIntX; static;
    class function ExclusiveOr(int1: TIntX; int2: TIntX): TIntX; static;
    class function OnesComplement(value: TIntX): TIntX; static;

  end;

implementation

/// <summary>
/// Helper method used in computing Integer SquareRoot.
/// </summary>
class function TOpHelper.Guesser(n: TIntX; g: TIntX; last: TIntX): TIntX;
begin

  if ((last >= (g - 1)) and (last <= (g + 1))) then
  begin
    result := g;
    Exit;
  end
  else
  begin
    result := Guesser(n, (g + (n div g)) shr 1, g);
    Exit;
  end;
end;

/// <summary>
/// Adds two big integers.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Resulting big integer.</returns>
/// <exception cref="EArgumentException"><paramref name="int1" /> or <paramref name="int2" /> is too big for add operation.</exception>

class function TOpHelper.Add(int1: TIntX; int2: TIntX): TIntX;
var
  x, smallerInt, biggerInt, newInt: TIntX;

begin
  // Process zero values in special way
  if (int2._length = 0) then
  begin
    result := TIntX.Create(int1);
    Exit;
  end;
  if (int1._length = 0) then
  begin
    x := TIntX.Create(int2);
    x._negative := int1._negative; // always get sign of the first big integer
    result := x;
    Exit;
  end;

  // Determine big int with lower length

  TDigitHelper.GetMinMaxLengthObjects(int1, int2, smallerInt, biggerInt);

  // Check for add operation possibility
  if (biggerInt._length = TConstants.MaxUInt32Value) then
  begin
    raise EArgumentException.Create(Strings.IntegerTooBig);
  end;

  // Create new big int object of needed length
  newInt := TIntX.Create(biggerInt._length + 1, int1._negative);

  // Do actual addition
  newInt._length := TDigitOpHelper.Add(biggerInt._digits, biggerInt._length,
    smallerInt._digits, smallerInt._length, newInt._digits);

  // Normalization may be needed
  newInt.TryNormalize();

  result := newInt;
end;

/// <summary>
/// Subtracts two big integers.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Resulting big integer.</returns>

class function TOpHelper.Sub(int1: TIntX; int2: TIntX): TIntX;
var
  smallerInt, biggerInt, newInt: TIntX;
  compareResult: Integer;
  tempState: Boolean;
begin
  // Process zero values in special way
  if (int1._length = 0) then
  begin
    result := TIntX.Create(int2._digits, True);
    Exit;
  end;
  if (int2._length = 0) then
  begin
    result := TIntX.Create(int1);
    Exit;
  end;

  // Determine lower big int (without sign)

  compareResult := TDigitOpHelper.Cmp(int1._digits, int1._length, int2._digits,
    int2._length);
  if (compareResult = 0) then
  begin
    result := TIntX.Create(0); // integers are equal
    Exit;
  end;
  if (compareResult < 0) then
  begin
    smallerInt := int1;
    biggerInt := int2;
  end
  else
  begin
    smallerInt := int2;
    biggerInt := int1;
  end;

  tempState := TIntX.CompareRecords(int1, smallerInt);
  // Create new big TIntX object
  newInt := TIntX.Create(biggerInt._length, tempState xor int1._negative);

  // Do actual subtraction
  newInt._length := TDigitOpHelper.Sub(biggerInt._digits, biggerInt._length,
    smallerInt._digits, smallerInt._length, newInt._digits);

  // Normalization may be needed
  newInt.TryNormalize();

  result := newInt;
end;

/// <summary>
/// Adds/subtracts one <see cref="TIntX" /> to/from another.
/// Determines which operation to use basing on operands signs.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <param name="subtract">Was subtraction initially.</param>
/// <returns>Add/subtract operation result.</returns>
/// <exception cref="EArgumentNilException"><paramref name="int1" /> or <paramref name="int2" /> is a null reference.</exception>

class function TOpHelper.AddSub(int1: TIntX; int2: TIntX;
  subtract: Boolean): TIntX;

begin
  // Exceptions

  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then

    raise EArgumentNilException.Create(Strings.CantBeNull + ' int2');

  // Determine real operation type and result sign
  if (subtract xor int1._negative = int2._negative) then
    result := Add(int1, int2)
  else
    result := Sub(int1, int2);
end;

/// <summary>
/// Returns a specified big integer raised to the specified power.
/// </summary>
/// <param name="value">Number to raise.</param>
/// <param name="power">Power.</param>
/// <param name="multiplyMode">Multiply mode set explicitly.</param>
/// <returns>Number in given power.</returns>
/// <exception cref="ArgumentNillException"><paramref name="value" /> is a null reference.</exception>

class function TOpHelper.Pow(value: TIntX; power: UInt32;
  multiplyMode: TMultiplyMode): TIntX;
var
  msb: Integer;
  multiplier: IIMultiplier;
  res: TIntX;
  powerMask: UInt32;

begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  // Return one for zero pow
  if (power = 0) then
  begin
    result := 1;
    Exit;
  end;

  // Return the number itself from a power of one
  if (power = 1) then
  begin
    result := TIntX.Create(value);
    Exit;
  end;

  // Return zero for a zero
  if (value._length = 0) then
  begin
    result := TIntX.Create(0);
    Exit;
  end;

  // Get first one bit
  msb := TBits.msb(power);

  // Get multiplier
  multiplier := TMultiplyManager.GetMultiplier(multiplyMode);

  // Do actual raising
  res := value;
  powerMask := UInt32(1) shl (msb - 1);

  while powerMask <> 0 do
  begin

    // Always square
    res := multiplier.Multiply(res, res);

    // Maybe mul
    if ((power and powerMask) <> 0) then
    begin
      res := multiplier.Multiply(res, value);
    end;
    powerMask := powerMask shr 1;
  end;

  result := res;
end;

/// <summary>
/// Returns a non negative big integer.
/// </summary>
/// <param name="value">Number to get its absolute value.</param>
/// <returns>Absolute number.</returns>

class function TOpHelper.AbsoluteValue(value: TIntX): TIntX;
begin
  if value._negative then
    result := TIntX.Create(value, True)
  else
    result := value;
end;

/// <summary>
/// Calculates Integer Logarithm of a number <see cref="TIntX" /> object for a specified base.
/// the largest power the base can be raised to that does not exceed the number.
/// </summary>
/// <param name="base">base.</param>
/// <param name="number">number to get log of.</param>
/// <returns>Log.</returns>

class function TOpHelper.LogN(base: TIntX; number: TIntX): TIntX;
var
  lo, b_lo, hi, mid, b_mid, b_hi: TIntX;
begin
  lo := 0;
  b_lo := 1;
  hi := 1;
  b_hi := base;
  while (b_hi < number) do
  begin
    lo := hi;
    b_lo := b_hi;
    hi := hi * 2;
    b_hi := b_hi * b_hi;
  end;

  while ((hi - lo) > 1) do
  begin
    mid := (lo + hi) div 2;
    b_mid := b_lo * Integer(TIntX.Pow(base, UInt32(mid - lo)));
    if number < b_mid then
    begin
      hi := mid;
      b_hi := b_mid;
    end;

    if number > b_mid then
    begin
      lo := mid;
      b_lo := b_mid;
    end;

    if number = b_mid then
    begin
      result := mid;
      Exit;
    end;

  end;
  if b_hi = number then
    result := hi
  else
    result := lo;
end;

/// <summary>
/// Returns a specified big integer raised to the power of 2.
/// </summary>
/// <param name="value">Number to get its square.</param>
/// <returns>Squared number.</returns>

class function TOpHelper.Square(value: TIntX): TIntX;
begin
  result := TIntX.Pow(value, 2);
end;

/// <summary>
/// Calculates Integer SquareRoot of a TIntX object <see cref="http://www.dahuatu.com/RkWdPBx6W8.html" />
/// </summary>
/// <param name="value">value to get squareroot of.</param>
/// <returns>Integer SquareRoot.</returns>

class function TOpHelper.SquareRoot(value: TIntX): TIntX;
var
  sn: String;

begin
  if (value = 0) then
  begin
    result := 0;
    Exit;
  end;

  if (value = 1) then
  begin
    result := 1;
    Exit;
  end;

  if (value > 10) then
  begin
    sn := value.ToString();
    result := Guesser(value, TIntX.Parse(Copy(sn, 1, Length(sn) shr 1)), 0);
    Exit;
  end
  else
  begin
    result := Guesser(value, value shr 1, 0);
    Exit;
  end;
end;

/// <summary>
/// Returns a specified big integer holding the factorial of value.
/// </summary>
/// <param name="value">Number to get its factorial.</param>
/// <returns>factorialed number.</returns>
/// <exception cref="EArgumentException"><paramref name="value" /> is a negative value.</exception>

class function TOpHelper.Factorial(value: TIntX): TIntX;
var
  i: TIntX;

begin
  // Exception
  if (value < 0) then
    raise EArgumentException.Create(Format(Strings.NegativeFactorial,
      [value.ToString]));

  result := 1;
  // using iterative approach
  // recursive approach is slower and causes much overhead. it is also limiting (stackoverflow)
  i := 1;
  while i <= value do
  begin
    result := result * i;
    Inc(i);
  end;
end;

/// <summary>
/// Returns a specified big integer holding the GCD (Greatest common Divisor) of
/// two big integers using Binary GCD (Stein's algorithm).
/// using recursive implementation.
/// http://en.wikipedia.org/wiki/Binary_GCD_algorithm
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>GCD number.</returns>

class function TOpHelper.GCD(int1: TIntX; int2: TIntX): TIntX;
begin
  // check if int1 is negative and returns the absolute value of it.
  if int1._negative then
    int1 := AbsoluteValue(int1);

  // check if int2 is negative and returns the absolute value of it.
  if int2._negative then
    int2 := AbsoluteValue(int2);

  // simple cases (termination)

  if (int1 = int2) then
  begin
    result := int1;
    Exit;
  end;
  if (int1 = 0) then
  begin
    result := int2;
    Exit;
  end;
  if (int2 = 0) then
  begin
    result := int1;
    Exit;
  end;

  // look for factors of 2

  if not int1.IsOdd then // int1 is even
  begin
    if (int2.IsOdd) then // int2 is even
    begin
      result := GCD(int1 shr 1, int2);
      Exit;
    end
    else // both int1 and int2 are even
    begin
      result := GCD(int1 shr 1, int2 shr 1) shl 1;
      Exit;
    end;

  end;

  if not int2.IsOdd then // int1 is odd, int2 is even
  begin
    result := GCD(int1, int2 shr 1);
    Exit;
  end;

  // reduce larger argument

  if (int1 > int2) then
  begin
    result := GCD((int1 - int2) shr 1, int2);
    Exit;
  end;

  result := GCD((int2 - int1) shr 1, int1);

end;

// http://www.di-mgt.com.au/euclidean.html
// https://en.wikipedia.org/wiki/Modular_multiplicative_inverse
// Calculate Modular Inversion for two IntX Digits using Euclids Extended Algorithm

class function TOpHelper.InvMod(int1: TIntX; int2: TIntX): TIntX;
var
  u1, u3, v1, v3, t1, t3, q, iter: TIntX;
begin

  // /* Step X1. Initialise */
  u1 := 1;
  u3 := int1;
  v1 := 0;
  v3 := int2;
  // /* Remember odd/even iterations */
  iter := 1;
  // /* Step X2. Loop while v3 != 0 */
  while (v3 <> 0) do
  begin
    /// * Step X3. Divide and "Subtract" */
    q := u3 div v3;
    t3 := u3 mod v3;
    t1 := u1 + q * v1;
    // /* Swap */
    u1 := v1;
    v1 := t1;
    u3 := v3;
    v3 := t3;
    iter := -iter;
  end;

  // /* Make sure u3 = gcd(u,v) == 1 */

  if (u3 <> 1) then // u3 is nowing holding the GCD Value
  begin
    result := 0; // /* Error: No inverse exists */
    Exit;
  end;
  // /* Ensure a positive result */

  // result will hold the Modular Inverse (InvMod)
  if (iter < 0) then
    result := int2 - u1
  else
    result := u1;
end;

// https://en.wikipedia.org/wiki/Bézout's_identity
// https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Pseudocode
// Calculate Bézoutsidentity for two IntX Digits using Euclids Extended Algorithm

class function TOpHelper.Bézoutsidentity(int1: TIntX; int2: TIntX;
  out bezOne: TIntX; out bezTwo: TIntX): TIntX;
var
  s, t, r, old_s, old_t, old_r, quotient, prov: TIntX;
begin

  if int1._negative then
    raise EArgumentNilException.Create(Strings.BezoutNegativeNotAllowed
      + ' int1');

  if int2._negative then
    raise EArgumentNilException.Create(Strings.BezoutNegativeNotAllowed + ' '
      + ' int2');

  if (int1 = 0) or (int2 = 0) then
    raise EArgumentException.Create(Strings.BezoutNegativeCantComputeZero);

  s := 0;
  t := 1;
  r := int2;
  old_s := 1;
  old_t := 0;
  old_r := int1;

  while r <> 0 do
  begin

    quotient := old_r div r;
    prov := r;
    r := old_r - quotient * prov;
    old_r := prov;
    prov := s;
    s := old_s - quotient * prov;
    old_s := prov;
    prov := t;
    t := old_t - quotient * prov;
    old_t := prov;

  end;
  if old_r._negative then
  begin
    old_r := TIntX.AbsoluteValue(old_r);
  end;

  bezOne := old_s; // old_s holds the first value of bezout identity
  bezTwo := old_t; // old_t holds the second value of bezout identity
  result := old_r; // old_r holds the GCD Value

end;

/// <summary>
/// Compares 2 <see cref="TIntX" /> objects.
/// Returns "-2" if any argument is null, "-1" if <paramref name="int1" /> &lt; <paramref name="int2" />,
/// "0" if equal and "1" if &gt;.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <param name="throwNullException">Raises or not <see cref="NullReferenceException" />.</param>
/// <returns>Comparsion result.</returns>
/// <exception cref="EArgumentNilException"><paramref name="int1" /> or <paramref name="int2" /> is a null reference and <paramref name= "throwNullException" /> is set to true.</exception>

class function TOpHelper.Cmp(int1: TIntX; int2: TIntX;
  throwNullException: Boolean): Integer;
var
  isNull1, isNull2: Boolean;
begin

  // If one of the operands is null, throw exception or return -2
  isNull1 := TIntX.CompareRecords(int1, Default (TIntX));
  isNull2 := TIntX.CompareRecords(int2, Default (TIntX));

  if (isNull1 or isNull2) then
  begin
    if (throwNullException) then
    begin
      if isNull1 then
        raise EArgumentNilException.Create(Strings.CantBeNullCmp + ' int1')
      else if isNull2 then
        raise EArgumentNilException.Create(Strings.CantBeNullCmp + ' int2')
    end

    else
    begin
      if (isNull1 and isNull2) then
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
  end;
  // Compare sign
  if (int1._negative and not int2._negative) then
  begin
    result := -1;
    Exit;
  end;
  if (not int1._negative and int2._negative) then
  begin
    result := 1;
    Exit;
  end;

  // Compare presentation
  if int1._negative then

    result := TDigitOpHelper.Cmp(int1._digits, int1._length, int2._digits,
      int2._length) * -1
  else
    result := TDigitOpHelper.Cmp(int1._digits, int1._length, int2._digits,
      int2._length) * 1;

end;

/// <summary>
/// Compares <see cref="TIntX" /> object to int.
/// Returns "-1" if <paramref name="int1" /> &lt; <paramref name="int2" />, "0" if equal and "1" if &gt;.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second integer.</param>
/// <returns>Comparsion result.</returns>

class function TOpHelper.Cmp(int1: TIntX; int2: Integer): Integer;
var
  digit2: UInt32;
  negative2, zeroinithelper: Boolean;
begin
  // Special processing for zero
  if (int2 = 0) then
  begin
    if int1._length = 0 then
    begin
      result := 0;
      Exit;
    end
    else
    begin
      if int1._negative then
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

  end;
  if (int1._length = 0) then
  begin
    if int2 > 0 then
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

  // Compare presentation
  if (int1._length > 1) then
  begin
    if int1._negative then
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

  TDigitHelper.ToUInt32WithSign(int2, digit2, negative2, zeroinithelper);

  // Compare sign
  if (int1._negative and not negative2) then
  begin
    result := -1;
    Exit;
  end;
  if (not int1._negative and negative2) then
  begin
    result := 1;
    Exit;
  end;

  if int1._digits[0] = digit2 then
  begin
    result := 0;
    Exit;
  end
  else
  begin
    if (int1._digits[0]) < (digit2 xor UInt32(Ord(negative2))) then
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

end;

/// <summary>
/// Compares <see cref="TIntX" /> object to unsigned int.
/// Returns "-1" if <paramref name="int1" /> &lt; <paramref name="int2" />, "0" if equal and "1" if &gt;.
/// For internal use.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second unsigned integer.</param>
/// <returns>Comparsion result.</returns>

class function TOpHelper.Cmp(int1: TIntX; int2: UInt32): Integer;
begin
  // Special processing for zero
  if (int2 = 0) then
  begin
    if int1._length = 0 then
    begin
      result := 0;
      Exit;
    end
    else
    begin
      if int1._negative then
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

  end;
  if (int1._length = 0) then
  begin
    result := -1;
    Exit;
  end;

  // Compare presentation
  if (int1._negative) then
  begin
    result := -1;
    Exit;
  end;
  if (int1._length > 1) then
  begin
    result := 1;
    Exit;
  end;
  if int1._digits[0] = int2 then
  begin
    result := 0;
    Exit;
  end
  else
  begin
    if int1._digits[0] < int2 then
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
end;

/// <summary>
/// Shifts <see cref="TIntX" /> object.
/// Determines which operation to use basing on shift sign.
/// </summary>
/// <param name="IntX">Big integer.</param>
/// <param name="shift">Bits count to shift.</param>
/// <param name="toLeft">If true the shifting to the left.</param>
/// <returns>Bitwise shift operation result.</returns>
/// <exception cref="ArgumentNuilException"><paramref name="IntX" /> is a null reference.</exception>

class function TOpHelper.Sh(IntX: TIntX; shift: Int64; toLeft: Boolean): TIntX;
var
  bitCount, intXBitCount, newBitCount: UInt64;
  negativeShift, zeroinithelper: Boolean;
  msb, smallShift: Integer;
  newLength, fullDigits: UInt32;
  newInt: TIntX;
begin

  // Exceptions
  if TIntX.CompareRecords(IntX, Default (TIntX)) then

  begin
    raise EArgumentNilException.Create(Strings.CantBeNullOne + ' intX');
  end;

  // Zero can't be shifted
  if (IntX._length = 0) then
  begin
    result := TIntX.Create(0);
    Exit;
  end;

  // Can't shift on zero value
  if (shift = 0) then
  begin
    result := TIntX.Create(IntX);
    Exit;
  end;

  // Determine real bits count and direction

  TDigitHelper.ToUInt64WithSign(shift, bitCount, negativeShift, zeroinithelper);
  toLeft := toLeft xor negativeShift;

  msb := TBits.msb(IntX._digits[IntX._length - 1]);
  intXBitCount := UInt64(IntX._length - 1) * TConstants.DigitBitCount +
    UInt64(msb) + UInt64(1);

  // If shifting to the right and shift is too big then return zero
  if (not toLeft and (bitCount >= intXBitCount)) then
  begin
    result := TIntX.Create(0);
    Exit;
  end;

  // Calculate new bit count
  if toLeft then
    newBitCount := intXBitCount + bitCount
  else
    newBitCount := intXBitCount - bitCount;

  // If shifting to the left and shift is too big to fit in big integer, throw an exception
  if (toLeft and (newBitCount > TConstants.MaxBitCount)) then
  begin
    raise EArgumentException.Create(Strings.IntegerTooBig + ' intX');
  end;

  // Get exact length of new big integer (no normalize is ever needed here).
  // Create new big integer with given length
  if newBitCount mod TConstants.DigitBitCount = 0 then
    newLength := UInt32(newBitCount div TConstants.DigitBitCount + UInt64(0))
  else
  begin
    newLength := UInt32(newBitCount div TConstants.DigitBitCount + UInt64(1));
  end;
  newInt := TIntX.Create(newLength, IntX._negative);
  newInt._zeroinithelper := zeroinithelper;

  // Get full and small shift values
  fullDigits := UInt32(bitCount div TConstants.DigitBitCount);
  smallShift := Integer(bitCount mod TConstants.DigitBitCount);

  // We can just copy (no shift) if small shift is zero
  if (smallShift = 0) then
  begin
    if (toLeft) then
    begin
      Move(IntX._digits[0], newInt._digits[fullDigits],
        IntX._length * SizeOf(UInt32));

    end
    else
    begin
      Move(IntX._digits[fullDigits], newInt._digits[0],
        newLength * SizeOf(UInt32));

    end
  end
  else
  begin
    // Do copy with real shift in the needed direction
    if (toLeft) then
    begin
      TDigitOpHelper.ShiftRight(IntX._digits, 0, IntX._length, newInt._digits,
        fullDigits + 1, TConstants.DigitBitCount - smallShift);
    end
    else
    begin
      // If new result length is smaller then original length we shouldn't lose any digits
      if (newLength < (IntX._length - fullDigits)) then
      begin
        Inc(newLength);
      end;

      TDigitOpHelper.ShiftRight(IntX._digits, fullDigits, newLength,
        newInt._digits, 0, smallShift);
    end;
  end;

  result := newInt;
end;

/// <summary>
/// Performs bitwise OR for two big integers.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Resulting big integer.</returns>

class function TOpHelper.BitwiseOr(int1: TIntX; int2: TIntX): TIntX;
var
  smallerInt, biggerInt, newInt: TIntX;
begin
  // Exceptions

  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then

    raise EArgumentNilException.Create(Strings.CantBeNull + ' int2');

  // Process zero values in special way
  if (int1._length = 0) then
  begin
    result := TIntX.Create(int2);
    Exit;
  end;
  if (int2._length = 0) then
  begin
    result := TIntX.Create(int1);
    Exit;
  end;

  // Determine big int with lower length
  TDigitHelper.GetMinMaxLengthObjects(int1, int2, smallerInt, biggerInt);

  // Create new big int object of needed length
  newInt := TIntX.Create(biggerInt._length, int1._negative or int2._negative);

  // Do actual operation
  TDigitOpHelper.BitwiseOr(biggerInt._digits, biggerInt._length,
    smallerInt._digits, smallerInt._length, newInt._digits);

  result := newInt;
end;

/// <summary>
/// Performs bitwise AND for two big integers.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Resulting big integer.</returns>

class function TOpHelper.BitwiseAnd(int1: TIntX; int2: TIntX): TIntX;
var
  smallerInt, biggerInt, newInt: TIntX;
begin

  // Exceptions

  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then

    raise EArgumentNilException.Create(Strings.CantBeNull + ' int2');

  // Process zero values in special way
  if ((int1._length = 0) or (int2._length = 0)) then
  begin
    result := TIntX.Create(0);
    Exit;
  end;

  // Determine big int with lower length
  TDigitHelper.GetMinMaxLengthObjects(int1, int2, smallerInt, biggerInt);

  // Create new big int object of needed length
  newInt := TIntX.Create(smallerInt._length, int1._negative and int2._negative);

  // Do actual operation
  newInt._length := TDigitOpHelper.BitwiseAnd(biggerInt._digits,
    smallerInt._digits, smallerInt._length, newInt._digits);

  // Normalization may be needed
  newInt.TryNormalize();

  result := newInt;
end;

/// <summary>
/// Performs bitwise XOR for two big integers.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Resulting big integer.</returns>

class function TOpHelper.ExclusiveOr(int1: TIntX; int2: TIntX): TIntX;
var
  smallerInt, biggerInt, newInt: TIntX;
begin

  // Exceptions
  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then

    raise EArgumentNilException.Create(Strings.CantBeNull + ' int2');

  // Process zero values in special way
  if (int1._length = 0) then
  begin
    result := TIntX.Create(int2);
    Exit;
  end;
  if (int2._length = 0) then
  begin
    result := TIntX.Create(int1);
    Exit;
  end;

  // Determine big int with lower length
  TDigitHelper.GetMinMaxLengthObjects(int1, int2, smallerInt, biggerInt);

  // Create new big int object of needed length
  newInt := TIntX.Create(biggerInt._length, int1._negative xor int2._negative);

  // Do actual operation
  newInt._length := TDigitOpHelper.ExclusiveOr(biggerInt._digits,
    biggerInt._length, smallerInt._digits, smallerInt._length, newInt._digits);

  // Normalization may be needed
  newInt.TryNormalize();

  result := newInt;
end;

/// <summary>
/// Performs bitwise NOT for big integer.
/// </summary>
/// <param name="value">Big integer.</param>
/// <returns>Resulting big integer.</returns>

class function TOpHelper.OnesComplement(value: TIntX): TIntX;
var
  newInt: TIntX;
begin

  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create(Strings.CantBeNull + ' value');
  end;

  // Process zero values in special way
  if (value._length = 0) then
  begin
    result := TIntX.Create(0);
    Exit;
  end;

  // Create new big TIntX object of needed length
  newInt := TIntX.Create(value._length, not value._negative);

  // Do actual operation
  newInt._length := TDigitOpHelper.OnesComplement(value._digits, value._length,
    newInt._digits);

  // Normalization may be needed
  newInt.TryNormalize();

  result := newInt;
end;

end.
