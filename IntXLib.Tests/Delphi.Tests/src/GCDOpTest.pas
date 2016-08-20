unit GCDOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TGCDOpTest = class(TObject)
  public
    [Test]
    procedure GCDIntXBothPositive();
    [Test]
    procedure GCDIntXBothNegative();
    [Test]
    procedure GCDIntXBothSigns();

  end;

implementation

procedure TGCDOpTest.GCDIntXBothPositive;
var
  res: TIntX;
begin
  res := TIntX.GCD(4, 6);
  Assert.IsTrue(res = 2);
  res := TIntX.GCD(24, 18);
  Assert.IsTrue(res = 6);
  res := TIntX.GCD(234, 100);
  Assert.IsTrue(res = 2);
  res := TIntX.GCD(235, 100);
  Assert.IsTrue(res = 5);
end;

procedure TGCDOpTest.GCDIntXBothNegative;
var
  res: TIntX;
begin
  res := TIntX.GCD(-4, -6);
  Assert.IsTrue(res = 2);
  res := TIntX.GCD(-24, -18);
  Assert.IsTrue(res = 6);
  res := TIntX.GCD(-234, -100);
  Assert.IsTrue(res = 2);
end;

procedure TGCDOpTest.GCDIntXBothSigns;
var
  res: TIntX;
begin
  res := TIntX.GCD(-4, +6);
  Assert.IsTrue(res = 2);
  res := TIntX.GCD(+24, -18);
  Assert.IsTrue(res = 6);
  res := TIntX.GCD(-234, +100);
  Assert.IsTrue(res = 2);
end;

initialization

TDUnitX.RegisterTestFixture(TGCDOpTest);

end.
