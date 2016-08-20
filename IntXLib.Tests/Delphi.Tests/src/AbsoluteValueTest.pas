unit AbsoluteValueTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TAbsoluteValueTest = class(TObject)
  public
    [Test]
    procedure AbsoluteTest();
    [Test]
    procedure AbsoluteTestZero();
    procedure NullAbsoluteTest();

    [Test]
    procedure CallNullAbsoluteTest();
  end;

implementation

[Test]
procedure TAbsoluteValueTest.AbsoluteTest();
var
  int1, res: TIntX;
begin
  int1 := TIntX.Create(-5);
  res := TIntX.AbsoluteValue(int1);
  Assert.IsTrue(res = 5);
  res := TIntX.AbsoluteValue(-25);
  Assert.IsTrue(res = 25);
  res := TIntX.AbsoluteValue(TIntX.Parse('-500'));
  Assert.IsTrue(res = 500);
  int1 := TIntX.Create(10);
  res := TIntX.AbsoluteValue(int1);
  Assert.IsTrue(res = 10);
  res := TIntX.AbsoluteValue(80);
  Assert.IsTrue(res = 80);
  res := TIntX.AbsoluteValue(TIntX.Parse('900'));
  Assert.IsTrue(res = 900);
end;

[Test]
procedure TAbsoluteValueTest.AbsoluteTestZero();
var
  int1, res: TIntX;
begin
  int1 := TIntX.Create(-0);
  res := TIntX.AbsoluteValue(int1);
  Assert.IsTrue(res = 0);
  res := TIntX.AbsoluteValue(TIntX.Parse('-0'));
  Assert.IsTrue(res = 0);
  res := TIntX.AbsoluteValue(0);
  Assert.IsTrue(res = 0);
  res := TIntX.AbsoluteValue(TIntX.Parse('0'));
  Assert.IsTrue(res = 0);

end;

procedure TAbsoluteValueTest.NullAbsoluteTest();
begin
  TIntX.AbsoluteValue(Default (TIntX));
end;

[Test]
procedure TAbsoluteValueTest.CallNullAbsoluteTest();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := NullAbsoluteTest;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

initialization

TDUnitX.RegisterTestFixture(TAbsoluteValueTest);

end.
