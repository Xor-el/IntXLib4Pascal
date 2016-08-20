unit uOpHelper;

{$I ..\Include\IntXLib.inc}

interface

uses
  Math,
  SysUtils,
  uConstants,
  uDigitHelper,
  uStrings,
  uDigitOpHelper,
  uXBits,
  uEnums,
  uIMultiplier,
  uMultiplyManager,
  uPcgRandomMinimal,
  uMillerRabin,
  uUtils,
  uIntXLibTypes,
  uIntX;

type
  /// <summary>
  /// Contains helping methods for operations over <see cref="TIntX" />.
  /// </summary>

  TOpHelper = class sealed(TObject)
  public

    const
    /// <summary>
    /// Constant used for internal operations.
    /// </summary>
    kcbitUint = Integer(32);

  type
    /// <summary>
    /// record used for internal operations.
    /// </summary>
    /// <remarks>
    /// Both record fields are aligned at zero offsets.
    /// </remarks>
    TDoubleUlong = packed record
      case Byte of
        0:

          (
            /// <summary>
            /// Double variable used for internal operations.
            /// </summary>
            dbl: Double
          );

        1:

          (
            /// <summary>
            /// UInt64 variable used for internal operations.
            /// </summary>
            uu: UInt64
          );

    end;

  type
    /// <summary>
    /// Record used for internal building operations.
    /// </summary>
    TBuilder = record
    private

      // class var

      /// <summary>
      /// Integer variable used for internal operations.
      /// </summary>
      /// <remarks>For a single UInt32, _iuLast is 0.</remarks>
      _iuLast: Integer;

      /// <summary>
      /// UInt32 variable used for internal operations.
      /// </summary>
      /// <remarks>Used if _iuLast = 0.</remarks>
      _uSmall: UInt32;

      /// <summary>
      /// <see cref="TIntXLibUInt32Array" /> used for internal operations.
      /// </summary>
      /// <remarks>Used if _iuLast > 0.</remarks>
      _rgu: TIntXLibUInt32Array;

    public
      /// <summary>
      /// Used to create an Instance of <see cref="TOpHelper.TBuilder" />. for internal use only.
      /// </summary>
      constructor Create(bn: TIntX; var sign: Integer);
      /// <summary>
      /// Function used for Internal operations.
      /// </summary>
      procedure GetApproxParts(out exp: Integer; out man: UInt64);

    end;

  public

    /// <summary>
    /// Function used for Internal operations.
    /// </summary>
    class function CbitHighZero(u: UInt32): Integer; overload; static;

    /// <summary>
    /// Function used for Internal operations.
    /// </summary>
    class function CbitHighZero(uu: UInt64): Integer; overload; static;

    /// <summary>
    /// Function used for Internal operations.
    /// </summary>
    class function MakeUlong(uHi: UInt32; uLo: UInt32): UInt64; static;

    { /// <summary>
      /// Helper method used in computing Integer SquareRoot.
      /// </summary>
      /// <param name="n">
      /// Internal variable
      /// </param>
      /// <param name="g">
      /// Internal variable
      /// </param>
      /// <param name="last">
      /// Internal variable
      /// </param>
      class function Guesser(n: TIntX; g: TIntX; last: TIntX): TIntX; static; }

    /// <summary>
    /// Returns the number of trailing 0-bits in x, starting at the least significant
    /// bit position.
    /// </summary>
    /// <param name="x">value to get number of trailing zero bits.</param>
    /// <returns>number of trailing 0-bits.</returns>
    /// <remarks>If x is 0, the result is undefined as per GCC Implementation.</remarks>

    class function __builtin_ctz(x: UInt32): Integer; inline; static;

  public

    /// <summary>
    /// Adds two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Resulting big integer.</returns>
    /// <exception cref="EArgumentException"><paramref name="int1" /> or <paramref name="int2" /> is too big for add operation.</exception>

    class function Add(int1: TIntX; int2: TIntX): TIntX; static;

    /// <summary>
    /// Subtracts two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Resulting big integer.</returns>

    class function Sub(int1: TIntX; int2: TIntX): TIntX; static;

    /// <summary>
    /// Adds/subtracts one <see cref="TIntX" /> to/from another.
    /// Determines which operation to use basing on operands signs.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <param name="subtract">Was subtraction initially.</param>
    /// <returns>Add/subtract operation result.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="int1" /> or <paramref name="int2" /> is a null reference.</exception>

    class function AddSub(int1: TIntX; int2: TIntX; subtract: Boolean)
      : TIntX; static;

    /// <summary>
    /// Returns a specified big integer raised to the specified power.
    /// </summary>
    /// <param name="value">Number to raise.</param>
    /// <param name="power">Power.</param>
    /// <param name="multiplyMode">Multiply mode set explicitly.</param>
    /// <returns>Number in given power.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class function Pow(value: TIntX; power: UInt32; multiplyMode: TMultiplyMode)
      : TIntX; static;

    /// <summary>
    /// Returns a Non-Negative Random <see cref="TIntX" /> object using Pcg Random.
    /// </summary>
    /// <returns>Random TIntX value.</returns>

    class function Random(): TIntX; static;

    /// <summary>
    /// Returns a Non-Negative Random <see cref="TIntX" /> object using Pcg Random within the specified Range. (Max not Included)
    /// </summary>
    /// <param name="Min">Minimum value.</param>
    /// <param name="Max">Maximum value (Max not Included)</param>
    /// <returns>Random TIntX value.</returns>

    class function RandomRange(Min: UInt32; Max: UInt32): TIntX; static;

    /// <summary>
    /// Returns a non negative big integer.
    /// </summary>
    /// <param name="value">value to get its absolute value.</param>
    /// <returns>Absolute number.</returns>

    class function AbsoluteValue(value: TIntX): TIntX; static;

    /// <summary>
    /// The base-10 logarithm of the value.
    /// </summary>
    /// <param name="value">The value.</param>
    /// <returns>The base-10 logarithm of the value.</returns>
    /// <remarks> Source : Microsoft .NET Reference on GitHub </remarks>

    class function Log10(value: TIntX): Double; static;

    /// <summary>
    /// Calculates the natural logarithm of the value.
    /// </summary>
    /// <param name="value">The value.</param>
    /// <returns>The natural logarithm.</returns>
    /// <remarks> Source : Microsoft .NET Reference on GitHub </remarks>

    class function Ln(value: TIntX): Double; static;

    /// <summary>
    /// Calculates Logarithm of a number <see cref="TIntX" /> object for a specified base.
    /// the largest power the base can be raised to that does not exceed the number.
    /// </summary>
    /// <param name="base">base.</param>
    /// <param name="value">number to get log of.</param>
    /// <returns>Log value.</returns>
    /// <remarks> Source : Microsoft .NET Reference on GitHub </remarks>

    class function LogN(base: Double; value: TIntX): Double; static;

    /// <summary>
    /// Calculates Integer Logarithm of a number <see cref="TIntX" /> object for a specified base.
    /// the largest power the base can be raised to that does not exceed the number.
    /// </summary>
    /// <param name="base">base.</param>
    /// <param name="number">number to get Integer log of.</param>
    /// <returns>Integer Log.</returns>
    /// <seealso href="http://gist.github.com/dharmatech/409723">[IntegerLogN Implementation]</seealso>

    class function IntegerLogN(base: TIntX; number: TIntX): TIntX; static;

    /// <summary>
    /// Returns a specified big integer raised to the power of 2.
    /// </summary>
    /// <param name="value">Number to get its square.</param>
    /// <returns>Squared number.</returns>

    class function Square(value: TIntX): TIntX; static;

    /// <summary>
    /// Calculates Integer SquareRoot of <see cref="TIntX" /> object
    /// </summary>
    /// <param name="value">value to get Integer squareroot of.</param>
    /// <returns>Integer SquareRoot.</returns>
    /// <seealso href="http://www.dahuatu.com/RkWdPBx6W8.html">[IntegerSquareRoot Implementation]</seealso>

    class function IntegerSquareRoot(value: TIntX): TIntX; static;

    /// <summary>
    /// Returns a specified big integer holding the factorial of value.
    /// </summary>
    /// <param name="value">Number to get its factorial.</param>
    /// <returns>factorialed number.</returns>
    /// <exception cref="EArgumentException"><paramref name="value" /> is a negative value.</exception>

    class function Factorial(value: TIntX): TIntX; static;

    /// <summary>
    /// (Optimized GCD).
    /// Returns a specified big integer holding the GCD (Greatest common Divisor) of
    /// two big integers using Binary GCD (Stein's algorithm).
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>GCD number.</returns>
    /// <seealso href="http://lemire.me/blog/archives/2013/12/26/fastest-way-to-compute-the-greatest-common-divisor/">[GCD Implementation]</seealso>
    /// <seealso href="https://hbfs.wordpress.com/2013/12/10/the-speed-of-gcd/">[GCD Implementation Optimizations]</seealso>

    class function GCD(int1: TIntX; int2: TIntX): TIntX; static;

    /// <summary>
    /// (LCM).
    /// Returns a specified big integer holding the LCM (Least Common Multiple) of
    /// two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>LCM number.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="int1" /> is a null reference.</exception>
    /// <exception cref="EArgumentNilException"><paramref name="int2" /> is a null reference.</exception>

    class function LCM(int1: TIntX; int2: TIntX): TIntX; static;

    /// <summary>
    /// Calculate Modular Inverse for two <see cref="TIntX" /> objects using Euclids Extended Algorithm.
    /// returns Zero if no Modular Inverse Exists for the Inputs
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Modular Inverse.</returns>
    /// <seealso href="https://en.wikipedia.org/wiki/Modular_multiplicative_inverse">[Modular Inverse Explanation]</seealso>
    /// <seealso href="http://www.di-mgt.com.au/euclidean.html">[Modular Inverse Implementation]</seealso>

    class function InvMod(int1: TIntX; int2: TIntX): TIntX; static;

    /// <summary>
    /// Calculates Calculates Modular Exponentiation of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">value to compute ModPow of.</param>
    /// <param name="exponent">exponent to use.</param>
    /// <param name="modulus">modulus to use.</param>
    /// <returns>Computed value.</returns>
    /// <seealso href="https://en.wikipedia.org/wiki/Modular_exponentiation">[Modular Exponentiation Explanation]</seealso>

    class function ModPow(value: TIntX; exponent: TIntX; modulus: TIntX)
      : TIntX; static;

    /// <summary>
    /// Calculates Bézoutsidentity for two <see cref="TIntX" /> objects using Euclids Extended Algorithm
    /// </summary>
    /// <param name="int1">first value.</param>
    /// <param name="int2">second value.</param>
    /// <param name="bezOne">first bezout value.</param>
    /// <param name="bezTwo">second bezout value.</param>
    /// <returns>GCD (Greatest Common Divisor) value.</returns>
    /// <seealso href="https://en.wikipedia.org/wiki/Bézout's_identity">[Bézout's identity Explanation]</seealso>
    /// <seealso href="https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Pseudocode">[Bézout's identity Pseudocode using Extended Euclidean algorithm]</seealso>

    class function Bezoutsidentity(int1: TIntX; int2: TIntX; out bezOne: TIntX;
      out bezTwo: TIntX): TIntX; static;

    /// <summary>
    /// Checks if a <see cref="TIntX" /> object is Probably Prime using Miller–Rabin primality test.
    /// </summary>
    /// <param name="value">big integer to check primality.</param>
    /// <param name="Accuracy">Accuracy parameter `k´ of the Miller-Rabin algorithm. Default is 5. The execution time is proportional to the value of the accuracy parameter.</param>
    /// <returns>Boolean value.</returns>
    /// <seealso href="https://en.wikipedia.org/wiki/Miller–Rabin_primality_test">[Miller–Rabin primality test Explanation]</seealso>
    /// <seealso href="https://github.com/cslarsen/miller-rabin">[Miller–Rabin primality test Implementation in C]</seealso>

    class function IsProbablyPrime(value: TIntX; Accuracy: Integer = 5)
      : Boolean; static;

    /// <summary>
    /// The Max Between Two TIntX values.
    /// </summary>
    /// <param name="left">left value.</param>
    /// <param name="right">right value.</param>
    /// <returns>The Maximum TIntX value.</returns>

    class function Max(left: TIntX; right: TIntX): TIntX; static;

    /// <summary>
    /// The Min Between Two TIntX values.
    /// </summary>
    /// <param name="left">left value.</param>
    /// <param name="right">right value.</param>
    /// <returns>The Minimum TIntX value.</returns>

    class function Min(left: TIntX; right: TIntX): TIntX; static;

    /// <summary>
    /// Compares 2 <see cref="TIntX" /> objects.
    /// Returns "-2" if any argument is null, "-1" if <paramref name="int1" /> &lt; <paramref name="int2" />,
    /// "0" if equal and "1" if &gt;.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <param name="throwNullException">Raises or not <see cref="EArgumentNilException" />.</param>
    /// <returns>Comparison result.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="int1" /> or <paramref name="int2" /> is a null reference and <paramref name= "throwNullException" /> is set to true.</exception>

    class function Cmp(int1: TIntX; int2: TIntX; throwNullException: Boolean)
      : Integer; overload; static;

    /// <summary>
    /// Compares <see cref="TIntX" /> object to int.
    /// Returns "-1" if <paramref name="int1" /> &lt; <paramref name="int2" />, "0" if equal and "1" if &gt;.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second integer.</param>
    /// <returns>Comparison result.</returns>

    class function Cmp(int1: TIntX; int2: Integer): Integer; overload; static;

    /// <summary>
    /// Compares <see cref="TIntX" /> object to unsigned int.
    /// Returns "-1" if <paramref name="int1" /> &lt; <paramref name="int2" />, "0" if equal and "1" if &gt;.
    /// For internal use.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second unsigned integer.</param>
    /// <returns>Comparison result.</returns>

    class function Cmp(int1: TIntX; int2: UInt32): Integer; overload; static;

    /// <summary>
    /// Shifts <see cref="TIntX" /> object.
    /// Determines which operation to use based on shift sign.
    /// </summary>
    /// <param name="IntX">Big integer.</param>
    /// <param name="shift">Bits count to shift.</param>
    /// <param name="toLeft">If true the shifting to the left.</param>
    /// <returns>Bitwise shift operation result.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="IntX" /> is a null reference.</exception>

    class function Sh(IntX: TIntX; shift: Int64; toLeft: Boolean)
      : TIntX; static;

    /// <summary>
    /// Performs bitwise OR for two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Resulting big integer.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="int1" /> or <paramref name="int2" /> is a null reference.</exception>

    class function BitwiseOr(int1: TIntX; int2: TIntX): TIntX; static;
    /// <summary>
    /// Performs bitwise AND for two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Resulting big integer.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="int1" /> or <paramref name="int2" /> is a null reference.</exception>

    class function BitwiseAnd(int1: TIntX; int2: TIntX): TIntX; static;

    /// <summary>
    /// Performs bitwise XOR for two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Resulting big integer.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="int1" /> or <paramref name="int2" /> is a null reference.</exception>

    class function ExclusiveOr(int1: TIntX; int2: TIntX): TIntX; static;

    /// <summary>
    /// Performs bitwise NOT for big integer.
    /// </summary>
    /// <param name="value">Big integer.</param>
    /// <returns>Resulting big integer.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class function OnesComplement(value: TIntX): TIntX; static;
    /// <summary>
    /// Function used for Internal operations.
    /// </summary>
    /// <param name="mdbl">
    /// internal variable
    /// </param>
    /// <param name="sign">
    /// variable used to indicate sign
    /// </param>
    /// <param name="exp">
    /// internal variable
    /// </param>
    /// <param name="man">
    /// internal variable
    /// </param>
    /// <param name="fFinite">
    /// internal variable
    /// </param>
    /// <remarks>
    /// Source : Microsoft .NET Reference on GitHub
    /// </remarks>
    class procedure GetDoubleParts(mdbl: Double; out sign: Integer;
      out exp: Integer; out man: UInt64; out fFinite: Boolean); static;
    /// <summary>
    /// Function used for Internal operations.
    /// </summary>
    /// <param name="sign">
    /// variable indicating sign
    /// </param>
    /// <param name="exp">
    /// variable used for internal operations
    /// </param>
    /// <param name="man">
    /// variable used for internal operations
    /// </param>
    /// <remarks>
    /// Source : Microsoft .NET Reference on GitHub
    /// </remarks>
    class function GetDoubleFromParts(sign: Integer; exp: Integer; man: UInt64)
      : Double; static;

    /// <summary>
    /// function used for Internal operations
    /// </summary>
    /// <param name="value">
    /// value to process
    /// </param>
    /// <param name="digits">
    /// digits array to process
    /// </param>
    /// <param name="newInt">
    /// output result
    /// </param>
    /// <remarks>
    /// Source : Microsoft .NET Reference on GitHub
    /// </remarks>
    class procedure SetDigitsFromDouble(value: Double;
      var digits: TIntXLibUInt32Array; out newInt: TIntX);

  end;

