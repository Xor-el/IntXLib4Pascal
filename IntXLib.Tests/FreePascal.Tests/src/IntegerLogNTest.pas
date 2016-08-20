unit IntegerLogNTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestIntegerLogN }

  TTestIntegerLogN = class(TTestCase)
  published

    procedure LogNBase10();

    procedure LogNBase2();

  end;

implementation

procedure TTestIntegerLogN.LogNBase10();
var
  base, number: TIntX;
begin
  base := 10;
  number := 100;
  AssertTrue(TIntX.IntegerLogN(base, number) = 2);
  base := TIntX.Create(10);
  number := TIntX.Create(10);
  AssertTrue(TIntX.IntegerLogN(base, number) = 1);
  base := TIntX.Create(10);
  number := TIntX.Create(500);
  AssertTrue(TIntX.IntegerLogN(base, number) = 2);
  base := TIntX.Create(10);
  number := TIntX.Create(1000);
  AssertTrue(TIntX.IntegerLogN(base, number) = 3);
end;

procedure TTestIntegerLogN.LogNBase2();
var
  base, number: TIntX;
begin
  base := 2;
  number := 100;
  AssertTrue(TIntX.IntegerLogN(base, number) = 6);
  base := TIntX.Create(2);
  number := TIntX.Create(10);
  AssertTrue(TIntX.IntegerLogN(base, number) = 3);
  base := TIntX.Create(2);
  number := TIntX.Create(500);
  AssertTrue(TIntX.IntegerLogN(base, number) = 8);
  base := TIntX.Create(2);
  number := TIntX.Create(1000);
  AssertTrue(TIntX.IntegerLogN(base, number) = 9);
end;


initialization

  RegisterTest(TTestIntegerLogN);
end.

