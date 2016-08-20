unit uIntX;

{$I ..\Include\IntXLib.inc}

interface

uses
{$IFDEF DELPHI}
  Generics.Collections,
{$ENDIF DELPHI}
  Math,
  SysUtils,
{$IFDEF DEBUG}
  SyncObjs,
{$ENDIF DEBUG}
  uIntXGlobalSettings,
  uIntXSettings,
  uEnums,
  uStrings,
  uIntXLibTypes;

type
  /// <summary>
  /// numeric record which represents arbitrary-precision integers.
  /// </summary>
  TIntX = record

    /// <summary>
    /// big integer digits.
    /// </summary>
    _digits: TIntXLibUInt32Array;
    /// <summary>
    /// big integer digits length.
    /// </summary>
    _length: UInt32;
    /// <summary>
    /// big integer sign ("-" if true).
    /// </summary>
    _negative: Boolean;
    /// <summary>
    /// used to check if <see cref="TIntX" /> was Zero Initialized.
    /// </summary>
    _zeroinithelper: Boolean;

  class var
    /// <summary>
    /// instance of <see cref="TIntXGlobalSettings" />.
    /// </summary>
    _globalSettings: TIntXGlobalSettings;

    /// <summary>
    /// instance of <see cref="TIntXSettings" />.
    /// </summary>
    _settings: TIntXSettings;

    /// <summary>
    /// <see cref="TFormatSettings" /> used in <see cref="TIntX" />.
    /// </summary>
    _FS: TFormatSettings;

