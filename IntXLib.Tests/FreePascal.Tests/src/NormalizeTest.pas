unit NormalizeTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestNormalize }

  TTestNormalize = class(TTestCase)
  published

    procedure Zero();

    procedure Simple();

  end;

implementation

procedure TTestNormalize.Zero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(7) - 7;
  int1.Normalize();
  AssertTrue(int1 = 0);
end;

procedure TTestNormalize.Simple();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(8);
  int1 := int1 * int1;
  int1.Normalize();
  AssertTrue(int1 = 64);
end;


initialization

  RegisterTest(TTestNormalize);
end.

