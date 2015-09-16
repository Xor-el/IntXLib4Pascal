unit IntX;

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
  SysUtils, DTypes, IntXGlobalSettings, IntXSettings, Enums,
  Constants, StrRepHelper, Strings, Generics.Defaults, Generics.Collections;

type
  /// <summary>
  /// Numeric record which represents arbitrary-precision integers.
  /// </summary>
  TIntX = record

    _digits: TMyUint32Array; // big integer digits
    _length: UInt32; // big integer digits length
    _negative: Boolean; // big integer sign ("-" if true)
    _zeroinithelper: Boolean; // used to check if TIntX was Zero Initialized.

  class var
    _globalSettings: TIntXGlobalSettings;
    _settings: TIntXSettings;
    Zero: TIntX;
    One: TIntX;
{$IFDEF DEBUG}
    /// <summary>
    /// Lock for maximal error during FHT rounding (debug-mode only).
    /// </summary>
    _maxFhtRoundErrorLock: TObject;

    /// <summary>
    /// Maximal error during FHT rounding (debug-mode only).
    /// </summary>
    MaxFhtRoundError: Double;
{$ENDIF}
  strict private
    procedure InitFromZero();
    procedure InitFromUlong(value: UInt64);
    procedure InitFromIntX(value: TIntX);
    procedure InitFromIntXAbs(value: TIntX);
    procedure InitFromDigits(digits: TMyUint32Array; negative: Boolean;
      mlength: UInt32);
  public
    class function GlobalSettings: TIntXGlobalSettings; static;
    class constructor Create();
    class destructor Destroy();
    constructor Create(value: Integer); overload;
    constructor Create(value: UInt32); overload;
    constructor Create(value: Int64); overload;
    constructor Create(value: UInt64); overload;
    constructor Create(digits: TMyUint32Array; negative: Boolean); overload;
    constructor Create(value: String); overload;
    constructor Create(value: String; numberBase: UInt32); overload;
    constructor Create(value: TIntX); overload;
    constructor Create(value: TIntX; isAbsolute: Boolean); overload;
    constructor Create(mlength: UInt32; negative: Boolean); overload;
    constructor Create(digits: TMyUint32Array; negative: Boolean;
      mlength: UInt32); overload;
    function Settings: TIntXSettings;
    function IsOdd: Boolean;
    class function Multiply(int1: TIntX; int2: TIntX; mode: TMultiplyMode)
      : TIntX; static;
    class function Divide(int1: TIntX; int2: TIntX; mode: TDivideMode)
      : TIntX; static;
    class function Modulo(int1: TIntX; int2: TIntX; mode: TDivideMode)
      : TIntX; static;
    class function DivideModulo(int1: TIntX; int2: TIntX; out modRes: TIntX)
      : TIntX; overload; static;
    class function DivideModulo(int1: TIntX; int2: TIntX; out modRes: TIntX;
      mode: TDivideMode): TIntX; overload; static;
    class function Random(): TIntX; static;
    class function RandomRange(Min: UInt32; Max: UInt32): TIntX; static;
    class function AbsoluteValue(value: TIntX): TIntX; static;
    class function LogN(base: TIntX; number: TIntX): TIntX; static;
    class function Square(value: TIntX): TIntX; static;
    class function SquareRoot(value: TIntX): TIntX; static;
    class function Factorial(value: TIntX): TIntX; static;
    class function GCD(int1: TIntX; int2: TIntX): TIntX; static;
    class function InvMod(int1: TIntX; int2: TIntX): TIntX; static;
    class function ModPow(value: TIntX; exponent: TIntX; modulus: TIntX)
      : TIntX; static;
    class function Bézoutsidentity(int1: TIntX; int2: TIntX; out bezOne: TIntX;
      out bezTwo: TIntX): TIntX; static;
    class function isProbablyPrime(value: TIntX; Accuracy: Integer = 5)
      : Boolean; static;
    class function Max(left: TIntX; right: TIntX): TIntX; static;
    class function Min(left: TIntX; right: TIntX): TIntX; static;
    class function Pow(value: TIntX; power: UInt32): TIntX; overload; static;
    class function Pow(value: TIntX; power: UInt32; multiplyMode: TMultiplyMode)
      : TIntX; overload; static;
    function ToString(): String; overload;
    function ToString(numberBase: UInt32): String; overload;
    function ToString(numberBase: UInt32; UpperCase: Boolean): String; overload;
    function ToString(numberBase: UInt32; alphabet: String): String; overload;
    class function Parse(value: String): TIntX; overload; static;
    class function Parse(value: String; numberBase: UInt32): TIntX;
      overload; static;
    class function Parse(value: String; numberBase: UInt32; alphabet: String)
      : TIntX; overload; static;
    class function Parse(value: String; mode: TParseMode): TIntX;
      overload; static;
    class function Parse(value: String; numberBase: UInt32; mode: TParseMode)
      : TIntX; overload; static;
    class function Parse(value: String; numberBase: UInt32; alphabet: String;
      mode: TParseMode): TIntX; overload; static;
    function Equals(n: TIntX): Boolean; overload;
    function Equals(n: Integer): Boolean; overload;
    function Equals(n: UInt32): Boolean; overload;
    function Equals(n: Int64): Boolean; overload;
    function Equals(n: UInt64): Boolean; overload;
    function CompareTo(n: TIntX): Integer; overload;
    function CompareTo(n: Integer): Integer; overload;
    function CompareTo(n: UInt32): Integer; overload;
    function CompareTo(n: Int64): Integer; overload;
    function CompareTo(n: UInt64): Integer; overload;
    procedure Normalize();
    procedure GetInternalState(out digits: TMyUint32Array;
      out negative: Boolean; out zeroinithelper: Boolean);
    procedure TryNormalize();
    class function CompareRecords(Rec1: TIntX; Rec2: TIntX): Boolean;
      static; inline;

    class operator Equal(int1: TIntX; int2: TIntX): Boolean;
    class operator Equal(int1: TIntX; int2: Integer): Boolean;
    class operator Equal(int1: Integer; int2: TIntX): Boolean;
    class operator Equal(int1: TIntX; int2: UInt32): Boolean;
    class operator Equal(int1: UInt32; int2: TIntX): Boolean;

    class operator NotEqual(int1: TIntX; int2: TIntX): Boolean;
    class operator NotEqual(int1: TIntX; int2: Integer): Boolean;
    class operator NotEqual(int1: Integer; int2: TIntX): Boolean;
    class operator NotEqual(int1: TIntX; int2: UInt32): Boolean;
    class operator NotEqual(int1: UInt32; int2: TIntX): Boolean;

    class operator GreaterThan(int1: TIntX; int2: TIntX): Boolean;
    class operator GreaterThan(int1: TIntX; int2: Integer): Boolean;
    class operator GreaterThan(int1: Integer; int2: TIntX): Boolean;
    class operator GreaterThan(int1: TIntX; int2: UInt32): Boolean;
    class operator GreaterThan(int1: UInt32; int2: TIntX): Boolean;

    class operator GreaterThanOrEqual(int1: TIntX; int2: TIntX): Boolean;
    class operator GreaterThanOrEqual(int1: TIntX; int2: Integer): Boolean;
    class operator GreaterThanOrEqual(int1: Integer; int2: TIntX): Boolean;
    class operator GreaterThanOrEqual(int1: TIntX; int2: UInt32): Boolean;
    class operator GreaterThanOrEqual(int1: UInt32; int2: TIntX): Boolean;

    class operator LessThan(int1: TIntX; int2: TIntX): Boolean;
    class operator LessThan(int1: TIntX; int2: Integer): Boolean;
    class operator LessThan(int1: Integer; int2: TIntX): Boolean;
    class operator LessThan(int1: TIntX; int2: UInt32): Boolean;
    class operator LessThan(int1: UInt32; int2: TIntX): Boolean;

    class operator LessThanOrEqual(int1: TIntX; int2: TIntX): Boolean;
    class operator LessThanOrEqual(int1: TIntX; int2: Integer): Boolean;
    class operator LessThanOrEqual(int1: Integer; int2: TIntX): Boolean;
    class operator LessThanOrEqual(int1: TIntX; int2: UInt32): Boolean;
    class operator LessThanOrEqual(int1: UInt32; int2: TIntX): Boolean;

    class operator Add(int1: TIntX; int2: TIntX): TIntX;
    class operator Subtract(int1: TIntX; int2: TIntX): TIntX;

    class operator Multiply(int1: TIntX; int2: TIntX): TIntX;

    class operator IntDivide(int1: TIntX; int2: TIntX): TIntX;
    class operator modulus(int1: TIntX; int2: TIntX): TIntX;

    class operator LeftShift(IntX: TIntX; shift: Integer): TIntX;
    class operator RightShift(IntX: TIntX; shift: Integer): TIntX;

    class operator Positive(value: TIntX): TIntX;
    class operator negative(value: TIntX): TIntX;

    class operator Inc(value: TIntX): TIntX;
    class operator Dec(value: TIntX): TIntX;

    class operator BitwiseOr(int1: TIntX; int2: TIntX): TIntX;
    class operator BitwiseAnd(int1: TIntX; int2: TIntX): TIntX;
    class operator BitwiseXor(int1: TIntX; int2: TIntX): TIntX;
    class operator LogicalNot(value: TIntX): TIntX;

    class operator Implicit(value: Integer): TIntX;
    class operator Implicit(value: UInt32): TIntX;
    class operator Implicit(value: Word): TIntX;
    class operator Implicit(value: Int64): TIntX;
    class operator Implicit(value: UInt64): TIntX;

    class operator Explicit(value: TIntX): Integer;
    class operator Explicit(value: TIntX): UInt32;
    class operator Explicit(value: TIntX): Int64;
    class operator Explicit(value: TIntX): UInt64;
    class operator Explicit(value: TIntX): Word;

  end;

