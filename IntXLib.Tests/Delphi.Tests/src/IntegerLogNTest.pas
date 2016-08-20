unit IntegerLogNTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TIntegerLogNTest = class(TObject)
  public
    [Test]
    procedure LogNBase10();
    [Test]
    procedure LogNBase2();
  end;

implementation

[Test]
procedure TIntegerLogNTest.LogNBase10();
var
  base, number: TIntX;
begin
  base := 10;
  number := 100;
  Assert.IsTrue(TIntX.IntegerLogN(base, number) = 2);
  base := TIntX.Create(10);
  number := TIntX.Create(10);
  Assert.IsTrue(TIntX.IntegerLogN(base, number) = 1);
  base := TIntX.Create(10);
  number := TIntX.Create(500);
  Assert.IsTrue(TIntX.IntegerLogN(base, number) = 2);
  base := TIntX.Create(10);
  number := TIntX.Create(1000);
  Assert.IsTrue(TIntX.IntegerLogN(base, number) = 3);
end;

[Test]
procedure TIntegerLogNTest.LogNBase2();
var
  base, number: TIntX;
begin
  base := 2;
  number := 100;
  Assert.IsTrue(TIntX.IntegerLogN(base, number) = 6);
  base := TIntX.Create(2);
  number := TIntX.Create(10);
  Assert.IsTrue(TIntX.IntegerLogN(base, number) = 3);
  base := TIntX.Create(2);
  number := TIntX.Create(500);
  Assert.IsTrue(TIntX.IntegerLogN(base, number) = 8);
  base := TIntX.Create(2);
  number := TIntX.Create(1000);
  Assert.IsTrue(TIntX.IntegerLogN(base, number) = 9);
end;

initialization

TDUnitX.RegisterTestFixture(TIntegerLogNTest);

end.
