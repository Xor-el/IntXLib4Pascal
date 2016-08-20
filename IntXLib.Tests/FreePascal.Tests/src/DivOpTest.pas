unit DivOpTest;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX;

type

  { TTestDivOp }

  TTestDivOp = class(TTestCase)
  published

    procedure Simple();

    procedure Neg();

    procedure Zero();

    procedure CallZeroException();

    procedure Big();

    procedure Big2();

    procedure BigDec();

    procedure BigDecNeg();

  private
    procedure ZeroException();

  end;

implementation


procedure TTestDivOp.Simple();
var
  int1, int2: TIntX;
begin
  int1 := 16;
  int2 := 5;
  AssertTrue(int1 div int2 = 3);
end;


procedure TTestDivOp.Neg();
var
  int1, int2: TIntX;
begin
  int1 := -16;
  int2 := 5;
  AssertTrue(int1 div int2 = -3);
  int1 := 16;
  int2 := -5;
  AssertTrue(int1 div int2 = -3);
  int1 := -16;
  int2 := -5;
  AssertTrue(int1 div int2 = 3);
end;


procedure TTestDivOp.Zero();
var
  int1, int2: TIntX;
begin
  int1 := 0;
  int2 := 25;
  AssertTrue(int1 div int2 = 0);
  int1 := 0;
  int2 := -25;
  AssertTrue(int1 div int2 = 0);
  int1 := 16;
  int2 := 25;
  AssertTrue(int1 div int2 = 0);
  int1 := -16;
  int2 := 25;
  AssertTrue(int1 div int2 = 0);
  int1 := 16;
  int2 := -25;
  AssertTrue(int1 div int2 = 0);
  int1 := -16;
  int2 := -25;
  AssertTrue(int1 div int2 = 0);
end;

procedure TTestDivOp.ZeroException();
var
  int1, int2: TIntX;
begin
  int1 := 1;
  int2 := 0;
  int1 := int1 div int2;
end;

procedure TTestDivOp.CallZeroException();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @ZeroException;

  AssertException(EDivByZero, TempMethod);
end;


procedure TTestDivOp.Big();
var
  temp1, temp2: TIntXLibUInt32Array;
  int1, int2: TIntX;
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
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  AssertTrue(int1 div int2 = $FFFFFFFE);
end;


procedure TTestDivOp.Big2();
var
  int1, int2, int3, int4: TIntX;
begin
  int1 := TIntX.Create('4574586690780877990306040650779005020012387464357');
  int2 := TIntX.Create('856778798907978995905496597069809708960893');
  int3 := TIntX.Create('8567787989079799590496597069809708960893');
  int4 := int1 * int2 + int3;
  AssertTrue(int4 div int2 = int1);
  AssertTrue(int4 mod int2 = int3);
end;


procedure TTestDivOp.BigDec();
var
  int1, int2, res: TIntX;
begin
  int1 := TIntX.Create('100000000000000000000000000000000000000000000');
  int2 := TIntX.Create('100000000000000000000000000000000000000000');
  res := int1 div int2;
  AssertTrue(res = 1000);
end;


procedure TTestDivOp.BigDecNeg();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create('-100000000000000000000000000000000000000000000');
  int2 := TIntX.Create('100000000000000000000000000000000000000000');
  AssertTrue(int1 div int2 = -1000);
end;


initialization

  RegisterTest(TTestDivOp);
end.

