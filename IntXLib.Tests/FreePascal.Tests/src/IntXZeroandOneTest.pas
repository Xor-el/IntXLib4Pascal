unit IntXZeroandOneTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestIntXZeroandOne }

  TTestIntXZeroandOne = class(TTestCase)
  published

    procedure IsCustomTIntXZeroEqualToZero();

    procedure IsCustomTIntXZeroEqualToNegativeZero();

    procedure IsCustomTIntXZeroEqualToNegativeZero2();

    procedure IsCustomTIntXOneEqualToOne();

  end;

implementation


procedure TTestIntXZeroandOne.IsCustomTIntXZeroEqualToZero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(0);
  AssertTrue(int1 = TIntX.Zero);
  AssertTrue(int1 = 0);
end;


procedure TTestIntXZeroandOne.IsCustomTIntXZeroEqualToNegativeZero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(-0);
  AssertTrue(int1 = TIntX.Zero);
  AssertTrue(int1 = 0);
end;


procedure TTestIntXZeroandOne.IsCustomTIntXZeroEqualToNegativeZero2();
var
  int1: TIntX;
begin
  int1 := TIntX.Create('-0');
  AssertTrue(int1 = TIntX.Zero);
  AssertTrue(int1 = 0);
end;


procedure TTestIntXZeroandOne.IsCustomTIntXOneEqualToOne();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(1);
  AssertTrue(int1 = TIntX.One);
  AssertTrue(int1 = 1);
end;


initialization

  RegisterTest(TTestIntXZeroandOne);
end.

