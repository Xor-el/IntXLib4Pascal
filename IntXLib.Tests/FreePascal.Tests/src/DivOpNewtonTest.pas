unit DivOpNewtonTest;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  fpcunit,
  testregistry,
  Math,
  TestHelper,
  uEnums,
  uIntXLibTypes,
  uIntX;

type

  { TTestDivOpNewton }

  TTestDivOpNewton = class(TTestCase)

  private
    F_length: integer;

    function GetAllOneDigits(mlength: integer): TIntXLibUInt32Array;
    function GetRandomDigits(out digits2: TIntXLibUInt32Array): TIntXLibUInt32Array;
    procedure NextBytes(var bytes: TBytes);
    procedure Inner();
    procedure InnerTwo();

  const
    StartLength = integer(1024);
    LengthIncrement = integer(101);
    RepeatCount = integer(10);
    RandomStartLength = integer(1024);
    RandomEndLength = integer(2048);
    RandomRepeatCount = integer(25);

  published
    procedure CompareWithClassic();
    procedure CompareWithClassicRandom();

  protected
    procedure SetUp; override;

  end;

implementation

procedure TTestDivOpNewton.CompareWithClassic;
var
  InnerMethod: TRunMethod;

begin
  InnerMethod := @Inner;
  TTestHelper.Repeater(RepeatCount, InnerMethod);
end;

procedure TTestDivOpNewton.CompareWithClassicRandom;
var
  InnerMethod: TRunMethod;
begin
  InnerMethod := @InnerTwo;
  TTestHelper.Repeater(RandomRepeatCount, InnerMethod);
end;

function TTestDivOpNewton.GetAllOneDigits(mlength: integer): TIntXLibUInt32Array;
var
  i: integer;
begin
  SetLength(Result, mlength);
  for i := 0 to Pred(Length(Result)) do
  begin
    Result[i] := $FFFFFFFF;
  end;
end;

function TTestDivOpNewton.GetRandomDigits(out digits2: TIntXLibUInt32Array):
TIntXLibUInt32Array;
var
  bytes: TBytes;
  i: integer;
begin
  SetLength(Result, RandomRange(RandomStartLength, RandomEndLength));
  SetLength(digits2, Length(Result) div 2);
  SetLength(bytes, 4);
  for i := 0 to Pred(Length(Result)) do
  begin
    NextBytes(bytes);
    Result[i] := PCardinal(@bytes[0])^;
    if (i < Length(digits2)) then
    begin
      NextBytes(bytes);
      digits2[i] := PCardinal(@bytes[0])^;
    end;

  end;
end;

procedure TTestDivOpNewton.NextBytes(var bytes: TBytes);
var
  i, randValue: integer;
begin
  for i := 0 to Pred(Length(bytes)) do
  begin
    randValue := RandomRange(2, 30);
    if (randValue and 1) <> 0 then
      bytes[i] := byte((randValue shr 1) xor $25)
    else
      bytes[i] := byte(randValue shr 1);
  end;
end;

procedure TTestDivOpNewton.SetUp;
begin
  inherited SetUp;
  F_length := StartLength;
  Randomize;
end;

procedure TTestDivOpNewton.Inner();
var
  x, x2, classicMod, fastMod, classic, fast: TIntX;
begin
  x := TIntX.Create(GetAllOneDigits(F_length), True);
  x2 := TIntX.Create(GetAllOneDigits(F_length div 2), True);
  classic := TIntX.DivideModulo(x, x2, classicMod, TDivideMode.dmClassic);
  fast := TIntX.DivideModulo(x, x2, fastMod, TDivideMode.dmAutoNewton);
  AssertTrue(classic = fast);
  AssertTrue(classicMod = fastMod);

  F_length := F_length + LengthIncrement;
end;

procedure TTestDivOpNewton.InnerTwo();
var
  x, x2, classicMod, fastMod, classic, fast: TIntX;
  digits2: TIntXLibUInt32Array;
begin
  x := TIntX.Create(GetRandomDigits(digits2), False);
  x2 := TIntX.Create(digits2, False);

  classic := TIntX.DivideModulo(x, x2, classicMod, TDivideMode.dmClassic);
  fast := TIntX.DivideModulo(x, x2, fastMod, TDivideMode.dmAutoNewton);

  AssertTrue(classic = fast);
  AssertTrue(classicMod = fastMod);
end;

initialization

  RegisterTest(TTestDivOpNewton);
end.
