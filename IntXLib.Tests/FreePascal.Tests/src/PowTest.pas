unit PowTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uEnums,
  uIntX;

type

  { TTestPow }

  TTestPow = class(TTestCase)
  published

    procedure Simple();

    procedure Zero();

    procedure PowZero();

    procedure PowOne();

    procedure Big();

  protected
    procedure SetUp; override;

  end;

implementation



{ TTestPow }


procedure TTestPow.Simple();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(-1);
  AssertTrue(TIntX.Pow(IntX, 17) = -1);
  AssertTrue(TIntX.Pow(IntX, 18) = 1);
end;


procedure TTestPow.Zero();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(0);
  AssertTrue(TIntX.Pow(IntX, 77) = 0);
end;


procedure TTestPow.PowZero();
begin
  AssertTrue(TIntX.Pow(0, 0) = 1);
end;


procedure TTestPow.PowOne();
begin
  AssertTrue(TIntX.Pow(7, 1) = 7);
end;


procedure TTestPow.Big();
begin
  AssertEquals('36893488147419103232', TIntX.Pow(2, 65).ToString());
end;

procedure TTestPow.SetUp;
begin
  inherited SetUp;
  TIntX.GlobalSettings.MultiplyMode := TMultiplyMode.mmClassic;
end;

initialization

  RegisterTest(TTestPow);
end.

