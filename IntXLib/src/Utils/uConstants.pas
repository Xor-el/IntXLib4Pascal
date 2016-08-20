unit uConstants;

{$I ..\Include\IntXLib.inc}

interface

uses
{$IFDEF DELPHI}
  Generics.Defaults,
  Generics.Collections,
{$ENDIF DELPHI}
  uStrRepHelper,
  uIntXLibTypes;

type
  /// <summary>
  /// Constants used in <see cref="TIntX" /> and helping classes.
  /// </summary>

  TConstants = class sealed(TObject)

  public

  class var

    /// <summary>
    /// Standard char->digit dictionary.
    /// </summary>
    FBaseCharToDigits: TDictionary<Char, UInt32>;

    /// <summary>
    /// Chars used to parse/output big integers (uppercase).
    /// </summary>
    FBaseUpperChars: TIntXLibCharArray;

    /// <summary>
    /// Chars used to parse/output big integers (lowercase).
    /// </summary>
    FBaseLowerChars: TIntXLibCharArray;

  const
    /// <summary>
    /// Digit opening bracket (used for bases bigger than 16).
    /// </summary>
    DigitOpeningBracket = Char('{');

    /// <summary>
    /// Digit closing bracket (used for bases bigger than 16).
    /// </summary>
    DigitClosingBracket = Char('}');

    /// <summary>
    /// Minus char (-).
    /// </summary>
    DigitsMinusChar = Char('-');

    /// <summary>
    /// Natural logarithm of digits base (log(2^32)).
    /// </summary>
    DigitBaseLog: Double = 22.180709777918249;

    /// <summary>
    /// Count of bits in one <see cref="TIntX" /> digit.
    /// </summary>
    DigitBitCount = Integer(32);

    /// <summary>
    /// <see cref="TIntX" /> length from which FHT is used (in auto-FHT mode).
    /// Before this length usual multiply algorithm works faster.
    /// </summary>
    AutoFhtLengthLowerBound = UInt32(UInt32(1) shl 9);

    /// <summary>
    /// <see cref="TIntX" /> length 'till which FHT is used (in auto-FHT mode).
    /// After this length using of FHT may be unsafe due to big precision errors.
    /// </summary>
    AutoFhtLengthUpperBound = UInt32(UInt32(1) shl 26);

    /// <summary>
    /// Number of lower digits used to check FHT multiplication result validity.
    /// </summary>
    FhtValidityCheckDigitCount = UInt32(10);

    /// <summary>
    /// <see cref="TIntX" /> length from which Newton approach is used (in auto-Newton mode).
    /// Before this length usual divide algorithm works faster.
    /// </summary>
    AutoNewtonLengthLowerBound = UInt32(UInt32(1) shl 13);

    /// <summary>
    /// <see cref="TIntX" /> length 'till which Newton approach is used (in auto-Newton mode).
    /// After this length using of fast division may be slow.
    /// </summary>
    AutoNewtonLengthUpperBound = UInt32(UInt32(1) shl 26);

    /// <summary>
    /// <see cref="TIntX" /> length from which fast parsing is used (in Fast parsing mode).
    /// Before this length usual parsing algorithm works faster.
    /// </summary>
    FastParseLengthLowerBound = UInt32(32);

    /// <summary>
    /// <see cref="TIntX" /> length from which fast conversion is used (in Fast convert mode).
    /// Before this length usual conversion algorithm works faster.
    /// </summary>
    FastConvertLengthLowerBound = UInt32(16);

    /// <summary>
    /// Maximum count of bits which can fit in <see cref="TIntX" />.
    /// </summary>
    MaxBitCount = UInt64(4294967295 * UInt64(32));

    /// <summary>
    /// 2 ^ <see cref="DigitBitCount"/>.
    /// </summary>
    BitCountStepOf2 = UInt64(UInt64(1) shl 32);

    /// <summary>
    /// Euler's Number.
    /// </summary>

    EulersNumber: Double = 2.7182818284590451;
    /// <summary>
    /// Min Integer value.
    /// </summary>
    MinIntValue = Integer(-2147483648);
    /// <summary>
    /// Max Integer value.
    /// </summary>
    MaxIntValue = Integer(2147483647);
    /// <summary>
    /// Min Int64 value.
    /// </summary>
    MinInt64Value = Int64(-9223372036854775808);
    /// <summary>
    /// Max Int64 value.
    /// </summary>
    MaxInt64Value = Int64(9223372036854775807);
    /// <summary>
    /// Max UInt32 value.
    /// </summary>
    MaxUInt32Value = UInt32(4294967295);
    /// <summary>
    /// Max UInt64 value.
    /// </summary>
    MaxUInt64Value = UInt64(18446744073709551615);
    /// <summary>
    /// PI (π).
    /// </summary>
    PI: Double = 3.1415926535897931;
    /// <summary>
    /// class constructor.
    /// </summary>
    class constructor Create();
    /// <summary>
    /// class destructor.
    /// </summary>
    class destructor Destroy;

  end;

implementation

// static class constructor
class constructor TConstants.Create();
var
  i: Integer;
  MyString: String;

begin

  FBaseUpperChars := TIntXLibCharArray.Create('0', '1', '2', '3', '4', '5', '6',
    '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');

  FBaseLowerChars := TIntXLibCharArray.Create('0', '1', '2', '3', '4', '5', '6',
    '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');

  SetString(MyString, PChar(@FBaseUpperChars[0]), Length(FBaseUpperChars));

  FBaseCharToDigits := TStrRepHelper.CharDictionaryFromAlphabet(MyString,
    UInt32(16));
  i := 10;
  while i < (Length(FBaseLowerChars)) do

  begin
    FBaseCharToDigits.Add(FBaseLowerChars[i], UInt32(i));
    Inc(i);
  end;
end;

// static class destructor
class destructor TConstants.Destroy;
begin
  FBaseCharToDigits.Free;
end;

end.
