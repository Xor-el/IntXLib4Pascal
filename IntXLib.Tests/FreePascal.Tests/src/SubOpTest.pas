unit SubOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  { TTestSubOp }

  TTestSubOp = class(TTestCase)
  published

    procedure Sub2IntX();

    procedure Sub2IntXNeg();

    procedure SubIntIntX();

    procedure SubIntXInt();


    procedure CallSubNullIntX();

    procedure Sub0IntX();

    procedure Sub0IntXNeg();

    procedure Sub2BigIntX();

    procedure Sub2BigIntXC();

    procedure Sub2BigIntXC2();

    procedure Sub2BigIntXC3();

    procedure Sub2BigIntXC4();

    procedure Sub2BigIntXC5();

    procedure SubAdd();

  private
    procedure SubNullIntX();


  end;

implementation


procedure TTestSubOp.Sub2IntX();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(5);
  AssertTrue(int1 - int2 = -2);
end;


procedure TTestSubOp.Sub2IntXNeg();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(-5);
  AssertTrue(int1 - int2 = 2);
end;


procedure TTestSubOp.SubIntIntX();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(3);
  AssertTrue(IntX - 5 = -2);
end;


procedure TTestSubOp.SubIntXInt();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(3);
  AssertTrue(5 - IntX = 2);
end;

procedure TTestSubOp.SubNullIntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(3);

  int1 := int1 - Default (TIntX);
end;


procedure TTestSubOp.CallSubNullIntX();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @SubNullIntX;

  AssertException(EArgumentNilException, TempMethod);
end;


procedure TTestSubOp.Sub0IntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(3);
  AssertTrue(int1 - 0 = 3);
  AssertTrue(0 - int1 = -3);
  AssertTrue(TIntX.Create(0) - int1 = -3);
  AssertTrue(TIntX.Create(0) - 0 = 0);
end;


procedure TTestSubOp.Sub0IntXNeg();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(-3);
  AssertTrue(int1 - 0 = -3);
  AssertTrue(0 - int1 = 3);
  AssertTrue(int1 - TIntX.Create(0) = -3);
  AssertTrue(TIntX.Create(0) - int1 = 3);
end;


procedure TTestSubOp.Sub2BigIntX();
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
  temp3[0] := 2;
  temp3[1] := 2;
  temp3[2] := 2;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, True);
  AssertTrue(int1 - int2 = int3);
end;


procedure TTestSubOp.Sub2BigIntXC();
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
  AssertTrue(int1 = int3 - int2);
end;


procedure TTestSubOp.Sub2BigIntXC2();
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
  AssertTrue(int1 = int3 - int2);
end;


procedure TTestSubOp.Sub2BigIntXC3();
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
  AssertTrue(int1 = int3 - int2);
end;


procedure TTestSubOp.Sub2BigIntXC4();
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
  AssertTrue(int1 = int3 - int2);
end;


procedure TTestSubOp.Sub2BigIntXC5();
var
  int1, int2, int3: TIntX;
begin
  int1 := TIntX.Create('40000000000000000000000000000000000000000000000000000');
  int2 := TIntX.Create
    ('10666666666666666666666666666666666666666666666666666666');
  int3 := TIntX.Create
    ('-10626666666666666666666666666666666666666666666666666666');
  AssertTrue(int1 - int2 = int3);
end;


procedure TTestSubOp.SubAdd();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(2);
  int2 := TIntX.Create(-3);
  AssertTrue(int1 - int2 = 5);
end;


initialization

  RegisterTest(TTestSubOp);
end.

