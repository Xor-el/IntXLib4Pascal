unit ExplicitConvertOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  Math,
  SysUtils,
  uIntXLibTypes,
  uIntX;

type

  { TTestExplicitConvertOp }

  TTestExplicitConvertOp = class(TTestCase)
  published

    procedure ConvertToInteger();

    procedure ConvertToUInt32();

    procedure ConvertToInt64();

    procedure ConvertToUInt64();

    procedure ConvertToDouble();

    procedure ConvertToWord();


    procedure CallConvertNullToInteger();


    procedure CallConvertNullToUInt32();



    procedure CallConvertNullToInt64();


    procedure CallConvertNullToUInt64();


    procedure CallConvertNullToWord();


    procedure CallConvertNullToDouble();

  private
    procedure ConvertNullToInteger();
    procedure ConvertNullToUInt32();
    procedure ConvertNullToInt64();
    procedure ConvertNullToUInt64();
    procedure ConvertNullToWord();
    procedure ConvertNullToDouble();

  end;

implementation


procedure TTestExplicitConvertOp.ConvertToInteger();
var
  temp: TIntXLibUInt32Array;
  n: integer;
  IntX: TIntX;
  un: UInt32;
begin
  n := 1234567890;
  IntX := n;
  AssertEquals(integer(IntX), n);

  n := -n;
  IntX := n;
  AssertEquals(integer(IntX), n);

  n := 0;
  IntX := n;
  AssertEquals(integer(IntX), n);

  n := 1234567890;
  un := UInt32(n);
  SetLength(temp, 3);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;
  IntX := TIntX.Create(temp, False);
  AssertEquals(integer(IntX), n);
  IntX := TIntX.Create(temp, True);
  AssertEquals(integer(IntX), -n);
end;


procedure TTestExplicitConvertOp.ConvertToUInt32();
var
  temp: TIntXLibUInt32Array;
  IntX: TIntX;
  n: UInt32;
begin
  n := 1234567890;
  IntX := n;
  AssertEquals(UInt32(IntX), n);

  n := 0;
  IntX := n;
  AssertEquals(UInt32(IntX), n);

  n := 1234567890;
  SetLength(temp, 3);
  temp[0] := n;
  temp[1] := n;
  temp[2] := n;
  IntX := TIntX.Create(temp, False);
  AssertEquals(UInt32(IntX), n);
end;


procedure TTestExplicitConvertOp.ConvertToInt64();
var
  temp: TIntXLibUInt32Array;
  IntX: TIntX;
  n: int64;
  un: UInt32;
  ni: integer;
begin
  n := 1234567890123456789;
  IntX := n;
  AssertEquals(int64(IntX), n);

  n := -n;
  IntX := n;
  AssertEquals(int64(IntX), n);

  n := 0;
  IntX := n;
  AssertEquals(int64(IntX), n);

  un := 1234567890;
  n := int64((un or UInt64(un) shl 32));
  SetLength(temp, 5);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;
  temp[3] := un;
  temp[4] := un;
  IntX := TIntX.Create(temp, False);
  AssertEquals(int64(IntX), n);
  IntX := TIntX.Create(temp, True);
  AssertEquals(int64(IntX), -n);

  ni := 1234567890;
  n := ni;
  IntX := ni;
  AssertEquals(int64(IntX), n);
end;


procedure TTestExplicitConvertOp.ConvertToUInt64();
var
  temp: TIntXLibUInt32Array;
  IntX: TIntX;
  n: UInt64;
  un: UInt32;
begin
  n := 1234567890123456789;
  IntX := n;
  AssertTrue(n = UInt64(IntX));

  n := 0;
  IntX := n;
  AssertTrue(n = UInt64(IntX));

  un := 1234567890;
  n := un or UInt64(un) shl 32;
  SetLength(temp, 5);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;
  temp[3] := un;
  temp[4] := un;
  IntX := TIntX.Create(temp, False);
  AssertTrue(n = UInt64(IntX));

  n := un;
  IntX := un;
  AssertTrue(n = UInt64(IntX));
