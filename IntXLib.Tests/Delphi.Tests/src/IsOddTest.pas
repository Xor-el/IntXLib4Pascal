unit IsOddTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TIsOddTest = class(TObject)
  public
    [Test]
    procedure ShouldBeFalseForZero();
    [Test]
    procedure ShouldBeFalseForEvenNumber();
    [Test]
    procedure ShouldBeTrueForOddNumber();
  end;

implementation

[Test]
procedure TIsOddTest.ShouldBeFalseForZero();
var
  value: TIntX;
  result: Boolean;
begin
  value := TIntX.Create(0);
  result := value.IsOdd;
  Assert.IsFalse(result);
end;

[Test]
procedure TIsOddTest.ShouldBeFalseForEvenNumber();
var
  value: TIntX;
  result: Boolean;
begin
  value := TIntX.Create(42);
  result := value.IsOdd;
  Assert.IsFalse(result);
end;

procedure TIsOddTest.ShouldBeTrueForOddNumber();
var
  value: TIntX;
  result: Boolean;
begin
  value := TIntX.Create(57);
  result := value.IsOdd;
  Assert.IsTrue(result);
end;

initialization

TDUnitX.RegisterTestFixture(TIsOddTest);

end.
