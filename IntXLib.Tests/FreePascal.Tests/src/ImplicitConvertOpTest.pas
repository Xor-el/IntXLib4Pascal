unit ImplicitConvertOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntX;

type

  { TTestImplicitConvertOp }

  TTestImplicitConvertOp = class(TTestCase)
  published

    procedure ConvertAllExceptInt64();

    procedure ConvertInt64();

  end;

implementation


procedure TTestImplicitConvertOp.ConvertAllExceptInt64();
var
  int1: TIntX;
begin
  int1 := Integer(0);
  AssertTrue(int1 = 0);
  int1 := UInt32(0);
  AssertTrue(int1 = 0);
  int1 := Byte(0);
  AssertTrue(int1 = 0);
  int1 := ShortInt(0);
  AssertTrue(int1 = 0);
  int1 := ShortInt(0);
  AssertTrue(int1 = 0);
  int1 := Word(0);
  AssertTrue(int1 = 0);
end;

procedure TTestImplicitConvertOp.ConvertInt64();
var
  int1: TIntX;
begin
  int1 := Int64(0);
  AssertTrue(int1 = 0);
  int1 := UInt64(0);
  AssertTrue(int1 = 0);
  int1 := -123123123123;
  AssertTrue(int1 = -123123123123);
end;


initialization

  RegisterTest(TTestImplicitConvertOp);
end.

