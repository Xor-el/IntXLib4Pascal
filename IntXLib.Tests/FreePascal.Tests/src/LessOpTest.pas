unit LessOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX;

type

  { TTestLessOp }

  TTestLessOp = class(TTestCase)
  published

    procedure Simple();

    procedure SimpleFail();

    procedure Big();

    procedure BigFail();

    procedure EqualValues();

    procedure Neg();

  end;

implementation



procedure TTestLessOp.Simple();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(7);
  int2 := TIntX.Create(8);
  AssertTrue(int1 < int2);
end;


procedure TTestLessOp.SimpleFail();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(8);
  AssertFalse(int1 < 7);
end;


procedure TTestLessOp.Big();
var
  temp1, temp2: TIntXLibUInt32Array;
  int1, int2: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := 1;
  temp1[1] := 2;
  SetLength(temp2, 3);
  temp2[0] := 1;
  temp2[1] := 2;
  temp2[2] := 3;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, True);
  AssertTrue(int2 < int1);
end;


procedure TTestLessOp.BigFail();
var
  temp1, temp2: TIntXLibUInt32Array;
  int1, int2: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := 1;
  temp1[1] := 2;
  SetLength(temp2, 3);
  temp2[0] := 1;
  temp2[1] := 2;
  temp2[2] := 3;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, True);
  AssertFalse(int1 < int2);
end;


procedure TTestLessOp.EqualValues();
var
  temp1, temp2: TIntXLibUInt32Array;
  int1, int2: TIntX;
begin
  SetLength(temp1, 3);
  temp1[0] := 1;
  temp1[1] := 2;
  temp1[2] := 3;
  SetLength(temp2, 3);
  temp2[0] := 1;
  temp2[1] := 2;
  temp2[2] := 3;
  int1 := TIntX.Create(temp1, True);
  int2 := TIntX.Create(temp2, True);
  AssertFalse(int1 < int2);
end;


procedure TTestLessOp.Neg();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(-10);
  int2 := TIntX.Create(-2);
  AssertTrue(int1 < int2);
end;


initialization

  RegisterTest(TTestLessOp);
end.

