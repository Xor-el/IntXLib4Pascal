unit BitwiseOrOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  [TestFixture]
  TBitwiseOrOpTest = class(TObject)
  public
    [Test]
    procedure ShouldBitwiseOrTwoIntX();
    [Test]
    procedure ShouldBitwiseOrPositiveAndNegativeIntX();
    [Test]
    procedure ShouldBitwiseOrTwoNegativeIntX();
    [Test]
    procedure ShouldBitwiseOrIntXAndZero();
    [Test]
    procedure ShouldBitwiseOrTwoBigIntX();
  end;

implementation

[Test]
procedure TBitwiseOrOpTest.ShouldBitwiseOrTwoIntX();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(5);

  result := int1 or int2;

  Assert.IsTrue(result.Equals(7));
end;

[Test]
procedure TBitwiseOrOpTest.ShouldBitwiseOrPositiveAndNegativeIntX();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(5);

  result := int1 or int2;

  Assert.IsTrue(result.Equals(-7));
end;

[Test]
procedure TBitwiseOrOpTest.ShouldBitwiseOrTwoNegativeIntX();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(-5);

  result := int1 or int2;
  Assert.IsTrue(result.Equals(-7));
end;

[Test]
procedure TBitwiseOrOpTest.ShouldBitwiseOrIntXAndZero();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(0);

  result := int1 or int2;

  Assert.IsTrue(result.Equals(int1));
end;

[Test]
procedure TBitwiseOrOpTest.ShouldBitwiseOrTwoBigIntX();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3, result: TIntX;
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

  result := int1 or int2;
  Assert.IsTrue(result.Equals(int3));

end;

initialization

TDUnitX.RegisterTestFixture(TBitwiseOrOpTest);

end.
