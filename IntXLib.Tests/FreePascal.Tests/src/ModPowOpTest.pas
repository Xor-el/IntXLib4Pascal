unit ModPowOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestModPowOp }

  TTestModPowOp = class(TTestCase)
  published

    procedure ModPowIntX();

  end;

implementation



{ TTestModPowOp }

procedure TTestModPowOp.ModPowIntX;
var
  res: TIntX;
begin
 res := TIntX.ModPow(11, 13, 19);
  AssertTrue(res = 11);
  res := TIntX.ModPow(123, 4567, 789);
  AssertTrue(res = 687);
  res := TIntX.ModPow(9876, 2457, 6457);
  AssertTrue(res = 3238);
end;

initialization

  RegisterTest(TTestModPowOp);
end.

