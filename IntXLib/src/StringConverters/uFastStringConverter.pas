unit uFastStringConverter;

{$I ..\Include\IntXLib.inc}

interface

uses
  SysUtils,
{$IFDEF DELPHI}
  Generics.Collections,
{$ENDIF DELPHI}
{$IFDEF FPC}
  gstack,
{$ENDIF FPC}
  uEnums,
  uDigitHelper,
  uStringConverterBase,
  uIMultiplier,
  uIDivider,
  uMultiplyManager,
  uDivideManager,
  uIStringConverter,
  uConstants,
  uXBits,
  uIntX,
  uIntXLibTypes;

type

  /// <summary>
  /// Fast ToString converting algorithm using divide-by-two.
  /// </summary>

  TFastStringConverter = class sealed(TStringConverterBase)

  private
    /// <summary>
    /// Classic Converter Instance.
    /// </summary>
    F_classicStringConverter: IIStringConverter;

  public
    /// <summary>
    /// Creates new <see cref="FastStringConverter" /> instance.
    /// </summary>
    /// <param name="pow2StringConverter">Converter for pow2 case.</param>
    /// <param name="mclassicStringConverter">Classic converter.</param>
    constructor Create(pow2StringConverter: IIStringConverter;
      mclassicStringConverter: IIStringConverter);
    /// <summary>
    /// Destructor.
    /// </summary>
    destructor Destroy(); override;
    /// <summary>
    /// Converts digits from internal representation into given base.
    /// </summary>
    /// <param name="digits">Big integer digits.</param>
    /// <param name="mlength">Big integer length.</param>
    /// <param name="numberBase">Base to use for output.</param>
    /// <param name="outputLength">Calculated output length (will be corrected inside).</param>
    /// <returns>Conversion result (later will be transformed to string).</returns>
    function ToString(digits: TIntXLibUInt32Array; mlength: UInt32;
      numberBase: UInt32; var outputLength: UInt32)
      : TIntXLibUInt32Array; override;

  end;

implementation

constructor TFastStringConverter.Create(pow2StringConverter: IIStringConverter;
  mclassicStringConverter: IIStringConverter);

begin

  inherited Create(pow2StringConverter);
  F_classicStringConverter := mclassicStringConverter;

end;

destructor TFastStringConverter.Destroy();
begin
  F_classicStringConverter := Nil;
  inherited Destroy;
end;

function TFastStringConverter.ToString(digits: TIntXLibUInt32Array;
  mlength: UInt32; numberBase: UInt32; var outputLength: UInt32)
  : TIntXLibUInt32Array;
var
  outputArray, resultArray, resultArray2, tempBuffer,
    tempArray: TIntXLibUInt32Array;
  resultLengthLog2, i: Integer;
  resultLength, loLength, innerStep, outerStep, j: UInt32;
  multiplier: IIMultiplier;
  divider: IIDivider;
  baseIntStack: TStack<TIntX>;
  baseInt: TIntX;
  resultPtr1Const, resultPtr2Const, tempBufferPtr, resultPtr1, resultPtr2,
    tempPtr, ptr1, ptr2, ptr1end, baseIntPtr, outputPtr: PCardinal;

begin
  outputArray := Inherited ToString(digits, mlength, numberBase, outputLength);

  // Maybe base method already converted this number
  if (outputArray <> Nil) then
  begin
    result := outputArray;
    Exit;
  end;

  // Check length - maybe use classic converter instead
  if (mlength < TConstants.FastConvertLengthLowerBound) then
  begin
    result := F_classicStringConverter.ToString(digits, mlength, numberBase,
      outputLength);
    Exit;
  end;

  resultLengthLog2 := TBits.CeilLog2(outputLength);
  resultLength := UInt32(1) shl resultLengthLog2;

  // Create and initially fill array for transformed numbers storing
  SetLength(resultArray, resultLength);
  Move(digits[0], resultArray[0], mlength * SizeOf(UInt32));

  // Create and initially fill array with lengths
  SetLength(resultArray2, resultLength);
  resultArray2[0] := mlength;

  multiplier := TMultiplyManager.GetCurrentMultiplier();
  divider := TDivideManager.GetCurrentDivider();

  // Generate all needed pows of numberBase in stack

  baseIntStack := TStack<TIntX>.Create;
  try

    baseInt := Default (TIntX);
    i := 0;
    while i < (resultLengthLog2) do
    begin

      if TIntX.CompareRecords(baseInt, Default (TIntX)) then
      begin
        baseInt := numberBase;
      end
      else
      begin
        baseInt := multiplier.Multiply(baseInt, baseInt);
      end;
      baseIntStack.Push(baseInt);

      Inc(i);
    end;

    // Create temporary buffer for second digits when doing div operation
    SetLength(tempBuffer, baseInt._length);

    // We will use unsafe code here

    resultPtr1Const := @resultArray[0];
    resultPtr2Const := @resultArray2[0];
    tempBufferPtr := @tempBuffer[0];
    // Results pointers which will be modified (on swap)
    resultPtr1 := resultPtr1Const;
    resultPtr2 := resultPtr2Const;

    // Outer cycle instead of recursion
    innerStep := resultLength shr 1;
    outerStep := resultLength;

    while (innerStep) > 0 do
    begin

      ptr1 := resultPtr1;
      ptr2 := resultPtr2;

      ptr1end := resultPtr1 + resultLength;

      // Get baseInt from stack and fix it too
{$IFDEF DELPHI}
      baseInt := TIntX(baseIntStack.Pop());
{$ENDIF DELPHI}
{$IFDEF FPC}
      baseInt := TIntX(baseIntStack.Top());
      baseIntStack.Pop();

{$ENDIF FPC}
      baseIntPtr := @baseInt._digits[0];
      // Cycle through all digits and their lengths

      while ptr1 < (ptr1end) do

      begin
        // Divide ptr1 (with length in *ptr2) by baseIntPtr here.
        // Results are stored in ptr2 & (ptr2 + innerStep), lengths - in *ptr1 and (*ptr1 + innerStep)

        loLength := ptr2^;

        (ptr1 + innerStep)^ := divider.DivMod(ptr1, ptr2, loLength, baseIntPtr,
          tempBufferPtr, baseInt._length, ptr2 + innerStep,
          TDivModResultFlags(Ord(TDivModResultFlags.dmrfDiv) or
          Ord(TDivModResultFlags.dmrfMod)), -2);

        ptr1^ := loLength;

        ptr1 := ptr1 + outerStep;

        ptr2 := ptr2 + outerStep;

      end;

      // After inner cycle resultArray will contain lengths and resultArray2 will contain actual values
      // so we need to swap them here
      tempArray := resultArray;
      resultArray := resultArray2;
      resultArray2 := tempArray;

      tempPtr := resultPtr1;

      resultPtr1 := resultPtr2;

      resultPtr2 := tempPtr;

      innerStep := innerStep shr 1;
      outerStep := outerStep shr 1;

    end;

    // Retrieve real output length
    outputLength := TDigitHelper.GetRealDigitsLength(resultArray2,
      outputLength);

    // Create output array
    SetLength(outputArray, outputLength);

    // Copy each digit but only if length is not null
    outputPtr := @outputArray[0];
    j := 0;
    while j < (outputLength) do
    begin

      if (resultPtr2[j] <> 0) then
      begin
        outputPtr[j] := resultPtr1[j];
      end;
      Inc(j);
    end;
{$IFDEF DELPHI}
    baseIntStack.Clear;
{$ENDIF DELPHI}
  finally
    baseIntStack.Free;
  end;

  result := outputArray;
end;

end.
