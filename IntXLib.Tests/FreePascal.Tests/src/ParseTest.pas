unit ParseTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX;

type

  { TTestParse }

  TTestParse = class(TTestCase)
  published

    procedure Zero();

    procedure WhiteSpace();

    procedure Sign();

    procedure Base();


    procedure CallNull();


    procedure CallInvalidFormat();


    procedure CallInvalidFormat2();


    procedure CallInvalidFormat3();

    procedure BigDec();

  private
    procedure Null();
    procedure InvalidFormat();
    procedure InvalidFormat2();
    procedure InvalidFormat3();

  end;

implementation


procedure TTestParse.Zero();
var
  int1: TIntX;
begin
  int1 := TIntX.Parse('0');
  AssertTrue(int1 = 0);
end;


procedure TTestParse.WhiteSpace();
var
  int1: TIntX;
begin
  int1 := TIntX.Parse('  7 ');
  AssertTrue(int1 = 7);
end;


procedure TTestParse.Sign();
var
  int1: TIntX;
begin
  int1 := TIntX.Parse('-7');
  AssertTrue(int1 = -7);
  int1 := TIntX.Parse('+7');
  AssertTrue(int1 = 7);
end;


procedure TTestParse.Base();
var
  int1: TIntX;
begin
  int1 := TIntX.Parse('abcdef', 16);
  AssertTrue(int1 = $ABCDEF);
  int1 := TIntX.Parse('100', 8);
  AssertTrue(int1 = 64);
  int1 := TIntX.Parse('0100');
  AssertTrue(int1 = 64);
  int1 := TIntX.Parse('0100000000000');
  AssertTrue(int1 = $200000000);
  int1 := TIntX.Parse('$abcdef');
  AssertTrue(int1 = $ABCDEF);
  int1 := TIntX.Parse('$ABCDEF');
  AssertTrue(int1 = $ABCDEF);
  int1 := TIntX.Parse('020000000000');
  AssertTrue(int1 = $80000000);
  int1 := TIntX.Parse('0xDEADBEEF');
  AssertTrue(int1 = $DEADBEEF);
  int1 := TIntX.Parse('0xdeadbeef');
  AssertTrue(int1 = $DEADBEEF);
  int1 := TIntX.Parse('0Xdeadbeef');
  AssertTrue(int1 = $DEADBEEF);
end;

procedure TTestParse.Null();
begin
  TIntX.Parse('');
end;


procedure TTestParse.CallNull();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @Null;

  AssertException(EArgumentNilException, TempMethod);
end;

procedure TTestParse.InvalidFormat();
begin
  TIntX.Parse('-123-');
end;


procedure TTestParse.CallInvalidFormat();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @InvalidFormat;

  AssertException(EFormatException, TempMethod);
end;

procedure TTestParse.InvalidFormat2();
begin
  TIntX.Parse('abc');
end;


procedure TTestParse.CallInvalidFormat2();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @InvalidFormat2;

  AssertException(EFormatException, TempMethod);
end;

procedure TTestParse.InvalidFormat3();
begin
  TIntX.Parse('987', 2);
end;


procedure TTestParse.CallInvalidFormat3();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @InvalidFormat3;

  AssertException(EFormatException, TempMethod);
end;


procedure TTestParse.BigDec();
var
  IntX: TIntX;
begin
  IntX := TIntX.Parse(
    '34589238954389567586547689234723587070897800300450823748275895896384753238944985');
  AssertEquals('34589238954389567586547689234723587070897800300450823748275895896384753238944985', IntX.ToString());
end;


initialization

  RegisterTest(TTestParse);
end.

