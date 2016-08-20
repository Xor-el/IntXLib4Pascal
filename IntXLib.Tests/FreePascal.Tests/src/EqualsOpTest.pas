unit EqualsOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestEqualsOp }

  TTestEqualsOp = class(TTestCase)
  published

    procedure Equals2IntX();

    procedure EqualsZeroIntX();

    procedure EqualsIntIntX();

    procedure EqualsNullIntX();

    procedure Equals2IntXOp();

  end;

implementation


procedure TTestEqualsOp.Equals2IntX();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(8);
  int2 := TIntX.Create(8);
  AssertTrue(int1.Equals(int2));
end;


procedure TTestEqualsOp.EqualsZeroIntX();
begin
  AssertFalse(TIntX.Create(0) = 1);
end;


procedure TTestEqualsOp.EqualsIntIntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(8);
  AssertTrue(int1 = 8);
end;


procedure TTestEqualsOp.EqualsNullIntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(8);
  AssertFalse(int1 = Default(TIntX));
end;


procedure TTestEqualsOp.Equals2IntXOp();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(8);
  int2 := TIntX.Create(8);
  AssertTrue(int1 = int2);
end;


initialization

  RegisterTest(TTestEqualsOp);
end.