{$IFDEF DEBUG}
    /// <summary>
    /// Critical Section for maximal error during FHT rounding (debug-mode only).
    /// </summary>
    _maxFhtRoundErrorCriticalSection: TCriticalSection;
    /// <summary>
    /// Maximal error during FHT rounding (debug-mode only).
    /// </summary>
    MaxFhtRoundError: Double;
{$ENDIF DEBUG}
  strict private

    /// <summary>
    /// <see cref="TIntX" /> instance settings getter and setter.
    /// </summary>

    function GetSettings: TIntXSettings;

    procedure SetSettings(value: TIntXSettings);

    /// <summary>
    /// isodd getter.
    /// </summary>

    function GetIsOdd: Boolean;

    /// <summary>
    /// isNegative getter.
    /// </summary>

    function GetIsNegative: Boolean;

    /// <summary>
    /// isZero getter.
    /// </summary>

    function GetIsZero: Boolean;

    /// <summary>
    /// isOne getter.
    /// </summary>

    function GetIsOne: Boolean;

    /// <summary>
    /// IsPowerOfTwo getter.
    /// </summary>

    function GetIsPowerOfTwo: Boolean;

    /// <summary>
    /// Getter function for <see cref="TIntX.Clone" />
    /// </summary>

    function GetClone: TIntX;

    /// <summary>
    /// Getter function for <see cref="TIntX.Zero" />
    /// </summary>
    class function GetZero: TIntX; static;
    /// <summary>
    /// Getter function for <see cref="TIntX.One" />
    /// </summary>
    class function GetOne: TIntX; static;
    /// <summary>
    /// Getter function for <see cref="TIntX.MinusOne" />
    /// </summary>
    class function GetMinusOne: TIntX; static;
    /// <summary>
    /// Getter function for <see cref="TIntX.Ten" />
    /// </summary>
    class function GetTen: TIntX; static;
    /// <summary>
    /// Getter function for <see cref="TIntX.GlobalSettings" />
    /// </summary>
    class function GetGlobalSettings: TIntXGlobalSettings; static;
    /// <summary>
    /// Initializes record instance from zero.
    /// For internal use.
    /// </summary>
    procedure InitFromZero();
    /// <summary>
    /// Initializes record instance from <see cref="UInt64" /> value.
    /// Doesn't initialize sign.
    /// For internal use.
    /// </summary>
    /// <param name="value">Unsigned Int64 value.</param>
    procedure InitFromUlong(value: UInt64);
    /// <summary>
    /// Initializes record instance from another <see cref="TIntX" /> value.
    /// For internal use.
    /// </summary>
    /// <param name="value">TIntX value.</param>
    procedure InitFromIntX(value: TIntX);

    /// <summary>
    /// Initializes record instance from digits array.
    /// For internal use.
    /// </summary>
    /// <param name="digits">Big integer digits.</param>
    /// <param name="negative">Big integer sign.</param>
    /// <param name="mlength">Big integer length.</param>

    procedure InitFromDigits(digits: TIntXLibUInt32Array; negative: Boolean;
      mlength: UInt32);
  public

    /// <summary>
    /// <see cref="TIntX" /> instance settings property.
    /// </summary>

    property Settings: TIntXSettings read GetSettings write SetSettings;

    /// <summary>
    /// Gets flag indicating if big integer is odd.
    /// </summary>

    property IsOdd: Boolean read GetIsOdd;

    /// <summary>
    /// Gets flag indicating if big integer is negative.
    /// </summary>

    property IsNegative: Boolean read GetIsNegative;

    /// <summary>
    /// Gets flag indicating if big integer is zero.
    /// </summary>

    property IsZero: Boolean read GetIsZero;

    /// <summary>
    /// Gets flag indicating if big integer is one.
    /// </summary>

    property IsOne: Boolean read GetIsOne;

    /// <summary>
    /// Gets flag indicating if big integer is a power of two.
    /// </summary>

    property IsPowerOfTwo: Boolean read GetIsPowerOfTwo;

    /// <summary>
    /// Returns a copy of the current <see cref="TIntX" />, with a unique copy of the data.
    /// </summary>

    property Clone: TIntX read GetClone;

    /// <summary>
    /// A Zero.
    /// </summary>
    class property Zero: TIntX read GetZero;
    /// <summary>
    /// A Positive One.
    /// </summary>
    class property One: TIntX read GetOne;
    /// <summary>
    /// A Negative One.
    /// </summary>
    class property MinusOne: TIntX read GetMinusOne;
    /// <summary>
    /// A Ten.
    /// </summary>
    class property Ten: TIntX read GetTen;
    /// <summary>
    /// <see cref="TIntX" /> global settings.
    /// </summary>
    class property GlobalSettings: TIntXGlobalSettings read GetGlobalSettings;

    // -- Class Constructor and Destructor --

    class constructor Create();
    class destructor Destroy();

    // -- Constructors --

    /// <summary>
    /// Creates new big integer from integer value.
    /// </summary>
    /// <param name="value">Integer value to create big integer from.</param>

    constructor Create(value: Integer); overload;

    /// <summary>
    /// Creates new big integer from unsigned integer value.
    /// </summary>
    /// <param name="value">Unsigned integer value to create big integer from.</param>

    constructor Create(value: UInt32); overload;

    /// <summary>
    /// Creates new big integer from Int64 value.
    /// </summary>
    /// <param name="value">Int64 value to create big integer from.</param>

    constructor Create(value: Int64); overload;

    /// <summary>
    /// Creates new big integer from unsigned Int64 value.
    /// </summary>
    /// <param name="value">Unsigned Int64 value to create big integer from.</param>

    constructor Create(value: UInt64); overload;

    /// <summary>
    /// Creates new big integer from a Double value.
    /// replicates Microsoft Double to BigInteger Implementation.
    /// </summary>
    /// <param name="value">
    /// Double value to create big integer from.
    /// </param>

    constructor Create(value: Double); overload;

    /// <summary>
    /// Creates new big integer from array of it's "digits".
    /// Digit with lower index has less weight.
    /// </summary>
    /// <param name="digits">Array of <see cref="TIntX" /> digits.</param>
    /// <param name="negative">True if this number is negative.</param>
    /// <exception cref="EArgumentNilException"><paramref name="digits" /> is a null reference.</exception>

    constructor Create(digits: TIntXLibUInt32Array; negative: Boolean);
      overload;

    /// <summary>
    /// Creates new <see cref="TIntX" /> from string.
    /// </summary>
    /// <param name="value">Number as string.</param>

    constructor Create(const value: String); overload;

    /// <summary>
    /// Creates new <see cref="TIntX" /> from string.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="numberBase">Number base.</param>

    constructor Create(const value: String; numberBase: UInt32); overload;

    /// <summary>
    /// Copy constructor.
    /// </summary>
    /// <param name="value">Value to copy from.</param>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    constructor Create(value: TIntX); overload;

    /// <summary>
    /// Creates new empty big integer with desired sign and length.
    ///
    /// For internal use.
    /// </summary>
    /// <param name="mlength">Desired digits length.</param>
    /// <param name="negative">Desired integer sign.</param>

    constructor Create(mlength: UInt32; negative: Boolean); overload;

    /// <summary>
    /// Creates new big integer from array of it's "digits" but with given length.
    /// Digit with lower index has less weight.
    ///
    /// For internal use.
    /// </summary>
    /// <param name="digits">Array of <see cref="TIntX" /> digits.</param>
    /// <param name="negative">True if this number is negative.</param>
    /// <param name="mlength">Length to use for internal digits array.</param>
    /// <exception cref="EArgumentNilException"><paramref name="digits" /> is a null reference.</exception>

    constructor Create(digits: TIntXLibUInt32Array; negative: Boolean;
      mlength: UInt32); overload;

    // -- Operators as functions and some other special mathematical functions --

    /// <summary>
    /// Multiplies one <see cref="TIntX" /> object by another.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <param name="mode">Multiply mode set explicitly.</param>
    /// <returns>Multiply result.</returns>

    class function Multiply(int1: TIntX; int2: TIntX; mode: TMultiplyMode)
      : TIntX; static;

    /// <summary>
    /// Divides one <see cref="TIntX" /> object by another.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <param name="mode">Divide mode.</param>
    /// <returns>Division result.</returns>

    class function Divide(int1: TIntX; int2: TIntX; mode: TDivideMode)
      : TIntX; static;

    /// <summary>
    /// Divides one <see cref="TIntX" /> object by another and returns division modulo.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <param name="mode">Divide mode.</param>
    /// <returns>Modulo result.</returns>

    class function Modulo(int1: TIntX; int2: TIntX; mode: TDivideMode)
      : TIntX; static;

    /// <summary>
    /// Divides one <see cref="TIntX" /> object by another.
    /// Returns both divident and remainder
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <param name="modRes">Remainder big integer.</param>
    /// <returns>Division result.</returns>

    class function DivideModulo(int1: TIntX; int2: TIntX; out modRes: TIntX)
      : TIntX; overload; static;

    /// <summary>
    /// Divides one <see cref="TIntX" /> object by another.
    /// Returns both divident and remainder
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <param name="modRes">Remainder big integer.</param>
    /// <param name="mode">Divide mode.</param>
    /// <returns>Division result.</returns>

    class function DivideModulo(int1: TIntX; int2: TIntX; out modRes: TIntX;
      mode: TDivideMode): TIntX; overload; static;

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
    /// Calculates absolute value of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">value to get absolute value of.</param>
    /// <returns>Absolute value.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class function AbsoluteValue(value: TIntX): TIntX; static;

    /// <summary>
    /// The base-10 logarithm of the value.
    /// </summary>
    /// <param name="value">The value.</param>
    /// <returns>The base-10 logarithm of the value.</returns>
    /// <remarks> Source : Microsoft .NET Reference on GitHub </remarks>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class function Log10(value: TIntX): Double; static;

    /// <summary>
    /// Calculates the natural logarithm of the value.
    /// </summary>
    /// <param name="value">
    /// The value.
    /// </param>
    /// <returns>
    /// The natural logarithm.
    /// </returns>
    /// <exception cref="EArgumentNilException">
    /// <paramref name="value" /> is a null reference.
    /// </exception>
    /// <remarks>
    /// Source : Microsoft .NET Reference on GitHub
    /// </remarks>

    class function Ln(value: TIntX): Double; static;

    /// <summary>
    /// Calculates Logarithm of a number <see cref="TIntX" /> object for a specified base.
    /// the largest power the base can be raised to that does not exceed the number.
    /// </summary>
    /// <param name="base">base.</param>
    /// <param name="value">number to get log of.</param>
    /// <returns>Log value.</returns>
    /// <remarks> Source : Microsoft .NET Reference on GitHub </remarks>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class function LogN(base: Double; value: TIntX): Double; overload; static;

    /// <summary>
    /// Calculates Integer Logarithm of a number <see cref="TIntX" /> object for a specified base.
    /// the largest power the base can be raised to that does not exceed the number.
    /// </summary>
    /// <param name="base">base.</param>
    /// <param name="number">number to get Integer log of.</param>
    /// <returns>Integer Log.</returns>
    /// <seealso href="http://gist.github.com/dharmatech/409723">[IntegerLogN Implementation]</seealso>
    /// <exception cref="EArgumentNilException"><paramref name="base" /> is a null reference.</exception>
    /// <exception cref="EArgumentNilException"><paramref name="number" /> is a null reference.</exception>
    /// <exception cref="EArgumentException"><paramref name="base" /> or <paramref name="number" /> is an invalid argument.</exception>

    class function IntegerLogN(base: TIntX; number: TIntX): TIntX;
      overload; static;

    /// <summary>
    /// Calculates Square of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">
    /// value to get square of.
    /// </param>
    /// <returns>
    /// Squared value.
    /// </returns>
    /// <exception cref="EArgumentNilException">
    /// <paramref name="value" /> is a null reference.
    /// </exception>

    class function Square(value: TIntX): TIntX; static;

    /// <summary>
    /// Calculates Integer SquareRoot of <see cref="TIntX" /> object
    /// </summary>
    /// <param name="value">value to get Integer squareroot of.</param>
    /// <returns>Integer SquareRoot.</returns>
    /// <seealso href="http://www.dahuatu.com/RkWdPBx6W8.html">[IntegerSquareRoot Implementation]</seealso>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class function IntegerSquareRoot(value: TIntX): TIntX; static;

    /// <summary>
    /// Calculates Factorial of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">value to get factorial of.</param>
    /// <returns>Factorial.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

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
    /// <exception cref="EArgumentNilException"><paramref name="int1" /> is a null reference.</exception>
    /// <exception cref="EArgumentNilException"><paramref name="int2" /> is a null reference.</exception>

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
    /// <exception cref="EArgumentNilException"><paramref name="int1" /> is a null reference.</exception>
    /// <exception cref="EArgumentNilException"><paramref name="int2" /> is a null reference.</exception>
    /// <exception cref="EArgumentException"><paramref name="int1" /> or <paramref name="int2" /> is an invalid argument.</exception>

    class function InvMod(int1: TIntX; int2: TIntX): TIntX; static;

    /// <summary>
    /// Calculates Calculates Modular Exponentiation of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">value to compute ModPow of.</param>
    /// <param name="exponent">exponent to use.</param>
    /// <param name="modulus">modulus to use.</param>
    /// <returns>Computed value.</returns>
    /// <seealso href="https://en.wikipedia.org/wiki/Modular_exponentiation">[Modular Exponentiation Explanation]</seealso>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>
    /// <exception cref="EArgumentNilException"><paramref name="exponent" /> is a null reference.</exception>
    /// <exception cref="EArgumentNilException"><paramref name="modulus" /> is a null reference.</exception>
    /// <exception cref="EArgumentException"><paramref name="modulus" />  is an invalid argument.</exception>
    /// <exception cref="EArgumentException"><paramref name="exponent" />  is an invalid argument.</exception>

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
    /// <exception cref="EArgumentNilException"><paramref name="int1" /> is a null reference.</exception>
    /// <exception cref="EArgumentNilException"><paramref name="int2" /> is a null reference.</exception>

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
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class function IsProbablyPrime(value: TIntX; Accuracy: Integer = 5)
      : Boolean; static;

    /// <summary>
    /// The Max Between Two <see cref="TIntX" /> values.
    /// </summary>
    /// <param name="left">
    /// left value.
    /// </param>
    /// <param name="right">
    /// right value.
    /// </param>
    /// <returns>
    /// The Maximum <see cref="TIntX" /> value.
    /// </returns>
    /// <exception cref="EArgumentNilException">
    /// <paramref name="left" /> is a null reference.
    /// </exception>
    /// <exception cref="EArgumentNilException">
    /// <paramref name="right" /> is a null reference.
    /// </exception>

    class function Max(left: TIntX; right: TIntX): TIntX; static;

    /// <summary>
    /// The Min Between Two <see cref="TIntX" /> values.
    /// </summary>
    /// <param name="left">left value.</param>
    /// <param name="right">right value.</param>
    /// <returns>The Minimum <see cref="TIntX" /> value.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="left" /> is a null reference.</exception>
    /// <exception cref="EArgumentNilException"><paramref name="right" /> is a null reference.</exception>

    class function Min(left: TIntX; right: TIntX): TIntX; static;

    /// <summary>
    /// Returns a specified big integer raised to the specified power.
    /// </summary>
    /// <param name="value">Number to raise.</param>
    /// <param name="power">Power.</param>
    /// <returns>Number in given power.</returns>

    class function Pow(value: TIntX; power: UInt32): TIntX; overload; static;

    /// <summary>
    /// Returns a specified big integer raised to the specified power.
    /// </summary>
    /// <param name="value">Number to raise.</param>
    /// <param name="power">Power.</param>
    /// <param name="multiplyMode">Multiply mode set explicitly.</param>
    /// <returns>Number in given power.</returns>

    class function Pow(value: TIntX; power: UInt32; multiplyMode: TMultiplyMode)
      : TIntX; overload; static;

    // String output functions

    /// <summary>
    /// Returns decimal string representation of this <see cref="TIntX" /> object.
    /// </summary>
    /// <returns>Decimal number in string.</returns>

    function ToString(): String; overload;

    /// <summary>
    /// Returns string representation of this <see cref="TIntX" /> object in given base.
    /// </summary>
    /// <param name="numberBase">Base of system in which to do output.</param>
    /// <returns>Object string representation.</returns>

    function ToString(numberBase: UInt32): String; overload;

    /// <summary>
    /// Returns string representation of this <see cref="TIntX" /> object in given base.
    /// </summary>
    /// <param name="numberBase">Base of system in which to do output.</param>
    /// <param name="upperCase">Use uppercase for bases from 11 to 16 (which use letters A-F).</param>
    /// <returns>Object string representation.</returns>

    function ToString(numberBase: UInt32; UpperCase: Boolean): String; overload;

    /// <summary>
    /// Returns string representation of this <see cref="TIntX" /> object in given base using custom alphabet.
    /// </summary>
    /// <param name="numberBase">Base of system in which to do output.</param>
    /// <param name="alphabet">Alphabet which contains chars used to represent big integer, char position is coresponding digit value.</param>
    /// <returns>Object string representation.</returns>

    function ToString(numberBase: UInt32; const alphabet: String)
      : String; overload;


    // -- Conversion functions --

    /// <summary>
    /// Converts the specified <see cref="TIntX" /> to a Double, if this is possible. returns Infinity (+ or -) if the
    /// value of the <see cref="TIntX" /> is too large or too small.
    /// uses method found in Microsoft BigInteger source on github.
    /// </summary>
    function AsDouble: Double;

    /// <summary>
    /// Converts the specified <see cref="TIntX" /> to an Integer, if this is possible. Raises an EOverFlowException if the
    /// value of the <see cref="TIntX" /> is too large.
    /// </summary>
    function AsInteger: Integer;

    /// <summary>
    /// Converts the specified <see cref="TIntX" /> to a UInt32, if this is possible. Raises an EOverFlowException if the
    /// value of the <see cref="TIntX" /> is too large or is negative.
    /// </summary>
    function AsUInt32: UInt32;

    /// <summary>
    /// Converts the specified <see cref="TIntX" /> to an Int64, if this is possible. Raises an EOverFlowException if the
    /// value of the <see cref="TIntX" /> is too large.
    /// </summary>
    function AsInt64: Int64;

    /// <summary>
    /// Converts the specified <see cref="TIntX" /> to a UInt64, if this is possible. Raises an EOverFlowException if the
    /// value of the <see cref="TIntX" /> is too large or is negative.
    /// </summary>
    function AsUInt64: UInt64;

    // String parsing functions

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object in decimal base.
    /// If number starts from "0" then it's treated as octal; if number starts from "$" or "0x"
    /// then it's treated as hexadecimal.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <returns>Parsed TIntX object.</returns>

    class function Parse(const value: String): TIntX; overload; static;

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="numberBase">Number base.</param>
    /// <returns>Parsed TIntX object.</returns>

    class function Parse(const value: String; numberBase: UInt32): TIntX;
      overload; static;

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object using custom alphabet.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="numberBase">Number base.</param>
    /// <param name="alphabet">Alphabet which contains chars used to represent big integer, char position is coresponding digit value.</param>
    /// <returns>Parsed TIntX object.</returns>

    class function Parse(const value: String; numberBase: UInt32;
      const alphabet: String): TIntX; overload; static;

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object in decimal base.
    /// If number starts from "0" then it's treated as octal; if number starts from "$" or "0x"
    /// then it's treated as hexadecimal.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="mode">Parse mode.</param>
    /// <returns>Parsed TIntX object.</returns>

    class function Parse(const value: String; mode: TParseMode): TIntX;
      overload; static;

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="numberBase">Number base.</param>
    /// <param name="mode">Parse mode.</param>
    /// <returns>Parsed TIntX object.</returns>

    class function Parse(const value: String; numberBase: UInt32;
      mode: TParseMode): TIntX; overload; static;

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object using custom alphabet.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="numberBase">Number base.</param>
    /// <param name="alphabet">Alphabet which contains chars used to represent big integer, char position is coresponding digit value.</param>
    /// <param name="mode">Parse mode.</param>
    /// <returns>Parsed TIntX object.</returns>

    class function Parse(const value: String; numberBase: UInt32;
      const alphabet: String; mode: TParseMode): TIntX; overload; static;

    /// <summary>
    /// Returns equality of this <see cref="TIntX" /> with another big integer.
    /// </summary>
    /// <param name="n">Big integer to compare with.</param>
    /// <returns>True if equals.</returns>

    function Equals(n: TIntX): Boolean; overload;

    /// <summary>
    /// Returns equality of this <see cref="TIntX" /> with another integer.
    /// </summary>
    /// <param name="n">Integer to compare with.</param>
    /// <returns>True if equals.</returns>

    function Equals(n: Integer): Boolean; overload;

    /// <summary>
    /// Returns equality of this <see cref="TIntX" /> with another unsigned integer.
    /// </summary>
    /// <param name="n">Unsigned integer to compare with.</param>
    /// <returns>True if equals.</returns>

    function Equals(n: UInt32): Boolean; overload;

    /// <summary>
    /// Returns equality of this <see cref="TIntX" /> with another Int64.
    /// </summary>
    /// <param name="n">Int64 to compare with.</param>
    /// <returns>True if equals.</returns>

    function Equals(n: Int64): Boolean; overload;

    /// <summary>
    /// Returns equality of this <see cref="TIntX" /> with another unsigned Int64.
    /// </summary>
    /// <param name="n">unsigned Int64 to compare with.</param>
    /// <returns>True if equals.</returns>

    function Equals(n: UInt64): Boolean; overload;

    /// <summary>
    /// Compares current object with another big integer.
    /// </summary>
    /// <param name="n">Big integer to compare with.</param>
    /// <returns>1 if object is bigger than <paramref name="n" />, -1 if object is smaller than <paramref name="n" />, 0 if they are equal.</returns>

    function CompareTo(n: TIntX): Integer; overload;

    /// <summary>
    /// Compares current object with another integer.
    /// </summary>
    /// <param name="n">Integer to compare with.</param>
    /// <returns>1 if object is bigger than <paramref name="n" />, -1 if object is smaller than <paramref name="n" />, 0 if they are equal.</returns>

    function CompareTo(n: Integer): Integer; overload;

    /// <summary>
    /// Compares current object with another unsigned integer.
    /// </summary>
    /// <param name="n">Unsigned integer to compare with.</param>
    /// <returns>1 if object is bigger than <paramref name="n" />, -1 if object is smaller than <paramref name="n" />, 0 if they are equal.</returns>

    function CompareTo(n: UInt32): Integer; overload;

    /// <summary>
    /// Compares current object with another Int64.
    /// </summary>
    /// <param name="n">Int64 to compare with.</param>
    /// <returns>1 if object is bigger than <paramref name="n" />, -1 if object is smaller than <paramref name="n" />, 0 if they are equal.</returns>

    function CompareTo(n: Int64): Integer; overload;

    /// <summary>
    /// Compares current object with another UInt64.
    /// </summary>
    /// <param name="n">UInt64 to compare with.</param>
    /// <returns>1 if object is bigger than <paramref name="n" />, -1 if object is smaller than <paramref name="n" />, 0 if they are equal.</returns>

    function CompareTo(n: UInt64): Integer; overload;

    /// <summary>
    /// Frees extra space not used by digits.
    /// </summary>

    procedure Normalize();

    /// <summary>
    /// Retrieves this <see cref="TIntX" /> internal state as digits array and sign.
    /// Can be used for serialization and other purposes.
    /// Note: please use constructor instead to clone <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="digits">Digits array.</param>
    /// <param name="negative">Is negative integer.</param>
    /// <param name="zeroinithelper">Is zero initialized?.</param>

    procedure GetInternalState(out digits: TIntXLibUInt32Array;
      out negative: Boolean; out zeroinithelper: Boolean);

    /// <summary>
    /// Frees extra space not used by digits only if auto-normalize is set for the instance.
    /// </summary>

    procedure TryNormalize();
    /// <summary>
    /// Compare two records to check if they are same.
    /// </summary>
    /// <param name="Rec1">Record one to compare.</param>
    /// <param name="Rec2">Record two to compare.</param>
    /// <returns>Boolean value (True if they contain the Same contents else False).</returns>
    class function CompareRecords(Rec1: TIntX; Rec2: TIntX): Boolean;
      static; inline;

    // -- Comparison operators --

    /// <summary>
    /// Compares two <see cref="TIntX" /> objects and returns true if their internal state is equal.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>True if equals.</returns>

    class operator Equal(int1: TIntX; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with integer and returns true if their internal state is equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">integer.</param>
    /// <returns>True if equals.</returns>

    class operator Equal(int1: TIntX; int2: Integer): Boolean;

    /// <summary>
    /// Compares integer with <see cref="TIntX" /> object and returns true if their internal state is equal.
    /// </summary>
    /// <param name="int1">integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if equals.</returns>

    class operator Equal(int1: Integer; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with unsigned integer and returns true if their internal state is equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">unsigned integer.</param>
    /// <returns>True if equals.</returns>

    class operator Equal(int1: TIntX; int2: UInt32): Boolean;

    /// <summary>
    /// Compares unsigned integer with <see cref="TIntX" /> object and returns true if their internal state is equal.
    /// </summary>
    /// <param name="int1">unsigned integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if equals.</returns>

    class operator Equal(int1: UInt32; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with Int64 and returns true if their internal state is equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">Int64.</param>
    /// <returns>True if equals.</returns>

    class operator Equal(int1: TIntX; int2: Int64): Boolean;

    /// <summary>
    /// Compares Int64 with <see cref="TIntX" /> object and returns true if their internal state is equal.
    /// </summary>
    /// <param name="int1">Int64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if equals.</returns>

    class operator Equal(int1: Int64; int2: TIntX): Boolean;
    /// <summary>
    /// Compares <see cref="TIntX" /> object with UInt64 and returns true if their internal state is equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">UInt64.</param>
    /// <returns>True if equals.</returns>

    class operator Equal(int1: TIntX; int2: UInt64): Boolean;

    /// <summary>
    /// Compares UInt64 with <see cref="TIntX" /> object and returns true if their internal state is equal.
    /// </summary>
    /// <param name="int1">UInt64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if equals.</returns>

    class operator Equal(int1: UInt64; int2: TIntX): Boolean;

    /// <summary>
    /// Compares two <see cref="TIntX" /> objects and returns true if their internal state is not equal.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>True if not equals.</returns>

    class operator NotEqual(int1: TIntX; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with integer and returns true if their internal state is not equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">integer.</param>
    /// <returns>True if not equals.</returns>

    class operator NotEqual(int1: TIntX; int2: Integer): Boolean;

    /// <summary>
    /// Compares integer with <see cref="TIntX" /> object and returns true if their internal state is not equal.
    /// </summary>
    /// <param name="int1">integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if not equals.</returns>

    class operator NotEqual(int1: Integer; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with unsigned integer and returns true if their internal state is not equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">unsigned integer.</param>
    /// <returns>True if not equals.</returns>

    class operator NotEqual(int1: TIntX; int2: UInt32): Boolean;

    /// <summary>
    /// Compares unsigned integer with <see cref="TIntX" /> object and returns true if their internal state is not equal.
    /// </summary>
    /// <param name="int1">unsigned integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if not equals.</returns>

    class operator NotEqual(int1: UInt32; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with Int64 and returns true if their internal state is not equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">Int64.</param>
    /// <returns>True if not equals.</returns>

    class operator NotEqual(int1: TIntX; int2: Int64): Boolean;

    /// <summary>
    /// Compares Int64 with <see cref="TIntX" /> object and returns true if their internal state is not equal.
    /// </summary>
    /// <param name="int1">Int64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if not equals.</returns>

    class operator NotEqual(int1: Int64; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with UInt64 and returns true if their internal state is not equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">UInt64.</param>
    /// <returns>True if not equals.</returns>

    class operator NotEqual(int1: TIntX; int2: UInt64): Boolean;

    /// <summary>
    /// Compares UInt64 with <see cref="TIntX" /> object and returns true if their internal state is not equal.
    /// </summary>
    /// <param name="int1">UInt64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if not equals.</returns>

    class operator NotEqual(int1: UInt64; int2: TIntX): Boolean;

    /// <summary>
    /// Compares two <see cref="TIntX" /> objects and returns true if first is greater.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>True if first is greater.</returns>

    class operator GreaterThan(int1: TIntX; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with integer and returns true if first is greater.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">integer.</param>
    /// <returns>True if first is greater.</returns>

    class operator GreaterThan(int1: TIntX; int2: Integer): Boolean;

    /// <summary>
    /// Compares integer with <see cref="TIntX" /> object and returns true if first is greater.
    /// </summary>
    /// <param name="int1">integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is greater.</returns>

    class operator GreaterThan(int1: Integer; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with unsigned integer and returns true if first is greater.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">unsigned integer.</param>
    /// <returns>True if first is greater.</returns>

    class operator GreaterThan(int1: TIntX; int2: UInt32): Boolean;

    /// <summary>
    /// Compares unsigned integer with <see cref="TIntX" /> object and returns true if first is greater.
    /// </summary>
    /// <param name="int1">unsigned integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is greater.</returns>

    class operator GreaterThan(int1: UInt32; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with Int64 and returns true if first is greater.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">Int64.</param>
    /// <returns>True if first is greater.</returns>

    class operator GreaterThan(int1: TIntX; int2: Int64): Boolean;

    /// <summary>
    /// Compares Int64 with <see cref="TIntX" /> object and returns true if first is greater.
    /// </summary>
    /// <param name="int1">Int64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is greater.</returns>

    class operator GreaterThan(int1: Int64; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with UInt64 and returns true if first is greater.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">UInt64.</param>
    /// <returns>True if first is greater.</returns>

    class operator GreaterThan(int1: TIntX; int2: UInt64): Boolean;

    /// <summary>
    /// Compares UInt64 with <see cref="TIntX" /> object and returns true if first is greater.
    /// </summary>
    /// <param name="int1">UInt64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is greater.</returns>

    class operator GreaterThan(int1: UInt64; int2: TIntX): Boolean;

    /// <summary>
    /// Compares two <see cref="TIntX" /> objects and returns true if first is greater or equal.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>True if first is greater or equal.</returns>

    class operator GreaterThanOrEqual(int1: TIntX; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with integer and returns true if first is greater or equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">integer.</param>
    /// <returns>True if first is greater or equal.</returns>

    class operator GreaterThanOrEqual(int1: TIntX; int2: Integer): Boolean;

    /// <summary>
    /// Compares integer with <see cref="TIntX" /> object and returns true if first is greater or equal.
    /// </summary>
    /// <param name="int1">integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is greater or equal.</returns>

    class operator GreaterThanOrEqual(int1: Integer; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with unsigned integer and returns true if first is greater or equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">unsigned integer.</param>
    /// <returns>True if first is greater or equal.</returns>

    class operator GreaterThanOrEqual(int1: TIntX; int2: UInt32): Boolean;

    /// <summary>
    /// Compares unsigned integer with <see cref="TIntX" /> object and returns true if first is greater or equal.
    /// </summary>
    /// <param name="int1">unsigned integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is greater or equal.</returns>

    class operator GreaterThanOrEqual(int1: UInt32; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with Int64 and returns true if first is greater or equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">Int64.</param>
    /// <returns>True if first is greater or equal.</returns>

    class operator GreaterThanOrEqual(int1: TIntX; int2: Int64): Boolean;

    /// <summary>
    /// Compares Int64 with <see cref="TIntX" /> object and returns true if first is greater or equal.
    /// </summary>
    /// <param name="int1">Int64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is greater or equal.</returns>

    class operator GreaterThanOrEqual(int1: Int64; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with UInt64 and returns true if first is greater or equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">UInt64.</param>
    /// <returns>True if first is greater or equal.</returns>

    class operator GreaterThanOrEqual(int1: TIntX; int2: UInt64): Boolean;

    /// <summary>
    /// Compares UInt64 with <see cref="TIntX" /> object and returns true if first is greater or equal.
    /// </summary>
    /// <param name="int1">UInt64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is greater or equal.</returns>

    class operator GreaterThanOrEqual(int1: UInt64; int2: TIntX): Boolean;

    /// <summary>
    /// Compares two <see cref="TIntX" /> objects and returns true if first is lighter.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>True if first is lighter.</returns>

    class operator LessThan(int1: TIntX; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with integer and returns true if first is lighter.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">integer.</param>
    /// <returns>True if first is lighter.</returns>

    class operator LessThan(int1: TIntX; int2: Integer): Boolean;

    /// <summary>
    /// Compares integer with <see cref="TIntX" /> object and returns true if first is lighter.
    /// </summary>
    /// <param name="int1">integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is lighter.</returns>

    class operator LessThan(int1: Integer; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with unsigned integer and returns true if first is lighter.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">unsigned integer.</param>
    /// <returns>True if first is lighter.</returns>

    class operator LessThan(int1: TIntX; int2: UInt32): Boolean;

    /// <summary>
    /// Compares unsigned integer with <see cref="TIntX" /> object and returns true if first is lighter.
    /// </summary>
    /// <param name="int1">unsigned integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is lighter.</returns>

    class operator LessThan(int1: UInt32; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with Int64 and returns true if first is lighter.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">Int64.</param>
    /// <returns>True if first is lighter.</returns>

    class operator LessThan(int1: TIntX; int2: Int64): Boolean;

    /// <summary>
    /// Compares Int64 with <see cref="TIntX" /> object and returns true if first is lighter.
    /// </summary>
    /// <param name="int1">Int64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is lighter.</returns>

    class operator LessThan(int1: Int64; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with UInt64 and returns true if first is lighter.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">UInt64.</param>
    /// <returns>True if first is lighter.</returns>

    class operator LessThan(int1: TIntX; int2: UInt64): Boolean;

    /// <summary>
    /// Compares UInt64 with <see cref="TIntX" /> object and returns true if first is lighter.
    /// </summary>
    /// <param name="int1">UInt64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is lighter.</returns>

    class operator LessThan(int1: UInt64; int2: TIntX): Boolean;

    /// <summary>
    /// Compares two <see cref="TIntX" /> objects and returns true if first is lighter or equal.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>True if first is lighter or equal.</returns>

    class operator LessThanOrEqual(int1: TIntX; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with integer and returns true if first is lighter or equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">integer.</param>
    /// <returns>True if first is lighter or equal.</returns>

    class operator LessThanOrEqual(int1: TIntX; int2: Integer): Boolean;

    /// <summary>
    /// Compares integer with <see cref="TIntX" /> object and returns true if first is lighter or equal.
    /// </summary>
    /// <param name="int1">integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is lighter or equal.</returns>

    class operator LessThanOrEqual(int1: Integer; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with unsigned integer and returns true if first is lighter or equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">unsigned integer.</param>
    /// <returns>True if first is lighter or equal.</returns>

    class operator LessThanOrEqual(int1: TIntX; int2: UInt32): Boolean;

    /// <summary>
    /// Compares unsigned integer with <see cref="TIntX" /> object and returns true if first is lighter or equal.
    /// </summary>
    /// <param name="int1">unsigned integer.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is lighter or equal.</returns>

    class operator LessThanOrEqual(int1: UInt32; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with Int64 and returns true if first is lighter or equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">Int64.</param>
    /// <returns>True if first is lighter or equal.</returns>

    class operator LessThanOrEqual(int1: TIntX; int2: Int64): Boolean;

    /// <summary>
    /// Compares Int64 with <see cref="TIntX" /> object and returns true if first is lighter or equal.
    /// </summary>
    /// <param name="int1">Int64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is lighter or equal.</returns>

    class operator LessThanOrEqual(int1: Int64; int2: TIntX): Boolean;

    /// <summary>
    /// Compares <see cref="TIntX" /> object with UInt64 and returns true if first is lighter or equal.
    /// </summary>
    /// <param name="int1">big integer.</param>
    /// <param name="int2">UInt64.</param>
    /// <returns>True if first is lighter or equal.</returns>

    class operator LessThanOrEqual(int1: TIntX; int2: UInt64): Boolean;

    /// <summary>
    /// Compares UInt64 with <see cref="TIntX" /> object and returns true if first is lighter or equal.
    /// </summary>
    /// <param name="int1">UInt64.</param>
    /// <param name="int2">big integer.</param>
    /// <returns>True if first is lighter or equal.</returns>

    class operator LessThanOrEqual(int1: UInt64; int2: TIntX): Boolean;

    // -- Arithmetic operators --

    /// <summary>
    /// Adds one <see cref="TIntX" /> object to another.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Addition result.</returns>

    class operator Add(int1: TIntX; int2: TIntX): TIntX;

    /// <summary>
    /// Subtracts one <see cref="TIntX" /> object from another.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Subtraction result.</returns>

    class operator Subtract(int1: TIntX; int2: TIntX): TIntX;

    /// <summary>
    /// Multiplies one <see cref="TIntX" /> object by another.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Multiply result.</returns>

    class operator Multiply(int1: TIntX; int2: TIntX): TIntX;

    /// <summary>
    /// Divides one <see cref="TIntX" /> object by another.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Division result.</returns>

    class operator IntDivide(int1: TIntX; int2: TIntX): TIntX;

    /// <summary>
    /// Divides one <see cref="TIntX" /> object by another and returns division modulo.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Modulo result.</returns>

    class operator modulus(int1: TIntX; int2: TIntX): TIntX;

    /// <summary>
    /// Shifts <see cref="TIntX" /> object by selected bits count to the left.
    /// </summary>
    /// <param name="intX">Big integer.</param>
    /// <param name="shift">Bits count.</param>
    /// <returns>Shifting result.</returns>

    class operator LeftShift(IntX: TIntX; shift: Integer): TIntX;

    /// <summary>
    /// Shifts <see cref="TIntX" /> object by selected bits count to the right.
    /// </summary>
    /// <param name="intX">Big integer.</param>
    /// <param name="shift">Bits count.</param>
    /// <returns>Shifting result.</returns>

    class operator RightShift(IntX: TIntX; shift: Integer): TIntX;

    /// <summary>
    /// Returns the same <see cref="TIntX" /> value.
    /// </summary>
    /// <param name="value">Initial value.</param>
    /// <returns>The same value, but new object.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class operator Positive(value: TIntX): TIntX;

    /// <summary>
    /// Returns the same <see cref="TIntX" /> value, but with other sign.
    /// </summary>
    /// <param name="value">Initial value.</param>
    /// <returns>The same value, but with other sign.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>
    class operator negative(value: TIntX): TIntX;

    /// <summary>
    /// Returns increased <see cref="TIntX" /> value.
    /// </summary>
    /// <param name="value">Initial value.</param>
    /// <returns>Increased value.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class operator Inc(value: TIntX): TIntX;
    /// <summary>
    /// Returns decreased <see cref="TIntX" /> value.
    /// </summary>
    /// <param name="value">Initial value.</param>
    /// <returns>Decreased value.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class operator Dec(value: TIntX): TIntX;

    // -- Logical and bitwise operators --

    /// <summary>
    /// Performs bitwise OR for two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Resulting big integer.</returns>

    class operator BitwiseOr(int1: TIntX; int2: TIntX): TIntX;

    /// <summary>
    /// Performs bitwise AND for two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Resulting big integer.</returns>

    class operator BitwiseAnd(int1: TIntX; int2: TIntX): TIntX;

    /// <summary>
    /// Performs bitwise XOR for two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Resulting big integer.</returns>

    class operator BitwiseXor(int1: TIntX; int2: TIntX): TIntX;

    /// <summary>
    /// Performs bitwise NOT for big integer.
    /// </summary>
    /// <param name="value">Big integer.</param>
    /// <returns>Resulting big integer.</returns>
    /// <remarks>
    /// ** In Delphi, You cannot overload the bitwise not operator, as BitwiseNot is not
    /// supported by the compiler. You have to overload the logical 'not' operator
    /// instead.
    /// **A bitwise not might be An Integer XOR -1  (Not Sure Though)**
    /// </remarks>
    /// <seealso href="http://stackoverflow.com/questions/1587777/what-kinds-of-operator-overloads-does-delphi-support/1588225#1588225">[For more Information]</seealso>

    class operator LogicalNot(value: TIntX): TIntX;

    // -- Implicit conversion operators --

    /// <summary>
    /// Implicitly converts <see cref="Byte" /> to <see cref="TIntX" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Implicit(value: Byte): TIntX;

    /// <summary>
    /// Implicitly converts <see cref="ShortInt" /> to <see cref="TIntX" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Implicit(value: ShortInt): TIntX;

    /// <summary>
    /// Implicitly converts <see cref="SmallInt" /> to <see cref="TIntX" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Implicit(value: SmallInt): TIntX;

    /// <summary>
    /// Implicitly converts <see cref="Word" /> to <see cref="TIntX" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Implicit(value: Word): TIntX;

    /// <summary>
    /// Implicitly converts <see cref="Integer" /> to <see cref="TIntX" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Implicit(value: Integer): TIntX;

    /// <summary>
    /// Implicitly converts <see cref="UInt32" /> to <see cref="TIntX" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Implicit(value: UInt32): TIntX;

    /// <summary>
    /// Implicitly converts <see cref="Int64" /> to <see cref="TIntX" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Implicit(value: Int64): TIntX;

    /// <summary>
    /// Implicitly converts <see cref="UInt64" /> to <see cref="TIntX" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Implicit(value: UInt64): TIntX;

    // -- Explicit conversion operators --

    /// <summary>
    /// Explicitly converts <see cref="Double" /> to <see cref="TIntX" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Explicit(value: Double): TIntX;

    /// <summary>
    /// Explicitly converts <see cref="TIntX" /> to <see cref="Byte" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Explicit(value: TIntX): Byte;

    /// <summary>
    /// Explicitly converts <see cref="TIntX" /> to <see cref="ShortInt" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Explicit(value: TIntX): ShortInt;

    /// <summary>
    /// Explicitly converts <see cref="TIntX" /> to <see cref="SmallInt" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Explicit(value: TIntX): SmallInt;

    /// <summary>
    /// Explicitly converts <see cref="TIntX" /> to <see cref="Word" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Explicit(value: TIntX): Word;

    /// <summary>
    /// Explicitly converts <see cref="TIntX" /> to <see cref="Integer" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Explicit(value: TIntX): Integer;

    /// <summary>
    /// Explicitly converts <see cref="TIntX" /> to <see cref="UInt32" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

    class operator Explicit(value: TIntX): UInt32;

    /// <summary>
    /// Explicitly converts <see cref="TIntX" /> to <see cref="Int64" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Explicit(value: TIntX): Int64;

    /// <summary>
    /// Explicitly converts <see cref="TIntX" /> to <see cref="UInt64" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Explicit(value: TIntX): UInt64;

    /// <summary>
    /// Explicitly converts <see cref="TIntX" /> to <see cref="Double" />.
    /// </summary>
    /// <param name="value">Value to convert.</param>
    /// <returns>Conversion result.</returns>

    class operator Explicit(value: TIntX): Double;

  end;

var

  /// <summary>
  /// Temporary Variable to Hold <c>Zero</c><see cref="TIntX" />.
  /// </summary>
  ZeroX: TIntX;
  /// <summary>
  /// Temporary Variable to Hold <c>One</c><see cref="TIntX" />.
  /// </summary>
  OneX: TIntX;
  /// <summary>
  /// Temporary Variable to Hold Minus <c>One</c><see cref="TIntX" />.
  /// </summary>
  MinusOneX: TIntX;
  /// <summary>
  /// Temporary Variable to Hold Ten <see cref="TIntX" />.
  /// </summary>
  TenX: TIntX;

implementation

uses
  uConstants,
  uMultiplyManager,
  uDivideManager,
  uStringConvertManager,
  uParseManager,
  uDigitHelper,
  uOpHelper,
  uStrRepHelper;

// static constructor
class constructor TIntX.Create();
begin
  _globalSettings := TIntXGlobalSettings.Create;
  _settings := TIntXSettings.Create(TIntX.GlobalSettings);
  // Global FormatSettings
{$IFDEF FPC}
  _FS := DefaultFormatSettings;
{$ELSE}
{$IFDEF DELPHIXE_UP}
  _FS := TFormatSettings.Create;
{$ELSE}
  GetLocaleFormatSettings(0, _FS);
{$ENDIF DELPHIXE_UP}
{$ENDIF FPC}
  // Create a Zero TIntX (a big integer with value as Zero)
  ZeroX := TIntX.Create(0);
  // Create a One TIntX (a big integer with value as One)
  OneX := TIntX.Create(1);
  // Create a MinusOne TIntX (a big integer with value as Negative One)
  MinusOneX := TIntX.Create(-1);
  // Create a Ten TIntX (a big integer with value as Ten)
  TenX := TIntX.Create(10);

{$IFDEF DEBUG}
  _maxFhtRoundErrorCriticalSection := TCriticalSection.Create;
{$ENDIF DEBUG}
end;

class destructor TIntX.Destroy();
begin
{$IFDEF DEBUG}
  _maxFhtRoundErrorCriticalSection.Free;
{$ENDIF DEBUG}
  _globalSettings.Free;
  _settings.Free;
end;

class function TIntX.GetZero: TIntX;
begin
  result := ZeroX;
end;

class function TIntX.GetOne: TIntX;
begin
  result := OneX;
end;

class function TIntX.GetMinusOne: TIntX;
begin
  result := MinusOneX;
end;

class function TIntX.GetTen: TIntX;
begin
  result := TenX;
end;

class function TIntX.GetGlobalSettings: TIntXGlobalSettings;
begin
  result := _globalSettings;
end;

constructor TIntX.Create(value: Integer);
begin
  if (value = 0) then
  begin
    // Very specific fast processing for zero values
    InitFromZero();
  end
  else
  begin
    // Prepare internal fields
    _length := 1;
    SetLength(_digits, _length);

    // Fill the only big integer digit
    TDigitHelper.ToUInt32WithSign(value, _digits[0], _negative,
      _zeroinithelper);
  end;
end;

constructor TIntX.Create(value: UInt32);
begin
  if (value = 0) then
  begin
    // Very specific fast processing for zero values
    InitFromZero();
  end
  else
  begin
    // Prepare internal fields

    SetLength(_digits, 1);
    _digits[0] := value;
    _length := 1;
    // Initialized _negative to False by default since this type does not have
    // negative values.
    _negative := false;

  end;
end;

constructor TIntX.Create(value: Int64);
var
  newValue: UInt64;
begin
  if (value = 0) then
  begin
    // Very specific fast processing for zero values
    InitFromZero();
  end
  else
  begin
    // Fill the only big integer digit
    TDigitHelper.ToUInt64WithSign(value, newValue, _negative, _zeroinithelper);
    InitFromUlong(newValue);
  end;
end;

constructor TIntX.Create(value: UInt64);
begin
  if (value = 0) then
  begin
    // Very specific fast processing for zero values
    InitFromZero();
  end
  else
  begin
    InitFromUlong(value);
    // Initialized _negative to False by default since this type does not have
    // negative values.
    _negative := false;
  end;
end;

constructor TIntX.Create(value: Double);
begin
  // Exceptions
  if (IsInfinite(value)) then
    raise EOverflowException.Create(uStrings.Overflow_TIntXInfinity);
  if (IsNaN(value)) then
    raise EOverflowException.Create(uStrings.Overflow_NotANumber);
  _digits := Nil;
  TOpHelper.SetDigitsFromDouble(value, _digits, Self);

end;

constructor TIntX.Create(digits: TIntXLibUInt32Array; negative: Boolean);
begin
  // Exception
  if (digits = Nil) then
  begin
    raise EArgumentNilException.Create('digits');
  end;
  InitFromDigits(digits, negative, TDigitHelper.GetRealDigitsLength(digits,
    UInt32(Length(digits))));
end;

constructor TIntX.Create(const value: String);
var
  IntX: TIntX;
begin
  IntX := Parse(value);
  InitFromIntX(IntX);
end;

constructor TIntX.Create(const value: String; numberBase: UInt32);
var
  IntX: TIntX;
begin
  IntX := Parse(value, numberBase);
  InitFromIntX(IntX);
end;

constructor TIntX.Create(value: TIntX);

begin
  // Exception
  if (value = Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  InitFromIntX(value);
end;

constructor TIntX.Create(mlength: UInt32; negative: Boolean);
begin
  _length := mlength;
  SetLength(_digits, _length);
  _negative := negative;

end;

constructor TIntX.Create(digits: TIntXLibUInt32Array; negative: Boolean;
  mlength: UInt32);
begin
  // Exception
  if (digits = Nil) then
  begin
    raise EArgumentNilException.Create('digits');
  end;

  InitFromDigits(digits, negative, mlength);
end;

function TIntX.GetSettings: TIntXSettings;
begin
  result := _settings;
end;

procedure TIntX.SetSettings(value: TIntXSettings);
begin
  _settings := value;
end;

function TIntX.GetIsOdd: Boolean;
begin
  result := (_length > 0) and ((_digits[0] and 1) = 1);
end;

function TIntX.GetIsNegative: Boolean;
begin
  result := _negative;
end;

function TIntX.GetIsZero: Boolean;
begin
  result := Self.Equals(TIntX.Zero);
end;

function TIntX.GetIsOne: Boolean;
begin
  result := Self.Equals(TIntX.One);
end;

function TIntX.GetIsPowerOfTwo: Boolean;
var
  iu: Integer;
begin
  if IsNegative then
  begin
    result := false;
    Exit;
  end;

  if Self <= TConstants.MaxUInt64Value then
  begin
    result := (not Self.IsZero) and (Self and (Self - 1) = 0);
    Exit;
  end;

  iu := Length(_digits) - 1;
  if ((_digits[iu] and (_digits[iu] - 1)) <> 0) then
  begin
    result := false;
    Exit;
  end;

  Dec(iu);
  while iu >= 0 do
  begin
    if (_digits[iu] <> 0) then
    begin
      result := false;
      Exit;
    end;
    Dec(iu);
  end;

  result := true;
  Exit;

end;

function TIntX.GetClone: TIntX;
begin
  result._digits := Copy(Self._digits);
  result._length := Self._length;
  result._negative := Self._negative;
  result._zeroinithelper := Self._zeroinithelper;
end;

class operator TIntX.Equal(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, false) = 0;
end;

class operator TIntX.Equal(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) = 0;
end;

class operator TIntX.Equal(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) = 0;
end;

class operator TIntX.Equal(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) = 0;
end;

class operator TIntX.Equal(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) = 0;
end;

class operator TIntX.Equal(int1: TIntX; int2: Int64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) = 0;
end;

class operator TIntX.Equal(int1: Int64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) = 0;
end;

class operator TIntX.Equal(int1: TIntX; int2: UInt64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) = 0;
end;

class operator TIntX.Equal(int1: UInt64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) = 0;
end;

class operator TIntX.NotEqual(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, false) <> 0;
end;

class operator TIntX.NotEqual(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) <> 0;
end;

class operator TIntX.NotEqual(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) <> 0;
end;

class operator TIntX.NotEqual(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) <> 0;
end;

class operator TIntX.NotEqual(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) <> 0;
end;

class operator TIntX.NotEqual(int1: TIntX; int2: Int64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) <> 0;
end;

class operator TIntX.NotEqual(int1: Int64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) <> 0;
end;

class operator TIntX.NotEqual(int1: TIntX; int2: UInt64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) <> 0;
end;

class operator TIntX.NotEqual(int1: UInt64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) <> 0;
end;

class operator TIntX.GreaterThan(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, true) > 0;
end;

class operator TIntX.GreaterThan(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) > 0;
end;

class operator TIntX.GreaterThan(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) < 0;
end;

class operator TIntX.GreaterThan(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) > 0;
end;

class operator TIntX.GreaterThan(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) < 0;
end;

class operator TIntX.GreaterThan(int1: TIntX; int2: Int64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) > 0;
end;

class operator TIntX.GreaterThan(int1: Int64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) < 0;
end;

class operator TIntX.GreaterThan(int1: TIntX; int2: UInt64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) > 0;
end;

class operator TIntX.GreaterThan(int1: UInt64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) < 0;
end;

class operator TIntX.GreaterThanOrEqual(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, true) >= 0;
end;

class operator TIntX.GreaterThanOrEqual(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) >= 0;
end;

class operator TIntX.GreaterThanOrEqual(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) <= 0;
end;

class operator TIntX.GreaterThanOrEqual(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) >= 0;
end;

class operator TIntX.GreaterThanOrEqual(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) <= 0;
end;

class operator TIntX.GreaterThanOrEqual(int1: TIntX; int2: Int64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) >= 0;
end;

class operator TIntX.GreaterThanOrEqual(int1: Int64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) <= 0;
end;

class operator TIntX.GreaterThanOrEqual(int1: TIntX; int2: UInt64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) >= 0;
end;

class operator TIntX.GreaterThanOrEqual(int1: UInt64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) <= 0;
end;

class operator TIntX.LessThan(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, true) < 0;
end;

class operator TIntX.LessThan(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) < 0;
end;

class operator TIntX.LessThan(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) > 0;
end;

class operator TIntX.LessThan(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) < 0;
end;

class operator TIntX.LessThan(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) > 0;
end;

class operator TIntX.LessThan(int1: TIntX; int2: Int64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) < 0;
end;

class operator TIntX.LessThan(int1: Int64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) > 0;
end;

class operator TIntX.LessThan(int1: TIntX; int2: UInt64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) < 0;
end;

class operator TIntX.LessThan(int1: UInt64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) > 0;
end;

class operator TIntX.LessThanOrEqual(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, true) <= 0;
end;

class operator TIntX.LessThanOrEqual(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) <= 0;
end;

class operator TIntX.LessThanOrEqual(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) >= 0;
end;

class operator TIntX.LessThanOrEqual(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) <= 0;
end;

class operator TIntX.LessThanOrEqual(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) >= 0;
end;

class operator TIntX.LessThanOrEqual(int1: TIntX; int2: Int64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) <= 0;
end;

class operator TIntX.LessThanOrEqual(int1: Int64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) >= 0;
end;

class operator TIntX.LessThanOrEqual(int1: TIntX; int2: UInt64): Boolean;
begin
  result := TOpHelper.Cmp(int1, TIntX.Create(int2), false) <= 0;
end;

class operator TIntX.LessThanOrEqual(int1: UInt64; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, TIntX.Create(int1), false) >= 0;
end;

class operator TIntX.Add(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TOpHelper.AddSub(int1, int2, false);
end;

class operator TIntX.Subtract(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TOpHelper.AddSub(int1, int2, true);
end;

class operator TIntX.Multiply(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TMultiplyManager.GetCurrentMultiplier().Multiply(int1, int2);
end;

class operator TIntX.IntDivide(int1: TIntX; int2: TIntX): TIntX;
var
  modRes: TIntX;
begin
  result := TDivideManager.GetCurrentDivider().DivMod(int1, int2, modRes,
    TDivModResultFlags.dmrfDiv);
end;

class operator TIntX.modulus(int1: TIntX; int2: TIntX): TIntX;
var
  modRes: TIntX;
begin
  TDivideManager.GetCurrentDivider().DivMod(int1, int2, modRes,
    TDivModResultFlags.dmrfMod);
  result := modRes;
end;

class operator TIntX.LeftShift(IntX: TIntX; shift: Integer): TIntX;
begin
  result := TOpHelper.Sh(IntX, shift, true);
end;

class operator TIntX.RightShift(IntX: TIntX; shift: Integer): TIntX;
begin
  result := TOpHelper.Sh(IntX, shift, false);
end;

class operator TIntX.Positive(value: TIntX): TIntX;

begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  result := TIntX.Create(value);

end;

class operator TIntX.negative(value: TIntX): TIntX;
var
  newValue: TIntX;
begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  newValue := TIntX.Create(value);
  if (newValue._length <> 0) then
  begin
    newValue._negative := not newValue._negative;
  end;
  result := newValue;
end;

class operator TIntX.Inc(value: TIntX): TIntX;

begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  result := value + UInt32(1);
end;

class operator TIntX.Dec(value: TIntX): TIntX;

begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  result := value - UInt32(1);
end;

class operator TIntX.BitwiseOr(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TOpHelper.BitwiseOr(int1, int2);
end;

class operator TIntX.BitwiseAnd(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TOpHelper.BitwiseAnd(int1, int2);
end;

class operator TIntX.BitwiseXor(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TOpHelper.ExclusiveOr(int1, int2);
end;

class operator TIntX.LogicalNot(value: TIntX): TIntX;
begin
  result := TOpHelper.OnesComplement(value);
end;

class operator TIntX.Implicit(value: Byte): TIntX;
begin
  result := TIntX.Create(value);
end;

class operator TIntX.Implicit(value: ShortInt): TIntX;
begin
  result := TIntX.Create(value);
end;

class operator TIntX.Implicit(value: SmallInt): TIntX;
begin
  result := TIntX.Create(value);
end;

class operator TIntX.Implicit(value: Word): TIntX;
begin
  result := TIntX.Create(value);
end;

class operator TIntX.Implicit(value: Integer): TIntX;
begin
  result := TIntX.Create(value);
end;

class operator TIntX.Implicit(value: UInt32): TIntX;
begin
  result := TIntX.Create(value);
end;

class operator TIntX.Implicit(value: Int64): TIntX;
begin
  result := TIntX.Create(value);
end;

class operator TIntX.Implicit(value: UInt64): TIntX;
begin
  result := TIntX.Create(value);
end;

class operator TIntX.Explicit(value: Double): TIntX;
begin
  result := TIntX.Create(value);
end;
{$OVERFLOWCHECKS ON}

class operator TIntX.Explicit(value: TIntX): Byte;
begin
  result := Byte(Integer(value));
end;
{$OVERFLOWCHECKS OFF}
{$OVERFLOWCHECKS ON}

class operator TIntX.Explicit(value: TIntX): ShortInt;
begin
  result := ShortInt(Integer(value));
end;
{$OVERFLOWCHECKS OFF}
{$OVERFLOWCHECKS ON}

class operator TIntX.Explicit(value: TIntX): SmallInt;
begin
  result := SmallInt(Integer(value));
end;
{$OVERFLOWCHECKS OFF}
{$OVERFLOWCHECKS ON}

class operator TIntX.Explicit(value: TIntX): Word;
begin
  result := Word(Integer(value));
end;
{$OVERFLOWCHECKS OFF}

class operator TIntX.Explicit(value: TIntX): Integer;
var
  res: Integer;
begin
  res := Integer(UInt32(value));
  if value._negative then
    result := -res
  else
    result := res
end;

class operator TIntX.Explicit(value: TIntX): UInt32;
begin
  // Exception
  if TIntX.CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create('value');

  if (value._length = 0) then
  begin
    result := 0;
    Exit;
  end;
  result := value._digits[0];
end;

class operator TIntX.Explicit(value: TIntX): Int64;
var
  res: Int64;
begin
  res := Int64(UInt64(value));
  if value._negative then
    result := -res
  else
    result := res
end;

class operator TIntX.Explicit(value: TIntX): UInt64;
var
  res: UInt64;
begin
  res := UInt32(value);
  if (value._length > 1) then
  begin
    res := res or UInt64(value._digits[1]) shl TConstants.DigitBitCount;
  end;
  result := res;
end;

class operator TIntX.Explicit(value: TIntX): Double;
begin
  result := value.AsDouble;
end;

class function TIntX.Multiply(int1: TIntX; int2: TIntX;
  mode: TMultiplyMode): TIntX;
begin
  result := TMultiplyManager.GetMultiplier(mode).Multiply(int1, int2);
end;

class function TIntX.Divide(int1: TIntX; int2: TIntX; mode: TDivideMode): TIntX;
var
  modRes: TIntX;
begin

  result := TDivideManager.GetDivider(mode).DivMod(int1, int2, modRes,
    TDivModResultFlags.dmrfDiv);

end;

class function TIntX.Modulo(int1: TIntX; int2: TIntX; mode: TDivideMode): TIntX;
var
  modRes: TIntX;
begin
  TDivideManager.GetDivider(mode).DivMod(int1, int2, modRes,
    TDivModResultFlags.dmrfMod);
  result := modRes;
end;

class function TIntX.DivideModulo(int1: TIntX; int2: TIntX;
  out modRes: TIntX): TIntX;
begin
  result := TDivideManager.GetCurrentDivider().DivMod(int1, int2, modRes,
    TDivModResultFlags(Ord(TDivModResultFlags.dmrfDiv) or
    Ord(TDivModResultFlags.dmrfMod)));
end;

class function TIntX.DivideModulo(int1: TIntX; int2: TIntX; out modRes: TIntX;
  mode: TDivideMode): TIntX;
begin
  result := TDivideManager.GetDivider(mode).DivMod(int1, int2, modRes,
    TDivModResultFlags(Ord(TDivModResultFlags.dmrfDiv) or
    Ord(TDivModResultFlags.dmrfMod)));
end;

class function TIntX.Random(): TIntX;

begin
  result := TOpHelper.Random();
end;

class function TIntX.RandomRange(Min: UInt32; Max: UInt32): TIntX;
begin
  result := TOpHelper.RandomRange(Min, Max);
end;

class function TIntX.AbsoluteValue(value: TIntX): TIntX;
begin
  // Exception
  if CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' value');
  result := TOpHelper.AbsoluteValue(value);
end;

class function TIntX.Log10(value: TIntX): Double;
begin
  // Exception
  if CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' value');
  result := TOpHelper.Log10(value);
end;

class function TIntX.Ln(value: TIntX): Double;
begin
  // Exception
  if CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' value');
  result := TOpHelper.Ln(value);

end;

class function TIntX.LogN(base: Double; value: TIntX): Double;

begin
  // Exception
  if CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' value');

  result := TOpHelper.LogN(base, value);
end;

class function TIntX.IntegerLogN(base: TIntX; number: TIntX): TIntX;
begin
  // Exceptions
  if CompareRecords(base, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' base');
  if CompareRecords(number, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' number');

  if ((base = 0) or (number = 0)) then
    raise EArgumentException.Create(uStrings.LogCantComputeZero);

  if ((base._negative) or (number._negative)) then
    raise EArgumentException.Create(uStrings.LogNegativeNotAllowed);

  result := TOpHelper.IntegerLogN(base, number);
end;

class function TIntX.Square(value: TIntX): TIntX;
begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  result := TOpHelper.Square(value);
end;

class function TIntX.IntegerSquareRoot(value: TIntX): TIntX;

begin
  // Exceptions

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  if value._negative then
    raise EArgumentException.Create(NegativeSquareRoot + ' value');
  result := TOpHelper.IntegerSquareRoot(value);
end;

class function TIntX.Factorial(value: TIntX): TIntX;

begin
  // Exception
  if CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create(uStrings.CantBeNull + ' value');
  result := TOpHelper.Factorial(value);
end;

class function TIntX.GCD(int1: TIntX; int2: TIntX): TIntX;
begin
  // Exceptions
  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create('int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then
    raise EArgumentNilException.Create('int2');

  result := TOpHelper.GCD(int1, int2);
end;

class function TIntX.LCM(int1: TIntX; int2: TIntX): TIntX;
begin
  // Exceptions
  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create('int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then
    raise EArgumentNilException.Create('int2');

  result := TOpHelper.LCM(int1, int2);
end;

class function TIntX.InvMod(int1: TIntX; int2: TIntX): TIntX;
begin
  // Exceptions
  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create('int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then
    raise EArgumentNilException.Create('int2');

  if ((int1._negative) or (int2._negative)) then
    raise EArgumentException.Create(uStrings.InvModNegativeNotAllowed);

  result := TOpHelper.InvMod(int1, int2);
end;

class function TIntX.ModPow(value: TIntX; exponent: TIntX;
  modulus: TIntX): TIntX;
begin
  // Exceptions
  if TIntX.CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create('value');

  if TIntX.CompareRecords(exponent, Default (TIntX)) then
    raise EArgumentNilException.Create('exponent');

  if TIntX.CompareRecords(modulus, Default (TIntX)) then
    raise EArgumentNilException.Create('modulus');

  if modulus <= 0 then
    raise EArgumentException.Create(uStrings.ModPowModulusCantbeZeroorNegative);

  if (exponent._negative) then
    raise EArgumentException.Create(uStrings.ModPowExponentCantbeNegative);

  result := TOpHelper.ModPow(value, exponent, modulus);
end;

class function TIntX.Bezoutsidentity(int1: TIntX; int2: TIntX;
  out bezOne: TIntX; out bezTwo: TIntX): TIntX;
begin
  // Exceptions
  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create('int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then
    raise EArgumentNilException.Create('int2');

  result := TOpHelper.Bezoutsidentity(int1, int2, bezOne, bezTwo);
end;

class function TIntX.IsProbablyPrime(value: TIntX;
  Accuracy: Integer = 5): Boolean;
begin
  // Exception
  if TIntX.CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create('value');
  result := TOpHelper.IsProbablyPrime(value, Accuracy);
end;

class function TIntX.Max(left: TIntX; right: TIntX): TIntX;
begin
  // Exceptions
  if TIntX.CompareRecords(left, Default (TIntX)) then
    raise EArgumentNilException.Create('left');

  if TIntX.CompareRecords(right, Default (TIntX)) then
    raise EArgumentNilException.Create('right');

  result := TOpHelper.Max(left, right);
end;

class function TIntX.Min(left: TIntX; right: TIntX): TIntX;
begin
  // Exceptions
  if TIntX.CompareRecords(left, Default (TIntX)) then
    raise EArgumentNilException.Create('left');

  if TIntX.CompareRecords(right, Default (TIntX)) then
    raise EArgumentNilException.Create('right');

  result := TOpHelper.Min(left, right);
end;

class function TIntX.Pow(value: TIntX; power: UInt32): TIntX;
begin
  result := TOpHelper.Pow(value, power, TIntX.GlobalSettings.multiplyMode);
end;

class function TIntX.Pow(value: TIntX; power: UInt32;
  multiplyMode: TMultiplyMode): TIntX;
begin
  result := TOpHelper.Pow(value, power, multiplyMode);
end;

function TIntX.ToString(): String;
begin
  result := ToString(UInt32(10), true);
end;

function TIntX.ToString(numberBase: UInt32): String;
begin
  result := ToString(numberBase, true);
end;

function TIntX.ToString(numberBase: UInt32; UpperCase: Boolean): String;
var
  tempCharArray: TIntXLibCharArray;
begin
  if UpperCase then
    tempCharArray := TConstants.FBaseUpperChars
  else
  begin
    tempCharArray := TConstants.FBaseLowerChars;
  end;

  result := TStringConvertManager.GetStringConverter(Settings.ToStringMode)
    .ToString(Self, numberBase, tempCharArray);
end;

function TIntX.ToString(numberBase: UInt32; const alphabet: String): String;
begin
  TStrRepHelper.AssertAlphabet(alphabet, numberBase);

  result := TStringConvertManager.GetStringConverter(Settings.ToStringMode)
    .ToString(Self, numberBase, TStrRepHelper.ToCharArray(alphabet));
end;

function TIntX.AsDouble: Double;
const
  infinityLength = Integer(1024 div 32);
  DoublePositiveInfinity: Double = 1.0 / 0.0;
  DoubleNegativeInfinity: Double = -1.0 / 0.0;
var
  man, h, m, l: UInt64;
  exp, sign, lLength, z: Integer;
  // reg: TOpHelper.TBuilder;
  bits: TIntXLibUInt32Array;
begin
  // Exception
  if TIntX.CompareRecords(Self, Default (TIntX)) then
    raise EArgumentNilException.Create('value');

  // sign := 1;
  // reg := TOpHelper.TBuilder.Create(Self, sign);
  // reg.GetApproxParts(exp, man);
  // result := TOpHelper.GetDoubleFromParts(sign, exp, man);

  bits := Self._digits;
  lLength := Self._length;

  if Self.IsZero then
  begin
    result := 0;
    Exit;
  end;

  if Self.IsNegative then
  begin
    sign := -1
  end
  else
  begin
    sign := 1;
  end;

  if (lLength > infinityLength) then
  begin

    if sign = 1 then
    begin
      result := DoublePositiveInfinity;
      Exit;
    end
    else
    begin
      result := DoubleNegativeInfinity;
      Exit;
    end;

  end;

  h := bits[lLength - 1];

  if lLength > 1 then
    m := bits[lLength - 2]
  else
    m := 0;

  if lLength > 2 then
    l := bits[lLength - 3]
  else
    l := 0;

  // measure the exact bit count
  z := TOpHelper.CbitHighZero(UInt32(h));

  exp := ((lLength - 2) * 32) - z;

  // extract most significant bits
  man := (h shl (32 + z)) or (m shl z) or (l shr (32 - z));

  result := TOpHelper.GetDoubleFromParts(sign, exp, man);

end;

function TIntX.AsInteger: Integer;
var
  res: Integer;
begin
  // Exception
  if TIntX.CompareRecords(Self, Default (TIntX)) then
    raise EArgumentNilException.Create('value');

  if (Self._length = 0) then
  begin
    result := 0;
    Exit;
  end;

  if ((Self._length > 1) or (Self._digits[0] > UInt32(TConstants.MaxIntValue)))
  then
    raise EOverflowException.Create(uStrings.OverFlow_Data);

  res := Integer(Self._digits[0]);
  if Self._negative then
    result := -res
  else
    result := res;
end;

function TIntX.AsUInt32: UInt32;
begin
  // Exception
  if TIntX.CompareRecords(Self, Default (TIntX)) then
    raise EArgumentNilException.Create('value');

  if (Self._length = 0) then
  begin
    result := 0;
    Exit;
  end;

  if ((Self._length > 1) or (Self._negative)) then
    raise EOverflowException.Create(uStrings.OverFlow_Data);

  result := Self._digits[0];
end;

function TIntX.AsInt64: Int64;
var
  res: UInt64;
begin
  // Exception
  if TIntX.CompareRecords(Self, Default (TIntX)) then
    raise EArgumentNilException.Create('value');

  if (Self._length = 0) then
  begin
    result := 0;
    Exit;
  end;

  if (Self._length > 2) then
    raise EOverflowException.Create(uStrings.OverFlow_Data);

  res := Self._digits[0];
  if (Self._length > 1) then
  begin
    res := res or (UInt64(Self._digits[1]) shl TConstants.DigitBitCount);
  end;
{$WARNINGS OFF}
  if res > (TConstants.MinInt64Value) then
  begin
    raise EOverflowException.Create(uStrings.OverFlow_Data);
  end;

  if ((res = TConstants.MinInt64Value) and (not Self._negative)) then
  begin
    raise EOverflowException.Create(uStrings.OverFlow_Data);
  end;
{$WARNINGS ON}
  if Self._negative then
    result := -Int64(res)
  else
    result := Int64(res);
end;

function TIntX.AsUInt64: UInt64;
var
  res: UInt64;
begin
  // Exception
  if TIntX.CompareRecords(Self, Default (TIntX)) then
    raise EArgumentNilException.Create('value');

  if (Self._length = 0) then
  begin
    result := 0;
    Exit;
  end;

  if (((Self._length) > 2) or (Self._negative)) then
    raise EOverflowException.Create(uStrings.OverFlow_Data);

  res := Self._digits[0];
  if (Self._length > 1) then
  begin
    res := res or (UInt64(Self._digits[1]) shl TConstants.DigitBitCount);
  end;
  result := res;
end;

class function TIntX.Parse(const value: String): TIntX;
begin
  result := TParseManager.GetCurrentParser().Parse(value, UInt32(10),
    TConstants.FBaseCharToDigits, true);
end;

class function TIntX.Parse(const value: String; numberBase: UInt32): TIntX;
begin
  result := TParseManager.GetCurrentParser().Parse(value, numberBase,
    TConstants.FBaseCharToDigits, false);
end;

class function TIntX.Parse(const value: String; numberBase: UInt32;
  const alphabet: String): TIntX;
var
  LCharDigits: TDictionary<Char, UInt32>;

begin

  LCharDigits := TStrRepHelper.CharDictionaryFromAlphabet(alphabet, numberBase);
  try
    result := TParseManager.GetCurrentParser().Parse(value, numberBase,
      LCharDigits, false);
  finally
    LCharDigits.Free;
  end;

end;

class function TIntX.Parse(const value: String; mode: TParseMode): TIntX;
begin
  result := TParseManager.GetParser(mode).Parse(value, UInt32(10),
    TConstants.FBaseCharToDigits, true);
end;

class function TIntX.Parse(const value: String; numberBase: UInt32;
  mode: TParseMode): TIntX;
begin
  result := TParseManager.GetParser(mode).Parse(value, numberBase,
    TConstants.FBaseCharToDigits, false);
end;

class function TIntX.Parse(const value: String; numberBase: UInt32;
  const alphabet: String; mode: TParseMode): TIntX;
var
  LCharDigits: TDictionary<Char, UInt32>;
begin

  LCharDigits := TStrRepHelper.CharDictionaryFromAlphabet(alphabet, numberBase);
  try
    result := TParseManager.GetParser(mode).Parse(value, numberBase,
      LCharDigits, false);
  finally
    LCharDigits.Free;
  end;

end;

function TIntX.Equals(n: TIntX): Boolean;
begin
  result := Self = n;
end;

function TIntX.Equals(n: Integer): Boolean;
begin
  result := Self = n;
end;

function TIntX.Equals(n: UInt32): Boolean;
begin
  result := Self = n;
end;

function TIntX.Equals(n: Int64): Boolean;
begin
  result := Self = n;
end;

function TIntX.Equals(n: UInt64): Boolean;
begin
  result := Self = n;
end;

function TIntX.CompareTo(n: TIntX): Integer;
begin
  result := TOpHelper.Cmp(Self, n, true);
end;

function TIntX.CompareTo(n: Integer): Integer;
begin
  result := TOpHelper.Cmp(Self, n);
end;

function TIntX.CompareTo(n: UInt32): Integer;
begin
  result := TOpHelper.Cmp(Self, n);
end;

function TIntX.CompareTo(n: Int64): Integer;
begin
  result := TOpHelper.Cmp(Self, n, true);
end;

function TIntX.CompareTo(n: UInt64): Integer;
begin
  result := TOpHelper.Cmp(Self, n, true);
end;

procedure TIntX.Normalize();
var
  newDigits: TIntXLibUInt32Array;
begin
  if (UInt32(Length(_digits)) > _length) then
  begin
    SetLength(newDigits, _length);
    Move(_digits[0], newDigits[0], _length * SizeOf(UInt32));
    _digits := newDigits;
  end;

  if (_length = 0) then
  begin
    _negative := false;
  end;
end;

procedure TIntX.GetInternalState(out digits: TIntXLibUInt32Array;
  out negative: Boolean; out zeroinithelper: Boolean);

begin
  SetLength(digits, _length);
  Move(_digits[0], digits[0], _length * SizeOf(UInt32));
  negative := _negative;
  zeroinithelper := _zeroinithelper;
end;

procedure TIntX.InitFromZero();
begin
  _length := 0;
  SetLength(_digits, 0);
  _zeroinithelper := true;
  _negative := false;
end;

procedure TIntX.InitFromUlong(value: UInt64);
var
  low, high: UInt32;

begin
  // Divide uint64 into 2 uint32 values
  low := UInt32(value);
  high := UInt32(value shr TConstants.DigitBitCount);

  // Prepare internal fields
  if (high = 0) then
  begin
    SetLength(_digits, 1);
    _digits[0] := low;
  end
  else
  begin
    SetLength(_digits, 2);
    _digits[0] := low;
    _digits[1] := high;
  end;

  _length := UInt32(Length(_digits));
end;

procedure TIntX.InitFromIntX(value: TIntX);
begin
  _digits := value._digits;
  _length := value._length;
  _negative := value._negative;
  _zeroinithelper := value._zeroinithelper;
end;

procedure TIntX.InitFromDigits(digits: TIntXLibUInt32Array; negative: Boolean;
  mlength: UInt32);
begin
  _length := mlength;
  SetLength(_digits, _length);
  Move(digits[0], _digits[0], mlength * SizeOf(UInt32));
  if (mlength <> 0) then
  begin
    _negative := negative;
  end;
end;

procedure TIntX.TryNormalize();
begin
  if (Settings.AutoNormalize) then
  begin
    Normalize();
  end;
end;

class function TIntX.CompareRecords(Rec1: TIntX; Rec2: TIntX): Boolean;

begin

  if Length(Rec1._digits) <> Length(Rec2._digits) then
  begin
    result := false;
    Exit;
  end;

  result := (CompareMem(Pointer(Rec1._digits), Pointer(Rec2._digits),
    Length(Rec1._digits) * SizeOf(UInt32)) and (Rec1._length = Rec2._length) and
    (Rec1._negative = Rec2._negative) and
    (Rec1._zeroinithelper = Rec2._zeroinithelper));

end;

end.
