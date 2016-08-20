unit ExclusiveOrOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  { TTestExclusiveOrOp }

  TTestExclusiveOrOp = class(TTestCase)
  published


    procedure ShouldExclusiveOrTwoIntX();

    procedure ShouldExclusiveOrPositiveAndNegativeIntX();

    procedure ShouldExclusiveOrTwoNegativeIntX();

    procedure ShouldExclusiveOrIntXAndZero();

    procedure ShouldExclusiveOrTwoBigIntX();

    procedure ShouldExclusiveOrTwoBigIntXOfDifferentLength();

  end;

implementation



procedure TTestExclusiveOrOp.ShouldExclusiveOrTwoIntX();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(5);

  Result := int1 xor int2;

  AssertTrue(Result.Equals(6));
end;


procedure TTestExclusiveOrOp.ShouldExclusiveOrPositiveAndNegativeIntX();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(5);

  Result := int1 xor int2;

  AssertTrue(Result.Equals(-6));
end;


procedure TTestExclusiveOrOp.ShouldExclusiveOrTwoNegativeIntX();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(-5);

  Result := int1 xor int2;

  AssertTrue(Result.Equals(6));
end;


procedure TTestExclusiveOrOp.ShouldExclusiveOrIntXAndZero();
var
  int1, int2, Result: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(0);

  Result := int1 xor int2;

  AssertTrue(Result.Equals(int1));
end;


procedure TTestExclusiveOrOp.ShouldExclusiveOrTwoBigIntX();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, Result: TIntX;
begin
  SetLength(temp1, 3);
  temp1[0] := 3;
  temp1[1] := 5;
  temp1[2] := TConstants.MaxUInt32Value;
  SetLength(temp2, 3);
  temp2[0] := 1;
  temp2[1] := 8;
  temp2[2] := TConstants.MaxUInt32Value;
  SetLength(temp3, 2);
  temp3[0] := 2;
  temp3[1] := 13;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);

  Result := int1 xor int2;

  AssertTrue(Result.Equals(TIntX.Create(temp3, False)));
end;


procedure TTestExclusiveOrOp.ShouldExclusiveOrTwoBigIntXOfDifferentLength();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, Result: TIntX;
begin
  SetLength(temp1, 4);
  temp1[0] := 3;
  temp1[1] := 5;
  temp1[2] := TConstants.MaxUInt32Value;
  temp1[3] := TConstants.MaxUInt32Value;
  SetLength(temp2, 3);
  temp2[0] := 1;
  temp2[1] := 8;
  temp2[2] := TConstants.MaxUInt32Value;
  SetLength(temp3, 4);
  temp3[0] := 2;
  temp3[1] := 13;
  temp3[2] := 0;
  temp3[3] := TConstants.MaxUInt32Value;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);

  Result := int1 xor int2;

  AssertTrue(Result.Equals(TIntX.Create(temp3, False)));
end;


initialization

  RegisterTest(TTestExclusiveOrOp);
end.


