unit UnaryOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TUnaryOpTest = class(TObject)
  public
    [Test]
    procedure Plus();
    [Test]
    procedure Minus();
    [Test]
    procedure ZeroPositive();
    [Test]
    procedure ZeroNegative();
    [Test]
    procedure Increment();
    [Test]
    procedure Decrement();
  end;

implementation

[Test]
procedure TUnaryOpTest.Plus();
var
  IntX: TIntX;
begin
  IntX := 77;
  Assert.IsTrue(IntX = +IntX);
end;

[Test]
procedure TUnaryOpTest.Minus();
var
  IntX: TIntX;
begin
  IntX := 77;
  Assert.IsTrue(-IntX = -77);
end;

[Test]
procedure TUnaryOpTest.ZeroPositive();
var
  IntX: TIntX;
begin
  IntX := 0;
  Assert.IsTrue(IntX = +IntX);
end;

[Test]
procedure TUnaryOpTest.ZeroNegative();
var
  IntX: TIntX;
begin
  IntX := 0;
  Assert.IsTrue(IntX = -IntX);

end;

[Test]
procedure TUnaryOpTest.Increment();
var
  IntX: TIntX;
begin
  IntX := 77;
  Assert.IsTrue(IntX = 77);
  Inc(IntX);
  Inc(IntX);
  Assert.IsTrue(IntX = 79);
end;

[Test]
procedure TUnaryOpTest.Decrement();
var
  IntX: TIntX;
begin
  IntX := 77;
  Assert.IsTrue(IntX = 77);
  Dec(IntX);
  Dec(IntX);
  Assert.IsTrue(IntX = 75);
end;

initialization

TDUnitX.RegisterTestFixture(TUnaryOpTest);

end.
