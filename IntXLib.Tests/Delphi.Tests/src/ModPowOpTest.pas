unit ModPowOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TModPowOpTest = class(TObject)
  public
    [Test]
    procedure ModPowIntX();

  end;

implementation

procedure TModPowOpTest.ModPowIntX();
var
  res: TIntX;
begin
  res := TIntX.ModPow(11, 13, 19);
  Assert.IsTrue(res = 11);
  res := TIntX.ModPow(123, 4567, 789);
  Assert.IsTrue(res = 687);
  res := TIntX.ModPow(9876, 2457, 6457);
  Assert.IsTrue(res = 3238);
end;

initialization

TDUnitX.RegisterTestFixture(TModPowOpTest);

end.
