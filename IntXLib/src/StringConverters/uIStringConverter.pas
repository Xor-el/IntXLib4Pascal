unit uIStringConverter;

{$I ..\Include\IntXLib.inc}

interface

uses
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// ToString converter class interface.
  /// </summary>

  IIStringConverter = interface(IInterface)
    ['{EC961CBB-1DA0-492B-A68F-97D3F1A30484}']

    /// <summary>
    /// Returns string representation of <see cref="TIntX" /> object in given base.
    /// </summary>
    /// <param name="IntX">Big integer to convert.</param>
    /// <param name="numberBase">Base of system in which to do output.</param>
    /// <param name="alphabet">Alphabet which contains chars used to represent big integer, char position is coresponding digit value.</param>
    /// <returns>Object string representation.</returns>

    function ToString(IntX: TIntX; numberBase: UInt32;
      alphabet: TIntXLibCharArray): String; overload;

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
      : TIntXLibUInt32Array; overload;

  end;

implementation

end.
