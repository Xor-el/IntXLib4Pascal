unit MulOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uEnums,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  { TTestMulOp }

  TTestMulOp = class(TTestCase)

  published

    procedure PureIntX();

    procedure PureIntXSign();

    procedure IntAndIntX();

    procedure Zero();

    procedure Big();

    procedure Big2();

    procedure Big3();

    procedure Performance();

  protected
    procedure SetUp; override;

  end;

implementation


procedure TTestMulOp.PureIntX();
begin
  AssertTrue(TIntX.Create(3) * TIntX.Create(5) = TIntX.Create(15));
end;


procedure TTestMulOp.PureIntXSign();
begin
  AssertTrue(TIntX.Create(-3) * TIntX.Create(5) = TIntX.Create(-15));
end;


procedure TTestMulOp.IntAndIntX();
begin
  AssertTrue(TIntX.Create(3) * 5 = 15);
end;


procedure TTestMulOp.Zero();
begin
  AssertTrue(0 * TIntX.Create(3) = 0);
end;


procedure TTestMulOp.Big();
var
  temp1, temp2, tempRes: TIntXLibUInt32Array;
  int1, int2, intRes: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := 1;
  temp1[1] := 1;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 1;
  SetLength(tempRes, 3);
  tempRes[0] := 1;
  tempRes[1] := 2;
  tempRes[2] := 1;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  intRes := TIntX.Create(tempRes, False);
  AssertTrue(int1 * int2 = intRes);
end;


procedure TTestMulOp.Big2();
var
  temp1, temp2, tempRes: TIntXLibUInt32Array;
  int1, int2, intRes: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := 1;
  temp1[1] := 1;
  SetLength(temp2, 1);
  temp2[0] := 2;
  SetLength(tempRes, 2);
  tempRes[0] := 2;
  tempRes[1] := 2;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  intRes := TIntX.Create(tempRes, False);
  AssertTrue(intRes = int1 * int2);
  AssertTrue(intRes = int2 * int1);
end;


procedure TTestMulOp.Big3();
var
  temp1, temp2, tempRes: TIntXLibUInt32Array;
  int1, int2, intRes: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := TConstants.MaxUInt32Value;
  temp1[1] := TConstants.MaxUInt32Value;
  SetLength(temp2, 2);
  temp2[0] := TConstants.MaxUInt32Value;
  temp2[1] := TConstants.MaxUInt32Value;
  SetLength(tempRes, 4);
  tempRes[0] := 1;
  tempRes[1] := 0;
  tempRes[2] := TConstants.MaxUInt32Value - 1;
  tempRes[3] := TConstants.MaxUInt32Value;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  intRes := TIntX.Create(tempRes, False);
  AssertTrue(int1 * int2 = intRes);
end;


procedure TTestMulOp.Performance();
var
  i: integer;
  temp1: TIntXLibUInt32Array;
  IntX, intX2: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := 0;
  temp1[1] := 1;
  IntX := TIntX.Create(temp1, False);
  intX2 := IntX;

  i := 0;
  while i <= Pred(1000) do
  begin
    intX2 := intX2 * IntX;
    Inc(i);
  end;
end;


procedure TTestMulOp.SetUp;
begin
  inherited SetUp;
  TIntX.GlobalSettings.MultiplyMode := TMultiplyMode.mmClassic;
end;

initialization

  RegisterTest(TTestMulOp);
end.