implementation

constructor TOpHelper.TBuilder.Create(bn: TIntX; var sign: Integer);
var
  n, mask: Integer;
begin

  _rgu := bn._digits;

  if bn.isZero then
    n := 0
  else if bn.IsNegative then
    n := -1
  else
    n := 1;

  mask := TUtils.Asr32(n, (kcbitUint - 1));
  sign := (sign xor mask) - mask;
  _iuLast := bn._length - 1; // Length(_rgu)  - 1
  _uSmall := _rgu[0];
  while ((_iuLast > 0) and (_rgu[_iuLast] = 0)) do
    Dec(_iuLast);
end;

procedure TOpHelper.TBuilder.GetApproxParts(out exp: Integer; out man: UInt64);
var
  cuLeft, cbit: Integer;
begin

  if (_iuLast = 0) then
  begin
    man := UInt64(_uSmall);
    exp := 0;
    Exit;
  end;

  cuLeft := _iuLast - 1;
  man := MakeUlong(_rgu[cuLeft + 1], _rgu[cuLeft]);
  exp := cuLeft * kcbitUint;
  cbit := CbitHighZero(_rgu[cuLeft + 1]);
  if ((cuLeft > 0) and (cbit > 0)) then
  begin
    // Get 64 bits.
{$IFDEF DEBUG}
    Assert(cbit < kcbitUint);
{$ENDIF DEBUG}
    man := (man shl cbit) or (_rgu[cuLeft - 1] shr (kcbitUint - cbit));
    exp := exp - cbit;
  end;
