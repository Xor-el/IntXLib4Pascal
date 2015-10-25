unit IDivider;

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
  DTypes, Enums, IntX;

type
  /// <summary>
  /// Divider class interface.
  /// </summary>

  IIDivider = interface
    ['{1DE44B6B-BCC7-47EF-B03E-1E289CBDA4B9}']

    /// <summary>
    /// Divides one <see cref="TIntX" /> by another.
    /// </summary>
    /// <param name="int1">First big integer.</param>
    /// <param name="int2">Second big integer.</param>
    /// <param name="modRes">Remainder big integer.</param>
    /// <param name="resultFlags">Which operation results to return.</param>
    /// <returns>Divident big integer.</returns>

    function DivMod(int1: TIntX; int2: TIntX; out modRes: TIntX;
      resultFlags: TDivModResultFlags): TIntX; overload;

    /// <summary>
    /// Divides two big integers.
    /// Also modifies <paramref name="digits1" /> and <paramref name="length1"/> (it will contain remainder).
    /// </summary>
    /// <param name="digits1">First big integer digits.</param>
    /// <param name="digitsBuffer1">Buffer for first big integer digits. May also contain remainder. Can be null - in this case it's created if necessary.</param>
    /// <param name="length1">First big integer length.</param>
    /// <param name="digits2">Second big integer digits.</param>
    /// <param name="digitsBuffer2">Buffer for second big integer digits. Only temporarily used. Can be null - in this case it's created if necessary.</param>
    /// <param name="length2">Second big integer length.</param>
    /// <param name="digitsRes">Resulting big integer digits.</param>
    /// <param name="resultFlags">Which operation results to return.</param>
    /// <param name="cmpResult">Big integers comparison result (pass -2 if omitted).</param>
    /// <returns>Resulting big integer length.</returns>

    function DivMod(digits1: TMyUInt32Array; digitsBuffer1: TMyUInt32Array;
      var length1: UInt32; digits2: TMyUInt32Array;
      digitsBuffer2: TMyUInt32Array; length2: UInt32; digitsRes: TMyUInt32Array;
      resultFlags: TDivModResultFlags; cmpResult: Integer): UInt32; overload;

    /// <summary>
    /// Divides two big integers.
    /// Also modifies <paramref name="digitsPtr1" /> and <paramref name="length1"/> (it will contain remainder).
    /// </summary>
    /// <param name="digitsPtr1">First big integer digits.</param>
    /// <param name="digitsBufferPtr1">Buffer for first big integer digits. May also contain remainder.</param>
    /// <param name="length1">First big integer length.</param>
    /// <param name="digitsPtr2">Second big integer digits.</param>
    /// <param name="digitsBufferPtr2">Buffer for second big integer digits. Only temporarily used.</param>
    /// <param name="length2">Second big integer length.</param>
    /// <param name="digitsResPtr">Resulting big integer digits.</param>
    /// <param name="resultFlags">Which operation results to return.</param>
    /// <param name="cmpResult">Big integers comparison result (pass -2 if omitted).</param>
    /// <returns>Resulting big integer length.</returns>

    function DivMod(digitsPtr1: PMyUInt32; digitsBufferPtr1: PMyUInt32;
      var length1: UInt32; digitsPtr2: PMyUInt32; digitsBufferPtr2: PMyUInt32;
      length2: UInt32; digitsResPtr: PMyUInt32; resultFlags: TDivModResultFlags;
      cmpResult: Integer): UInt32; overload;

  end;

implementation

end.
