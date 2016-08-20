unit EqualsOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TEqualsOpTest = class(TObject)
  public
    [Test]
    procedure Equals2IntX();
    [Test]
    procedure EqualsZeroIntX();
    [Test]
    procedure EqualsIntIntX();
    [Test]
    procedure EqualsNullIntX();
    [Test]
    procedure Equals2IntXOp();
  end;

implementation

[Test]
procedure TEqualsOpTest.Equals2IntX();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(8);
  int2 := TIntX.Create(8);
  Assert.IsTrue(int1.Equals(int2));
end;

[Test]
procedure TEqualsOpTest.EqualsZeroIntX();
begin
  Assert.IsFalse(TIntX.Create(0) = 1);
end;

[Test]
procedure TEqualsOpTest.EqualsIntIntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(8);
  Assert.IsTrue(int1 = 8);
end;

[Test]
procedure TEqualsOpTest.EqualsNullIntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(8);
  Assert.IsFalse(int1 = Default (TIntX));
end;

[Test]
procedure TEqualsOpTest.Equals2IntXOp();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(8);
  int2 := TIntX.Create(8);
  Assert.IsTrue(int1 = int2);
end;

initialization

TDUnitX.RegisterTestFixture(TEqualsOpTest);

end.
