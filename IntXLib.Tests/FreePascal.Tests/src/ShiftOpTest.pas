unit ShiftOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX;

type

  { TTestShiftOp }

  TTestShiftOp = class(TTestCase)
  published

    procedure Zero();

    procedure SimpleAndNeg();

    procedure Complex();

    procedure BigShift();

    procedure MassiveShift();

  end;

implementation


procedure TTestShiftOp.Zero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(0);
  AssertTrue(int1 shl 100 = 0);
  AssertTrue(int1 shr 100 = 0);
end;


procedure TTestShiftOp.SimpleAndNeg();
var
  temp: TIntXLibUInt32Array;
  int1: TIntX;
begin
  SetLength(temp, 2);
  temp[0] := 0;
  temp[1] := 8;
  int1 := TIntX.Create(8);
  AssertTrue((int1 shl 0 = int1 shr 0) and (int1 shl 0 = 8));
  AssertTrue((int1 shl 32 = int1 shr -32) and (int1 shl 32 =
    TIntX.Create(temp, False)));
end;


procedure TTestShiftOp.Complex();
var
  int1: TIntX;
begin
  int1 := TIntX.Create('$0080808080808080');
  AssertTrue((int1 shl 4).ToString(16) = '808080808080800');
  AssertTrue(int1 shr 36 = $80808);
end;


procedure TTestShiftOp.BigShift();
var
  int1: TIntX;
begin
  int1 := 8;
  AssertTrue(int1 shr 777 = 0);
end;


procedure TTestShiftOp.MassiveShift();
var
  n: TIntX;
  i: integer;
begin
  for i := 1 to Pred(2000) do
  begin
    n := i;
    n := n shl i;
    n := n shr i;
    AssertTrue(TIntX.Create(i).Equals(n));
  end;

end;


initialization

  RegisterTest(TTestShiftOp);
end.

