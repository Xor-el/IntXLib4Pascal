unit SubOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  [TestFixture]
  TSubOpTest = class(TObject)
  public
    [Test]
    procedure Sub2IntX();
    [Test]
    procedure Sub2IntXNeg();
    [Test]
    procedure SubIntIntX();
    [Test]
    procedure SubIntXInt();

    procedure SubNullIntX();

    [Test]
    procedure CallSubNullIntX();
    [Test]
    procedure Sub0IntX();
    [Test]
    procedure Sub0IntXNeg();
    [Test]
    procedure Sub2BigIntX();
    [Test]
    procedure Sub2BigIntXC();
    [Test]
    procedure Sub2BigIntXC2();
    [Test]
    procedure Sub2BigIntXC3();
    [Test]
    procedure Sub2BigIntXC4();
    [Test]
    procedure Sub2BigIntXC5();
    [Test]
    procedure SubAdd();

  end;

implementation

[Test]
procedure TSubOpTest.Sub2IntX();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(5);
  Assert.IsTrue(int1 - int2 = -2);
end;

[Test]
procedure TSubOpTest.Sub2IntXNeg();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(-5);
  Assert.IsTrue(int1 - int2 = 2);
end;

[Test]
procedure TSubOpTest.SubIntIntX();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(3);
  Assert.IsTrue(IntX - 5 = -2);
end;

[Test]
procedure TSubOpTest.SubIntXInt();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(3);
  Assert.IsTrue(5 - IntX = 2);
end;

procedure TSubOpTest.SubNullIntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(3);

  int1 := int1 - Default (TIntX);
end;

[Test]
procedure TSubOpTest.CallSubNullIntX();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := SubNullIntX;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

[Test]
procedure TSubOpTest.Sub0IntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(3);
  Assert.IsTrue(int1 - 0 = 3);
  Assert.IsTrue(0 - int1 = -3);
  Assert.IsTrue(TIntX.Create(0) - int1 = -3);
  Assert.IsTrue(TIntX.Create(0) - 0 = 0);
end;

[Test]
procedure TSubOpTest.Sub0IntXNeg();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(-3);
  Assert.IsTrue(int1 - 0 = -3);
  Assert.IsTrue(0 - int1 = 3);
  Assert.IsTrue(int1 - TIntX.Create(0) = -3);
  Assert.IsTrue(TIntX.Create(0) - int1 = 3);
end;

[Test]
procedure TSubOpTest.Sub2BigIntX();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3: TIntX;
begin
  SetLength(temp1, 3);
  temp1[0] := 1;
  temp1[1] := 2;
  temp1[2] := 3;
  SetLength(temp2, 3);
  temp2[0] := 3;
  temp2[1] := 4;
  temp2[2] := 5;
  SetLength(temp3, 3);
  temp3[0] := 2;
  temp3[1] := 2;
  temp3[2] := 2;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, True);
  Assert.IsTrue(int1 - int2 = int3);
end;

[Test]
procedure TSubOpTest.Sub2BigIntXC();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := TConstants.MaxUInt32Value;
  temp1[1] := TConstants.MaxUInt32Value - 1;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 1;
  SetLength(temp3, 3);
  temp3[0] := 0;
  temp3[1] := 0;
  temp3[2] := 1;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);
  Assert.IsTrue(int1 = int3 - int2);
end;

[Test]
procedure TSubOpTest.Sub2BigIntXC2();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := TConstants.MaxUInt32Value - 1;
  temp1[1] := TConstants.MaxUInt32Value - 1;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 1;
  SetLength(temp3, 2);
  temp3[0] := TConstants.MaxUInt32Value;
  temp3[1] := TConstants.MaxUInt32Value;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);
  Assert.IsTrue(int1 = int3 - int2);
end;

[Test]
procedure TSubOpTest.Sub2BigIntXC3();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := TConstants.MaxUInt32Value;
  temp1[1] := TConstants.MaxUInt32Value;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 1;
  SetLength(temp3, 3);
  temp3[0] := 0;
  temp3[1] := 1;
  temp3[2] := 1;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);
  Assert.IsTrue(int1 = int3 - int2);
end;

[Test]
procedure TSubOpTest.Sub2BigIntXC4();
var
  temp1, temp2, temp3: TIntXLibUInt32Array;
  int1, int2, int3: TIntX;
begin
  SetLength(temp1, 4);
  temp1[0] := TConstants.MaxUInt32Value;
  temp1[1] := TConstants.MaxUInt32Value;
  temp1[2] := 1;
  temp1[3] := 1;
  SetLength(temp2, 2);
  temp2[0] := 1;
  temp2[1] := 1;
  SetLength(temp3, 4);
  temp3[0] := 0;
  temp3[1] := 1;
  temp3[2] := 2;
  temp3[3] := 1;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);
  Assert.IsTrue(int1 = int3 - int2);
end;

[Test]
procedure TSubOpTest.Sub2BigIntXC5();
var
  int1, int2, int3: TIntX;
begin
  int1 := TIntX.Create('40000000000000000000000000000000000000000000000000000');
  int2 := TIntX.Create
    ('10666666666666666666666666666666666666666666666666666666');
  int3 := TIntX.Create
    ('-10626666666666666666666666666666666666666666666666666666');
  Assert.IsTrue(int1 - int2 = int3);
end;

[Test]
procedure TSubOpTest.SubAdd();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(2);
  int2 := TIntX.Create(-3);
  Assert.IsTrue(int1 - int2 = 5);
end;

initialization

TDUnitX.RegisterTestFixture(TSubOpTest);

end.
