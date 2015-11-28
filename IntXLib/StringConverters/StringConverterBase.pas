unit StringConverterBase;

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
  IStringConverter, SysUtils, Strings, Math, Constants, Bits, Utils,
  IntX;

type
  /// <summary>
  /// Base class for ToString converters.
  /// Contains default implementations of convert operation over <see cref="TIntX" /> instances.
  /// </summary>

  TStringConverterBase = class abstract(TInterfacedObject, IIStringConverter)

  private
    /// <summary>
    /// Converter for Pow2 Case.
    /// </summary>
    F_pow2StringConverter: IIStringConverter;

  public

    /// <summary>
    /// Creates new <see cref="StringConverterBase" /> instance.
    /// </summary>
    /// <param name="pow2StringConverter">Converter for pow2 case.</param>

    constructor Create(pow2StringConverter: IIStringConverter);

    /// <summary>
    /// Destructor.
    /// </summary>

    destructor Destroy(); override;

    /// <summary>
    /// Returns string representation of <see cref="TIntX" /> object in given base.
    /// </summary>
    /// <param name="IntX">Big integer to convert.</param>
    /// <param name="numberBase">Base of system in which to do output.</param>
    /// <param name="alphabet">Alphabet which contains chars used to represent big integer, char position is coresponding digit value.</param>
    /// <returns>Object string representation.</returns>
    /// <exception cref="EArgumentException"><paramref name="numberBase" /> is less then 2 or <paramref name="IntX" /> is too big to fit in string.</exception>

    function ToString(IntX: TIntX; numberBase: UInt32; alphabet: array of Char)
      : String; reintroduce; overload; virtual;

    /// <summary>
    /// Converts digits from internal representaion into given base.
    /// </summary>
    /// <param name="digits">Big integer digits.</param>
    /// <param name="mlength">Big integer length.</param>
    /// <param name="numberBase">Base to use for output.</param>
    /// <param name="outputLength">Calculated output length (will be corrected inside).</param>
    /// <returns>Conversion result (later will be transformed to string).</returns>

    function ToString(digits: TArray<Cardinal>; mlength: UInt32;
      numberBase: UInt32; var outputLength: UInt32): TArray<Cardinal>;
      reintroduce; overload; virtual;

  end;

implementation

constructor TStringConverterBase.Create(pow2StringConverter: IIStringConverter);

begin
  inherited Create;
  F_pow2StringConverter := pow2StringConverter;
end;

destructor TStringConverterBase.Destroy();
begin
  F_pow2StringConverter := Nil;
  inherited Destroy;
end;

function TStringConverterBase.ToString(IntX: TIntX; numberBase: UInt32;
  alphabet: array of Char): String;

var
  outputLength, i, lengthCoef: UInt32;
  isBigBase: Boolean;
  maxBuilderLength: UInt64;
  outputArray: TArray<Cardinal>;
  outputBuilder: TStringBuilder;
begin
  // Test base

  if ((numberBase < 2) or (numberBase > 65536)) then
  begin
    raise EArgumentException.Create(Strings.ToStringSmallBase + ' numberBase');
  end;

  // Special processing for zero values
  if (IntX._length = 0) then
  begin
    result := '0';
    Exit;
  end;

  // Calculate output array length
  outputLength := UInt32(Ceil(TConstants.DigitBaseLog / Ln(numberBase) *
    IntX._length));

  // Define length coefficient for string builder
  isBigBase := numberBase > UInt32(Length(alphabet));
  if isBigBase then
    lengthCoef := UInt32(Ceil(Log10(numberBase))) + UInt32(2)
  else
  begin
    lengthCoef := UInt32(1);
  end;

  // Determine maximal possible length of string
  maxBuilderLength := UInt64(outputLength) * lengthCoef + UInt64(1);
  if (maxBuilderLength > TConstants.MaxIntValue) then
  begin
    // This big integer can't be transformed to string
    raise EArgumentException.Create(Strings.IntegerTooBig + ' IntX');
  end;

  // Transform digits into another base
  outputArray := ToString(IntX._digits, IntX._length, numberBase, outputLength);

  // Output everything to the string builder
  outputBuilder := TStringBuilder.Create
    (Integer(outputLength * lengthCoef + 1));

  try

    // Maybe append minus sign
    if (IntX._negative) then
    begin
      outputBuilder.Append(TConstants.DigitsMinusChar);
    end;
    i := outputLength - 1;
    while i < (outputLength) do
    begin
      if (not isBigBase) then
      begin
        // Output char-by-char for bases up to covered by alphabet
        outputBuilder.Append(alphabet[Integer(outputArray[i])]);
      end
      else
      begin
        // Output digits in brackets for bigger bases
        outputBuilder.Append(TConstants.DigitOpeningBracket);
        outputBuilder.Append(UInttoStr(outputArray[i]));
        outputBuilder.Append(TConstants.DigitClosingBracket);
      end;
      Dec(i);
    end;

    // Output all digits

    result := outputBuilder.ToString();
  finally
    outputBuilder.Free;
  end;
end;

function TStringConverterBase.ToString(digits: TArray<Cardinal>;
  mlength: UInt32; numberBase: UInt32; var outputLength: UInt32)
  : TArray<Cardinal>;
begin
  // Default implementation - always call pow2 converter if numberBase is pow of 2

  if numberBase = UInt32(1) shl TBits.Msb(numberBase) then
  begin
    result := F_pow2StringConverter.ToString(digits, mlength, numberBase,
      outputLength)
  end
  else
  begin
    result := Nil;
  end;

end;

end.
