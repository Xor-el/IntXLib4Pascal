unit ParseFastTest;

interface

uses
  DUnitX.TestFramework, SysUtils, Math, IntX, Enums, TestHelper;

type

  [TestFixture]
  TToParseFastTest = class(TObject)

  const
    StartLength: Integer = 1024;
    LengthIncrement: Integer = 101;
    RepeatCount: Integer = 50;
    RandomStartLength: Integer = 1024;
    RandomEndLength: Integer = 4000;
    RandomRepeatCount: Integer = 50;

  var
    F_length: Integer;

  public
    [Setup]
    procedure Setup;
    function GetAllNineChars(mlength: Integer): String;
    function GetRandomChars(): String;
    [Test]
    procedure CompareWithClassic();
    [Test]
    procedure CompareWithClassicRandom();
  end;

implementation

procedure TToParseFastTest.Setup;
begin
  F_length := StartLength;
end;

function TToParseFastTest.GetAllNineChars(mlength: Integer): String;
begin
  result := StringOfChar('9', mlength);
end;

function TToParseFastTest.GetRandomChars(): String;
var
  mlength: Integer;
  builder: TStringBuilder;
begin
  Randomize;
  mlength := RandomRange(RandomStartLength, RandomEndLength);
  builder := TStringBuilder.Create(mlength);
  try
    builder.Clear;
    builder.Append(RandomRange(1, 9));
    Dec(mlength);
    while mlength <> 0 do
    begin
      builder.Append(RandomRange(0, 9));
      Dec(mlength);
    end;
    result := builder.ToString();
  finally
    builder.Free;
  end;
end;

[Test]
procedure TToParseFastTest.CompareWithClassic();
var
  str: String;
  classic, fast: TIntX;
begin
  TTestHelper.Repeater(RepeatCount,
    procedure
    begin
      str := GetAllNineChars(F_length);
      classic := TIntX.Parse(str, TParseMode.pmClassic);
      fast := TIntX.Parse(str, TParseMode.pmFast);
      Assert.IsTrue(classic = fast);
      F_length := F_length + LengthIncrement;
    end);
end;

[Test]
procedure TToParseFastTest.CompareWithClassicRandom();
var
  str: String;
  classic, fast: TIntX;
begin
  TTestHelper.Repeater(RandomRepeatCount,
    procedure
    begin
      str := GetRandomChars();
      classic := TIntX.Parse(str, TParseMode.pmClassic);
      fast := TIntX.Parse(str, TParseMode.pmFast);
      Assert.IsTrue(classic = fast);
    end);
end;

initialization

TDUnitX.RegisterTestFixture(TToParseFastTest);

end.
