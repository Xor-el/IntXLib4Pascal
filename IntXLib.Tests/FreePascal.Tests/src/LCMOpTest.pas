unit LCMOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestLCMOp }

  TTestLCMOp = class(TTestCase)
  published

    procedure LCMIntXBothPositive();

    procedure LCMIntXBothNegative();

    procedure LCMIntXBothSigns();

  end;

implementation



{ TTestLCMOp }

procedure TTestLCMOp.LCMIntXBothPositive;
var
  res: TIntX;
begin
  res := TIntX.LCM(4, 6);
  AssertTrue(res = 2);
  res := TIntX.LCM(24, 18);
  AssertTrue(res = 6);
  res := TIntX.LCM(234, 100);
  AssertTrue(res = 2);
  res := TIntX.LCM(235, 100);
  AssertTrue(res = 5);
end;

procedure TTestLCMOp.LCMIntXBothNegative;
var
  res: TIntX;
begin
  res := TIntX.LCM(-4, -6);
  AssertTrue(res = 2);
  res := TIntX.LCM(-24, -18);
  AssertTrue(res = 6);
  res := TIntX.LCM(-234, -100);
  AssertTrue(res = 2);
end;

procedure TTestLCMOp.LCMIntXBothSigns;
var
  res: TIntX;
begin
  res := TIntX.LCM(-4, +6);
  AssertTrue(res = 2);
  res := TIntX.LCM(+24, -18);
  AssertTrue(res = 6);
  res := TIntX.LCM(-234, +100);
  AssertTrue(res = 2);
end;

initialization

  RegisterTest(TTestLCMOp);
end.

