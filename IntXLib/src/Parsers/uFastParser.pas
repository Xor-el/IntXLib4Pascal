unit uFastParser;

{$I ..\Include\IntXLib.inc}

interface

uses
{$IFDEF DELPHI}
  Generics.Collections,
{$ENDIF DELPHI}
  uParserBase,
  uDigitOpHelper,
  uIMultiplier,
  uMultiplyManager,
  uIParser,
  uConstants,
  uXBits,
  uStrRepHelper,
  uDigitHelper,
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Fast parsing algorithm using divide-by-two (O[n*{log n}^2]).
  /// </summary>

  TFastParser = class sealed(TParserBase)

  private
    /// <summary>
    /// Classic Parser Instance
    /// </summary>
    F_classicParser: IIParser;

  public

    /// <summary>
    /// Creates new <see cref="FastParser" /> instance.
    /// </summary>
    /// <param name="pow2Parser">Parser for pow2 case.</param>
    /// <param name="classicParser">Classic parser.</param>

    constructor Create(pow2Parser: IIParser; classicParser: IIParser);

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="startIndex">Index inside string from which to start.</param>
    /// <param name="endIndex">Index inside string on which to end.</param>
    /// <param name="numberBase">Number base.</param>
    /// <param name="charToDigits">Char->digit dictionary.</param>
    /// <param name="digitsRes">Resulting digits.</param>
    /// <returns>Parsed integer length.</returns>

    function Parse(const value: String; startIndex: Integer; endIndex: Integer;
      numberBase: UInt32; charToDigits: TDictionary<Char, UInt32>;
      digitsRes: TIntXLibUInt32Array): UInt32; override;

  end;

implementation

constructor TFastParser.Create(pow2Parser: IIParser; classicParser: IIParser);
begin
  Inherited Create(pow2Parser);
  F_classicParser := classicParser;

end;

function TFastParser.Parse(const value: String; startIndex: Integer;
  endIndex: Integer; numberBase: UInt32;
  charToDigits: TDictionary<Char, UInt32>;
  digitsRes: TIntXLibUInt32Array): UInt32;
var
  newLength, initialLength, valueLength, digitsLength, loLength, hiLength,
    innerStep, outerStep, realLength: UInt32;
  valueDigits, valueDigits2, tempDigits: TIntXLibUInt32Array;
  valueDigitsStartPtr, valueDigitsStartPtr2, valueDigitsPtr, valueDigitsPtr2,
    tempPtr, ptr1, ptr2, valueDigitsPtrEnd, baseDigitsPtr: PCardinal;
  valueStartPtr, valuePtr, valueEndPtr: PChar;
  multiplier: IIMultiplier;
  baseInt: TIntX;

begin
  newLength := Inherited Parse(value, startIndex, endIndex, numberBase,
    charToDigits, digitsRes);

  // Maybe base method already parsed this number
  if (newLength <> 0) then
  begin
    result := newLength;
    Exit;
  end;

  // Check length - maybe use classic parser instead
  initialLength := UInt32(Length(digitsRes));
  if (initialLength < TConstants.FastParseLengthLowerBound) then
  begin
    result := F_classicParser.Parse(value, startIndex, endIndex, numberBase,
      charToDigits, digitsRes);
    Exit;
  end;

  valueLength := UInt32(endIndex - startIndex + 1);
  digitsLength := UInt32(1) shl TBits.CeilLog2(valueLength);

  // Prepare array for digits in other base
  SetLength(valueDigits, digitsLength);

  // This second array will store integer lengths initially
  SetLength(valueDigits2, digitsLength);

  valueDigitsStartPtr := @valueDigits[0];
  valueDigitsStartPtr2 := @valueDigits2[0];

  // In the string first digit means last in digits array
  valueDigitsPtr := valueDigitsStartPtr + valueLength - 1;
  valueDigitsPtr2 := valueDigitsStartPtr2 + valueLength - 1;

  // Reverse copy characters into digits
  valueStartPtr := PChar(value);
  // for Zero-Based Strings Language, Remove the '-1' .
  valuePtr := valueStartPtr + startIndex - 1;
  valueEndPtr := valuePtr + valueLength - 1;

  // for Zero-Based Strings Language, Remove the '=' .
  while valuePtr <= (valueEndPtr) do
  begin

    // Get digit itself - this call will throw an exception if char is invalid

    valueDigitsPtr^ := TStrRepHelper.GetDigit(charToDigits, valuePtr^,
      numberBase);

    // Set length of this digit (zero for zero)
    if valueDigitsPtr^ = UInt32(0) then
      valueDigitsPtr2^ := UInt32(0)
    else
    begin
      valueDigitsPtr2^ := UInt32(1);
    end;

    Inc(valuePtr);
    Dec(valueDigitsPtr);
    Dec(valueDigitsPtr2);

  end;

  // lengths array needs to be cleared before using

  TDigitHelper.SetBlockDigits(valueDigitsStartPtr2 + valueLength,
    digitsLength - valueLength, 0);

  // Now start from the digit arrays beginning
  valueDigitsPtr := valueDigitsStartPtr;

  valueDigitsPtr2 := valueDigitsStartPtr2;

  // Current multiplier (classic or fast) will be used
  multiplier := TMultiplyManager.GetCurrentMultiplier();

  // Here base in needed power will be stored
  baseInt := Default (TIntX);
  innerStep := 1;
  outerStep := 2;
  while innerStep < (digitsLength) do
  begin

    if baseInt = Default (TIntX) then
    begin
      baseInt := numberBase
    end
    else
    begin
      baseInt := baseInt * baseInt;
    end;
    baseDigitsPtr := @baseInt._digits[0];

    // Start from arrays beginning
    ptr1 := valueDigitsPtr;

    ptr2 := valueDigitsPtr2;

    // vauleDigits array end
    valueDigitsPtrEnd := valueDigitsPtr + digitsLength;

    // Cycle through all digits and their lengths
    while ptr1 < (valueDigitsPtrEnd) do
    begin
      // Get lengths of "lower" and "higher" value parts

      loLength := ptr2^;
      hiLength := (ptr2 + innerStep)^;

      if (hiLength <> 0) then
      begin
        // We always must clear an array before multiply
        TDigitHelper.SetBlockDigits(ptr2, outerStep, UInt32(0));

        // Multiply per baseInt

        hiLength := multiplier.Multiply(baseDigitsPtr, baseInt._length,
          ptr1 + innerStep, hiLength, ptr2);

      end;

      // Sum results
      if ((hiLength <> 0) or (loLength <> 0)) then
      begin
        ptr1^ := TDigitOpHelper.Add(ptr2, hiLength, ptr1, loLength, ptr2);

      end
      else
      begin
        ptr1^ := UInt32(0);
      end;

      ptr1 := ptr1 + outerStep;
      ptr2 := ptr2 + outerStep;

    end;
    // After inner cycle valueDigits will contain lengths and valueDigits2 will contain actual values
    // so we need to swap them here
    tempDigits := valueDigits;
    valueDigits := valueDigits2;
    valueDigits2 := tempDigits;

    tempPtr := valueDigitsPtr;

    valueDigitsPtr := valueDigitsPtr2;
    valueDigitsPtr2 := tempPtr;
    innerStep := innerStep shl 1;
    outerStep := outerStep shl 1;

  end;

  // Determine real length of converted number
  realLength := valueDigits2[0];

  // Copy to result
  Move(valueDigits[0], digitsRes[0], realLength * SizeOf(UInt32));
  result := realLength;
end;

end.