end;

class function TOpHelper.MakeUlong(uHi: UInt32; uLo: UInt32): UInt64;
begin
  result := (UInt64(uHi) shl kcbitUint) or uLo;
end;

class function TOpHelper.CbitHighZero(u: UInt32): Integer;
var
  cbit: Integer;
begin
  if (u = 0) then
  begin
    result := 32;
    Exit;
  end;

  cbit := 0;
  if ((u and $FFFF0000) = 0) then
  begin
    cbit := cbit + 16;
    u := u shl 16;
  end;
  if ((u and $FF000000) = 0) then
  begin
    cbit := cbit + 8;
    u := u shl 8;
  end;
  if ((u and $F0000000) = 0) then
  begin
    cbit := cbit + 4;
    u := u shl 4;
  end;
  if ((u and $C0000000) = 0) then
  begin
    cbit := cbit + 2;
    u := u shl 2;
  end;
  if ((u and $80000000) = 0) then
    cbit := cbit + 1;
  result := cbit;
end;

class function TOpHelper.CbitHighZero(uu: UInt64): Integer;
begin
  if ((uu and $FFFFFFFF00000000) = 0) then
    result := 32 + CbitHighZero(UInt32(uu))
  else
    result := CbitHighZero(UInt32(uu shr 32));
end;

