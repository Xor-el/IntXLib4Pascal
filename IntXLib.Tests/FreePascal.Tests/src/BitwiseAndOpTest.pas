unit BitwiseAndOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  { TTestBitwiseAndOp }

  TTestBitwiseAndOp = class(TTestCase)
  published

    procedure ShouldBitwiseAndTwoIntX();

    procedure ShouldBitwiseAndPositiveAndNegativeIntX();

    procedure ShouldBitwiseAndTwoNegativeIntX();

    procedure ShouldBitwiseAndIntXAndZero();

    procedure ShouldBitwiseAndTwoBigIntX();

  end;

implementation

procedure TTestBitwiseAndOp.ShouldBitwiseAndTwoIntX();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(11);
  int2 := TIntX.Create(13);

  Result := int1 and int2;
  AssertTrue(Result.Equals(9));
end;


procedure TTestBitwiseAndOp.ShouldBitwiseAndPositiveAndNegativeIntX();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(-11);
  int2 := TIntX.Create(13);

  Result := int1 and int2;
  AssertTrue(Result.Equals(9));
end;


procedure TTestBitwiseAndOp.ShouldBitwiseAndTwoNegativeIntX();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(-11);
  int2 := TIntX.Create(-13);

  Result := int1 and int2;
  AssertTrue(Result.Equals(-9));
end;


procedure TTestBitwiseAndOp.ShouldBitwiseAndIntXAndZero();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(11);
  int2 := TIntX.Create(0);

  Result := int1 and int2;

  AssertTrue(Result.Equals(0));
end;


procedure TTestBitwiseAndOp.ShouldBitwiseAndTwoBigIntX();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, Result: TIntX;
begin
  SetLength(temp1, 4);
  temp1[0] := 11;
  temp1[1] := 6;
  temp1[2] := TConstants.MaxUInt32Value;
  temp1[3] := TConstants.MaxUInt32Value;
  SetLength(temp2, 3);
  temp2[0] := 13;
  temp2[1] := 3;
  temp2[2] := 0;
  SetLength(temp3, 2);
  temp3[0] := 9;
  temp3[1] := 2;

  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);

  Result := int1 and int2;

  AssertTrue(Result.Equals(TIntX.Create(temp3, False)));
end;


initialization

  RegisterTest(TTestBitwiseAndOp);
end.

