unit BezoutsIdentityOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TBezoutsIdentityOpTest = class(TObject)
  public
    [Test]
    procedure BezIntX();

  end;

implementation

procedure TBezoutsIdentityOpTest.BezIntX();
var
  gcd, bez1, bez2: TIntX;
begin
  gcd := TIntX.Bezoutsidentity(421, 111, bez1, bez2);
  Assert.IsTrue(bez1 = -29);
  Assert.IsTrue(bez2 = 110);
  Assert.IsTrue(gcd = 1);

  gcd := TIntX.Bezoutsidentity(93, 219, bez1, bez2);
  Assert.IsTrue(bez1 = 33);
  Assert.IsTrue(bez2 = -14);
  Assert.IsTrue(gcd = 3);

end;

initialization

TDUnitX.RegisterTestFixture(TBezoutsIdentityOpTest);

end.
