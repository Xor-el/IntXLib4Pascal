unit ShiftOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TShiftOpTest = class(TObject)
  public
    [Test]
    procedure Zero();
    [Test]
    procedure SimpleAndNeg();
    [Test]
    procedure Complex();
    [Test]
    procedure BigShift();
    [Test]
    procedure MassiveShift();

  end;

implementation

[Test]
procedure TShiftOpTest.Zero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(0);
  Assert.IsTrue(int1 shl 100 = 0);
  Assert.IsTrue(int1 shr 100 = 0);
end;

[Test]
procedure TShiftOpTest.SimpleAndNeg();
var
  temp: TIntXLibUInt32Array;
  int1: TIntX;
begin
  SetLength(temp, 2);
  temp[0] := 0;
  temp[1] := 8;
  int1 := TIntX.Create(8);
  Assert.IsTrue((int1 shl 0 = int1 shr 0) and (int1 shl 0 = 8));
  Assert.IsTrue((int1 shl 32 = int1 shr - 32) and
    (int1 shl 32 = TIntX.Create(temp, False)));
end;

[Test]
procedure TShiftOpTest.Complex();
var
  int1: TIntX;
begin
  int1 := TIntX.Create('$0080808080808080');
  Assert.IsTrue((int1 shl 4).ToString(16) = '808080808080800');
  Assert.IsTrue(int1 shr 36 = $80808);
end;

[Test]
procedure TShiftOpTest.BigShift();
var
  int1: TIntX;
begin
  int1 := 8;
  Assert.IsTrue(int1 shr 777 = 0);
end;

[Test]
procedure TShiftOpTest.MassiveShift();
var
  n: TIntX;
  i: Integer;
begin
  for i := 1 to Pred(2000) do
  begin
    n := i;
    n := n shl i;
    n := n shr i;
    Assert.IsTrue(TIntX.Create(i).Equals(n));
  end;

end;

initialization

TDUnitX.RegisterTestFixture(TShiftOpTest);

end.
