unit MultiplierBase;

{
  * Copyright (c) 2015 Ugochukwu Mmaduekwe ugo4brain@gmail.com

  *   This Source Code Form is subject to the terms of the Mozilla Public License
  * v. 2.0. If a copy of the MPL was not distributed with this file, You can
  * obtain one at http://mozilla.org/MPL/2.0/.

  *   Neither the name of Ugochukwu Mmaduekwe nor the names of its contributors may
  *  be used to endorse or promote products derived from this software without
  *  specific prior written permission.

}

{$POINTERMATH ON}

interface

uses
  Strings, DTypes, IMultiplier, Utils, IntX;

type
  /// <summary>
  /// Base class for multipliers.
  /// Contains default implementation of multiply operation over <see cref="TIntX" /> instances.
  /// </summary>

  TMultiplierBase = class abstract(TInterfacedObject, IIMultiplier)
  public

    /// <summary>
    /// Multiplies two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Resulting big integer.</returns>
    /// <exception cref="EArgumentNilException"><paramref name="int1" /> or <paramref name="int2" /> is a null reference.</exception>
    /// <exception cref="EArgumentException"><paramref name="int1" /> or <paramref name="int2" /> is too big for multiply operation.</exception>

    function Multiply(int1: TIntX; int2: TIntX): TIntX; overload; virtual;

    /// <summary>
    /// Multiplies two big integers represented by their digits.
    /// </summary>
    /// <param name="digits1">First big integer digits.</param>
    /// <param name="length1">First big integer real length.</param>
    /// <param name="digits2">Second big integer digits.</param>
    /// <param name="length2">Second big integer real length.</param>
    /// <param name="digitsRes">Where to put resulting big integer.</param>
    /// <returns>Resulting big integer real length.</returns>

    function Multiply(digits1: TMyUInt32Array; length1: UInt32;
      digits2: TMyUInt32Array; length2: UInt32; digitsRes: TMyUInt32Array)
      : UInt32; overload; virtual;

    /// <summary>
    /// Multiplies two big integers using pointers.
    /// </summary>
    /// <param name="digitsPtr1">First big integer digits.</param>
    /// <param name="length1">First big integer length.</param>
    /// <param name="digitsPtr2">Second big integer digits.</param>
    /// <param name="length2">Second big integer length.</param>
    /// <param name="digitsResPtr">Resulting big integer digits.</param>
    /// <returns>Resulting big integer length.</returns>

    function Multiply(digitsPtr1: PMyUInt32; length1: UInt32;
      digitsPtr2: PMyUInt32; length2: UInt32; digitsResPtr: PMyUInt32): UInt32;
      overload; virtual; abstract;

  end;

implementation

function TMultiplierBase.Multiply(int1: TIntX; int2: TIntX): TIntX;
var
  newLength: UInt64;
  newInt: TIntX;

begin
  if TIntX.CompareRecords(int1, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' int1');

  if TIntX.CompareRecords(int2, Default (TIntX)) then
    raise EArgumentNilException.Create(Strings.CantBeNull + ' int2');

  // Special behavior for zero cases
  if ((int1._length = 0) or (int2._length = 0)) then
  begin
    result := TIntX.Create(0);
    Exit;
  end;

  // Get new big integer length and check it
  newLength := UInt64(int1._length) + int2._length;
  if (newLength shr 32 <> 0) then

    raise EArgumentException.Create(Strings.IntegerTooBig);

  // Create resulting big int
  newInt := TIntX.Create(UInt32(newLength), int1._negative xor int2._negative);

  // Perform actual digits multiplication
  newInt._length := Multiply(int1._digits, int1._length, int2._digits,
    int2._length, newInt._digits);

  // Normalization may be needed
  newInt.TryNormalize();

  result := newInt;

end;

function TMultiplierBase.Multiply(digits1: TMyUInt32Array; length1: UInt32;
  digits2: TMyUInt32Array; length2: UInt32; digitsRes: TMyUInt32Array): UInt32;
var
  digitsPtr1, digitsPtr2, digitsResPtr: PMyUInt32;
begin
  digitsPtr1 := @digits1[0];
  digitsPtr2 := @digits2[0];
  digitsResPtr := @digitsRes[0];

  result := Multiply(digitsPtr1, length1, digitsPtr2, length2, digitsResPtr);

end;

end.
