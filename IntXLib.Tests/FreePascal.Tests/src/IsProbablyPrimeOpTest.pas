unit IsProbablyPrimeOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestIsProbablyPrimeOp }

  TTestIsProbablyPrimeOp = class(TTestCase)
  published


    procedure IsPrimeIntX();

    procedure IsNotPrimeIntX();

    procedure IsPrimeBigIntX();

  end;

implementation

{ TTestIsProbablyPrimeOp }

procedure TTestIsProbablyPrimeOp.IsPrimeIntX();
begin
  AssertTrue(TIntX.IsProbablyPrime(2));
  AssertTrue(TIntX.IsProbablyPrime(373));
  AssertTrue(TIntX.IsProbablyPrime(743));
  AssertTrue(TIntX.IsProbablyPrime(991));
end;

procedure TTestIsProbablyPrimeOp.IsNotPrimeIntX();
begin
  AssertFalse(TIntX.IsProbablyPrime(0));
  AssertFalse(TIntX.IsProbablyPrime(1));
  AssertFalse(TIntX.IsProbablyPrime(908));
  AssertFalse(TIntX.IsProbablyPrime(992));
end;

procedure TTestIsProbablyPrimeOp.IsPrimeBigIntX();
var
  Prime: TIntX;
begin

  Prime := TIntX.Create(
    '4037822906834806026590207171027732546490364744205956362416274692101181' +
    '8446300065249638243017389009856122930741656904767');
  AssertTrue(TIntX.IsProbablyPrime(Prime));
end;

initialization

  RegisterTest(TTestIsProbablyPrimeOp);
end.