implementation

uses
  MultiplyManager, DivideManager, StringConvertManager, ParseManager,
  DigitHelper, OpHelper;

// static constructor
class constructor TIntX.Create();
begin
  _globalSettings := TIntXGlobalSettings.Create;
  _settings := TIntXSettings.Create(GlobalSettings);
  // Create a Zero TIntX (a big integer with value as Zero)
  Zero := TIntX.Create(0);
  // Create a One TIntX (a big integer with value as One)
  One := TIntX.Create(1);

{$IFDEF DEBUG}
  _maxFhtRoundErrorLock := TObject.Create;
{$ENDIF}
end;

class destructor TIntX.Destroy();
begin
{$IFDEF DEBUG}
  _maxFhtRoundErrorLock.Free;
{$ENDIF}
  _globalSettings.Free;
  _settings.Free;
end;

/// <summary>
/// Creates new big integer from integer value.
/// </summary>
/// <param name="value">Integer value to create big integer from.</param>

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

/// <summary>
/// Creates new big integer from unsigned integer value.
/// </summary>
/// <param name="value">Unsigned integer value to create big integer from.</param>

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
    _negative := False;

  end;
end;

/// <summary>
/// Creates new big integer from Int64 value.
/// </summary>
/// <param name="value">Int64 value to create big integer from.</param>

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

/// <summary>
/// Creates new big integer from unsigned Int64 value.
/// </summary>
/// <param name="value">Unsigned Int64 value to create big integer from.</param>

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
    _negative := False;
  end;
end;

/// <summary>
/// Creates new big integer from array of it's "digits".
/// Digit with lower index has less weight.
/// </summary>
/// <param name="digits">Array of <see cref="TIntX" /> digits.</param>
/// <param name="negative">True if this number is negative.</param>

constructor TIntX.Create(digits: TMyUint32Array; negative: Boolean);
begin
  // Exceptions
  if (digits = Nil) then
  begin
    raise EArgumentNilException.Create('values');
  end;
  InitFromDigits(digits, negative, TDigitHelper.GetRealDigitsLength(digits,
    UInt32(Length(digits))));
end;

/// <summary>
/// Creates new <see cref="TIntX" /> from string.
/// </summary>
/// <param name="value">Number as string.</param>

constructor TIntX.Create(value: String);
var
  IntX: TIntX;
begin
  IntX := Parse(value);
  InitFromIntX(IntX);
end;

/// <summary>
/// Creates new <see cref="TIntX" /> from string.
/// </summary>
/// <param name="value">Number as string.</param>
/// <param name="numberBase">Number base.</param>

constructor TIntX.Create(value: String; numberBase: UInt32);
var
  IntX: TIntX;
begin
  IntX := Parse(value, numberBase);
  InitFromIntX(IntX);
end;

/// <summary>
/// Copy constructor.
/// </summary>
/// <param name="value">Value to copy from.</param>
/// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

constructor TIntX.Create(value: TIntX);

