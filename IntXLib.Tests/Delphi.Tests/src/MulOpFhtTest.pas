unit MulOpFhtTest;

interface

uses
  DUnitX.TestFramework,
  Math,
  uEnums,
  TestHelper,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TMulOpFhtTest = class(TObject)
  private

    F_length: Integer;

  const
    StartLength = Integer(256);
    LengthIncrement = Integer(101);
    RepeatCount = Integer(10);
    RandomStartLength = Integer(256);
    RandomEndLength = Integer(1000);
    RandomRepeatCount = Integer(50);

    function GetAllOneDigits(mlength: Integer): TIntXLibUInt32Array;
    function GetRandomDigits(mlength: Integer): TIntXLibUInt32Array; overload;
    function GetRandomDigits(): TIntXLibUInt32Array; overload;

  public
    [Setup]
    procedure Setup;
    [Test]
    procedure CompareWithClassic();
    [Test]
    procedure SmallLargeCompareWithClassic();
    [Test]
    procedure CompareWithClassicRandom();
  end;

implementation

procedure TMulOpFhtTest.Setup;
begin
  F_length := StartLength;
  Randomize;
end;

function TMulOpFhtTest.GetAllOneDigits(mlength: Integer): TIntXLibUInt32Array;
var
  i: Integer;
begin
  SetLength(result, mlength);
  for i := 0 to Pred(Length(result)) do
  begin
    result[i] := $7F7F7F7F;
  end;
end;

function TMulOpFhtTest.GetRandomDigits(mlength: Integer): TIntXLibUInt32Array;
var
  i: Integer;
begin
  SetLength(result, mlength);
  for i := 0 to Pred(Length(result)) do
  begin
    result[i] := UInt32(Random(RandomEndLength) + 1) * UInt32(2);
  end;
end;

function TMulOpFhtTest.GetRandomDigits(): TIntXLibUInt32Array;
begin
  result := GetRandomDigits(RandomRange(RandomStartLength, RandomEndLength));
end;

[Test]
procedure TMulOpFhtTest.CompareWithClassic();
var
  x, classic, fht: TIntX;
begin
  TTestHelper.Repeater(RepeatCount,
    procedure
    begin
      x := TIntX.Create(GetAllOneDigits(F_length), True);
      classic := TIntX.Multiply(x, x, TMultiplyMode.mmClassic);
      fht := TIntX.Multiply(x, x, TMultiplyMode.mmAutoFht);
      Assert.IsTrue(classic = fht);
      F_length := F_length + LengthIncrement;
    end);
end;

[Test]
procedure TMulOpFhtTest.SmallLargeCompareWithClassic();
var
  x, y, classic, fht: TIntX;
begin
  x := TIntX.Create(GetAllOneDigits(50000), False);
  y := TIntX.Create(GetAllOneDigits(512), False);
  classic := TIntX.Multiply(x, y, TMultiplyMode.mmClassic);
  fht := TIntX.Multiply(x, y, TMultiplyMode.mmAutoFht);
  Assert.IsTrue(classic = fht);
end;

[Test]
procedure TMulOpFhtTest.CompareWithClassicRandom();
var
  x, classic, fht: TIntX;
begin
  TTestHelper.Repeater(RandomRepeatCount,
    procedure
    begin
      x := TIntX.Create(GetRandomDigits(), False);
      classic := TIntX.Multiply(x, x, TMultiplyMode.mmClassic);
      fht := TIntX.Multiply(x, x, TMultiplyMode.mmAutoFht);
      Assert.IsTrue(classic = fht);
    end);
end;

initialization

TDUnitX.RegisterTestFixture(TMulOpFhtTest);

end.
