unit uAutoFhtMultiplier;

{$I ..\Include\IntXLib.inc}

interface

uses
  Math,
  SysUtils,
  uMultiplierBase,
  uDigitOpHelper,
  uIMultiplier,
  uFhtHelper,
  uConstants,
  uStrings,
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Multiplies using FHT.
  /// </summary>

  TAutoFhtMultiplier = class sealed(TMultiplierBase)

  private
    /// <summary>
    /// IIMultiplier Instance.
    /// </summary>
    F_classicMultiplier: IIMultiplier;

  public
    /// <summary>
    /// Creates new <see cref="TAutoFhtMultiplier" /> instance.
    /// </summary>
    /// <param name="classicMultiplier">Multiplier to use if FHT is unapplicatible.</param>

    constructor Create(classicMultiplier: IIMultiplier);

    /// <summary>
    /// Destructor.
    /// </summary>

    destructor Destroy(); override;

    /// <summary>
    /// Multiplies two big integers using pointers.
    /// </summary>
    /// <param name="digitsPtr1">First big integer digits.</param>
    /// <param name="length1">First big integer length.</param>
    /// <param name="digitsPtr2">Second big integer digits.</param>
    /// <param name="length2">Second big integer length.</param>
    /// <param name="digitsResPtr">Resulting big integer digits.</param>
    /// <returns>Resulting big integer real length.</returns>

    function Multiply(digitsPtr1: PCardinal; length1: UInt32;
      digitsPtr2: PCardinal; length2: UInt32; digitsResPtr: PCardinal)
      : UInt32; override;

  end;

implementation

constructor TAutoFhtMultiplier.Create(classicMultiplier: IIMultiplier);

begin
  inherited Create;
  F_classicMultiplier := classicMultiplier;
end;

destructor TAutoFhtMultiplier.Destroy();
begin
  F_classicMultiplier := Nil;
  inherited Destroy;
end;

function TAutoFhtMultiplier.Multiply(digitsPtr1: PCardinal; length1: UInt32;
  digitsPtr2: PCardinal; length2: UInt32; digitsResPtr: PCardinal): UInt32;
var
  newLength, lowerDigitCount: UInt32;
  data1, data2: TIntXLibDoubleArray;
  slice1: PDouble;
  validationResult: TIntXLibUInt32Array;
  validationResultPtr: PCardinal;

begin
  // Check length - maybe use classic multiplier instead
  if ((length1 < TConstants.AutoFhtLengthLowerBound) or
    (length2 < TConstants.AutoFhtLengthLowerBound) or
    (length1 > TConstants.AutoFhtLengthUpperBound) or
    (length2 > TConstants.AutoFhtLengthUpperBound)) then
  begin
    result := F_classicMultiplier.Multiply(digitsPtr1, length1, digitsPtr2,
      length2, digitsResPtr);
    Exit;
  end;

  newLength := length1 + length2;

  // Do FHT for first big integer
  data1 := TFhtHelper.ConvertDigitsToDouble(digitsPtr1, length1, newLength);
  TFhtHelper.Fht(data1, UInt32(Length(data1)));

  // Compare digits

  if ((digitsPtr1 = digitsPtr2) or (TDigitOpHelper.Cmp(digitsPtr1, length1,
    digitsPtr2, length2) = 0)) then
  begin
    // Use the same FHT for equal big integers
    data2 := data1;

  end
  else
  begin
    // Do FHT over second digits
    data2 := TFhtHelper.ConvertDigitsToDouble(digitsPtr2, length2, newLength);
    TFhtHelper.Fht(data2, UInt32(Length(data2)));
  end;

  // Perform multiplication and reverse FHT
  TFhtHelper.MultiplyFhtResults(data1, data2, UInt32(Length(data1)));
  TFhtHelper.ReverseFht(data1, UInt32(Length(data1)));

  // Convert to digits
  slice1 := @data1[0];

  TFhtHelper.ConvertDoubleToDigits(slice1, UInt32(Length(data1)), newLength,
    digitsResPtr);

  // Maybe check for validity using classic multiplication
  if (TIntX.GlobalSettings.ApplyFhtValidityCheck) then
  begin
    lowerDigitCount :=
      Min(length2, Min(length1, TConstants.FhtValidityCheckDigitCount));

    // Validate result by multiplying lowerDigitCount digits using classic algorithm and comparing
    SetLength(validationResult, lowerDigitCount * 2);
    validationResultPtr := @validationResult[0];

    F_classicMultiplier.Multiply(digitsPtr1, lowerDigitCount, digitsPtr2,
      lowerDigitCount, validationResultPtr);
    if (TDigitOpHelper.Cmp(validationResultPtr, lowerDigitCount, digitsResPtr,
      lowerDigitCount) <> 0) then
    begin

      raise EFhtMultiplicationException.Create
        (Format(uStrings.FhtMultiplicationError, [length1, length2],
        TIntX._FS));
    end;

  end;

  if digitsResPtr[newLength - 1] = 0 then
  begin

    Dec(newLength);
    result := newLength;
  end
  else
    result := newLength;

end;

end.
