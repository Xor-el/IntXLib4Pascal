unit IntXZeroandOneTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TTIntXZeroandOneTest = class(TObject)
  public
    [Test]
    procedure IsCustomTIntXZeroEqualToZero();
    [Test]
    procedure IsCustomTIntXZeroEqualToNegativeZero();
    [Test]
    procedure IsCustomTIntXZeroEqualToNegativeZero2();
    [Test]
    procedure IsCustomTIntXOneEqualToOne();
  end;

implementation

[Test]
procedure TTIntXZeroandOneTest.IsCustomTIntXZeroEqualToZero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(0);
  Assert.IsTrue(int1 = TIntX.Zero);
  Assert.IsTrue(int1 = 0);
end;

[Test]
procedure TTIntXZeroandOneTest.IsCustomTIntXZeroEqualToNegativeZero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(-0);
  Assert.IsTrue(int1 = TIntX.Zero);
  Assert.IsTrue(int1 = 0);
end;

[Test]
procedure TTIntXZeroandOneTest.IsCustomTIntXZeroEqualToNegativeZero2();
var
  int1: TIntX;
begin
  int1 := TIntX.Create('-0');
  Assert.IsTrue(int1 = TIntX.Zero);
  Assert.IsTrue(int1 = 0);
end;

[Test]
procedure TTIntXZeroandOneTest.IsCustomTIntXOneEqualToOne();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(1);
  Assert.IsTrue(int1 = TIntX.One);
  Assert.IsTrue(int1 = 1);
end;

initialization

TDUnitX.RegisterTestFixture(TTIntXZeroandOneTest);

end.