{ class function TOpHelper.Guesser(n: TIntX; g: TIntX; last: TIntX): TIntX;
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
  end; }

class function TOpHelper.Add(int1: TIntX; int2: TIntX): TIntX;
var
  x, smallerInt, biggerInt, newInt: TIntX;

begin
  // Process zero values in special way

  if ((int1._length = 0) and (int2._length = 0)) then
  begin
    result := TIntX.Create(0);
    Exit;
  end;

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
    raise EArgumentException.Create(uStrings.IntegerTooBig);
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

class function TOpHelper.Sub(int1: TIntX; int2: TIntX): TIntX;
var
  smallerInt, biggerInt, newInt: TIntX;
  compareResult: Integer;
  tempState: Boolean;
begin
  // Process zero values in special way

  if ((int1._length = 0) and (int2._length = 0)) then
  begin
    result := TIntX.Create(0);
    Exit;
  end;

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

class function TOpHelper.AddSub(int1: TIntX; int2: TIntX;
  subtract: Boolean): TIntX;

begin
  // Exceptions

  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then

    raise EArgumentNilException.Create(uStrings.CantBeNull + ' int2');

  // Determine real operation type and result sign
  if (subtract xor int1._negative = int2._negative) then
    result := Add(int1, int2)
  else
    result := Sub(int1, int2);
