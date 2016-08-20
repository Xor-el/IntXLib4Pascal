unit uEnums;

{$I ..\Include\IntXLib.inc}

interface

type
  /// <summary>
  /// <see cref="TIntX" /> divide results to return.
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
  /// Big integers multiply mode used in <see cref="TIntX" />.
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
  /// Big integers divide mode used in <see cref="TIntX" />.
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
  /// Big integers parsing mode used in <see cref="TIntX" />.
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
  /// Big integers to string conversion mode used in <see cref="TIntX" />.
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

// uses
// IntX;

end.
