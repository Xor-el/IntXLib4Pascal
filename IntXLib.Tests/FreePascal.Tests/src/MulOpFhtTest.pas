unit MulOpFhtTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  Math,
  TestHelper,
  uEnums,
  uIntXLibTypes,
  uIntX;

type

  { TTestMulOpFht }

  TTestMulOpFht = class(TTestCase)

  private
    F_length: integer;

  const
    StartLength = integer(256);
    LengthIncrement = integer(101);
    RepeatCount = integer(10);
    RandomStartLength = integer(256);
    RandomEndLength = integer(1000);
    RandomRepeatCount = integer(50);

  published
    procedure CompareWithClassic();

    procedure SmallLargeCompareWithClassic();

    procedure CompareWithClassicRandom();

  private
    function GetAllOneDigits(mlength: integer): TIntXLibUInt32Array;
    function GetRandomDigits(mlength: integer): TIntXLibUInt32Array; overload;
    function GetRandomDigits(): TIntXLibUInt32Array; overload;
    procedure Inner();
    procedure InnerTwo();

  protected
    procedure SetUp; override;

  end;

implementation


procedure TTestMulOpFht.CompareWithClassic();
begin
  TTestHelper.Repeater(RepeatCount, @Inner);
end;


procedure TTestMulOpFht.SmallLargeCompareWithClassic();
var
  x, y, classic, fht: TIntX;
begin
  x := TIntX.Create(GetAllOneDigits(50000), False);
  y := TIntX.Create(GetAllOneDigits(512), False);
  classic := TIntX.Multiply(x, y, TMultiplyMode.mmClassic);
  fht := TIntX.Multiply(x, y, TMultiplyMode.mmAutoFht);
  AssertTrue(classic = fht);
end;


procedure TTestMulOpFht.CompareWithClassicRandom();
begin
  TTestHelper.Repeater(RandomRepeatCount, @InnerTwo);
end;

function TTestMulOpFht.GetAllOneDigits(mlength: integer): TIntXLibUInt32Array;
var
  i: integer;
begin
  SetLength(Result, mlength);
  for i := 0 to Pred(Length(Result)) do
  begin
    Result[i] := $7F7F7F7F;
  end;
end;

function TTestMulOpFht.GetRandomDigits(mlength: integer): TIntXLibUInt32Array;
var
  i: integer;
begin
  SetLength(Result, mlength);
  for i := 0 to Pred(Length(Result)) do
  begin
    Result[i] := UInt32(Random(RandomEndLength) + 1) * UInt32(2);
  end;
end;

function TTestMulOpFht.GetRandomDigits: TIntXLibUInt32Array;
begin
  Result := GetRandomDigits(RandomRange(RandomStartLength, RandomEndLength));
end;


procedure TTestMulOpFht.Inner();
var
  x, classic, fht: TIntX;
begin
  x := TIntX.Create(GetAllOneDigits(F_length), True);
  classic := TIntX.Multiply(x, x, TMultiplyMode.mmClassic);
  fht := TIntX.Multiply(x, x, TMultiplyMode.mmAutoFht);
  AssertTrue(classic = fht);
  F_length := F_length + LengthIncrement;
end;

procedure TTestMulOpFht.InnerTwo();
var
  x, classic, fht: TIntX;
begin
  x := TIntX.Create(GetRandomDigits(), False);
  classic := TIntX.Multiply(x, x, TMultiplyMode.mmClassic);
  fht := TIntX.Multiply(x, x, TMultiplyMode.mmAutoFht);
  AssertTrue(classic = fht);
end;

procedure TTestMulOpFht.SetUp;
begin
  inherited SetUp;
  F_length := StartLength;
  Randomize;
end;

initialization

  RegisterTest(TTestMulOpFht);
end.