end;

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

  // optimization if value (base) is 2.
  if value = 2 then
  begin
    result := TIntX.One shl power;
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

class function TOpHelper.Random(): TIntX;

begin
  result := TPcg.NextUInt32();
end;

class function TOpHelper.RandomRange(Min: UInt32; Max: UInt32): TIntX;

begin
  result := TPcg.NextUInt32(Min, Max);
end;

class function TOpHelper.AbsoluteValue(value: TIntX): TIntX;
begin
  if value._negative then
    result := -value
  else
    result := value;
end;

class function TOpHelper.Log10(value: TIntX): Double;
begin

  result := TIntX.LogN(10, value);
end;

class function TOpHelper.Ln(value: TIntX): Double;
begin

  result := TIntX.LogN(TConstants.EulersNumber, value);

end;
(*
  class function TOpHelper.LogN(base: Double; value: TIntX): Double;
  var
  c, d: Double;
  uintLength, topbits, bitlen, index: Int64;
  indbit: UInt32;
  const
  DoubleZero: Double = 0;
  constOne: Double = 1.0;
  DoubleNaN: Double = 0.0 / 0.0;
  DoublePositiveInfinity: Double = 1.0 / 0.0;
  ZeroPointZero: Double = 0.0;
  Log2: Double = 0.69314718055994529;
  kcbitUint: Integer = 32;

  begin

  c := 0;
  d := 0.5;

  if ((value.IsNegative) or (base = constOne)) then
  begin
  result := DoubleNaN;
  Exit;
  end;
  if (base = DoublePositiveInfinity) then
  begin
  if value.isOne then
  begin
  result := ZeroPointZero;
  Exit;
  end
  else
  begin
  result := DoubleNaN;
  Exit;
  end;

  end;
  if ((base = ZeroPointZero) and (not(value.isOne))) then
  begin
  result := DoubleNaN;
  Exit;
  end;
  if (value._digits = Nil) then
  begin
  result := Math.LogN(base, DoubleZero);
  Exit;
  end;

  uintLength := Int64(Length(value._digits));
  topbits := Int64(TBits.BitLengthOfUInt(value._digits[uintLength - 1]));
  bitlen := Int64((uintLength - 1) * kcbitUint + topbits);
  indbit := Int64(UInt32(1 shl (topbits - 1)));

  index := uintLength - 1;
  while index >= 0 do
  begin
  while (indbit <> 0) do
  begin
  if ((value._digits[index] and indbit) <> 0) then
  begin
  c := c + d;
  end;
  d := d * 0.5;
  indbit := indbit shr 1;
  end;
  indbit := $80000000;
  Dec(index);
  end;
  result := (System.Ln(c) + Log2 * bitlen) / System.Ln(base);
  end; *)