begin

  if (value = Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  InitFromIntX(value);
end;

/// <summary>
/// Copy constructor.
/// </summary>
/// <param name="value">Value to copy from.</param>
/// <param name="isAbsolute">Used to indicate if we want to get absolute value or not.</param>
/// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

constructor TIntX.Create(value: TIntX; isAbsolute: Boolean);

begin

  if (value = Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;
  InitFromIntXAbs(value);
end;

/// <summary>
/// Creates new empty big integer with desired sign and length.
///
/// For internal use.
/// </summary>
/// <param name="mlength">Desired digits length.</param>
/// <param name="negative">Desired integer sign.</param>

constructor TIntX.Create(mlength: UInt32; negative: Boolean);
begin
  _length := mlength;
  SetLength(_digits, _length);
  _negative := negative;

end;

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

constructor TIntX.Create(digits: TMyUint32Array; negative: Boolean;
  mlength: UInt32);
begin
  // Exceptions
  if (digits = Nil) then
  begin
    raise EArgumentNilException.Create('values');
  end;

  InitFromDigits(digits, negative, mlength);
end;

/// <summary>
/// <see cref="TIntX" /> global settings.
/// </summary>

class function TIntX.GlobalSettings: TIntXGlobalSettings;

begin
  result := _globalSettings;
end;

/// <summary>
/// <see cref="TIntX" /> instance settings.
/// </summary>

function TIntX.Settings: TIntXSettings;
begin
  result := _settings;
end;

/// <summary>
/// Gets flag indicating if big integer is odd.
/// </summary>

function TIntX.IsOdd: Boolean;
begin
  result := (_length > 0) and ((_digits[0] and 1) = 1);
end;

/// <summary>
/// Compares two <see cref="TIntX" /> objects and returns true if their internal state is equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if equals.</returns>

class operator TIntX.Equal(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, False) = 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with integer and returns true if their internal state is equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second integer.</param>
/// <returns>True if equals.</returns>

class operator TIntX.Equal(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) = 0;
end;

/// <summary>
/// Compares integer with <see cref="TIntX" /> object and returns true if their internal state is equal.
/// </summary>
/// <param name="int1">First integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if equals.</returns>

class operator TIntX.Equal(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) = 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with unsigned integer and returns true if their internal state is equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second unsigned integer.</param>
/// <returns>True if equals.</returns>

class operator TIntX.Equal(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) = 0;
end;

/// <summary>
/// Compares unsigned integer with <see cref="TIntX" /> object and returns true if their internal state is equal.
/// </summary>
/// <param name="int1">First unsigned integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if equals.</returns>

class operator TIntX.Equal(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) = 0;
end;

/// <summary>
/// Compares two <see cref="TIntX" /> objects and returns true if their internal state is not equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if not equals.</returns>

class operator TIntX.NotEqual(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, False) <> 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with integer and returns true if their internal state is not equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second integer.</param>
/// <returns>True if not equals.</returns>

class operator TIntX.NotEqual(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) <> 0;
end;

/// <summary>
/// Compares integer with <see cref="TIntX" /> object and returns true if their internal state is not equal.
/// </summary>
/// <param name="int1">First integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if not equals.</returns>

class operator TIntX.NotEqual(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) <> 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with unsigned integer and returns true if their internal state is not equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second unsigned integer.</param>
/// <returns>True if not equals.</returns>

class operator TIntX.NotEqual(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) <> 0;
end;

/// <summary>
/// Compares unsigned integer with <see cref="TIntX" /> object and returns true if their internal state is not equal.
/// </summary>
/// <param name="int1">First unsigned integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if not equals.</returns>

class operator TIntX.NotEqual(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) <> 0;
end;

/// <summary>
/// Compares two <see cref="TIntX" /> objects and returns true if first is greater.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is greater.</returns>

class operator TIntX.GreaterThan(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, True) > 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with integer and returns true if first is greater.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second integer.</param>
/// <returns>True if first is greater.</returns>

class operator TIntX.GreaterThan(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) > 0;
end;

/// <summary>
/// Compares integer with <see cref="TIntX" /> object and returns true if first is greater.
/// </summary>
/// <param name="int1">First integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is greater.</returns>

class operator TIntX.GreaterThan(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) < 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with unsigned integer and returns true if first is greater.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second unsigned integer.</param>
/// <returns>True if first is greater.</returns>

class operator TIntX.GreaterThan(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) > 0;
end;

/// <summary>
/// Compares unsigned integer with <see cref="TIntX" /> object and returns true if first is greater.
/// </summary>
/// <param name="int1">First unsigned integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is greater.</returns>

class operator TIntX.GreaterThan(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) < 0;
end;

/// <summary>
/// Compares two <see cref="TIntX" /> objects and returns true if first is greater or equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is greater or equal.</returns>

class operator TIntX.GreaterThanOrEqual(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, True) >= 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with integer and returns true if first is greater or equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second integer.</param>
/// <returns>True if first is greater or equal.</returns>

class operator TIntX.GreaterThanOrEqual(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) >= 0;
end;

/// <summary>
/// Compares integer with <see cref="TIntX" /> object and returns true if first is greater or equal.
/// </summary>
/// <param name="int1">First integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is greater or equal.</returns>

class operator TIntX.GreaterThanOrEqual(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) <= 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with unsigned integer and returns true if first is greater or equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second unsigned integer.</param>
/// <returns>True if first is greater or equal.</returns>

class operator TIntX.GreaterThanOrEqual(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) >= 0;
end;

/// <summary>
/// Compares unsigned integer with <see cref="TIntX" /> object and returns true if first is greater or equal.
/// </summary>
/// <param name="int1">First unsigned integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is greater or equal.</returns>

class operator TIntX.GreaterThanOrEqual(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) <= 0;
end;

/// <summary>
/// Compares two <see cref="TIntX" /> objects and returns true if first is lighter.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is lighter.</returns>

class operator TIntX.LessThan(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, True) < 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with integer and returns true if first is lighter.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second integer.</param>
/// <returns>True if first is lighter.</returns>

class operator TIntX.LessThan(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) < 0;
end;

/// <summary>
/// Compares integer with <see cref="TIntX" /> object and returns true if first is lighter.
/// </summary>
/// <param name="int1">First integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is lighter.</returns>

class operator TIntX.LessThan(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) > 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with unsigned integer and returns true if first is lighter.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second unsigned integer.</param>
/// <returns>True if first is lighter.</returns>

class operator TIntX.LessThan(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) < 0;
end;

/// <summary>
/// Compares unsigned integer with <see cref="TIntX" /> object and returns true if first is lighter.
/// </summary>
/// <param name="int1">First unsigned integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is lighter.</returns>

class operator TIntX.LessThan(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) > 0;
end;

/// <summary>
/// Compares two <see cref="TIntX" /> objects and returns true if first is lighter or equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is lighter or equal.</returns>

class operator TIntX.LessThanOrEqual(int1: TIntX; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2, True) <= 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with integer and returns true if first is lighter or equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second integer.</param>
/// <returns>True if first is lighter or equal.</returns>

class operator TIntX.LessThanOrEqual(int1: TIntX; int2: Integer): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) <= 0;
end;

/// <summary>
/// Compares integer with <see cref="TIntX" /> object and returns true if first is lighter or equal.
/// </summary>
/// <param name="int1">First integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is lighter or equal.</returns>

class operator TIntX.LessThanOrEqual(int1: Integer; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) >= 0;
end;

/// <summary>
/// Compares <see cref="TIntX" /> object with unsigned integer and returns true if first is lighter or equal.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second unsigned integer.</param>
/// <returns>True if first is lighter or equal.</returns>

class operator TIntX.LessThanOrEqual(int1: TIntX; int2: UInt32): Boolean;
begin
  result := TOpHelper.Cmp(int1, int2) <= 0;
end;

/// <summary>
/// Compares unsigned integer with <see cref="TIntX" /> object and returns true if first is lighter or equal.
/// </summary>
/// <param name="int1">First unsigned integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>True if first is lighter or equal.</returns>

class operator TIntX.LessThanOrEqual(int1: UInt32; int2: TIntX): Boolean;
begin
  result := TOpHelper.Cmp(int2, int1) >= 0;
end;

/// <summary>
/// Adds one <see cref="TIntX" /> object to another.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Addition result.</returns>

class operator TIntX.Add(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TOpHelper.AddSub(int1, int2, False);
end;

/// <summary>
/// Subtracts one <see cref="TIntX" /> object from another.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Subtraction result.</returns>

class operator TIntX.Subtract(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TOpHelper.AddSub(int1, int2, True);
end;

/// <summary>
/// Multiplies one <see cref="TIntX" /> object on another.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Multiply result.</returns>

class operator TIntX.Multiply(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TMultiplyManager.GetCurrentMultiplier().Multiply(int1, int2);
end;

/// <summary>
/// Divides one <see cref="TIntX" /> object by another.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Division result.</returns>

class operator TIntX.IntDivide(int1: TIntX; int2: TIntX): TIntX;
var
  modRes: TIntX;
begin
  result := TDivideManager.GetCurrentDivider().DivMod(int1, int2, modRes,
    TDivModResultFlags.dmrfDiv);
end;

/// <summary>
/// Divides one <see cref="TIntX" /> object by another and returns division modulo.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Modulo result.</returns>

class operator TIntX.modulus(int1: TIntX; int2: TIntX): TIntX;
var
  modRes: TIntX;
begin
  TDivideManager.GetCurrentDivider().DivMod(int1, int2, modRes,
    TDivModResultFlags.dmrfMod);
  result := modRes;
end;

/// <summary>
/// Shifts <see cref="TIntX" /> object on selected bits count to the left.
/// </summary>
/// <param name="intX">Big integer.</param>
/// <param name="shift">Bits count.</param>
/// <returns>Shifting result.</returns>

class operator TIntX.LeftShift(IntX: TIntX; shift: Integer): TIntX;
begin
  result := TOpHelper.Sh(IntX, shift, True);
end;

/// <summary>
/// Shifts <see cref="TIntX" /> object on selected bits count to the right.
/// </summary>
/// <param name="intX">Big integer.</param>
/// <param name="shift">Bits count.</param>
/// <returns>Shifting result.</returns>

class operator TIntX.RightShift(IntX: TIntX; shift: Integer): TIntX;
begin
  result := TOpHelper.Sh(IntX, shift, False);
end;

/// <summary>
/// Returns the same <see cref="TIntX" /> value.
/// </summary>
/// <param name="value">Initial value.</param>
/// <returns>The same value, but new object.</returns>
/// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

class operator TIntX.Positive(value: TIntX): TIntX;

begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  result := TIntX.Create(value);

end;

/// <summary>
/// Returns the same <see cref="TIntX" /> value, but with other sign.
/// </summary>
/// <param name="value">Initial value.</param>
/// <returns>The same value, but with other sign.</returns>
/// <exception cref="EArgumentNilException"><paramref name="value" /> is a null reference.</exception>

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

/// <summary>
/// Returns increased <see cref="TIntX" /> value.
/// </summary>
/// <param name="value">Initial value.</param>
/// <returns>Increased value.</returns>
/// <exception cref="ArgumentNullException"><paramref name="value" /> is a null reference.</exception>

class operator TIntX.Inc(value: TIntX): TIntX;

begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  result := value + UInt32(1);
end;

/// <summary>
/// Returns decreased <see cref="TIntX" /> value.
/// </summary>
/// <param name="value">Initial value.</param>
/// <returns>Decreased value.</returns>
/// <exception cref="ArgumentNullException"><paramref name="value" /> is a null reference.</exception>

class operator TIntX.Dec(value: TIntX): TIntX;

begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  result := value - UInt32(1);
end;

/// <summary>
/// Performs bitwise OR for two big integers.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Resulting big integer.</returns>

class operator TIntX.BitwiseOr(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TOpHelper.BitwiseOr(int1, int2);
end;

/// <summary>
/// Performs bitwise AND for two big integers.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Resulting big integer.</returns>

class operator TIntX.BitwiseAnd(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TOpHelper.BitwiseAnd(int1, int2);
end;

/// <summary>
/// Performs bitwise XOR for two big integers.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>Resulting big integer.</returns>

class operator TIntX.BitwiseXor(int1: TIntX; int2: TIntX): TIntX;
begin
  result := TOpHelper.ExclusiveOr(int1, int2);
end;

/// <summary>
/// Performs bitwise NOT for big integer.
/// </summary>
/// <param name="value">Big integer.</param>
/// <returns>Resulting big integer.</returns>
/// ** In Delphi, You cannot overload the bitwise not operator, as BitwiseNot is not
/// supported by the compiler. You have to overload the logical 'not' operator
/// instead.  (http://stackoverflow.com/questions/1587777/what-kinds-of-
// operator-overloads-does-delphi-support/1588225#1588225)
/// A bitwise not might be AnInteger XOR -1  (Not Sure Though)

class operator TIntX.LogicalNot(value: TIntX): TIntX;
begin
  result := TOpHelper.OnesComplement(value);
end;

/// <summary>
/// Implicitly converts <see cref="Integer" /> to <see cref="TIntX" />.
/// </summary>
/// <param name="value">Value to convert.</param>
/// <returns>Conversion result.</returns>

class operator TIntX.Implicit(value: Integer): TIntX;
begin
  result := TIntX.Create(value);
end;

/// <summary>
/// Implicitly converts <see cref="UInt32" /> to <see cref="TIntX" />.
/// </summary>
/// <param name="value">Value to convert.</param>
/// <returns>Conversion result.</returns>

class operator TIntX.Implicit(value: UInt32): TIntX;
begin
  result := TIntX.Create(value);
end;

/// <summary>
/// Implicitly converts <see cref="Word" /> to <see cref="TIntX" />.
/// </summary>
/// <param name="value">Value to convert.</param>
/// <returns>Conversion result.</returns>

class operator TIntX.Implicit(value: Word): TIntX;
begin
  result := TIntX.Create(value);
end;

/// <summary>
/// Implicitly converts <see cref="Int64" /> to <see cref="TIntX" />.
/// </summary>
/// <param name="value">Value to convert.</param>
/// <returns>Conversion result.</returns>

class operator TIntX.Implicit(value: Int64): TIntX;
begin
  result := TIntX.Create(value);
end;

/// <summary>
/// Implicitly converts <see cref="UInt64" /> to <see cref="TIntX" />.
/// </summary>
/// <param name="value">Value to convert.</param>
/// <returns>Conversion result.</returns>

class operator TIntX.Implicit(value: UInt64): TIntX;
begin
  result := TIntX.Create(value);
end;

/// <summary>
/// Explicitly converts <see cref="TIntX" /> to <see cref="Integer" />.
/// </summary>
/// <param name="value">Value to convert.</param>
/// <returns>Conversion result.</returns>

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

/// <summary>
/// Explicitly converts <see cref="TIntX" /> to <see cref="UInt32" />.
/// </summary>
/// <param name="value">Value to convert.</param>
/// <returns>Conversion result.</returns>

class operator TIntX.Explicit(value: TIntX): UInt32;

begin

  if TIntX.CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create('value');

  if (value._length = 0) then
  begin
    result := 0;
    Exit;
  end;
  result := value._digits[0];
end;

/// <summary>
/// Explicitly converts <see cref="TIntX" /> to <see cref="Int64" />.
/// </summary>
/// <param name="value">Value to convert.</param>
/// <returns>Conversion result.</returns>

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

/// <summary>
/// Explicitly converts <see cref="TIntX" /> to <see cref="UInt64" />.
/// </summary>
/// <param name="value">Value to convert.</param>
/// <returns>Conversion result.</returns>

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

/// <summary>
/// Explicitly converts <see cref="TIntX" /> to <see cref="Word" />.
/// </summary>
/// <param name="value">Value to convert.</param>
/// <returns>Conversion result.</returns>

class operator TIntX.Explicit(value: TIntX): Word;
begin
  result := Word(UInt32(value));
end;

/// <summary>
/// Multiplies one <see cref="TIntX" /> object on another.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <param name="mode">Multiply mode set explicitly.</param>
/// <returns>Multiply result.</returns>

class function TIntX.Multiply(int1: TIntX; int2: TIntX;
  mode: TMultiplyMode): TIntX;
begin
  result := TMultiplyManager.GetMultiplier(mode).Multiply(int1, int2);
end;

/// <summary>
/// Divides one <see cref="TIntX" /> object by another.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <param name="mode">Divide mode.</param>
/// <returns>Division result.</returns>

class function TIntX.Divide(int1: TIntX; int2: TIntX; mode: TDivideMode): TIntX;
var
  modRes: TIntX;
begin

  result := TDivideManager.GetDivider(mode).DivMod(int1, int2, modRes,
    TDivModResultFlags.dmrfDiv);

end;

/// <summary>
/// Divides one <see cref="TIntX" /> object by another and returns division modulo.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <param name="mode">Divide mode.</param>
/// <returns>Modulo result.</returns>

class function TIntX.Modulo(int1: TIntX; int2: TIntX; mode: TDivideMode): TIntX;
var
  modRes: TIntX;
begin
  TDivideManager.GetDivider(mode).DivMod(int1, int2, modRes,
    TDivModResultFlags.dmrfMod);
  result := modRes;
end;

/// <summary>
/// Divides one <see cref="TIntX" /> object on another.
/// Returns both divident and remainder
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <param name="modRes">Remainder big integer.</param>
/// <returns>Division result.</returns>

class function TIntX.DivideModulo(int1: TIntX; int2: TIntX;
  out modRes: TIntX): TIntX;
begin
  result := TDivideManager.GetCurrentDivider().DivMod(int1, int2, modRes,
    TDivModResultFlags(Ord(TDivModResultFlags.dmrfDiv) or
    Ord(TDivModResultFlags.dmrfMod)));
end;

/// <summary>
/// Divides one <see cref="TIntX" /> object on another.
/// Returns both divident and remainder
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <param name="modRes">Remainder big integer.</param>
/// <param name="mode">Divide mode.</param>
/// <returns>Division result.</returns>

class function TIntX.DivideModulo(int1: TIntX; int2: TIntX; out modRes: TIntX;
  mode: TDivideMode): TIntX;
begin
  result := TDivideManager.GetDivider(mode).DivMod(int1, int2, modRes,
    TDivModResultFlags(Ord(TDivModResultFlags.dmrfDiv) or
    Ord(TDivModResultFlags.dmrfMod)));
end;

/// <summary>
/// Returns a Non-Negative Random <see cref="TIntX" /> object using Mersemme Twister.
/// </summary>
/// <returns>Random TIntX value.</returns>

class function TIntX.Random(): TIntX;
begin
  result := TOpHelper.Random();
end;

/// <summary>
/// Returns a Non-Negative Random <see cref="TIntX" /> object using Mersemme
// Twister within the specified Range. (Max not Included)
/// </summary>
/// <returns>Random TIntX value.</returns>

class function TIntX.RandomRange(Min: UInt32; Max: UInt32): TIntX;
begin
  result := TOpHelper.RandomRange(Min, Max);
end;

/// <summary>
/// Calculates absolute value <see cref="TIntX" /> object.
/// </summary>
/// <param name="value">value to get absolute value of.</param>
/// <returns>Absolute value.</returns>

class function TIntX.AbsoluteValue(value: TIntX): TIntX;
begin
  if CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' value');
  result := TOpHelper.AbsoluteValue(value);
end;

/// <summary>
/// http://gist.github.com/dharmatech/409723
/// Calculates Integer Logarithm of a number <see cref="TIntX" /> object for a specified base.
/// the largest power the base can be raised to that does not exceed the number.
/// </summary>
/// <param name="base">base.</param>
/// <param name="number">number to get log of.</param>
/// <returns>Log.</returns>

class function TIntX.LogN(base: TIntX; number: TIntX): TIntX;
begin
  if CompareRecords(base, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' base');
  if CompareRecords(number, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' number');

  if ((base = 0) or (number = 0)) then
    raise EArgumentException.Create(Strings.LogCantComputeZero);

  if ((base._negative) or (number._negative)) then
    raise EArgumentException.Create(Strings.LogNegativeNotAllowed);

  result := TOpHelper.LogN(base, number);
end;

/// <summary>
/// Calculates Square of <see cref="TIntX" /> object.
/// </summary>
/// <param name="value">value to get square of.</param>
/// <returns>Squared value.</returns>

class function TIntX.Square(value: TIntX): TIntX;
begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  result := TOpHelper.Square(value);
end;

/// <summary>
/// Calculates Integer SquareRoot of <see cref="TIntX" /> object <see cref="http://www.dahuatu.com/RkWdPBx6W8.html" />
/// </summary>
/// <param name="value">value to get squareroot of.</param>
/// <returns>Integer SquareRoot.</returns>

class function TIntX.SquareRoot(value: TIntX): TIntX;

begin
  // Exception

  if TIntX.CompareRecords(value, Default (TIntX)) then
  begin
    raise EArgumentNilException.Create('value');
  end;

  if value._negative then
    raise EArgumentException.Create(NegativeSquareRoot + ' value');
  result := TOpHelper.SquareRoot(value);
end;

/// <summary>
/// Calculates Factorial of <see cref="TIntX" /> object.
/// </summary>
/// <param name="value">value to get factorial of.</param>
/// <returns>Factorial.</returns>

class function TIntX.Factorial(value: TIntX): TIntX;

begin
  if CompareRecords(value, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' value');
  result := TOpHelper.Factorial(value);
end;

/// <summary>
/// Calculate GCD of two <see cref="TIntX" /> object.
/// </summary>
/// <param name="int1">First big integer.</param>
/// <param name="int2">Second big integer.</param>
/// <returns>GCD value.</returns>

class function TIntX.GCD(int1: TIntX; int2: TIntX): TIntX;
begin
  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentException.Create('int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then
    raise EArgumentException.Create('int2');

  result := TOpHelper.GCD(int1, int2);
end;

// http://www.di-mgt.com.au/euclidean.html
// https://en.wikipedia.org/wiki/Modular_multiplicative_inverse
// Calculate Modular Inversion for two IntX Digits using Euclids Extended Algorithm
// returns Zero if no Modular Inverse Exists for the Inputs

class function TIntX.InvMod(int1: TIntX; int2: TIntX): TIntX;
begin
  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentException.Create('int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then
    raise EArgumentException.Create('int2');

  if ((int1._negative) or (int2._negative)) then
    raise EArgumentException.Create(Strings.InvModNegativeNotAllowed);

  result := TOpHelper.InvMod(int1, int2);
end;

// https://en.wikipedia.org/wiki/Modular_exponentiation
// Calculates Modular Exponentiation

class function TIntX.ModPow(value: TIntX; exponent: TIntX;
  modulus: TIntX): TIntX;
begin
  if TIntX.CompareRecords(value, Default (TIntX)) then
    raise EArgumentException.Create('value');

  if TIntX.CompareRecords(exponent, Default (TIntX)) then
    raise EArgumentException.Create('exponent');

  if TIntX.CompareRecords(modulus, Default (TIntX)) then
    raise EArgumentException.Create('modulus');

  if modulus <= 0 then
    raise EArgumentException.Create(Strings.ModPowModulusCantbeZeroorNegative);

  if (exponent._negative) then
    raise EArgumentException.Create(Strings.ModPowExponentCantbeNegative);

  result := TOpHelper.ModPow(value, exponent, modulus);
end;


// https://en.wikipedia.org/wiki/Bézout's_identity
// https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Pseudocode
// Calculate Bézoutsidentity for two IntX Digits using Euclids Extended Algorithm

class function TIntX.Bézoutsidentity(int1: TIntX; int2: TIntX;
  out bezOne: TIntX; out bezTwo: TIntX): TIntX;
begin
  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentException.Create('int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then
    raise EArgumentException.Create('int2');

  result := TOpHelper.Bézoutsidentity(int1, int2, bezOne, bezTwo);
end;

/// <summary>
/// Checks if an <see cref="TIntX" /> object is Probably Prime using Miller–Rabin primality test.
/// https://en.wikipedia.org/wiki/Miller–Rabin_primality_test
/// https://github.com/cslarsen/miller-rabin
/// </summary>
/// <param name="value">big integer to check primality.</param>
/// <param name="Accuracy">Accuracy parameter `k´ of the Miller-Rabin algorithm. Default is 5. The execution time is proportional to the value of the accuracy parameter.</param>
/// <returns>Boolean value.</returns>

class function TIntX.isProbablyPrime(value: TIntX;
  Accuracy: Integer = 5): Boolean;
begin
  if TIntX.CompareRecords(value, Default (TIntX)) then
    raise EArgumentException.Create('value');
  result := TOpHelper.isProbablyPrime(value, Accuracy);
end;

// get Maximum value between two TIntX values
class function TIntX.Max(left: TIntX; right: TIntX): TIntX;
begin
  if TIntX.CompareRecords(left, Default (TIntX)) then
    raise EArgumentException.Create('left');

  if TIntX.CompareRecords(right, Default (TIntX)) then
    raise EArgumentException.Create('right');

  result := TOpHelper.Max(left, right);
end;

// get Minimum value between two TIntX values
class function TIntX.Min(left: TIntX; right: TIntX): TIntX;
begin
  if TIntX.CompareRecords(left, Default (TIntX)) then
    raise EArgumentException.Create('left');

  if TIntX.CompareRecords(right, Default (TIntX)) then
    raise EArgumentException.Create('right');

  result := TOpHelper.Min(left, right);
end;

/// <summary>
/// Returns a specified big integer raised to the specified power.
/// </summary>
/// <param name="value">Number to raise.</param>
/// <param name="power">Power.</param>
/// <returns>Number in given power.</returns>

class function TIntX.Pow(value: TIntX; power: UInt32): TIntX;
begin
  result := TOpHelper.Pow(value, power, GlobalSettings.multiplyMode);
end;

/// <summary>
/// Returns a specified big integer raised to the specified power.
/// </summary>
/// <param name="value">Number to raise.</param>
/// <param name="power">Power.</param>
/// <param name="multiplyMode">Multiply mode set explicitly.</param>
/// <returns>Number in given power.</returns>

class function TIntX.Pow(value: TIntX; power: UInt32;
  multiplyMode: TMultiplyMode): TIntX;
begin
  result := TOpHelper.Pow(value, power, multiplyMode);
end;

/// <summary>
/// Returns decimal string representation of this <see cref="TIntX" /> object.
/// </summary>
/// <returns>Decimal number in string.</returns>

function TIntX.ToString(): String;
begin
  result := ToString(UInt32(10), True);
end;

/// <summary>
/// Returns string representation of this <see cref="TIntX" /> object in given base.
/// </summary>
/// <param name="numberBase">Base of system in which to do output.</param>
/// <returns>Object string representation.</returns>

function TIntX.ToString(numberBase: UInt32): String;
begin
  result := ToString(numberBase, True);
end;

/// <summary>
/// Returns string representation of this <see cref="TIntX" /> object in given base.
/// </summary>
/// <param name="numberBase">Base of system in which to do output.</param>
/// <param name="upperCase">Use uppercase for bases from 11 to 16 (which use letters A-F).</param>
/// <returns>Object string representation.</returns>

function TIntX.ToString(numberBase: UInt32; UpperCase: Boolean): String;
var
  tempCharArray: TCharArray;
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

/// <summary>
/// Returns string representation of this <see cref="TIntX" /> object in given base using custom alphabet.
/// </summary>
/// <param name="numberBase">Base of system in which to do output.</param>
/// <param name="alphabet">Alphabet which contains chars used to represent big integer, char position is coresponding digit value.</param>
/// <returns>Object string representation.</returns>

function TIntX.ToString(numberBase: UInt32; alphabet: String): String;
begin
  TStrRepHelper.AssertAlphabet(alphabet, numberBase);

  result := TStringConvertManager.GetStringConverter(Settings.ToStringMode)
    .ToString(Self, numberBase, TStrRepHelper.ToCharArray(alphabet));
end;

/// <summary>
/// Parses provided string representation of <see cref="TIntX" /> object in decimal base.
/// If number starts from "0" then it's treated as octal; if number starts from "$"
/// then it's treated as hexadecimal.
/// </summary>
/// <param name="value">Number as string.</param>
/// <returns>Parsed object.</returns>

class function TIntX.Parse(value: String): TIntX;
begin
  result := TParseManager.GetCurrentParser().Parse(value, UInt32(10),
    TConstants.FBaseCharToDigits, True);
end;

/// <summary>
/// Parses provided string representation of <see cref="TIntX" /> object.
/// </summary>
/// <param name="value">Number as string.</param>
/// <param name="numberBase">Number base.</param>
/// <returns>Parsed object.</returns>

class function TIntX.Parse(value: String; numberBase: UInt32): TIntX;
begin
  result := TParseManager.GetCurrentParser().Parse(value, numberBase,
    TConstants.FBaseCharToDigits, False);
end;

/// <summary>
/// Parses provided string representation of <see cref="TIntX" /> object using custom alphabet.
/// </summary>
/// <param name="value">Number as string.</param>
/// <param name="numberBase">Number base.</param>
/// <param name="alphabet">Alphabet which contains chars used to represent big integer, char position is coresponding digit value.</param>
/// <returns>Parsed object.</returns>

class function TIntX.Parse(value: String; numberBase: UInt32;
  alphabet: String): TIntX;
var
  FcharDigits: TDictionary<Char, UInt32>;
begin
  FcharDigits := TDictionary<Char, UInt32>.Create(Integer(numberBase));
  try
    result := TParseManager.GetCurrentParser().Parse(value, numberBase,
      TStrRepHelper.CharDictionaryFromAlphabet(alphabet, numberBase,
      FcharDigits), False);
  finally
    FcharDigits.Free;
  end;

end;

/// <summary>
/// Parses provided string representation of <see cref="TIntX" /> object in decimal base.
/// If number starts from "0" then it's treated as octal; if number starts from "$"
/// then it's treated as hexadecimal.
/// </summary>
/// <param name="value">Number as string.</param>
/// <param name="mode">Parse mode.</param>
/// <returns>Parsed object.</returns>

class function TIntX.Parse(value: String; mode: TParseMode): TIntX;
begin
  result := TParseManager.GetParser(mode).Parse(value, UInt32(10),
    TConstants.FBaseCharToDigits, True);
end;

/// <summary>
/// Parses provided string representation of <see cref="TIntX" /> object.
/// </summary>
/// <param name="value">Number as string.</param>
/// <param name="numberBase">Number base.</param>
/// <param name="mode">Parse mode.</param>
/// <returns>Parsed object.</returns>

class function TIntX.Parse(value: String; numberBase: UInt32;
  mode: TParseMode): TIntX;
begin
  result := TParseManager.GetParser(mode).Parse(value, numberBase,
    TConstants.FBaseCharToDigits, False);
end;

/// <summary>
/// Parses provided string representation of <see cref="TIntX" /> object using custom alphabet.
/// </summary>
/// <param name="value">Number as string.</param>
/// <param name="numberBase">Number base.</param>
/// <param name="alphabet">Alphabet which contains chars used to represent big integer, char position is coresponding digit value.</param>
/// <param name="mode">Parse mode.</param>
/// <returns>Parsed object.</returns>

class function TIntX.Parse(value: String; numberBase: UInt32; alphabet: String;
  mode: TParseMode): TIntX;
var
  FcharDigits: TDictionary<Char, UInt32>;
begin
  FcharDigits := TDictionary<Char, UInt32>.Create(Integer(numberBase));
  try
    result := TParseManager.GetParser(mode).Parse(value, numberBase,
      TStrRepHelper.CharDictionaryFromAlphabet(alphabet, numberBase,
      FcharDigits), False);
  finally
    FcharDigits.Free;
  end;

end;

/// <summary>
/// Returns equality of this <see cref="TIntX" /> with another big integer.
/// </summary>
/// <param name="n">Big integer to compare with.</param>
/// <returns>True if equals.</returns>
function TIntX.Equals(n: TIntX): Boolean;
begin
  result := Self = n;
end;

/// <summary>
/// Returns equality of this <see cref="TIntX" /> with another integer.
/// </summary>
/// <param name="n">Integer to compare with.</param>
/// <returns>True if equals.</returns>
function TIntX.Equals(n: Integer): Boolean;
begin
  result := Self = n;
end;

/// <summary>
/// Returns equality of this <see cref="TIntX" /> with another unsigned integer.
/// </summary>
/// <param name="n">Unsigned integer to compare with.</param>
/// <returns>True if equals.</returns>
function TIntX.Equals(n: UInt32): Boolean;
begin
  result := Self = n;
end;

/// <summary>
/// Returns equality of this <see cref="TIntX" /> with another Int64.
/// </summary>
/// <param name="n">Int64 to compare with.</param>
/// <returns>True if equals.</returns>
function TIntX.Equals(n: Int64): Boolean;
begin
  result := Self = n;
end;

/// <summary>
/// Returns equality of this <see cref="TIntX" /> with another unsigned Int64.
/// </summary>
/// <param name="n">unsigned Int64 to compare with.</param>
/// <returns>True if equals.</returns>
function TIntX.Equals(n: UInt64): Boolean;
begin
  result := Self = n;
end;

/// <summary>
/// Compares current object with another big integer.
/// </summary>
/// <param name="n">Big integer to compare with.</param>
/// <returns>1 if object is bigger than <paramref name="n" />, -1 if object is smaller than <paramref name="n" />, 0 if they are equal.</returns>
function TIntX.CompareTo(n: TIntX): Integer;
begin
  result := TOpHelper.Cmp(Self, n, True);
end;

/// <summary>
/// Compares current object with another integer.
/// </summary>
/// <param name="n">Integer to compare with.</param>
/// <returns>1 if object is bigger than <paramref name="n" />, -1 if object is smaller than <paramref name="n" />, 0 if they are equal.</returns>
function TIntX.CompareTo(n: Integer): Integer;
begin
  result := TOpHelper.Cmp(Self, n);
end;

/// <summary>
/// Compares current object with another unsigned integer.
/// </summary>
/// <param name="n">Unsigned integer to compare with.</param>
/// <returns>1 if object is bigger than <paramref name="n" />, -1 if object is smaller than <paramref name="n" />, 0 if they are equal.</returns>
function TIntX.CompareTo(n: UInt32): Integer;
begin
  result := TOpHelper.Cmp(Self, n);
end;

/// <summary>
/// Compares current object with another Int64.
/// </summary>
/// <param name="n">Int64 to compare with.</param>
/// <returns>1 if object is bigger than <paramref name="n" />, -1 if object is smaller than <paramref name="n" />, 0 if they are equal.</returns>
function TIntX.CompareTo(n: Int64): Integer;
begin
  result := TOpHelper.Cmp(Self, n, True);
end;

/// <summary>
/// Compares current object with another UInt64.
/// </summary>
/// <param name="n">UInt64 to compare with.</param>
/// <returns>1 if object is bigger than <paramref name="n" />, -1 if object is smaller than <paramref name="n" />, 0 if they are equal.</returns>
function TIntX.CompareTo(n: UInt64): Integer;
begin
  result := TOpHelper.Cmp(Self, n, True);
end;

/// <summary>
/// Frees extra space not used by digits.
/// </summary>

procedure TIntX.Normalize();
var
  newDigits: TMyUint32Array;
begin
  if (UInt32(Length(_digits)) > _length) then
  begin
    SetLength(newDigits, _length);
    Move(_digits[0], newDigits[0], _length * SizeOf(UInt32));
    _digits := newDigits;
  end;

  if (_length = 0) then
  begin
    _negative := False;
  end;
end;

/// <summary>
/// Retrieves this <see cref="TIntX" /> internal state as digits array and sign.
/// Can be used for serialization and other purposes.
/// Note: please use constructor instead to clone <see cref="TIntX" /> object.
/// </summary>
/// <param name="digits">Digits array.</param>
/// <param name="negative">Is negative integer.</param>
/// <param name="zeroinithelper">Is zeroinit state.</param>

procedure TIntX.GetInternalState(out digits: TMyUint32Array;
  out negative: Boolean; out zeroinithelper: Boolean);

begin
  SetLength(digits, _length);
  Move(_digits[0], digits[0], _length * SizeOf(UInt32));
  negative := _negative;
  zeroinithelper := _zeroinithelper;
end;

/// <summary>
/// Initializes record instance from zero.
/// For internal use.
/// </summary>

procedure TIntX.InitFromZero();
begin
  _length := 0;
  SetLength(_digits, 0);
  _zeroinithelper := True;
  _negative := False;
end;

/// <summary>
/// Initializes record instance from <see cref="UInt64" /> value.
/// Doesn't initialize sign.
/// For internal use.
/// </summary>
/// <param name="value">Unsigned Int64 value.</param>

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

/// <summary>
/// Initializes record instance from another <see cref="TIntX" /> value.
/// For internal use.
/// </summary>
/// <param name="value">Big integer value.</param>

procedure TIntX.InitFromIntX(value: TIntX);
begin
  _digits := value._digits;
  _length := value._length;
  _negative := value._negative;
  _zeroinithelper := value._zeroinithelper;
end;

/// <summary>
/// Initializes record instance from TIntX to get absolute value.
/// For internal use.
/// </summary>
/// <param name="value">Big integer digits.</param>

procedure TIntX.InitFromIntXAbs(value: TIntX);
begin
  _digits := value._digits;
  _length := value._length;
  _negative := False;
  _zeroinithelper := value._zeroinithelper;
end;

/// <summary>
/// Initializes record instance from digits array.
/// For internal use.
/// </summary>
/// <param name="digits">Big integer digits.</param>
/// <param name="negative">Big integer sign.</param>
/// <param name="mlength">Big integer length.</param>

procedure TIntX.InitFromDigits(digits: TMyUint32Array; negative: Boolean;
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

/// <summary>
/// Frees extra space not used by digits only if auto-normalize is set for the instance.
/// </summary>

procedure TIntX.TryNormalize();
begin
  if (Settings.AutoNormalize) then
  begin
    Normalize();
  end;
end;

/// <summary>
/// Compare two records to check if they are same.
/// </summary>
/// <returns>Boolean value.</returns>

class function TIntX.CompareRecords(Rec1: TIntX; Rec2: TIntX): Boolean;
begin

  result := (CompareMem(@Rec1._digits, @Rec2._digits, Length(Rec1._digits) *
    SizeOf(UInt32)) and (Rec1._length = Rec2._length) and
    (Rec1._negative = Rec2._negative) and
    (Rec1._zeroinithelper = Rec2._zeroinithelper));
end;

end.
