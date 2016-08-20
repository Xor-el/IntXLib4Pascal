unit ModOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TModOpTest = class(TObject)
  public
    [Test]
    procedure Simple();
    [Test]
    procedure Neg();
    [Test]
    procedure Zero();
    procedure ZeroException();

    [Test]
    procedure CallZeroException();
    [Test]
    procedure Big();
    [Test]
    procedure BigDec();
    [Test]
    procedure BigDecNeg();
  end;

implementation

[Test]
procedure TModOpTest.Simple();
var
  int1, int2: TIntX;
begin
  int1 := 16;
  int2 := 5;
  Assert.IsTrue(int1 mod int2 = 1);
end;

[Test]
procedure TModOpTest.Neg();
var
  int1, int2: TIntX;
begin
  int1 := -16;
  int2 := 5;
  Assert.IsTrue(int1 mod int2 = -1);
  int1 := 16;
  int2 := -5;
  Assert.IsTrue(int1 mod int2 = 1);
  int1 := -16;
  int2 := -5;
  Assert.IsTrue(int1 mod int2 = -1);
end;

[Test]
procedure TModOpTest.Zero();
var
  int1, int2: TIntX;
begin
  int1 := 0;
  int2 := 25;
  Assert.IsTrue(int1 mod int2 = 0);
  int1 := 0;
  int2 := -25;
  Assert.IsTrue(int1 mod int2 = 0);
  int1 := 16;
  int2 := 25;
  Assert.IsTrue(int1 mod int2 = 16);
  int1 := -16;
  int2 := 25;
  Assert.IsTrue(int1 mod int2 = -16);
  int1 := 16;
  int2 := -25;
  Assert.IsTrue(int1 mod int2 = 16);
  int1 := -16;
  int2 := -25;
  Assert.IsTrue(int1 mod int2 = -16);
  int1 := 50;
  int2 := 25;
  Assert.IsTrue(int1 mod int2 = 0);
  int1 := -50;
  int2 := -25;
  Assert.IsTrue(int1 mod int2 = 0);
end;

procedure TModOpTest.ZeroException();
var
  int1, int2: TIntX;
begin
  int1 := 1;
  int2 := 0;
  int1 := int1 mod int2;
end;

[Test]
procedure TModOpTest.CallZeroException();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := ZeroException;

  Assert.WillRaise(TempMethod, EDivByZero);
end;

[Test]
procedure TModOpTest.Big();
var
  temp1, temp2, tempM: TIntXLibUInt32Array;
  int1, int2, intM: TIntX;
begin
  SetLength(temp1, 4);
  temp1[0] := 0;
  temp1[1] := 0;
  temp1[2] := $80000000;
  temp1[3] := $7FFFFFFF;
  SetLength(temp2, 3);
  temp2[0] := 1;
  temp2[1] := 0;
  temp2[2] := $80000000;
  SetLength(tempM, 3);
  tempM[0] := 2;
  tempM[1] := $FFFFFFFF;
  tempM[2] := $7FFFFFFF;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  intM := TIntX.Create(tempM, False);
  Assert.IsTrue(int1 mod int2 = intM);
end;

[Test]
procedure TModOpTest.BigDec();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create('100000000000000000000000000000000000000000000');
  int2 := TIntX.Create('100000000000000000000000000000000000000000');
  Assert.IsTrue(int1 mod int2 = 0);
end;

[Test]
procedure TModOpTest.BigDecNeg();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create('-100000000000000000000000000000000000000000001');
  int2 := TIntX.Create('100000000000000000000000000000000000000000');
  Assert.IsTrue(int1 mod int2 = -1);
end;

initialization

TDUnitX.RegisterTestFixture(TModOpTest);

end.
