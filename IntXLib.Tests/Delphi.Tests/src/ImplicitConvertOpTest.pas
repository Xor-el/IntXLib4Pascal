unit ImplicitConvertOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TImplicitConvertOpTest = class(TObject)
  public
    [Test]
    procedure ConvertAllExceptInt64();
    [Test]
    procedure ConvertInt64();
  end;

implementation

[Test]
procedure TImplicitConvertOpTest.ConvertAllExceptInt64();
var
  int1: TIntX;
begin
  int1 := Integer(0);
  Assert.IsTrue(int1 = 0);
  int1 := UInt32(0);
  Assert.IsTrue(int1 = 0);
  int1 := Byte(0);
  Assert.IsTrue(int1 = 0);
  int1 := ShortInt(0);
  Assert.IsTrue(int1 = 0);
  int1 := ShortInt(0);
  Assert.IsTrue(int1 = 0);
  int1 := Word(0);
  Assert.IsTrue(int1 = 0);
end;

[Test]
procedure TImplicitConvertOpTest.ConvertInt64();
var
  int1: TIntX;
begin
  int1 := Int64(0);
  Assert.IsTrue(int1 = 0);
  int1 := UInt64(0);
  Assert.IsTrue(int1 = 0);
  int1 := -123123123123;
  Assert.IsTrue(int1 = -123123123123);
end;

initialization

TDUnitX.RegisterTestFixture(TImplicitConvertOpTest);

end.
