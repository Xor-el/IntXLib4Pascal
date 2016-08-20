unit IsProbablyPrimeOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntX;

type

  [TestFixture]
  TIsProbablyPrimeOpTest = class(TObject)
  public
    [Test]
    procedure IsPrimeIntX();
    [Test]
    procedure IsNotPrimeIntX();
    [Test]
    procedure IsPrimeBigIntX();

  end;

implementation

procedure TIsProbablyPrimeOpTest.IsPrimeIntX();
begin
  Assert.IsTrue(TIntX.IsProbablyPrime(2));
  Assert.IsTrue(TIntX.IsProbablyPrime(373));
  Assert.IsTrue(TIntX.IsProbablyPrime(743));
  Assert.IsTrue(TIntX.IsProbablyPrime(991));
end;

procedure TIsProbablyPrimeOpTest.IsNotPrimeIntX();
begin
  Assert.IsFalse(TIntX.IsProbablyPrime(0));
  Assert.IsFalse(TIntX.IsProbablyPrime(1));
  Assert.IsFalse(TIntX.IsProbablyPrime(908));
  Assert.IsFalse(TIntX.IsProbablyPrime(992));
end;

procedure TIsProbablyPrimeOpTest.IsPrimeBigIntX();
var
  Prime: TIntX;
begin

  Prime := TIntX.Create
    ('40378229068348060265902071710277325464903647442059563624162746921011818446300065249638243017389009856122930741656904767');
  Assert.IsTrue(TIntX.IsProbablyPrime(Prime));
end;

initialization

TDUnitX.RegisterTestFixture(TIsProbablyPrimeOpTest);

end.
