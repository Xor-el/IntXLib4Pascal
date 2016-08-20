unit DivOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TDivOpTest = class(TObject)
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
    procedure Big2();
    [Test]
    procedure BigDec();
    [Test]
    procedure BigDecNeg();
  end;

implementation

[Test]
procedure TDivOpTest.Simple();
var
  int1, int2: TIntX;
begin
  int1 := 16;
  int2 := 5;
  Assert.IsTrue(int1 div int2 = 3);
end;

[Test]
procedure TDivOpTest.Neg();
var
  int1, int2: TIntX;
begin
  int1 := -16;
  int2 := 5;
  Assert.IsTrue(int1 div int2 = -3);
  int1 := 16;
  int2 := -5;
  Assert.IsTrue(int1 div int2 = -3);
  int1 := -16;
  int2 := -5;
  Assert.IsTrue(int1 div int2 = 3);
end;

[Test]
procedure TDivOpTest.Zero();
var
  int1, int2: TIntX;
begin
  int1 := 0;
  int2 := 25;
  Assert.IsTrue(int1 div int2 = 0);
  int1 := 0;
  int2 := -25;
  Assert.IsTrue(int1 div int2 = 0);
  int1 := 16;
  int2 := 25;
  Assert.IsTrue(int1 div int2 = 0);
  int1 := -16;
  int2 := 25;
  Assert.IsTrue(int1 div int2 = 0);
  int1 := 16;
  int2 := -25;
  Assert.IsTrue(int1 div int2 = 0);
  int1 := -16;
  int2 := -25;
  Assert.IsTrue(int1 div int2 = 0);
end;

procedure TDivOpTest.ZeroException();
var
  int1, int2: TIntX;
begin
  int1 := 1;
  int2 := 0;
  int1 := int1 div int2;
end;

// [Test, ExpectedException(typeof(EDivByZero))]
[Test]
procedure TDivOpTest.CallZeroException();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := ZeroException;

  Assert.WillRaise(TempMethod, EDivByZero);
end;

[Test]
procedure TDivOpTest.Big();
var
  temp1, temp2: TIntXLibUInt32Array;
  int1, int2: TIntX;
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
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  Assert.IsTrue(int1 div int2 = $FFFFFFFE);
end;

[Test]
procedure TDivOpTest.Big2();
var
  int1, int2, int3, int4: TIntX;
begin
  int1 := TIntX.Create('4574586690780877990306040650779005020012387464357');
  int2 := TIntX.Create('856778798907978995905496597069809708960893');
  int3 := TIntX.Create('8567787989079799590496597069809708960893');
  int4 := int1 * int2 + int3;
  Assert.IsTrue(int4 div int2 = int1);
  Assert.IsTrue(int4 mod int2 = int3);
end;

[Test]
procedure TDivOpTest.BigDec();
var
  int1, int2, res: TIntX;
begin
  int1 := TIntX.Create('100000000000000000000000000000000000000000000');
  int2 := TIntX.Create('100000000000000000000000000000000000000000');
  res := int1 div int2;
  Assert.IsTrue(res = 1000);
end;

[Test]
procedure TDivOpTest.BigDecNeg();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create('-100000000000000000000000000000000000000000000');
  int2 := TIntX.Create('100000000000000000000000000000000000000000');
  Assert.IsTrue(int1 div int2 = -1000);
end;

initialization

TDUnitX.RegisterTestFixture(TDivOpTest);

end.
