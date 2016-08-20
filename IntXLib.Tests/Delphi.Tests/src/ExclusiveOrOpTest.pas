unit ExclusiveOrOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  [TestFixture]
  TExclusiveOrOpTest = class(TObject)
  public
    [Test]
    procedure ShouldExclusiveOrTwoIntX();
    [Test]
    procedure ShouldExclusiveOrPositiveAndNegativeIntX();
    [Test]
    procedure ShouldExclusiveOrTwoNegativeIntX();
    [Test]
    procedure ShouldExclusiveOrIntXAndZero();
    [Test]
    procedure ShouldExclusiveOrTwoBigIntX();
    [Test]
    procedure ShouldExclusiveOrTwoBigIntXOfDifferentLength();

  end;

implementation

[Test]
procedure TExclusiveOrOpTest.ShouldExclusiveOrTwoIntX();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(5);

  result := int1 xor int2;

  Assert.IsTrue(result.Equals(6));
end;

[Test]
procedure TExclusiveOrOpTest.ShouldExclusiveOrPositiveAndNegativeIntX();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(5);

  result := int1 xor int2;

  Assert.IsTrue(result.Equals(-6));
end;

[Test]
procedure TExclusiveOrOpTest.ShouldExclusiveOrTwoNegativeIntX();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(-5);

  result := int1 xor int2;

  Assert.IsTrue(result.Equals(6));
end;

[Test]
procedure TExclusiveOrOpTest.ShouldExclusiveOrIntXAndZero();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(0);

  result := int1 xor int2;

  Assert.IsTrue(result.Equals(int1));
end;

[Test]
procedure TExclusiveOrOpTest.ShouldExclusiveOrTwoBigIntX();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, result: TIntX;
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

  result := int1 xor int2;

  Assert.IsTrue(result.Equals(TIntX.Create(temp3, False)));
end;

[Test]
procedure TExclusiveOrOpTest.ShouldExclusiveOrTwoBigIntXOfDifferentLength();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, result: TIntX;
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

  result := int1 xor int2;

  Assert.IsTrue(result.Equals(TIntX.Create(temp3, False)));
end;

initialization

TDUnitX.RegisterTestFixture(TExclusiveOrOpTest);

end.
