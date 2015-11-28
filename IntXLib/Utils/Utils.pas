unit Utils;

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
  SysUtils;

type

  /// <summary>
  /// Custom class that contains various helper functions.
  /// </summary>

  TUtils = class sealed

  public

    /// <summary>
    /// Calculates Arithmetic shift right.
    /// </summary>
    /// <param name="value">Integer value to compute 'Asr' on.</param>
    /// <param name="ShiftBits"> number of bits to shift value to.</param>
    /// <returns>Shifted value.</returns>
    /// <seealso href="http://stackoverflow.com/questions/21940986/">[Delphi ASR Implementation for Integer]</seealso>

    class function Asr(value: Integer; ShiftBits: Integer): Integer; overload;
      static; inline;

    /// <summary>
    /// Calculates Arithmetic shift right.
    /// </summary>
    /// <param name="value">Int64 value to compute 'Asr' on.</param>
    /// <param name="ShiftBits"> number of bits to shift value to.</param>
    /// <returns>Shifted value.</returns>
    /// <seealso href="http://github.com/Spelt/ZXing.Delphi/blob/master/Lib/Classes/Common/MathUtils.pas">[Delphi ASR Implementation for Int64]</seealso>

    class function Asr(value: Int64; ShiftBits: Integer): Int64; overload;
      static; inline;

  end;

  TFormatSettings = SysUtils.TFormatSettings;
  EOverflowException = SysUtils.EOverflow;
  EArgumentNilException = SysUtils.EArgumentNilException;
  EFhtMultiplicationException = class(Exception);
  EFormatException = class(Exception);
  EArithmeticException = SysUtils.EMathError;
  EArgumentException = SysUtils.EArgumentException;
  EArgumentOutOfRangeException = SysUtils.EArgumentOutOfRangeException;
  EDivByZero = SysUtils.EDivByZero;

implementation

class function TUtils.Asr(value: Integer; ShiftBits: Integer): Integer;

begin
  Result := value shr ShiftBits;
  if (value and $80000000) > 0 then
    // if you don't want to cast ($FFFFFFFF) to an Integer, simply replace it with (-1) to avoid range check error.
    Result := Result or (Integer($FFFFFFFF) shl (32 - ShiftBits));
end;

class function TUtils.Asr(value: Int64; ShiftBits: Integer): Int64;
begin
  Result := value shr ShiftBits;
  if (value and $8000000000000000) > 0 then
    Result := Result or ($FFFFFFFFFFFFFFFF shl (64 - ShiftBits));
end;

end.
