unit MillerRabin;

(*
  * The Miller-Rabin primality test
  *
  * Written by Christian Stigen Larsen, 2012-01-10
  * http://csl.sublevel3.org
  * Ported to Delphi by Ugochukwu Mmaduekwe
  *
*)

interface

uses
  IntX;

type
  TMillerRabin = class

  public

    class function isProbablyPrimeMR(n: TIntX; k: Integer = 5): Boolean;

  end;

implementation

(*
  * The Miller-Rabin probabilistic primality test.
  *
  * Returns true if ``n´´ is *PROBABLY* prime, false if it's composite.
  * The parameter ``k´´ is the accuracy.
  *
  * The running time should be somewhere around O(k log_3 n).
  *
*)

class function TMillerRabin.isProbablyPrimeMR(n: TIntX; k: Integer = 5)
  : Boolean;
var
  s, i, r: Integer;
  m, d, a, x: TIntX;
label
  LOOP;
begin
  // Must have ODD n greater than THREE
  if ((n = 2) or (n = 3)) then
  begin
    result := True;
    Exit;
  end;
  if ((n <= 1) or not(n.IsOdd)) then
  begin
    result := False;
    Exit;
  end;

  // Write n-1 as d*2^s by factoring powers of 2 from n-1
  s := 0;
  m := n - 1;
  while not m.IsOdd do
  begin
    Inc(s);
    m := m shr 1;
  end;

  d := (n - 1) div (1 shl s);

  i := 0;
  while i < k do
  begin
    a := TIntX.RandomRange(2, UInt32(n - 2));
    x := TIntX.ModPow(a, d, n);
    if ((x = 1) or (x = n - 1)) then
    begin
      Inc(i);
      continue;
    end;

    r := 1;
    while r <= (s - 1) do
    begin
      x := TIntX.ModPow(x, 2, n);
      if (x = 1) then
      begin
        result := False;
        Exit;
      end;
      if (x = n - 1) then
        goto LOOP;
      Inc(r);
    end;

    result := False;
    Exit;

  LOOP:
    Inc(i);
    continue;

  end;
  // n is *probably* prime
  result := True;
end;

end.