end;

procedure TTestExplicitConvertOp.ConvertToDouble;
var
  IntX: TIntX;
  d: double;
begin
  d := 1.7976931348623157E+308;
  IntX := TIntX.Create(d);
  AssertEquals
  ('17976931348623157081452742373170435679807056752584499659891747680315726078002853876058955863276687817154045895351438246423432132688946418276846754670353751' + '6986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368',
    IntX.ToString());
  d := double(IntX);
  AssertEquals('1.79769313486232E308', FloatToStr(d));

  d := -1.7976931348623157E+308;
  IntX := TIntX.Create(d);
  AssertEquals
  ('-17976931348623157081452742373170435679807056752584499659891747680315726078002853876058955863276687817154045895351438246423432132688946418276846754670353751' + '6986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368',
    IntX.ToString());
  d := double(IntX);
  AssertEquals('-1.79769313486232E308', FloatToStr(d));

  d := 1.7976931348623157E+308;
  IntX := TIntX.Create(d) + TIntX.Create(d);
  d := double(IntX);
  AssertTrue(d = Infinity);

  d := -1.7976931348623157E+308;
  IntX := TIntX.Create(d) + TIntX.Create(d);
  d := double(IntX);
  AssertTrue(d = NegInfinity);

  IntX := TIntX.Create(0);
  d := double(IntX);
  AssertTrue(d = 0);

  d := 9007199254740993;
  IntX := TIntX.Create(d);
  d := double(IntX);
  AssertTrue(d = 9007199254740992);
end;


procedure TTestExplicitConvertOp.ConvertToWord();
var
  n: word;
  IntX: TIntX;
begin
  n := 12345;
  IntX := n;
  AssertEquals(n, word(IntX));

  n := 0;
  IntX := n;
  AssertEquals(n, word(IntX));
end;

procedure TTestExplicitConvertOp.ConvertNullToInteger();
var
  {%H-}LVariable: integer;
begin

  LVariable := integer(TIntX(Default(TIntX)));
end;



procedure TTestExplicitConvertOp.CallConvertNullToInteger();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @ConvertNullToInteger;

  AssertException(EArgumentNilException, TempMethod);
end;

procedure TTestExplicitConvertOp.ConvertNullToUInt32();
var
  {%H-}LVariable: UInt32;
begin

  LVariable := UInt32(TIntX(Default(TIntX)));
end;



procedure TTestExplicitConvertOp.CallConvertNullToUInt32();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @ConvertNullToUInt32;

  AssertException(EArgumentNilException, TempMethod);
end;

procedure TTestExplicitConvertOp.ConvertNullToInt64();
var
  {%H-}LVariable: int64;
begin

  LVariable := int64(TIntX(Default(TIntX)));
end;

procedure TTestExplicitConvertOp.CallConvertNullToInt64();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @ConvertNullToInt64;

  AssertException(EArgumentNilException, TempMethod);
end;

procedure TTestExplicitConvertOp.ConvertNullToUInt64();
var
  {%H-}LVariable: UInt64;
begin

  LVariable := UInt64(TIntX(Default(TIntX)));
end;



procedure TTestExplicitConvertOp.CallConvertNullToUInt64();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @ConvertNullToUInt64;

  AssertException(EArgumentNilException, TempMethod);
end;

procedure TTestExplicitConvertOp.ConvertNullToWord();
var
  {%H-}LVariable: word;
begin

  LVariable := word(TIntX(Default(TIntX)));
end;



procedure TTestExplicitConvertOp.CallConvertNullToWord();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @ConvertNullToWord;

  AssertException(EArgumentNilException, TempMethod);
end;

procedure TTestExplicitConvertOp.ConvertNullToDouble();
var
  {%H-}LVariable: double;
begin

  LVariable := double(TIntX(Default(TIntX)));
end;



procedure TTestExplicitConvertOp.CallConvertNullToDouble();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @ConvertNullToDouble;

  AssertException(EArgumentNilException, TempMethod);
end;


initialization

  RegisterTest(TTestExplicitConvertOp);
end.



