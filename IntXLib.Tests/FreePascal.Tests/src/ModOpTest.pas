unit ModOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX;

type

  { TTestModOp }

  TTestModOp = class(TTestCase)
  published
    procedure Simple();

    procedure Neg();

    procedure Zero();

    procedure CallZeroException();

    procedure Big();

    procedure BigDec();

    procedure BigDecNeg();

  private
    procedure ZeroException();

  end;

implementation


procedure TTestModOp.Simple();
var
  int1, int2: TIntX;
begin
  int1 := 16;
  int2 := 5;
  AssertTrue(int1 mod int2 = 1);
end;


procedure TTestModOp.Neg();
var
  int1, int2: TIntX;
begin
  int1 := -16;
  int2 := 5;
  AssertTrue(int1 mod int2 = -1);
  int1 := 16;
  int2 := -5;
  AssertTrue(int1 mod int2 = 1);
  int1 := -16;
  int2 := -5;
  AssertTrue(int1 mod int2 = -1);
end;


procedure TTestModOp.Zero();
var
  int1, int2: TIntX;
begin
  int1 := 0;
  int2 := 25;
  AssertTrue(int1 mod int2 = 0);
  int1 := 0;
  int2 := -25;
  AssertTrue(int1 mod int2 = 0);
  int1 := 16;
  int2 := 25;
  AssertTrue(int1 mod int2 = 16);
  int1 := -16;
  int2 := 25;
  AssertTrue(int1 mod int2 = -16);
  int1 := 16;
  int2 := -25;
  AssertTrue(int1 mod int2 = 16);
  int1 := -16;
  int2 := -25;
  AssertTrue(int1 mod int2 = -16);
  int1 := 50;
  int2 := 25;
  AssertTrue(int1 mod int2 = 0);
  int1 := -50;
  int2 := -25;
  AssertTrue(int1 mod int2 = 0);
end;

procedure TTestModOp.ZeroException();
var
  int1, int2: TIntX;
begin
  int1 := 1;
  int2 := 0;
  int1 := int1 mod int2;
end;

procedure TTestModOp.CallZeroException();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @ZeroException;

  AssertException(EDivByZero, TempMethod);
end;


procedure TTestModOp.Big();
var
  temp1, temp2, tempM: TIntXLibUInt32Array;
  int1, int2, intM: TIntX;
begin
  SetLength(temp1, 4);
  temp1[0] := 0;
  temp1[1] := 0;
  temp1[2] := $80000000;
  temp1[3] := $7FFFFFFF;
  SetLength(temp2, 3);
  temp2[0] := 1;
  temp2[1] := 0;
  temp2[2] := $80000000;
  SetLength(tempM, 3);
  tempM[0] := 2;
  tempM[1] := $FFFFFFFF;
  tempM[2] := $7FFFFFFF;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  intM := TIntX.Create(tempM, False);
  AssertTrue(int1 mod int2 = intM);
end;


procedure TTestModOp.BigDec();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create('100000000000000000000000000000000000000000000');
  int2 := TIntX.Create('100000000000000000000000000000000000000000');
  AssertTrue(int1 mod int2 = 0);
end;


procedure TTestModOp.BigDecNeg();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create('-100000000000000000000000000000000000000000001');
  int2 := TIntX.Create('100000000000000000000000000000000000000000');
  AssertTrue(int1 mod int2 = -1);
end;


initialization

  RegisterTest(TTestModOp);
end.

