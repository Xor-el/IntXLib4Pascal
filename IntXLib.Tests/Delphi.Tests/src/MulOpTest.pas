unit MulOpTest;

interface

uses
  DUnitX.TestFramework,
  uEnums,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  [TestFixture]
  TMulOpTest = class(TObject)
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure PureIntX();
    [Test]
    procedure PureIntXSign();
    [Test]
    procedure IntAndIntX();
    [Test]
    procedure Zero();
    [Test]
    procedure Big();
    [Test]
    procedure Big2();
    [Test]
    procedure Big3();
    [Test]
    procedure Performance();
  end;

implementation

procedure TMulOpTest.Setup;
begin
  TIntX.GlobalSettings.MultiplyMode := TMultiplyMode.mmClassic;
end;

[Test]
procedure TMulOpTest.PureIntX();
begin
  Assert.IsTrue(TIntX.Create(3) * TIntX.Create(5) = TIntX.Create(15));
end;

[Test]
procedure TMulOpTest.PureIntXSign();
begin
  Assert.IsTrue(TIntX.Create(-3) * TIntX.Create(5) = TIntX.Create(-15));
end;

[Test]
procedure TMulOpTest.IntAndIntX();
begin
  Assert.IsTrue(TIntX.Create(3) * 5 = 15);
end;

[Test]
procedure TMulOpTest.Zero();
begin
  Assert.IsTrue(0 * TIntX.Create(3) = 0);
end;

[Test]
procedure TMulOpTest.Big();
var
  temp1, temp2, tempRes: TIntXLibUInt32Array;
  int1, int2, intRes: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := 1;
  temp1[1] := 1;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 1;
  SetLength(tempRes, 3);
  tempRes[0] := 1;
  tempRes[1] := 2;
  tempRes[2] := 1;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  intRes := TIntX.Create(tempRes, False);
  Assert.IsTrue(int1 * int2 = intRes);
end;

[Test]
procedure TMulOpTest.Big2();
var
  temp1, temp2, tempRes: TIntXLibUInt32Array;
  int1, int2, intRes: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := 1;
  temp1[1] := 1;
  SetLength(temp2, 1);
  temp2[0] := 2;
  SetLength(tempRes, 2);
  tempRes[0] := 2;
  tempRes[1] := 2;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  intRes := TIntX.Create(tempRes, False);
  Assert.IsTrue(intRes = int1 * int2);
  Assert.IsTrue(intRes = int2 * int1);
end;

[Test]
procedure TMulOpTest.Big3();
var
  temp1, temp2, tempRes: TIntXLibUInt32Array;
  int1, int2, intRes: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := TConstants.MaxUInt32Value;
  temp1[1] := TConstants.MaxUInt32Value;
  SetLength(temp2, 2);
  temp2[0] := TConstants.MaxUInt32Value;
  temp2[1] := TConstants.MaxUInt32Value;
  SetLength(tempRes, 4);
  tempRes[0] := 1;
  tempRes[1] := 0;
  tempRes[2] := TConstants.MaxUInt32Value - 1;
  tempRes[3] := TConstants.MaxUInt32Value;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  intRes := TIntX.Create(tempRes, False);
  Assert.IsTrue(int1 * int2 = intRes);
end;

[Test]
procedure TMulOpTest.Performance();
var
  i: Integer;
  temp1: TIntXLibUInt32Array;
  IntX, intX2: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := 0;
  temp1[1] := 1;
  IntX := TIntX.Create(temp1, False);
  intX2 := IntX;

  i := 0;
  while i <= Pred(1000) do
  begin
    intX2 := intX2 * IntX;
    Inc(i);
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TMulOpTest);

end.
