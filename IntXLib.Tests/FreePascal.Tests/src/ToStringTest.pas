unit ToStringTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  SysUtils,
  uIntX,
  uConstants;

type

  { TTestToString }

  TTestToString = class(TTestCase)
  published

    procedure VerySimple();

    procedure Simple();

    procedure Zero();

    procedure Neg();

    procedure Big();

    procedure Binary();

    procedure Octal();

    procedure Octal2();

    procedure Octal3();

    procedure Hex();

    procedure HexLower();

    procedure OtherBase();

  end;

implementation


procedure TTestToString.VerySimple();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(11);
  AssertEquals('11', IntX.ToString());
end;


procedure TTestToString.Simple();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(12345670);
  AssertEquals('12345670', IntX.ToString());
end;


procedure TTestToString.Zero();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(0);
  AssertEquals('0', IntX.ToString());
end;


procedure TTestToString.Neg();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(TConstants.MinIntValue);
  AssertEquals(InttoStr(TConstants.MinIntValue), IntX.ToString());
end;


procedure TTestToString.Big();
var
  IntX: TIntX;
  Int64X: Int64;
begin
  IntX := TIntX.Create(TConstants.MaxIntValue);
  IntX := IntX + IntX + IntX + IntX + IntX + IntX + IntX + IntX;
  Int64X := TConstants.MaxIntValue;
  Int64X := Int64X + Int64X + Int64X + Int64X + Int64X + Int64X +
    Int64X + Int64X;
  AssertEquals(IntX.ToString(), InttoStr(Int64X));
end;


procedure TTestToString.Binary();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(19);
  AssertEquals('10011', IntX.ToString(2));
end;


procedure TTestToString.Octal();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(100);
  AssertEquals('144', IntX.ToString(8));
end;


procedure TTestToString.Octal2();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(901);
  AssertEquals('1605', IntX.ToString(8));
end;


procedure TTestToString.Octal3();
var
  IntX: TIntX;
begin
  IntX := $80000000;
  AssertEquals('20000000000', IntX.ToString(8));
  IntX := $100000000;
  AssertEquals('40000000000', IntX.ToString(8));
end;


procedure TTestToString.Hex();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create($ABCDEF);
  AssertEquals('ABCDEF', IntX.ToString(16));
end;


procedure TTestToString.HexLower();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create($FF00FF00FF00FF);
  AssertEquals('ff00ff00ff00ff', IntX.ToString(16, False));
end;


procedure TTestToString.OtherBase();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(-144);
  AssertEquals('-{1}{4}', IntX.ToString(140));
end;


initialization

  RegisterTest(TTestToString);
end.

