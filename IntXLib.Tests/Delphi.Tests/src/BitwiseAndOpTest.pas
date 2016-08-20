unit BitwiseAndOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  [TestFixture]
  TBitwiseAndOpTest = class(TObject)
  public
    [Test]
    procedure ShouldBitwiseAndTwoIntX();
    [Test]
    procedure ShouldBitwiseAndPositiveAndNegativeIntX();
    [Test]
    procedure ShouldBitwiseAndTwoNegativeIntX();
    [Test]
    procedure ShouldBitwiseAndIntXAndZero();
    [Test]
    procedure ShouldBitwiseAndTwoBigIntX();
  end;

implementation

[Test]
procedure TBitwiseAndOpTest.ShouldBitwiseAndTwoIntX();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(11);
  int2 := TIntX.Create(13);

  result := int1 and int2;
  Assert.IsTrue(result.Equals(9));
end;

[Test]
procedure TBitwiseAndOpTest.ShouldBitwiseAndPositiveAndNegativeIntX();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(-11);
  int2 := TIntX.Create(13);

  result := int1 and int2;
  Assert.IsTrue(result.Equals(9));
end;

[Test]
procedure TBitwiseAndOpTest.ShouldBitwiseAndTwoNegativeIntX();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(-11);
  int2 := TIntX.Create(-13);

  result := int1 and int2;
  Assert.IsTrue(result.Equals(-9));
end;

[Test]
procedure TBitwiseAndOpTest.ShouldBitwiseAndIntXAndZero();
var
  int1, int2, result: TIntX;
begin
  int1 := TIntX.Create(11);
  int2 := TIntX.Create(0);

  result := int1 and int2;

  Assert.IsTrue(result.Equals(0));
end;

[Test]
procedure TBitwiseAndOpTest.ShouldBitwiseAndTwoBigIntX();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, result: TIntX;
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

  result := int1 and int2;

  Assert.IsTrue(result.Equals(TIntX.Create(temp3, False)));
end;

initialization

TDUnitX.RegisterTestFixture(TBitwiseAndOpTest);

end.
