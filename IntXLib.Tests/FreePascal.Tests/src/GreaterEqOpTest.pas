unit GreaterEqOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX;

type

  { TTestGreaterEqOp }

  TTestGreaterEqOp = class(TTestCase)
  published

    procedure Simple();

    procedure SimpleFail();

    procedure Big();

    procedure BigFail();

    procedure EqualValues();

  end;

implementation


procedure TTestGreaterEqOp.Simple();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(7);
  int2 := TIntX.Create(8);
  AssertTrue(int2 >= int1);
end;


procedure TTestGreaterEqOp.SimpleFail();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(8);
  AssertFalse(7 >= int1);
end;


procedure TTestGreaterEqOp.Big();
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
  AssertTrue(int1 >= int2);
end;


procedure TTestGreaterEqOp.BigFail();
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
  AssertFalse(int2 >= int1);
end;


procedure TTestGreaterEqOp.EqualValues();
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
  AssertTrue(int2 >= int1);
end;


initialization

  RegisterTest(TTestGreaterEqOp);
end.

