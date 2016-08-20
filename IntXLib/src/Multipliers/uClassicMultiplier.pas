unit uClassicMultiplier;

{$I ..\Include\IntXLib.inc}

interface

uses
  uMultiplierBase,
  uDigitHelper;

type
  /// <summary>
  /// Multiplies using "classic" algorithm.
  /// </summary>

  TClassicMultiplier = class sealed(TMultiplierBase)

  public

    /// <summary>
    /// Multiplies two big integers using pointers.
    /// </summary>
    /// <param name="digitsPtr1">First big integer digits.</param>
    /// <param name="length1">First big integer length.</param>
    /// <param name="digitsPtr2">Second big integer digits.</param>
    /// <param name="length2">Second big integer length.</param>
    /// <param name="digitsResPtr">Resulting big integer digits.</param>
    /// <returns>Resulting big integer length.</returns>

    function Multiply(digitsPtr1: PCardinal; length1: UInt32;
      digitsPtr2: PCardinal; length2: UInt32; digitsResPtr: PCardinal)
      : UInt32; override;

  end;

implementation

function TClassicMultiplier.Multiply(digitsPtr1: PCardinal; length1: UInt32;
  digitsPtr2: PCardinal; length2: UInt32; digitsResPtr: PCardinal): UInt32;
var
  c: UInt64;
  lengthTemp, newLength: UInt32;
  ptrTemp, digitsPtr1End, digitsPtr2End, ptr1, ptrRes: PCardinal;

begin

  // External cycle must be always smaller
  if (length1 < length2) then
  begin
    // First must be bigger - swap
    lengthTemp := length1;
    length1 := length2;
    length2 := lengthTemp;

    ptrTemp := digitsPtr1;
    digitsPtr1 := digitsPtr2;
    digitsPtr2 := ptrTemp;
  end;

  // Prepare end pointers
  digitsPtr1End := digitsPtr1 + length1;
  digitsPtr2End := digitsPtr2 + length2;

  // We must always clear first "length1" digits in result
  TDigitHelper.SetBlockDigits(digitsResPtr, length1, UInt32(0));

  // Perform digits multiplication

  ptrRes := Nil;

  while digitsPtr2 < (digitsPtr2End) do

  begin

    // Check for zero (sometimes may help). There is no sense to make this check in internal cycle -
    // it would give performance gain only here
    if (digitsPtr2^ = 0) then
    begin
      Inc(digitsPtr2);
      Inc(digitsResPtr);
      continue;
    end;

    c := 0;
    ptr1 := digitsPtr1;
    ptrRes := digitsResPtr;

    while (ptr1) < (digitsPtr1End) do

    begin

      c := c + UInt64(digitsPtr2^) * ptr1^ + ptrRes^;

      (ptrRes)^ := UInt32(c);
      c := c shr 32;
      Inc(ptr1);
      Inc(ptrRes);
    end;

    (ptrRes)^ := UInt32(c);

    Inc(digitsPtr2);
    Inc(digitsResPtr);
  end;

  newLength := length1 + length2;

  if ((newLength > 0) and ((ptrRes = Nil) or (ptrRes^ = 0))) then

  begin
    Dec(newLength);
  end;

  result := newLength;

end;

end.
