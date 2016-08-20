unit uStringConverterBase;

{$I ..\Include\IntXLib.inc}

interface

uses
  Math,
  SysUtils,
  uIStringConverter,
  uStrings,
  uConstants,
  uXBits,
  uIntX,
  uIntXLibTypes;

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

    function ToString(IntX: TIntX; numberBase: UInt32;
      alphabet: TIntXLibCharArray): String; reintroduce; overload; virtual;

    /// <summary>
    /// Converts digits from internal representaion into given base.
    /// </summary>
    /// <param name="digits">Big integer digits.</param>
    /// <param name="mlength">Big integer length.</param>
    /// <param name="numberBase">Base to use for output.</param>
    /// <param name="outputLength">Calculated output length (will be corrected inside).</param>
    /// <returns>Conversion result (later will be transformed to string).</returns>

    function ToString(digits: TIntXLibUInt32Array; mlength: UInt32;
      numberBase: UInt32; var outputLength: UInt32): TIntXLibUInt32Array;
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
  alphabet: TIntXLibCharArray): String;

var
  outputLength, i, lengthCoef: UInt32;
  isBigBase: Boolean;
  maxBuilderLength: UInt64;
  outputArray: TIntXLibUInt32Array;
{$IFDEF DELPHI}
  outputBuilder: TStringBuilder;
{$ENDIF DELPHI}
{$IFDEF FPC}
  outputBuilder: String;
  Idx, aCount: UInt32;
{$ENDIF FPC}
begin
  // Test base

  if ((numberBase < 2) or (numberBase > 65536)) then
  begin
    raise EArgumentException.Create(uStrings.ToStringSmallBase + ' numberBase');
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
    raise EArgumentException.Create(uStrings.IntegerTooBig + ' IntX');
  end;

  // Transform digits into another base
  outputArray := ToString(IntX._digits, IntX._length, numberBase, outputLength);

  // Output everything to the string builder or string

{$IFDEF DELPHI}
  outputBuilder := TStringBuilder.Create
    (Integer(outputLength * lengthCoef + 1));
{$ENDIF DELPHI}
{$IFDEF FPC}
  SetLength(outputBuilder, Integer(outputLength * lengthCoef + 1));
  Idx := 1; // Lower Index of Pascal String.
  aCount := 0;
{$ENDIF FPC}
{$IFDEF DELPHI}
  try
{$ENDIF DELPHI}
    // Maybe append minus sign
    if (IntX._negative) then
    begin
{$IFDEF DELPHI}
      outputBuilder.Append(TConstants.DigitsMinusChar);
{$ENDIF DELPHI}
{$IFDEF FPC}
      outputBuilder[Idx] := (TConstants.DigitsMinusChar);
      Inc(Idx);
      Inc(aCount);
{$ENDIF FPC}
    end;
    i := outputLength - 1;
    while i < (outputLength) do
    begin
      if (not isBigBase) then
      begin
        // Output char-by-char for bases up to covered by alphabet
{$IFDEF DELPHI}
        outputBuilder.Append(alphabet[Integer(outputArray[i])]);
{$ENDIF DELPHI}
{$IFDEF FPC}
        outputBuilder[Idx] := alphabet[Integer(outputArray[i])];
        Inc(aCount);
{$ENDIF FPC}
      end
      else
      begin
        // Output digits in brackets for bigger bases

{$IFDEF DELPHI}
        outputBuilder.Append(TConstants.DigitOpeningBracket);
        outputBuilder.Append(UInttoStr(outputArray[i]));
        outputBuilder.Append(TConstants.DigitClosingBracket);
{$ENDIF DELPHI}
{$IFDEF FPC}
        outputBuilder[Idx] := TConstants.DigitOpeningBracket;
        Inc(Idx);
        outputBuilder[Idx] := IntToStr(outputArray[i])[1];
        // [1] means get first char in returned string.
        Inc(Idx);
        outputBuilder[Idx] := TConstants.DigitClosingBracket;
        Inc(aCount, 3);
{$ENDIF FPC}
      end;
      Dec(i);
{$IFDEF FPC}
      Inc(Idx);
{$ENDIF FPC}
    end;

    // Output all digits
{$IFDEF DELPHI}
    result := outputBuilder.ToString();
{$ENDIF DELPHI}
{$IFDEF FPC}
    SetLength(outputBuilder, aCount);
    result := outputBuilder;
{$ENDIF FPC}
{$IFDEF DELPHI}
  finally
    outputBuilder.Free;
  end;
{$ENDIF DELPHI}
end;

function TStringConverterBase.ToString(digits: TIntXLibUInt32Array;
  mlength: UInt32; numberBase: UInt32; var outputLength: UInt32)
  : TIntXLibUInt32Array;
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
