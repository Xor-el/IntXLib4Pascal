unit NormalizeTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TNormalizeTest = class(TObject)
  public
    [Test]
    procedure Zero();
    [Test]
    procedure Simple();
  end;

implementation

[Test]
procedure TNormalizeTest.Zero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(7) - 7;
  int1.Normalize();
  Assert.IsTrue(int1 = 0);
end;

[Test]
procedure TNormalizeTest.Simple();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(8);
  int1 := int1 * int1;
  int1.Normalize();
  Assert.IsTrue(int1 = 64);
end;

initialization

TDUnitX.RegisterTestFixture(TNormalizeTest);

end.
