unit uUtils;

{$I ..\Include\IntXLib.inc}

interface

uses
  uIntXLibTypes;

type

  /// <summary>
  /// Custom class that contains various helper functions.
  /// </summary>

  TUtils = class sealed(TObject)

  public

    /// <summary>
    /// Calculates Arithmetic shift right.
    /// </summary>
    /// <param name="value">Integer value to compute 'Asr' on.</param>
    /// <param name="ShiftBits"> number of bits to shift value to.</param>
    /// <returns>Shifted value.</returns>
    /// <seealso href="http://stackoverflow.com/questions/21940986/">[Delphi ASR Implementation for Integer]</seealso>

    class function Asr32(value: Integer; ShiftBits: Integer): Integer; overload;
      static; inline;

    /// <summary>
    /// Calculates Arithmetic shift right.
    /// </summary>
    /// <param name="value">Int64 value to compute 'Asr' on.</param>
    /// <param name="ShiftBits"> number of bits to shift value to.</param>
    /// <returns>Shifted value.</returns>
    /// <seealso href="http://github.com/Spelt/ZXing.Delphi/blob/master/Lib/Classes/Common/MathUtils.pas">[Delphi ASR Implementation for Int64]</seealso>

    class function Asr64(value: Int64; ShiftBits: Integer): Int64; overload;
      static; inline;

    // Lifted from DaThoX Free Pascal generics library with little modifications.

    class procedure QuickSort(var AValues: TIntXLibCharArray;
      ALeft, ARight: Integer); static;

  end;

implementation

class function TUtils.Asr32(value: Integer; ShiftBits: Integer): Integer;

begin
  Result := value shr ShiftBits;
  if (value and $80000000) > 0 then
    // if you don't want to cast ($FFFFFFFF) to an Integer, simply replace it with
    // (-1) to avoid range check error.
    Result := Result or (Integer($FFFFFFFF) shl (32 - ShiftBits));
end;

class function TUtils.Asr64(value: Int64; ShiftBits: Integer): Int64;
begin
  Result := value shr ShiftBits;
  if (value and $8000000000000000) > 0 then
    Result := Result or ($FFFFFFFFFFFFFFFF shl (64 - ShiftBits));
end;

class procedure TUtils.QuickSort(var AValues: TIntXLibCharArray;
  ALeft, ARight: Integer);
var
  I, J: Integer;
  P, Q: Char;
begin
  if ((ARight - ALeft) <= 0) or (Length(AValues) = 0) then
    Exit;
  repeat
    I := ALeft;
    J := ARight;
    P := AValues[ALeft + (ARight - ALeft) shr 1];
    repeat
      while AValues[I] < P do
        Inc(I);
      while AValues[J] > P do
        Dec(J);
      if I <= J then
      begin
        if I <> J then
        begin
          Q := AValues[I];
          AValues[I] := AValues[J];
          AValues[J] := Q;
        end;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    // sort the smaller range recursively
    // sort the bigger range via the loop
    // Reasons: memory usage is O(log(n)) instead of O(n) and loop is faster than recursion
    if J - ALeft < ARight - I then
    begin
      if ALeft < J then
        QuickSort(AValues, ALeft, J);
      ALeft := I;
    end
    else
    begin
      if I < ARight then
        QuickSort(AValues, I, ARight);
      ARight := J;
    end;
  until ALeft >= ARight;
end;

end.
