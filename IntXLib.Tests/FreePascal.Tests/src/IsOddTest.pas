unit IsOddTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestIsOdd }

  TTestIsOdd = class(TTestCase)
  published

    procedure ShouldBeFalseForZero();

    procedure ShouldBeFalseForEvenNumber();

    procedure ShouldBeTrueForOddNumber();

  end;

implementation


procedure TTestIsOdd.ShouldBeFalseForZero();
var
  Value: TIntX;
  Result: boolean;
begin
  Value := TIntX.Create(0);
  Result := Value.IsOdd;
  AssertFalse(Result);
end;


procedure TTestIsOdd.ShouldBeFalseForEvenNumber();
var
  Value: TIntX;
  Result: boolean;
begin
  Value := TIntX.Create(42);
  Result := Value.IsOdd;
  AssertFalse(Result);
end;

procedure TTestIsOdd.ShouldBeTrueForOddNumber();
var
  Value: TIntX;
  Result: boolean;
begin
  Value := TIntX.Create(57);
  Result := Value.IsOdd;
  AssertTrue(Result);
end;


initialization

  RegisterTest(TTestIsOdd);
end.

