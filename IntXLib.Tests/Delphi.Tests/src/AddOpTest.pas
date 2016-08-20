unit AddOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  // Classes,
  uIntX,
  uConstants;

type

  [TestFixture]
  TAddOpTest = class(TObject)
  public
    [Test]
    procedure Add2IntX();
    [Test]
    procedure Add2IntXNeg();
    [Test]
    procedure AddIntIntX();
    [Test]
    procedure AddIntXInt();

    procedure AddNullIntX();

    [Test]
    procedure CallAddNullIntX();
    [Test]
    procedure Add0IntX();
    [Test]
    procedure Add0IntXNeg();
    [Test]
    procedure Add2BigIntX();
    [Test]
    procedure Add2BigIntXC();
    [Test]
    procedure Add2BigIntXC2();
    [Test]
    procedure Add2BigIntXC3();
    [Test]
    procedure Add2BigIntXC4();
    [Test]
    procedure Fibon();
    [Test]
    procedure AddSub();
    {
      // Simple output (hex Fibonacci numbers). uncomment to see
      [Test]
      procedure FibonOut();
    }

  end;

implementation

[Test]
procedure TAddOpTest.Add2IntX();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(3);
  int2 := TIntX.Create(5);
  Assert.IsTrue(int1 + int2 = 8);
end;

[Test]
procedure TAddOpTest.Add2IntXNeg();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(-3);
  int2 := TIntX.Create(-5);
  Assert.IsTrue(int1 + int2 = -8);
end;

[Test]
procedure TAddOpTest.AddIntIntX();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(3);
  Assert.IsTrue(IntX + 5 = 8);
end;

[Test]
procedure TAddOpTest.AddIntXInt();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(3);
  Assert.IsTrue(5 + IntX = 8);
end;

procedure TAddOpTest.AddNullIntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(3);

  int1 := int1 + Default (TIntX);
end;

[Test]
procedure TAddOpTest.CallAddNullIntX();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := AddNullIntX;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

[Test]
procedure TAddOpTest.Add0IntX();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(3);
  Assert.IsTrue(int1 + 0 = 3);
  Assert.IsTrue(int1 + TIntX.Create(0) = 3);
end;

[Test]
procedure TAddOpTest.Add0IntXNeg();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(-3);
  Assert.IsTrue(int1 + 0 = -3);
  Assert.IsTrue(int1 + TIntX.Create(0) = -3);
  Assert.IsTrue(TIntX.Create(0) + TIntX.Create(-1) = -1);
  Assert.IsTrue(TIntX.Create(0) + 0 = 0);
end;

[Test]
procedure TAddOpTest.Add2BigIntX();
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
  temp3[0] := 4;
  temp3[1] := 6;
  temp3[2] := 8;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, False);
  int3 := TIntX.Create(temp3, False);
  Assert.IsTrue(int1 + int2 = int3);
end;

[Test]
procedure TAddOpTest.Add2BigIntXC();
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
  Assert.IsTrue(int1 + int2 = int3);
end;

[Test]
procedure TAddOpTest.Add2BigIntXC2();
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
  Assert.IsTrue(int1 + int2 = int3);
end;

[Test]
procedure TAddOpTest.Add2BigIntXC3();
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
  Assert.IsTrue(int1 + int2 = int3);
end;

[Test]
procedure TAddOpTest.Add2BigIntXC4();
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
  Assert.IsTrue(int1 + int2 = int3);
end;

[Test]
procedure TAddOpTest.Fibon();
var
  int1, int2, int3: TIntX;
  i: Integer;
begin
  int1 := TIntX.Create(1);
  int2 := int1;
  int3 := Default (TIntX);

  i := 0;
  while i <= Pred(10000) do
  begin
    int3 := int1 + int2;
    int1 := int2;
    int2 := int3;
    Inc(i);
  end;

end;

[Test]
procedure TAddOpTest.AddSub();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(2);
  int2 := TIntX.Create(-2);
  Assert.IsTrue(int1 + int2 = 0);
end;

// Simple output (hex Fibonacci numbers). Uncomment to see
(*
  [Test]
  procedure TAddOpTest.FibonOut();
  var
  numberBase: UInt32;
  Writer: TStreamWriter;
  int1, int2, int3: TIntX;
  i: Integer;
  begin
  numberBase := 16;
  Writer := TStreamWriter.Create('fibon.txt');
  try
  int1 := TIntX.Create(1);
  Writer.WriteLine(int1.ToString(numberBase));
  int2 := int1;
  Writer.WriteLine(int2.ToString(numberBase));
  int3 := Default (TIntX);
  for i := 0 to Pred(1000) do
  begin
  int3 := int1 + int2;
  Writer.WriteLine(int3.ToString(numberBase));
  int1 := int2;
  int2 := int3;
  end;

  finally
  Writer.Free;
  end;

  end;
*)

initialization

TDUnitX.RegisterTestFixture(TAddOpTest);

end.
