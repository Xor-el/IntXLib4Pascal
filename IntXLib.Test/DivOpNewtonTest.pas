unit DivOpNewtonTest;

interface

uses
  DUnitX.TestFramework, IntX, Math, TestHelper, Enums;

type

  [TestFixture]
  TDivOpNewtonTest = class(TObject)
  const
    StartLength: Integer = 1024;
    LengthIncrement: Integer = 101;
    RepeatCount: Integer = 10;
    RandomStartLength: Integer = 1024;
    RandomEndLength: Integer = 2048;
    RandomRepeatCount: Integer = 25;

  var
    F_length: Integer;

  public
    [Setup]
    procedure Setup;
    function GetAllOneDigits(mlength: Integer): TArray<Cardinal>;
    function GetRandomDigits(out digits2: TArray<Cardinal>): TArray<Cardinal>;
    procedure NextBytes(var bytes: TArray<Byte>); inline;
    [Test]
    procedure CompareWithClassic();
    [Test]
    procedure CompareWithClassicRandom();
  end;

implementation

procedure TDivOpNewtonTest.Setup;
begin
  F_length := StartLength;
end;

function TDivOpNewtonTest.GetAllOneDigits(mlength: Integer): TArray<Cardinal>;
var
  i: Integer;
begin
  SetLength(result, mlength);
  for i := 0 to Pred(Length(result)) do
  begin
    result[i] := $FFFFFFFF;
  end;
end;

function TDivOpNewtonTest.GetRandomDigits(out digits2: TArray<Cardinal>)
  : TArray<Cardinal>;
var
  bytes: TArray<Byte>;
  i: Integer;
begin
  Randomize;
  SetLength(result, RandomRange(RandomStartLength, RandomEndLength));
  SetLength(digits2, Length(result) div 2);
  SetLength(bytes, 4);
  for i := 0 to Pred(Length(result)) do
  begin
    NextBytes(bytes);
    result[i] := PCardinal(@bytes[0])^;
    if (i < Length(digits2)) then
    begin
      NextBytes(bytes);
      digits2[i] := PCardinal(@bytes[0])^;
    end;

  end;
end;

procedure TDivOpNewtonTest.NextBytes(var bytes: TArray<Byte>);
var
  i, randValue: Integer;
begin
  Randomize;
  for i := 0 to Pred(Length(bytes)) do
  begin
    randValue := RandomRange(2, 30);
    if (randValue and 1) <> 0 then
      bytes[i] := Byte((randValue shr 1) xor $25)
    else
      bytes[i] := Byte(randValue shr 1);
  end;

end;

[Test]
procedure TDivOpNewtonTest.CompareWithClassic();
var
  x, x2, classicMod, fastMod, classic, fast: TIntX;
begin
  TTestHelper.Repeater(RepeatCount,
    procedure
    begin

      x := TIntX.Create(GetAllOneDigits(F_length), True);
      x2 := TIntX.Create(GetAllOneDigits(F_length div 2), True);
      classic := TIntX.DivideModulo(x, x2, classicMod, TDivideMode.dmClassic);
      fast := TIntX.DivideModulo(x, x2, fastMod, TDivideMode.dmAutoNewton);
      Assert.IsTrue(classic = fast);
      Assert.IsTrue(classicMod = fastMod);

      F_length := F_length + LengthIncrement;

    end);
end;

[Test]
procedure TDivOpNewtonTest.CompareWithClassicRandom();
var
  x, x2, classicMod, fastMod, classic, fast: TIntX;
  digits2: TArray<Cardinal>;
begin
  TTestHelper.Repeater(RandomRepeatCount,
    procedure
    begin

      x := TIntX.Create(GetRandomDigits(digits2), False);
      x2 := TIntX.Create(digits2, False);

      classic := TIntX.DivideModulo(x, x2, classicMod, TDivideMode.dmClassic);
      fast := TIntX.DivideModulo(x, x2, fastMod, TDivideMode.dmAutoNewton);

      Assert.IsTrue(classic = fast);
      Assert.IsTrue(classicMod = fastMod);
    end);
end;

initialization

TDUnitX.RegisterTestFixture(TDivOpNewtonTest);

end.
