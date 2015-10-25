unit DigitConverter;

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
  Strings, DTypes, Utils, IntX;

type
  /// <summary>
  /// Converts <see cref="TIntX"/> digits to/from byte array.
  /// </summary>

  TDigitConverter = class

  public
    /// <summary>
    /// Converts big integer digits to bytes.
    /// </summary>
    /// <param name="digits"><see cref="TIntX" /> digits.</param>
    /// <returns>Resulting bytes.</returns>
    /// <remarks>
    /// Digits can be obtained using <see cref="TIntX.GetInternalState(TMyUInt32Array,Boolean,Boolean)" /> method.
    /// </remarks>
    /// <exception cref="EArgumentNilException"><paramref name="digits" /> is a null reference.</exception>

    class function ToBytes(digits: TMyUInt32Array): TMyByteArray; static;
    /// <summary>
    /// Converts bytes to big integer digits.
    /// </summary>
    /// <param name="bytes">Bytes.</param>
    /// <returns>Resulting <see cref="TIntX" /> digits.</returns>
    /// <remarks>
    /// Big integer can be created from digits using <see cref="TIntX.Create(TMyUInt32Array,Boolean)" /> constructor.
    /// </remarks>
    /// <exception cref="EArgumentNilException"><paramref name="bytes" /> is a null reference.</exception>

    class function FromBytes(bytes: TMyByteArray): TMyUInt32Array; static;

  end;

implementation

class function TDigitConverter.ToBytes(digits: TMyUInt32Array): TMyByteArray;

begin
  if (Length(digits) = 0) then
  begin
    raise EArgumentNilException.Create('digits');
  end;

  SetLength(result, (Length(digits) * 4));
  Move(digits[0], result[0], Length(result) * SizeOf(UInt32));
end;

class function TDigitConverter.FromBytes(bytes: TMyByteArray): TMyUInt32Array;

begin
  if (bytes = Nil) then
  begin
    raise EArgumentNilException.Create('bytes');
  end;
  if (Length(bytes) mod 4 <> 0) then
  begin
    raise EArgumentException.Create(Strings.DigitBytesLengthInvalid + ' bytes');
  end;
  SetLength(result, (Length(bytes) div 4));
  Move(bytes[0], result[0], Length(bytes) * SizeOf(Byte));
end;

end.
