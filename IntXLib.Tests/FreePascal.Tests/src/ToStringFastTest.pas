unit ToStringFastTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  SysUtils,
  Math,
  uEnums,
  TestHelper,
  uIntX;

type

  { TTestToStringFast }

  TTestToStringFast = class(TTestCase)

  private
    F_length: integer;

  const
    StartLength = integer(1024);
    LengthIncrement = integer(101);
    RepeatCount = integer(10);
    RandomStartLength = integer(1024);
    RandomEndLength = integer(4000);
    RandomRepeatCount = integer(10);

    function GetAllNineChars(mlength: integer): string;
    function GetRandomChars(): string;
    procedure Inner();
    procedure InnerTwo();

  published
    procedure CompareWithClassic();

    procedure CompareWithClassicRandom();

  protected
    procedure SetUp; override;

  end;

implementation


procedure TTestToStringFast.CompareWithClassic();
begin
  TTestHelper.Repeater(RepeatCount, @Inner);
end;


procedure TTestToStringFast.CompareWithClassicRandom();
begin
  TTestHelper.Repeater(RandomRepeatCount, @InnerTwo);
end;

function TTestToStringFast.GetAllNineChars(mlength: integer): string;
begin
  Result := StringOfChar('9', mlength);
end;

function TTestToStringFast.GetRandomChars(): string;
var
  mlength: integer;
  builder: string;
begin
  mlength := RandomRange(RandomStartLength, RandomEndLength);
  builder := '';

  builder := builder + IntToStr(RandomRange(1, 9));
  Dec(mlength);
  while mlength <> 0 do
  begin
    builder := builder + IntToStr(RandomRange(0, 9));
    Dec(mlength);
  end;
  Result := builder;

end;

procedure TTestToStringFast.Inner();
var
  str, strFast, strClassic: string;
  x: TIntX;
begin
  str := GetAllNineChars(F_length);
  x := TIntX.Parse(str, TParseMode.pmFast);
  x.Settings.ToStringMode := TToStringMode.tsmFast;
  strFast := x.ToString();
  x.Settings.ToStringMode := TToStringMode.tsmClassic;
  strClassic := x.ToString();
  AssertEquals(str, strFast);
  AssertEquals(strFast, strClassic);
  F_length := F_length + LengthIncrement;
end;

procedure TTestToStringFast.InnerTwo();
var
  str, strFast, strClassic: string;
  x: TIntX;
begin
  str := GetRandomChars();
  x := TIntX.Parse(str, TParseMode.pmFast);
  x.Settings.ToStringMode := TToStringMode.tsmFast;
  strFast := x.ToString();
  x.Settings.ToStringMode := TToStringMode.tsmClassic;
  strClassic := x.ToString();
  AssertEquals(str, strFast);
  AssertEquals(strFast, strClassic);
end;

procedure TTestToStringFast.SetUp;
begin
  inherited SetUp;
  F_length := StartLength;
  Randomize;
end;

initialization

  RegisterTest(TTestToStringFast);
end.
