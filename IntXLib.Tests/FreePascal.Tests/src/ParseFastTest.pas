unit ParseFastTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  Math,
  SysUtils,
  TestHelper,
  uEnums,
  uIntX;

type

  { TTestToParseFast }

  TTestToParseFast = class(TTestCase)

  private
    F_length: integer;

    function GetAllNineChars(mlength: integer): string;
    function GetRandomChars(): string;
    procedure Inner();
    procedure InnerTwo();

  const
    StartLength = integer(1024);
    LengthIncrement = integer(101);
    RepeatCount = integer(50);
    RandomStartLength = integer(1024);
    RandomEndLength = integer(4000);
    RandomRepeatCount = integer(50);

  published
    procedure CompareWithClassic();

    procedure CompareWithClassicRandom();

  protected
    procedure SetUp; override;

  end;

implementation

procedure TTestToParseFast.CompareWithClassic();
begin
  TTestHelper.Repeater(RepeatCount, @Inner);
end;

procedure TTestToParseFast.CompareWithClassicRandom();
begin
  TTestHelper.Repeater(RandomRepeatCount, @InnerTwo);
end;


procedure TTestToParseFast.Inner();
var
  str: string;
  classic, fast: TIntX;
begin
  str := GetAllNineChars(F_length);
  classic := TIntX.Parse(str, TParseMode.pmClassic);
  fast := TIntX.Parse(str, TParseMode.pmFast);
  AssertTrue(classic = fast);
  F_length := F_length + LengthIncrement;
end;

procedure TTestToParseFast.InnerTwo();
var
  str: string;
  classic, fast: TIntX;
begin
  str := GetRandomChars();
  classic := TIntX.Parse(str, TParseMode.pmClassic);
  fast := TIntX.Parse(str, TParseMode.pmFast);
  AssertTrue(classic = fast);
end;

procedure TTestToParseFast.SetUp;
begin
  inherited SetUp;
  F_length := StartLength;
  Randomize;
end;

function TTestToParseFast.GetAllNineChars(mlength: integer): string;
begin
  Result := StringOfChar('9', mlength);
end;

function TTestToParseFast.GetRandomChars(): string;
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

initialization

  RegisterTest(TTestToParseFast);
end.
