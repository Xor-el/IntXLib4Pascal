unit OnesComplementOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uConstants,
  uIntX;

type

  [TestFixture]
  TOnesComplementOpTest = class(TObject)
  public
    [Test]
    procedure ShouldOnesComplementIntX();
    [Test]
    procedure ShouldOnesComplementNegativeIntX();
    [Test]
    procedure ShouldOnesComplementZero();
    [Test]
    procedure ShouldOnesComplementBigIntX();
  end;

implementation

[Test]
procedure TOnesComplementOpTest.ShouldOnesComplementIntX();
var
  value, result: TIntX;
  val: UInt32;
begin
  val := 11;
  value := TIntX.Create(11);
  result := not value;
  Assert.IsTrue(result = -not val);
end;

[Test]
procedure TOnesComplementOpTest.ShouldOnesComplementNegativeIntX();
var
  value, result: TIntX;
  val: UInt32;
begin
  val := 11;
  value := TIntX.Create(-11);
  result := not value;
  Assert.IsTrue(result = not val);
end;

[Test]
procedure TOnesComplementOpTest.ShouldOnesComplementZero();
var
  value, result: TIntX;
begin
  value := TIntX.Create(0);
  result := not value;
  Assert.IsTrue(result = 0);
end;

[Test]
procedure TOnesComplementOpTest.ShouldOnesComplementBigIntX();
var
  temp1, temp2: TIntXLibUInt32Array;
  value, result: TIntX;
begin
  SetLength(temp1, 3);
  temp1[0] := 3;
  temp1[1] := 5;
  temp1[2] := TConstants.MaxUInt32Value;
  SetLength(temp2, 2);
  temp2[0] := UInt32(not UInt32(3));
  temp2[1] := UInt32(not UInt32(5));
  value := TIntX.Create(temp1, False);
  result := not value;
  Assert.IsTrue(result = TIntX.Create(temp2, True));
end;

initialization

TDUnitX.RegisterTestFixture(TOnesComplementOpTest);

end.
