unit AbsoluteValueTest;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX;

type

  { TTestAbsoluteValue }

  TTestAbsoluteValue = class(TTestCase)
  published
    procedure AbsoluteTest();
    procedure AbsoluteTestZero();
    procedure CallNullAbsoluteTest();

  private
    procedure NullAbsoluteTest();

  end;

implementation

procedure TTestAbsoluteValue.AbsoluteTest();
var
  int1, res: TIntX;
begin
  int1 := TIntX.Create(-5);
  res := TIntX.AbsoluteValue(int1);
  AssertTrue(res = 5);
  res := TIntX.AbsoluteValue(-25);
  AssertTrue(res = 25);
  res := TIntX.AbsoluteValue(TIntX.Parse('-500'));
  AssertTrue(res = 500);
  int1 := TIntX.Create(10);
  res := TIntX.AbsoluteValue(int1);
  AssertTrue(res = 10);
  res := TIntX.AbsoluteValue(80);
  AssertTrue(res = 80);
  res := TIntX.AbsoluteValue(TIntX.Parse('900'));
  AssertTrue(res = 900);
end;

procedure TTestAbsoluteValue.AbsoluteTestZero();
var
  int1, res: TIntX;
begin
  int1 := TIntX.Create(-0);
  res := TIntX.AbsoluteValue(int1);
  AssertTrue(res = 0);
  res := TIntX.AbsoluteValue(TIntX.Parse('-0'));
  AssertTrue(res = 0);
  res := TIntX.AbsoluteValue(0);
  AssertTrue(res = 0);
  res := TIntX.AbsoluteValue(TIntX.Parse('0'));
  AssertTrue(res = 0);
end;

procedure TTestAbsoluteValue.CallNullAbsoluteTest();
var
  TempMethod: TRunMethod;
begin

  TempMethod := @NullAbsoluteTest;

  AssertException(EArgumentNilException, TempMethod);

end;

procedure TTestAbsoluteValue.NullAbsoluteTest();
begin
  TIntX.AbsoluteValue(Default(TIntX));
end;


initialization

  RegisterTest(TTestAbsoluteValue);
end.

