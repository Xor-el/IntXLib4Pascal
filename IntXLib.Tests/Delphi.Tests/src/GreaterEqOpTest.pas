unit GreaterEqOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TGreaterEqOpTest = class(TObject)
  public
    [Test]
    procedure Simple();
    [Test]
    procedure SimpleFail();
    [Test]
    procedure Big();
    [Test]
    procedure BigFail();
    [Test]
    procedure EqualValues();

  end;

implementation

[Test]
procedure TGreaterEqOpTest.Simple();
var
  int1, int2: TIntX;
begin
  int1 := TIntX.Create(7);
  int2 := TIntX.Create(8);
  Assert.IsTrue(int2 >= int1);
end;

[Test]
procedure TGreaterEqOpTest.SimpleFail();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(8);
  Assert.IsFalse(7 >= int1);
end;

[Test]
procedure TGreaterEqOpTest.Big();
var
  temp1, temp2: TIntXLibUInt32Array;
  int1, int2: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := 1;
  temp1[1] := 2;
  SetLength(temp2, 3);
  temp2[0] := 1;
  temp2[1] := 2;
  temp2[2] := 3;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, True);
  Assert.IsTrue(int1 >= int2);
end;

[Test]
procedure TGreaterEqOpTest.BigFail();
var
  temp1, temp2: TIntXLibUInt32Array;
  int1, int2: TIntX;
begin
  SetLength(temp1, 2);
  temp1[0] := 1;
  temp1[1] := 2;
  SetLength(temp2, 3);
  temp2[0] := 1;
  temp2[1] := 2;
  temp2[2] := 3;
  int1 := TIntX.Create(temp1, False);
  int2 := TIntX.Create(temp2, True);
  Assert.IsFalse(int2 >= int1);
end;

[Test]
procedure TGreaterEqOpTest.EqualValues();
var
  temp1, temp2: TIntXLibUInt32Array;
  int1, int2: TIntX;
begin
  SetLength(temp1, 3);
  temp1[0] := 1;
  temp1[1] := 2;
  temp1[2] := 3;
  SetLength(temp2, 3);
  temp2[0] := 1;
  temp2[1] := 2;
  temp2[2] := 3;
  int1 := TIntX.Create(temp1, True);
  int2 := TIntX.Create(temp2, True);
  Assert.IsTrue(int2 >= int1);
end;

initialization

TDUnitX.RegisterTestFixture(TGreaterEqOpTest);

end.
