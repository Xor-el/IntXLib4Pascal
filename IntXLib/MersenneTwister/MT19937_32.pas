unit MT19937_32;

{
  * Copyright (c) 2015 Ugochukwu Mmaduekwe ugo4brain@gmail.com

  *  MersenneTwister with a 32 bit Word Length in Delphi

}

interface

type
  TMersenneTwister_32 = class

  public
    class constructor Create();
    class function NextUInt32(): UInt32; overload; inline;
    class function NextUInt32(min: UInt32; max: UInt32): UInt32;
      overload; inline;
    class function NextInt(): Integer; overload;
    class function NextInt(max: Integer): Integer; overload;
    class function NextInt(min: Integer; max: Integer): Integer; overload;
    class function NextDouble(): Double;

  strict private
  class var
    F_index: Integer;
    F_mt: array of UInt32;
    F_Seed: UInt32;

  const
    n: Integer = 624;
    m: Integer = 397;

    class function ExtractNumber(): UInt32; inline;
    class procedure Twist(); inline;
  end;

implementation

// class constructor
class constructor TMersenneTwister_32.Create();
var
  i: UInt32;
begin
  // F_Seed := 5489;
  Randomize;
  F_Seed := UInt32(Random(MaxInt)); // Initialize to a Random Seed
  F_index := n;
  SetLength(F_mt, n);
  F_mt[0] := F_Seed; // Initialize the initial state to the seed
  i := 1;
  while i < UInt32(n) do
  begin
    F_mt[i] := (1812433253 * (F_mt[i - 1] xor (F_mt[i - 1] shr 30)) + i);
    Inc(i);
  end;

end;

class function TMersenneTwister_32.ExtractNumber(): UInt32;
var
  y: UInt32;
begin
  if (F_index >= n) then
    Twist();
  y := F_mt[F_index];
  // Tempering
  // right shift by 11 bits
  y := y xor (y shr 11);
  // Shift y left by 7 and take the bitwise and of 2636928640
  y := y xor ((y shl 7) and 2636928640);
  // Shift y left by 15 and take the bitwise and of y and 4022730752
  y := y xor ((y shl 15) and 4022730752);
  // Right shift by 18 bits
  y := y xor (y shr 18);
  Inc(F_index);
  result := y;
end;

class procedure TMersenneTwister_32.Twist();
var
  i: Integer;
  y: UInt32;
begin
  for i := 0 to Pred(n) do
  begin
    // Get the most significant bit and add it to the less significant bits of the next number
    y := ((F_mt[i]) and $80000000) + ((F_mt[(i + 1) mod n]) and $7FFFFFFF);
    F_mt[i] := F_mt[(i + m) mod n] xor UInt32(y shr 1);
    if (y mod 2 <> 0) then
      F_mt[i] := F_mt[i] xor $9908B0DF;
  end;
  F_index := 0;
end;

class function TMersenneTwister_32.NextUInt32(): UInt32;
begin
  result := ExtractNumber();
end;

// max is NOT included

class function TMersenneTwister_32.NextUInt32(min: UInt32; max: UInt32): UInt32;
begin
  result := 0;
  if max = 0 then
    Exit;
  result := NextUInt32() mod (max - min) + min;
end;

// Can be negative
class function TMersenneTwister_32.NextInt(): Integer;
begin
  result := Integer(ExtractNumber());
end;

// max is NOT included

class function TMersenneTwister_32.NextInt(max: Integer): Integer;
begin
  result := 0;
  if max = 0 then
    Exit;
  result := Integer(NextUInt32() mod UInt32(max));
end;

// between min (included) and max (excluded)

class function TMersenneTwister_32.NextInt(min: Integer; max: Integer): Integer;
begin
  result := 0;
  if max = 0 then
    Exit;
  result := Integer(NextUInt32() mod UInt32((max - min) + min));
end;

// between 0 and 1 (included)
class function TMersenneTwister_32.NextDouble(): Double;
begin
  result := (NextUInt32() mod 65536) / 65535.0;
end;

end.
