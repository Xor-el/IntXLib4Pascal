unit AsConvertOpTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TAsConvertOpTest = class(TObject)
  public
    [Test]
    procedure AsInteger();
    [Test]
    procedure AsUInt32();
    [Test]
    procedure AsInt64();
    [Test]
    procedure AsUInt64();

  end;

implementation

[Test]
procedure TAsConvertOpTest.AsInteger();
var
  temp: TIntXLibUInt32Array;
  n: Integer;
  IntX: TIntX;
  un: UInt32;
begin
  IntX := TIntX.Create(High(UInt32));
  Assert.WillRaise(
    procedure
    begin
      IntX.AsInteger;
    end, EOverflowException);

  n := 1234567890;
  IntX := n;
  Assert.AreEqual(n, Integer(IntX));

  n := -n;
  IntX := n;
  Assert.AreEqual(n, Integer(IntX));

  n := 0;
  IntX := n;
  Assert.AreEqual(n, Integer(IntX));

  n := 1234567890;
  un := UInt32(n);

  SetLength(temp, 3);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(temp, False);
      IntX.AsInteger;
    end, EOverflowException);

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(temp, True);
      IntX.AsInteger;
    end, EOverflowException);

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(High(Integer)) + 10;
      IntX.AsInteger;
    end, EOverflowException);

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(Low(Integer)) - 10;
      IntX.AsInteger;
    end, EOverflowException);

end;

[Test]
procedure TAsConvertOpTest.AsUInt32();
var
  temp: TIntXLibUInt32Array;
  IntX: TIntX;
  n: UInt32;

begin
  n := 1234567890;
  IntX := n;
  Assert.AreEqual(n, UInt32(IntX));

  n := 0;
  IntX := n;
  Assert.AreEqual(n, UInt32(IntX));

  n := 1234567890;
  SetLength(temp, 3);
  temp[0] := n;
  temp[1] := n;
  temp[2] := n;

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(temp, False);
      IntX.AsUInt32;
    end, EOverflowException);

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(High(UInt32)) + 10;
      IntX.AsUInt32;
    end, EOverflowException);

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(Low(UInt32)) - 10;
      IntX.AsUInt32;
    end, EOverflowException);

end;

[Test]
procedure TAsConvertOpTest.AsInt64();
var
  temp: TIntXLibUInt32Array;
  IntX: TIntX;
  n: Int64;
  un: UInt32;
  ni: Integer;

begin
  n := 1234567890123456789;
  IntX := n;
  Assert.AreEqual(n, Int64(IntX));

  n := -n;
  IntX := n;
  Assert.AreEqual(n, Int64(IntX));

  n := 0;
  IntX := n;
  Assert.AreEqual(n, Int64(IntX));

  un := 1234567890;
  SetLength(temp, 5);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;
  temp[3] := un;
  temp[4] := un;

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(temp, False);
      IntX.AsInt64;
    end, EOverflowException);

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(temp, True);
      IntX.AsInt64;
    end, EOverflowException);

  ni := 1234567890;
  n := ni;
  IntX := ni;
  Assert.AreEqual(n, Int64(IntX));

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(High(Int64)) + 10;
      IntX.AsInt64;
    end, EOverflowException);

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(Low(Int64)) - 10;
      IntX.AsInt64;
    end, EOverflowException);
end;

[Test]
procedure TAsConvertOpTest.AsUInt64();
var
  temp: TIntXLibUInt32Array;
  IntX: TIntX;
  n: UInt64;
  un: UInt32;
begin
  n := 1234567890123456789;
  IntX := n;
  Assert.AreEqual(n, UInt64(IntX));

  n := 0;
  IntX := n;
  Assert.AreEqual(n, UInt64(IntX));

  un := 1234567890;

  SetLength(temp, 5);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;
  temp[3] := un;
  temp[4] := un;

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(temp, False);
      IntX.AsUInt64;
    end, EOverflowException);

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(High(UInt64)) + 10;
      IntX.AsUInt64;
    end, EOverflowException);

  Assert.WillRaise(
    procedure
    begin

      IntX := TIntX.Create(Low(UInt64)) - 10;
      IntX.AsUInt64;
    end, EOverflowException);

end;

initialization

TDUnitX.RegisterTestFixture(TAsConvertOpTest);

end.
