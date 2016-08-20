unit ToStringFastTest;

interface

uses
  DUnitX.TestFramework,
  SysUtils,
  Math,
  uEnums,
  TestHelper,
  uIntX;

type

  [TestFixture]
  TToStringFastTest = class(TObject)

  private
    F_length: Integer;

  const
    StartLength = Integer(1024);
    LengthIncrement = Integer(101);
    RepeatCount = Integer(10);
    RandomStartLength = Integer(1024);
    RandomEndLength = Integer(4000);
    RandomRepeatCount = Integer(10);

    function GetAllNineChars(mlength: Integer): String;
    function GetRandomChars(): String;

  public
    [Setup]
    procedure Setup;
    [Test]
    procedure CompareWithClassic();
    [Test]
    procedure CompareWithClassicRandom();
  end;

implementation

procedure TToStringFastTest.Setup;
begin
  F_length := StartLength;
  Randomize;
end;

function TToStringFastTest.GetAllNineChars(mlength: Integer): String;
begin
  result := StringOfChar('9', mlength);
end;

function TToStringFastTest.GetRandomChars(): String;
var
  mlength: Integer;
  builder: TStringBuilder;
begin
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
procedure TToStringFastTest.CompareWithClassic();
var
  str, strFast, strClassic: String;
  x: TIntX;
begin
  TTestHelper.Repeater(RepeatCount,
    procedure
    begin
      str := GetAllNineChars(F_length);
      x := TIntX.Parse(str, TParseMode.pmFast);
      x.Settings.ToStringMode := TToStringMode.tsmFast;
      strFast := x.ToString();
      x.Settings.ToStringMode := TToStringMode.tsmClassic;
      strClassic := x.ToString();
      Assert.AreEqual(str, strFast);
      Assert.AreEqual(strFast, strClassic);
      F_length := F_length + LengthIncrement;
    end);
end;

[Test]
procedure TToStringFastTest.CompareWithClassicRandom();
var
  str, strFast, strClassic: String;
  x: TIntX;
begin
  TTestHelper.Repeater(RandomRepeatCount,
    procedure
    begin
      str := GetRandomChars();
      x := TIntX.Parse(str, TParseMode.pmFast);
      x.Settings.ToStringMode := TToStringMode.tsmFast;
      strFast := x.ToString();
      x.Settings.ToStringMode := TToStringMode.tsmClassic;
      strClassic := x.ToString();
      Assert.AreEqual(str, strFast);
      Assert.AreEqual(strFast, strClassic);
    end);
end;

initialization

TDUnitX.RegisterTestFixture(TToStringFastTest);

end.
