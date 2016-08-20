unit AddOpTest;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  fpcunit,
  testregistry,
  uIntX,
  uConstants,
  uIntXLibTypes;

type

  { TTestAddOp }

  TTestAddOp = class(TTestCase)
  published

    procedure Add2IntX();

    procedure Add2IntXNeg();

    procedure AddIntIntX();

    procedure AddIntXInt();

    procedure CallAddNullIntX();

    procedure Add0IntX();

    procedure Add0IntXNeg();

    procedure Add2BigIntX();

    procedure Add2BigIntXC();

    procedure Add2BigIntXC2();

    procedure Add2BigIntXC3();

    procedure Add2BigIntXC4();

    procedure Fibon();

    procedure AddSub();

  private
    procedure AddNullIntX();

  end;

implementation

{ TTestAddOp }


procedure TTestAddOp.Add2IntX();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(5);
  AssertTrue(int1 + int2 = 8);
end;


procedure TTestAddOp.Add2IntXNeg();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(-5);
  AssertTrue(int1 + int2 = -8);
end;


procedure TTestAddOp.AddIntIntX();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(3);
  AssertTrue(IntX + 5 = 8);
end;


procedure TTestAddOp.AddIntXInt();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(3);
  AssertTrue(5 + IntX = 8);
end;

procedure TTestAddOp.AddNullIntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(3);

  int1 := int1 + Default(TIntX);
end;

procedure TTestAddOp.CallAddNullIntX();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @AddNullIntX;

  AssertException(EArgumentNilException, TempMethod);
end;


procedure TTestAddOp.Add0IntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(3);
  AssertTrue(int1 + 0 = 3);
  AssertTrue(int1 + TIntX.Create(0) = 3);
end;


procedure TTestAddOp.Add0IntXNeg();
var
  int1, tempIntX: TIntX;
begin
  int1 := TIntX.Create(-3);
  AssertTrue(int1 + 0 = -3);
  AssertTrue(int1 + TIntX.Create(0) = -3);
  tempIntX := TIntX.Create(-1);
  AssertTrue((TIntX.Create(0) + tempIntX) = -1);
  AssertTrue(TIntX.Create(0) + 0 = 0);
end;


procedure TTestAddOp.Add2BigIntX();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3: TIntX;
begin
  SetLength(temp1, 3);
  temp1[0] := 1;
  temp1[1] := 2;
  temp1[2] := 3;
  SetLength(temp2, 3);
  temp2[0] := 3;
  temp2[1] := 4;
  temp2[2] := 5;
  SetLength(temp3, 3);
  temp3[0] := 4;
  temp3[1] := 6;
  temp3[2] := 8;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);
  AssertTrue(int1 + int2 = int3);
end;


procedure TTestAddOp.Add2BigIntXC();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := TConstants.MaxUInt32Value;
  temp1[1] := TConstants.MaxUInt32Value - 1;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 1;
  SetLength(temp3, 3);
  temp3[0] := 0;
  temp3[1] := 0;
  temp3[2] := 1;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);
  AssertTrue(int1 + int2 = int3);
end;


procedure TTestAddOp.Add2BigIntXC2();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := TConstants.MaxUInt32Value - 1;
  temp1[1] := TConstants.MaxUInt32Value - 1;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 1;
  SetLength(temp3, 2);
  temp3[0] := TConstants.MaxUInt32Value;
  temp3[1] := TConstants.MaxUInt32Value;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);
  AssertTrue(int1 + int2 = int3);
end;


procedure TTestAddOp.Add2BigIntXC3();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := TConstants.MaxUInt32Value;
  temp1[1] := TConstants.MaxUInt32Value;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 1;
  SetLength(temp3, 3);
  temp3[0] := 0;
  temp3[1] := 1;
  temp3[2] := 1;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);
  AssertTrue(int1 + int2 = int3);
end;


procedure TTestAddOp.Add2BigIntXC4();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3: TIntX;
begin
  SetLength(temp1, 4);
  temp1[0] := TConstants.MaxUInt32Value;
  temp1[1] := TConstants.MaxUInt32Value;
  temp1[2] := 1;
  temp1[3] := 1;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 1;
  SetLength(temp3, 4);
  temp3[0] := 0;
  temp3[1] := 1;
  temp3[2] := 2;
  temp3[3] := 1;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);
  AssertTrue(int1 + int2 = int3);
end;


procedure TTestAddOp.Fibon();
var
  int1, int2, int3: TIntX;
  i: integer;
begin
  int1 := TIntX.Create(1);
  int2 := int1;
  int3 := Default(TIntX);

  i := 0;
  while i <= Pred(10000) do
  begin
    int3 := int1 + int2;
    int1 := int2;
    int2 := int3;
    Inc(i);
  end;

end;


procedure TTestAddOp.AddSub();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(2);
  int2 := TIntX.Create(-2);
  AssertTrue(int1 + int2 = 0);
end;

initialization

  RegisterTest(TTestAddOp);
end.

