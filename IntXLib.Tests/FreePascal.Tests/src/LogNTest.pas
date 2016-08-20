unit LogNTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  Math,
  uIntX;

type

  { TTestLogN }

  TTestLogN = class(TTestCase)
  published

    procedure LogNBase10();

    procedure LogNBase2();

  end;

implementation

procedure TTestLogN.LogNBase10();
var
  based, numberd, ans: Double;
  number: TIntX;
begin
  based := 10;
  number := 100;
  numberd := 100;
  ans := Math.LogN(based, numberd);
  AssertTrue(TIntX.LogN(based, number) = ans);

  number := 10;
  numberd := 10;
  ans := Math.LogN(based, numberd);
  AssertTrue(TIntX.LogN(based, number) = ans);

  number := 500;
  numberd := 500;
  ans := Math.LogN(based, numberd);
  AssertTrue(TIntX.LogN(based, number) = ans);

  number := 1000;
  numberd := 1000;
  ans := Math.LogN(based, numberd);
  AssertTrue(TIntX.LogN(based, number) = ans);

end;

procedure TTestLogN.LogNBase2();
var
  based, numberd, ans: Double;
  number: TIntX;
begin
  based := 2;
  number := 100;
  numberd := 100;
  ans := Math.LogN(based, numberd);
  AssertTrue(TIntX.LogN(based, number) = ans);

  number := 10;
  numberd := 10;
  ans := Math.LogN(based, numberd);
  AssertTrue(TIntX.LogN(based, number) = ans);

  number := 500;
  numberd := 500;
  ans := Math.LogN(based, numberd);
  AssertTrue(TIntX.LogN(based, number) = ans);

  number := 1000;
  numberd := 1000;
  ans := Math.LogN(based, numberd);
  AssertTrue(TIntX.LogN(based, number) = ans);

  number := TIntX.One shl 64 shl High(Int32);

  AssertTrue(TIntX.LogN(based, number) = 2147483711);
end;


initialization

  RegisterTest(TTestLogN);
end.

