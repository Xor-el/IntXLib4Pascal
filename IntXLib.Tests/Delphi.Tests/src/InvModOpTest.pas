unit InvModOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TInvModTest = class(TObject)
  public
    [Test]
    procedure IntXBothPositive();

  end;

implementation

procedure TInvModTest.IntXBothPositive;
var
  res: TIntX;
begin
  res := TIntX.InvMod(123, 4567);
  Assert.IsTrue(res = 854);
  res := TIntX.InvMod(9876, 2457);
  Assert.IsTrue(res = 0); // zero means modular inverse does not exist.
end;

initialization

TDUnitX.RegisterTestFixture(TInvModTest);

end.
