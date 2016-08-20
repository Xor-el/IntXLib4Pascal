unit GCDOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestGCDOp }

  TTestGCDOp = class(TTestCase)
  published

    procedure GCDIntXBothPositive();

    procedure GCDIntXBothNegative();

    procedure GCDIntXBothSigns();

  end;

implementation



{ TTestGCDOp }

procedure TTestGCDOp.GCDIntXBothPositive;
var
  res: TIntX;
begin
  res := TIntX.GCD(4, 6);
  AssertTrue(res = 2);
  res := TIntX.GCD(24, 18);
  AssertTrue(res = 6);
  res := TIntX.GCD(234, 100);
  AssertTrue(res = 2);
  res := TIntX.GCD(235, 100);
  AssertTrue(res = 5);
end;

procedure TTestGCDOp.GCDIntXBothNegative;
var
  res: TIntX;
begin
  res := TIntX.GCD(-4, -6);
  AssertTrue(res = 2);
  res := TIntX.GCD(-24, -18);
  AssertTrue(res = 6);
  res := TIntX.GCD(-234, -100);
  AssertTrue(res = 2);
end;

procedure TTestGCDOp.GCDIntXBothSigns;
var
  res: TIntX;
begin
  res := TIntX.GCD(-4, +6);
  AssertTrue(res = 2);
  res := TIntX.GCD(+24, -18);
  AssertTrue(res = 6);
  res := TIntX.GCD(-234, +100);
  AssertTrue(res = 2);
end;

initialization

  RegisterTest(TTestGCDOp);
end.

