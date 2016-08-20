unit LCMOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TLCMOpTest = class(TObject)
  public
    [Test]
    procedure LCMIntXBothPositive();
    [Test]
    procedure LCMIntXBothNegative();
    [Test]
    procedure LCMIntXBothSigns();

  end;

implementation

procedure TLCMOpTest.LCMIntXBothPositive;
var
  res: TIntX;
begin
  res := TIntX.LCM(4, 6);
  Assert.IsTrue(res = 12);
  res := TIntX.LCM(24, 18);
  Assert.IsTrue(res = 72);
  res := TIntX.LCM(234, 100);
  Assert.IsTrue(res = 11700);
end;

procedure TLCMOpTest.LCMIntXBothNegative;
var
  res: TIntX;
begin
  res := TIntX.LCM(-4, -6);
  Assert.IsTrue(res = 12);
  res := TIntX.LCM(-24, -18);
  Assert.IsTrue(res = 72);
  res := TIntX.LCM(-234, -100);
  Assert.IsTrue(res = 11700);
end;

procedure TLCMOpTest.LCMIntXBothSigns;
var
  res: TIntX;
begin
  res := TIntX.LCM(-4, +6);
  Assert.IsTrue(res = 12);
  res := TIntX.LCM(+24, -18);
  Assert.IsTrue(res = 72);
  res := TIntX.LCM(-234, +100);
  Assert.IsTrue(res = 11700);
end;

initialization

TDUnitX.RegisterTestFixture(TLCMOpTest);

end.