class function TOpHelper.LogN(base: Double; value: TIntX): Double;
var
  tempD, tempTwo, pa, pb, pc, tempDouble: Double;
  c: Integer;
  b: Int64;
  h, m, l, x: UInt64;
const
  constOne: Double = 1.0;
  DoubleNaN: Double = 0.0 / 0.0;
  DoublePositiveInfinity: Double = 1.0 / 0.0;
  DoubleNegativeInfinity: Double = -1.0 / 0.0;
  ZeroPointZero: Double = 0.0;

begin

  if ((value.IsNegative) or (base = constOne)) then
  begin
    result := DoubleNaN;
    Exit;
  end;
  if (base = DoublePositiveInfinity) then
  begin
    if value.IsOne then
    begin
      result := ZeroPointZero;
      Exit;
    end
    else
    begin
      result := DoubleNaN;
      Exit;
    end;

  end;
  if ((base = ZeroPointZero) and (not(value.IsOne))) then
  begin
    result := DoubleNaN;
    Exit;
  end;

  if (value._digits = Nil) then
  begin
    result := DoubleNegativeInfinity;
    Exit;
  end;

  if (value <= TConstants.MaxUInt64Value) then
  begin
    tempDouble := UInt64(value);
    result := Math.LogN(base, tempDouble);
    Exit;
  end;

  // h := value._digits[Length(value._digits) - 1];
  h := value._digits[value._length - 1];

  // if Length(value._digits) > 1 then
  if value._length > 1 then
    // m := value._digits[Length(value._digits) - 2]
    m := value._digits[value._length - 2]
  else
    m := 0;

  // if Length(value._digits) > 2 then
  if value._length > 2 then
    // l := value._digits[Length(value._digits) - 3]
    l := value._digits[value._length - 3]
  else
    l := 0;

  // measure the exact bit count
  c := CbitHighZero(UInt32(h));

  // b := ((Int64(Length(value._digits))) * 32) - c;
  b := ((Int64(value._length)) * 32) - c;

  // extract most significant bits
  x := (h shl (32 + c)) or (m shl c) or (l shr (32 - c));

  tempD := x;
  tempTwo := 2;
  pa := Math.LogN(base, tempD);
  pc := Math.LogN(tempTwo, base);
  pb := (b - 64) / pc;
  result := pa + pb;

end;

class function TOpHelper.IntegerLogN(base: TIntX; number: TIntX): TIntX;
var
  lo, b_lo, hi, mid, b_mid, b_hi: TIntX;
begin
  lo := TIntX.Zero;
  b_lo := TIntX.One;
  hi := TIntX.One;
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

class function TOpHelper.Square(value: TIntX): TIntX;
begin
  result := TIntX.Pow(value, 2);
end;

class function TOpHelper.IntegerSquareRoot(value: TIntX): TIntX;
var
  // sn: String;
  a, b, mid, eight: TIntX;

begin
  if (value.isZero) then
  begin
    result := TIntX.Zero;
    Exit;
  end;

  if (value.IsOne) then
  begin
    result := TIntX.One;
    Exit;
  end;

  a := TIntX.One;
  eight := TIntX.Create(8);
  b := (value shr 5) + eight;

  while b.CompareTo(a) >= 0 do
  begin
    mid := (a + b) shr 1;
    if (mid * mid).CompareTo(value) > 0 then
    begin
      b := (mid - TIntX.One);
    end
    else
    begin
      a := (mid + TIntX.One);
    end;

  end;

  result := a - TIntX.One;
  { if (value > 999) then
    begin
    sn := value.ToString();
    result := Guesser(value, TIntX.Parse(Copy(sn, 1, Length(sn) shr 1)),
    TIntX.Zero);
    Exit;
    end
    else
    begin
    result := Guesser(value, value shr 1, TIntX.Zero);
    Exit;
    end; }
end;

class function TOpHelper.Factorial(value: TIntX): TIntX;
var
  I: TIntX;

begin
  // Exception
  if (value < 0) then
    raise EArgumentException.Create(Format(uStrings.NegativeFactorial,
      [value.ToString], TIntX._FS));

  result := 1;
  // using iterative approach
  // recursive approach is slower and causes much overhead. it is also limiting (stackoverflow)
  I := 1;
  while I <= value do
  begin
    result := result * I;
    Inc(I);
  end;
end;

