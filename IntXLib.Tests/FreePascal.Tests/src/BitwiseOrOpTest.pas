unit BitwiseOrOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  { TTestBitwiseOrOp }

  TTestBitwiseOrOp = class(TTestCase)
  published

    procedure ShouldBitwiseOrTwoIntX();

    procedure ShouldBitwiseOrPositiveAndNegativeIntX();

    procedure ShouldBitwiseOrTwoNegativeIntX();

    procedure ShouldBitwiseOrIntXAndZero();

    procedure ShouldBitwiseOrTwoBigIntX();

  end;

implementation

procedure TTestBitwiseOrOp.ShouldBitwiseOrTwoIntX();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(5);

  Result := int1 or int2;
  AssertTrue(Result.Equals(7));
end;


procedure TTestBitwiseOrOp.ShouldBitwiseOrPositiveAndNegativeIntX();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(5);

  Result := int1 or int2;
  AssertTrue(Result.Equals(-7));
end;


procedure TTestBitwiseOrOp.ShouldBitwiseOrTwoNegativeIntX();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(-5);

  Result := int1 or int2;
  AssertTrue(Result.Equals(-7));
end;


procedure TTestBitwiseOrOp.ShouldBitwiseOrIntXAndZero();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(0);

  Result := int1 or int2;

  AssertTrue(Result.Equals(int1));
end;


procedure TTestBitwiseOrOp.ShouldBitwiseOrTwoBigIntX();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3, Result: TIntX;
begin
  SetLength(temp1, 3);
  temp1[0] := 3;
  temp1[1] := 5;
  temp1[2] := TConstants.MaxUInt32Value;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 8;
  SetLength(temp3, 3);
  temp3[0] := 3;
  temp3[1] := 13;
  temp3[2] := TConstants.MaxUInt32Value;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);

  Result := int1 or int2;
  AssertTrue(Result.Equals(int3));
end;


initialization

  RegisterTest(TTestBitwiseOrOp);
end.

