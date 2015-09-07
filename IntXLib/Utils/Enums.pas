unit Enums;

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

type
  /// <summary>
  /// <see cref="IntX" /> divide results to return.
  /// </summary>

  TDivModResultFlags = (

    /// <summary>
    /// Divident is returned.
    /// </summary>

    dmrfDiv = 1,

    /// <summary>
    /// Remainder is returned.
    /// </summary>

    dmrfMod = 2);

  /// <summary>
  /// Big integers multiply mode used in <see cref="IntX" />.
  /// </summary>

  TMultiplyMode = (

    /// <summary>
    /// FHT (Fast Hartley Transform) is used for really big integers.
    /// Time estimate is O(n * log n).
    /// Default mode.
    /// </summary>

    mmAutoFht,

    /// <summary>
    /// Classic method is used.
    /// Time estimate is O(n ^ 2).
    /// </summary>

    mmClassic);

  /// <summary>
  /// Big integers divide mode used in <see cref="IntX" />.
  /// </summary>

  TDivideMode = (

    /// <summary>
    /// Newton approximation algorithm is used for really big integers.
    /// Time estimate is same as for multiplication.
    /// Default mode.
    /// </summary>

    dmAutoNewton,

    /// <summary>
    /// Classic method is used.
    /// Time estimate is O(n ^ 2).
    /// </summary>

    dmClassic);

  /// <summary>
  /// Big integers parsing mode used in <see cref="IntX" />.
  /// </summary>

  TParseMode = (

    /// <summary>
    /// Fast method which uses divide-by-two approach and fast multiply to parse numbers.
    /// Time estimate is O(n * [log n]^2).
    /// Default mode.
    /// </summary>

    pmFast,

    /// <summary>
    /// Classic method is used (using multiplication).
    /// Time estimate is O(n ^ 2).
    /// </summary>

    pmClassic);

  /// <summary>
  /// Big integers to string conversion mode used in <see cref="IntX" />.
  /// </summary>

  TToStringMode = (

    /// <summary>
    /// Fast method which uses divide-by-two approach to convert numbers.
    /// Default mode.
    /// </summary>

    tsmFast,

    /// <summary>
    /// Classic method is used (using division).
    /// Time estimate is O(n ^ 2).
    /// </summary>

    tsmClassic);

implementation

end.