class function TOpHelper.__builtin_ctz(x: UInt32): Integer;
var
  n: Integer;
begin
  // This uses a binary search algorithm from Hacker's Delight.
  n := 1;
  if ((x and $0000FFFF) = 0) then
  begin
    n := n + 16;
    x := x shr 16;
  end;
  if ((x and $000000FF) = 0) then
  begin
    n := n + 8;
    x := x shr 8;
  end;
  if ((x and $0000000F) = 0) then
  begin
    n := n + 4;
    x := x shr 4;
  end;
  if ((x and $00000003) = 0) then
  begin
    n := n + 2;
    x := x shr 2;
  end;
  result := n - Integer(x and 1);
end;

class function TOpHelper.GCD(int1: TIntX; int2: TIntX): TIntX;
var
  shift: Integer;
  temp: TIntX;
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

  shift := __builtin_ctz(UInt32(int1 or int2));
  int1 := int1 shr __builtin_ctz(UInt32(int1));
  while (int2 <> 0) do
  begin
    int2 := int2 shr __builtin_ctz(UInt32(int2));
    if (int1 > int2) then
    begin
      temp := int2;
      int2 := int1;
      int1 := temp;
    end;
    int2 := int2 - int1;
  end;

  result := int1 shl shift;
end;

class function TOpHelper.LCM(int1: TIntX; int2: TIntX): TIntX;
begin
  result := (TIntX.AbsoluteValue(int1 * int2)) div (TIntX.GCD(int1, int2));
end;

class function TOpHelper.InvMod(int1: TIntX; int2: TIntX): TIntX;
var
  u1, u3, v1, v3, t1, t3, q, iter: TIntX;
begin

  // /* Step X1. Initialize */
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

  if (u3 <> 1) then // u3 is now holding the GCD Value
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

class function TOpHelper.ModPow(value: TIntX; exponent: TIntX;
  modulus: TIntX): TIntX;
begin
  result := 1;
  value := value mod modulus;
  while exponent > 0 do
  begin
    if exponent.IsOdd then
    begin
      result := (result * value) mod modulus;
    end;
    exponent := exponent shr 1;
    value := (value * value) mod modulus;

  end;
end;

class function TOpHelper.Bezoutsidentity(int1: TIntX; int2: TIntX;
  out bezOne: TIntX; out bezTwo: TIntX): TIntX;
var
  s, t, r, old_s, old_t, old_r, quotient, prov: TIntX;
begin

  if int1._negative then
    raise EArgumentNilException.Create(uStrings.BezoutNegativeNotAllowed
      + ' int1');

  if int2._negative then
    raise EArgumentNilException.Create(uStrings.BezoutNegativeNotAllowed + ' '
      + ' int2');

  if (int1 = 0) or (int2 = 0) then
    raise EArgumentException.Create(uStrings.BezoutNegativeCantComputeZero);

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

class function TOpHelper.IsProbablyPrime(value: TIntX;
  Accuracy: Integer = 5): Boolean;
begin
  result := TMillerRabin.IsProbablyPrimeMR(value, Accuracy);
end;

class function TOpHelper.Max(left: TIntX; right: TIntX): TIntX;
begin
  if (left.CompareTo(right) < 0) then
    result := right
  else
    result := left;
end;

class function TOpHelper.Min(left: TIntX; right: TIntX): TIntX;
begin
  if (left.CompareTo(right) <= 0) then
    result := left
  else
    result := right;
end;

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
        raise EArgumentNilException.Create(uStrings.CantBeNullCmp + ' int1')
      else if isNull2 then
        raise EArgumentNilException.Create(uStrings.CantBeNullCmp + ' int2')
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
    raise EArgumentNilException.Create(uStrings.CantBeNullOne + ' intX');
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
    raise EArgumentException.Create(uStrings.IntegerTooBig + ' intX');
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

class function TOpHelper.BitwiseOr(int1: TIntX; int2: TIntX): TIntX;
var
  smallerInt, biggerInt, newInt: TIntX;
begin
  // Exceptions

  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then

    raise EArgumentNilException.Create(uStrings.CantBeNull + ' int2');

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

class function TOpHelper.BitwiseAnd(int1: TIntX; int2: TIntX): TIntX;
var
  smallerInt, biggerInt, newInt: TIntX;
begin

  // Exceptions

  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then

    raise EArgumentNilException.Create(uStrings.CantBeNull + ' int2');

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

class function TOpHelper.ExclusiveOr(int1: TIntX; int2: TIntX): TIntX;
var
  smallerInt, biggerInt, newInt: TIntX;
begin

  // Exceptions
  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then

    raise EArgumentNilException.Create(uStrings.CantBeNull + ' int2');

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

class function TOpHelper.OnesComplement(value: TIntX): TIntX;
var
  newInt: TIntX;
