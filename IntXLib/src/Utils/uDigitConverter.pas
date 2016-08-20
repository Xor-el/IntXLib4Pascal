unit uDigitConverter;

{$I ..\Include\IntXLib.inc}

interface

uses
  SysUtils,
  uStrings,
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Converts <see cref="TIntX"/> digits to/from byte array.
  /// </summary>

  TDigitConverter = class sealed(TObject)

  public
    /// <summary>
    /// Converts big integer digits to bytes.
    /// </summary>
    /// <param name="digits"><see cref="TIntX" /> digits.</param>
    /// <returns>Resulting bytes.</returns>
    /// <remarks>
    /// Digits can be obtained using <see cref="TIntX.GetInternalState(TIntXLibUInt32Array,Boolean,Boolean)" /> method.
    /// </remarks>
    /// <exception cref="EArgumentNilException"><paramref name="digits" /> is a null reference.</exception>

    class function ToBytes(digits: TIntXLibUInt32Array): TBytes; static;
    /// <summary>
    /// Converts bytes to big integer digits.
    /// </summary>
    /// <param name="bytes">Bytes.</param>
    /// <returns>Resulting <see cref="TIntX" /> digits.</returns>
    /// <remarks>
    /// Big integer can be created from digits using <see cref="TIntX.Create(TIntXLibUInt32Array,Boolean)" /> constructor.
    /// </remarks>
    /// <exception cref="EArgumentNilException"><paramref name="bytes" /> is a null reference.</exception>

    class function FromBytes(bytes: TBytes): TIntXLibUInt32Array; static;

  end;

implementation

class function TDigitConverter.ToBytes(digits: TIntXLibUInt32Array): TBytes;

begin

  if (digits = Nil) then
  begin
    raise EArgumentNilException.Create('digits');
  end;

  SetLength(result, (Length(digits) * 4));
  Move(digits[0], result[0], Length(result) * SizeOf(UInt32));
end;

class function TDigitConverter.FromBytes(bytes: TBytes): TIntXLibUInt32Array;

begin
  if (bytes = Nil) then
  begin
    raise EArgumentNilException.Create('bytes');
  end;
  if (Length(bytes) mod 4 <> 0) then
  begin
    raise EArgumentException.Create(uStrings.DigitBytesLengthInvalid +
      ' bytes');
  end;
  SetLength(result, (Length(bytes) div 4));
  Move(bytes[0], result[0], Length(bytes) * SizeOf(Byte));
end;

end.
