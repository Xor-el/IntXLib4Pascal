unit InvModOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestInvModOp }

  TTestInvModOp = class(TTestCase)
  published

    procedure IntXBothPositive();

  end;

implementation



{ TTestInvModOp }

procedure TTestInvModOp.IntXBothPositive;
var
  res: TIntX;
begin
 res := TIntX.InvMod(123, 4567);
  AssertTrue(res = 854);
  res := TIntX.InvMod(9876, 2457);
  AssertTrue(res = 0); // zero means modular inverse does not exist.
end;

initialization

  RegisterTest(TTestInvModOp);
end.

