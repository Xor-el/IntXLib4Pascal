unit BezoutsIdentityOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestBezoutsIdentityOp }

  TTestBezoutsIdentityOp = class(TTestCase)
  published

     procedure BezIntX();

  end;

implementation

{ TTestBezoutsIdentityOp }

procedure TTestBezoutsIdentityOp.BezIntX();
var
  gcd, bez1, bez2: TIntX;
begin
  gcd := TIntX.Bezoutsidentity(421, 111, bez1, bez2);
  AssertTrue(bez1 = -29);
  AssertTrue(bez2 = 110);
  AssertTrue(gcd = 1);

  gcd := TIntX.Bezoutsidentity(93, 219, bez1, bez2);
  AssertTrue(bez1 = 33);
  AssertTrue(bez2 = -14);
  AssertTrue(gcd = 3);
end;

initialization

  RegisterTest(TTestBezoutsIdentityOp);
end.

