unit uMillerRabin;

{$I ..\Include\IntXLib.inc}
(*
  * The Miller-Rabin primality test
  *
  * Written by Christian Stigen Larsen, 2012-01-10
  * http://csl.sublevel3.org
  * Ported to Pascal by Ugochukwu Mmaduekwe <ugo4brain@gmail.com>
  *
*)

(*
  * The Miller-Rabin probabilistic primality test.
  *
  * Returns true if ``n´´ is PROBABLY prime, false if it's composite.
  * The parameter ``k´´ is the accuracy.
  *
  * The running time should be somewhere around O(k log_3 n).
  *
*)

interface

uses
  uIntX;

type
  /// <summary>
  /// Class for Checking if a Number is Prime using Miller-Rabin Probabilistic Primality test.
  /// </summary>

  TMillerRabin = class(TObject)

  public

    /// <summary>
    /// Checks if a Number is Prime using Miller-Rabin Probabilistic Primality test.
    /// </summary>
    /// <param name="n">value to check.</param>
    /// <param name="k">Accuracy parameter `k´ of the Miller-Rabin algorithm. Default is 5. The execution time is proportional to the value of the accuracy parameter.</param>

    class function IsProbablyPrimeMR(n: TIntX; k: Integer = 5): Boolean;

  end;

implementation

class function TMillerRabin.IsProbablyPrimeMR(n: TIntX; k: Integer = 5)
  : Boolean;
var
  s, i, r: Integer;
  m, d, a, x: TIntX;
  Redo: Boolean;

begin
  Redo := False;
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
      begin
        Redo := True;
        Break;
      end;
      Inc(r);
    end;

    if not Redo then
    begin
      result := False;
      Exit;
    end
    else

    begin
      Inc(i);
      continue;
    end;

  end;
  // n is *probably* prime
  result := True;
end;

end.
