unit UnaryOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestUnaryOp }

  TTestUnaryOp = class(TTestCase)
  published

    procedure Plus();

    procedure Minus();

    procedure ZeroPositive();

    procedure ZeroNegative();

    procedure Increment();

    procedure Decrement();

  end;

implementation


procedure TTestUnaryOp.Plus();
var
  IntX: TIntX;
begin
  IntX := 77;
  AssertTrue(IntX = +IntX);
end;


procedure TTestUnaryOp.Minus();
var
  IntX: TIntX;
begin
  IntX := 77;
  AssertTrue(-IntX = -77);
end;


procedure TTestUnaryOp.ZeroPositive();
var
  IntX: TIntX;
begin
  IntX := 0;
  AssertTrue(IntX = +IntX);
end;


procedure TTestUnaryOp.ZeroNegative();
var
  IntX: TIntX;
begin
  IntX := 0;
  AssertTrue(IntX = -IntX);

end;


procedure TTestUnaryOp.Increment();
var
  IntX: TIntX;
begin
  IntX := 77;
  AssertTrue(IntX = 77);
  Inc(IntX);
  Inc(IntX);
  AssertTrue(IntX = 79);
end;


procedure TTestUnaryOp.Decrement();
var
  IntX: TIntX;
begin
  IntX := 77;
  AssertTrue(IntX = 77);
  Dec(IntX);
  Dec(IntX);
  AssertTrue(IntX = 75);
end;


initialization

  RegisterTest(TTestUnaryOp);
end.

