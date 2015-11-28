unit IMultiplier;

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
  IntX;

type
  /// <summary>
  /// Multiplier class interface.
  /// </summary>

  IIMultiplier = interface
    ['{9259DC7D-71A5-433A-A756-FD239C6F562F}']

    /// <summary>
    /// Multiplies two big integers.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <returns>Resulting big integer.</returns>

    function Multiply(int1: TIntX; int2: TIntX): TIntX; overload;

    /// <summary>
    /// Multiplies two big integers represented by their digits.
    /// </summary>
    /// <param name="digits1">First big integer digits.</param>
    /// <param name="length1">First big integer real length.</param>
    /// <param name="digits2">Second big integer digits.</param>
    /// <param name="length2">Second big integer real length.</param>
    /// <param name="digitsRes">Where to put resulting big integer.</param>
    /// <returns>Resulting big integer real length.</returns>

    function Multiply(digits1: TArray<Cardinal>; length1: UInt32;
      digits2: TArray<Cardinal>; length2: UInt32; digitsRes: TArray<Cardinal>)
      : UInt32; overload;

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
      : UInt32; overload;
  end;

implementation

end.
