unit Constants;

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
  StrRepHelper, SysUtils, Math, Generics.Collections;

type
  /// <summary>
  /// Constants used in <see cref="TIntX" /> and helping classes.
  /// </summary>

  TConstants = class

  public

  class var

    /// <summary>
    /// Standard char->digit dictionary.
    /// </summary>
    FBaseCharToDigits: TDictionary<Char, UInt32>;

    /// <summary>
    /// Chars used to parse/output big integers (uppercase).
    /// </summary>
    FBaseUpperChars: TArray<Char>;

    /// <summary>
    /// Chars used to parse/output big integers (lowercase).
    /// </summary>
    FBaseLowerChars: TArray<Char>;

  const
    /// <summary>
    /// Digit opening bracet (used for bases bigger than 16).
    /// </summary>
    DigitOpeningBracet: Char = '{';

    /// <summary>
    /// Digit closing bracet (used for bases bigger than 16).
    /// </summary>
    DigitClosingBracet: Char = '}';

    /// <summary>
    /// Minus char (-).
    /// </summary>
    DigitsMinusChar: Char = '-';

    /// <summary>
    /// Natural logarithm of digits base (log(2^32)).
    /// </summary>
    DigitBaseLog: Double = 22.180709777918249;

    /// <summary>
    /// Count of bits in one <see cref="TIntX" /> digit.
    /// </summary>
    DigitBitCount: Integer = 32;

    /// <summary>
    /// <see cref="TIntX" /> length from which FHT is used (in auto-FHT mode).
    /// Before this length usual multiply algorithm works faster.
    /// </summary>
    AutoFhtLengthLowerBound: UInt32 = UInt32(1) shl 9;

    /// <summary>
    /// <see cref="TIntX" /> length 'till which FHT is used (in auto-FHT mode).
    /// After this length using of FHT may be unsafe due to big precision errors.
    /// </summary>
    AutoFhtLengthUpperBound: UInt32 = UInt32(1) shl 26;

    /// <summary>
    /// Number of lower digits used to check FHT multiplication result validity.
    /// </summary>
    FhtValidityCheckDigitCount: UInt32 = 10;

    /// <summary>
    /// <see cref="TIntX" /> length from which Newton approach is used (in auto-Newton mode).
    /// Before this length usual divide algorithm works faster.
    /// </summary>
    AutoNewtonLengthLowerBound: UInt32 = UInt32(1) shl 13;

    /// <summary>
    /// <see cref="TIntX" /> length 'till which Newton approach is used (in auto-Newton mode).
    /// After this length using of fast division may be slow.
    /// </summary>
    AutoNewtonLengthUpperBound: UInt32 = UInt32(1) shl 26;

    /// <summary>
    /// <see cref="TIntX" /> length from which fast parsing is used (in Fast parsing mode).
    /// Before this length usual parsing algorithm works faster.
    /// </summary>
    FastParseLengthLowerBound: UInt32 = 32;

    /// <summary>
    /// <see cref="TIntX" /> length 'till which fast parsing is used (in Fast parsing mode).
    /// After this length using of parsing will be slow.
    /// </summary>
    FastParseLengthUpperBound: UInt32 = 4294967295;

    /// <summary>
    /// <see cref="TIntX" /> length from which fast conversion is used (in Fast convert mode).
    /// Before this length usual conversion algorithm works faster.
    /// </summary>
    FastConvertLengthLowerBound: UInt32 = 16;

    /// <summary>
    /// <see cref="TIntX" /> length 'till which fast conversion is used (in Fast convert mode).
    /// After this length using of conversion will be slow.
    /// </summary>
    FastConvertLengthUpperBound: UInt32 = 4294967295;

    /// <summary>
    /// Maximum count of bits which can fit in <see cref="TIntX" />.
    /// </summary>
    MaxBitCount: UInt64 = 4294967295 * UInt64(32);

    /// <summary>
    /// 2^<see cref="DigitBitCount"/>.
    /// </summary>
    BitCountStepOf2: UInt64 = UInt64(1) shl 32;

    MinIntValue: Integer = -2147483648;
    MaxIntValue: Integer = 2147483647;
    MinInt64Value: Int64 = -9223372036854775808;
    MaxInt64Value: Int64 = 9223372036854775807;
    MaxUInt32Value: UInt32 = 4294967295;
    PI: Double = 3.1415926535897931;

    class constructor Create();
    class destructor Destroy();

  end;

implementation

// static class constructor
class constructor TConstants.Create();
var
  i: Integer;
  MyString: String;
  FcharDigits: TDictionary<Char, UInt32>;
begin
  FcharDigits := TDictionary<Char, UInt32>.Create(Integer(UInt32(16)));
  FBaseUpperChars := TArray<Char>.Create('0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');

  FBaseLowerChars := TArray<Char>.Create('0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');

  SetString(MyString, PChar(@FBaseUpperChars[0]), Length(FBaseUpperChars));

  FBaseCharToDigits := TStrRepHelper.CharDictionaryFromAlphabet(MyString,
    UInt32(16), FcharDigits);
  i := 10;
  while i < (Length(FBaseLowerChars)) do

  begin
    FBaseCharToDigits.Add(FBaseLowerChars[i], UInt32(i));
    Inc(i);
  end;
end;

class destructor TConstants.Destroy();
begin
  FBaseCharToDigits.Free;
end;

end.