begin

  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' value');
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

class procedure TOpHelper.GetDoubleParts(mdbl: Double; out sign: Integer;
  out exp: Integer; out man: UInt64; out fFinite: Boolean);
var
  du: TDoubleUlong;
begin

  du.uu := 0;
  du.dbl := mdbl;

  sign := 1 - (Integer(du.uu shr 62) and 2);

  man := du.uu and $000FFFFFFFFFFFFF;
  exp := Integer(du.uu shr 52) and $7FF;
  if (exp = 0) then
  begin
    // Denormalized number.
    fFinite := True;
    if (man <> 0) then
      exp := -1074;
  end
  else

    if (exp = $7FF) then
  begin
    // NaN or Inifite.
    fFinite := False;
    exp := TConstants.MaxIntValue;
  end
  else
  begin
    fFinite := True;
    man := man or $0010000000000000;
    exp := exp - 1075;
  end;

end;

class function TOpHelper.GetDoubleFromParts(sign: Integer; exp: Integer;
  man: UInt64): Double;
var
  du: TDoubleUlong;
  cbitShift: Integer;
begin
  du.dbl := 0;

  if (man = 0) then
    du.uu := 0
  else

  begin
    // Normalize so that $0010 0000 0000 0000 is the highest bit set.
    cbitShift := CbitHighZero(man) - 11;
    if (cbitShift < 0) then
      man := man shr - cbitShift
    else
    begin
      man := man shl cbitShift;
    end;
    exp := exp - cbitShift;
{$IFDEF DEBUG}
    Assert((man and $FFF0000000000000) = $0010000000000000);
{$ENDIF DEBUG}
    // Move the point to just behind the leading 1: $001.0 0000 0000 0000
    // (52 bits) and skew the exponent (by $3FF == 1023).
    exp := exp + 1075;

    if (exp >= $7FF) then
    begin
      // Infinity.
      du.uu := $7FF0000000000000;
    end
    else if (exp <= 0) then
    begin
      // Denormalized.
      Dec(exp);
      if (exp < -52) then
      begin
        // Underflow to zero.
        du.uu := 0;
      end
      else
      begin
        du.uu := man shr - exp;
{$IFDEF DEBUG}
        Assert(du.uu <> 0);
{$ENDIF DEBUG}
      end
    end
    else
    begin
      // Mask off the implicit high bit.
      du.uu := (man and $000FFFFFFFFFFFFF) or (UInt64(exp) shl 52);
    end;
  end;
  if (sign < 0) then
    du.uu := du.uu or $8000000000000000;

  result := du.dbl;
end;

class procedure TOpHelper.SetDigitsFromDouble(value: Double;
  var digits: TIntXLibUInt32Array; out newInt: TIntX);
var
  sign, exp, kcbitUlong, kcbitUint, cu, cbit: Integer;
  man: UInt64;
  fFinite, tempSign: Boolean;
begin
  kcbitUint := 32;
  kcbitUlong := 64;
  TOpHelper.GetDoubleParts(value, sign, exp, man, fFinite);

  if (man = 0) then
  begin
    newInt := TIntX.Zero;
    Exit;
  end;

{$IFDEF DEBUG}
  Assert(man < (UInt64(1) shl 53));
  Assert((exp <= 0) or (man >= (UInt64(1) shl 52)));
{$ENDIF DEBUG}
  if (exp <= 0) then
  begin
    if (exp <= -kcbitUlong) then
    begin
      newInt := TIntX.Zero;
      Exit;
    end;

    newInt := man shr - exp;
    if (sign < 0) then
      newInt._negative := True;
  end
  else if (exp <= 11) then
  begin
    newInt := man shl exp;
    if (sign < 0) then
      newInt._negative := True;
  end
  else
  begin
    // Overflow into at least 3 uints.
    // Move the leading 1 to the high bit.
    man := man shl 11;
    exp := exp - 11;

    // Compute cu and cbit so that exp = 32 * cu - cbit and 0 <= cbit < 32.
    cu := ((exp - 1) div kcbitUint) + 1;
    cbit := cu * kcbitUint - exp;
{$IFDEF DEBUG}
    Assert((0 <= cbit) and (cbit < kcbitUint));
    Assert(cu >= 1);
{$ENDIF DEBUG}
    // Populate the uints.
    SetLength(digits, cu + 2);
    digits[cu + 1] := UInt32((man shr (cbit + kcbitUint)));
    digits[cu] := UInt32(man shr cbit);
    if (cbit > 0) then
      digits[cu - 1] := UInt32(man) shl (kcbitUint - cbit);

    if sign < 0 then
      tempSign := True
    else
      tempSign := False;
    newInt := TIntX.Create(digits, tempSign);

    newInt._negative := tempSign;

  end;

end;

end.
