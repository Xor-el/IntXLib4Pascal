unit LogNTest;

interface

uses
  DUnitX.TestFramework,
  Math,
  uIntX;

type

  [TestFixture]
  TLogNTest = class(TObject)
  public
    [Test]
    procedure LogNBase10();
    [Test]
    procedure LogNBase2();
  end;

implementation

[Test]
procedure TLogNTest.LogNBase10();
var
  based, numberd, ans: Double;
  number: TIntX;
begin
  based := 10;
  number := 100;
  numberd := 100;
  ans := Math.LogN(based, numberd);
  Assert.IsTrue(TIntX.LogN(based, number) = ans);

  number := 10;
  numberd := 10;
  ans := Math.LogN(based, numberd);
  Assert.IsTrue(TIntX.LogN(based, number) = ans);

  number := 500;
  numberd := 500;
  ans := Math.LogN(based, numberd);
  Assert.IsTrue(TIntX.LogN(based, number) = ans);

  number := 1000;
  numberd := 1000;
  ans := Math.LogN(based, numberd);
  Assert.IsTrue(TIntX.LogN(based, number) = ans);

end;

[Test]
procedure TLogNTest.LogNBase2();
var
  based, numberd, ans: Double;
  number: TIntX;
begin
  based := 2;
  number := 100;
  numberd := 100;
  ans := Math.LogN(based, numberd);
  Assert.IsTrue(TIntX.LogN(based, number) = ans);

  number := 10;
  numberd := 10;
  ans := Math.LogN(based, numberd);
  Assert.IsTrue(TIntX.LogN(based, number) = ans);

  number := 500;
  numberd := 500;
  ans := Math.LogN(based, numberd);
  Assert.IsTrue(TIntX.LogN(based, number) = ans);

  number := 1000;
  numberd := 1000;
  ans := Math.LogN(based, numberd);
  Assert.IsTrue(TIntX.LogN(based, number) = ans);

  number := TIntX.One shl 64 shl High(Int32);

  Assert.IsTrue(TIntX.LogN(based, number) = 2147483711);
end;

initialization

TDUnitX.RegisterTestFixture(TLogNTest);

end.
