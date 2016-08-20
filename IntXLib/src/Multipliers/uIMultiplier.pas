unit uIMultiplier;

{$I ..\Include\IntXLib.inc}

interface

uses
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Multiplier class interface.
  /// </summary>

  IIMultiplier = interface(IInterface)
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

    function Multiply(digits1: TIntXLibUInt32Array; length1: UInt32;
      digits2: TIntXLibUInt32Array; length2: UInt32;
      digitsRes: TIntXLibUInt32Array): UInt32; overload;

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
