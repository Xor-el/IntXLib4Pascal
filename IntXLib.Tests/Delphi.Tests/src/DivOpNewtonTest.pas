unit DivOpNewtonTest;

interface

uses
  DUnitX.TestFramework,
  Math,
  TestHelper,
  uEnums,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TDivOpNewtonTest = class(TObject)
  private

    F_length: Integer;

  const
    StartLength = Integer(1024);
    LengthIncrement = Integer(101);
    RepeatCount = Integer(10);
    RandomStartLength = Integer(1024);
    RandomEndLength = Integer(2048);
    RandomRepeatCount = Integer(25);

    function GetAllOneDigits(mlength: Integer): TIntXLibUInt32Array;
    function GetRandomDigits(out digits2: TIntXLibUInt32Array)
      : TIntXLibUInt32Array;
    procedure NextBytes(var bytes: TArray<Byte>);

  public
    [Setup]
    procedure Setup;
    [Test]
    procedure CompareWithClassic();
    [Test]
    procedure CompareWithClassicRandom();
  end;

implementation

procedure TDivOpNewtonTest.Setup;
begin
  F_length := StartLength;
  Randomize;
end;

function TDivOpNewtonTest.GetAllOneDigits(mlength: Integer)
  : TIntXLibUInt32Array;
var
  i: Integer;
begin
  SetLength(result, mlength);
  for i := 0 to Pred(Length(result)) do
  begin
    result[i] := $FFFFFFFF;
  end;
end;

function TDivOpNewtonTest.GetRandomDigits(out digits2: TIntXLibUInt32Array)
  : TIntXLibUInt32Array;
var
  bytes: TArray<Byte>;
  i: Integer;
begin

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
  digits2: TIntXLibUInt32Array;
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
