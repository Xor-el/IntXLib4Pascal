unit ExplicitConvertOpTest;

interface

uses
  DUnitX.TestFramework, SysUtils, IntX, DTypes;

type

  [TestFixture]
  TExplicitConvertOpTest = class(TObject)
  public
    [Test]
    procedure ConvertToInteger();
    [Test]
    procedure ConvertToUInt32();
    [Test]
    procedure ConvertToInt64();
    [Test]
    procedure ConvertToUInt64();
    [Test]
    procedure ConvertToWord();
    procedure ConvertNullToInteger();
    // [Test, ExpectedException(typeof(EArgumentNilException))]
    [Test]
    procedure CallConvertNullToInteger();
    procedure ConvertNullToUInt32();
    // [Test, ExpectedException(typeof(EArgumentNilException))]
    [Test]
    procedure CallConvertNullToUInt32();
    procedure ConvertNullToInt64();
    // [Test, ExpectedException(typeof(EArgumentNilException))]
    [Test]
    procedure CallConvertNullToInt64();
    procedure ConvertNullToUInt64();
    // [Test, ExpectedException(typeof(EArgumentNilException))]
    [Test]
    procedure CallConvertNullToUInt64();
    procedure ConvertNullToWord();
    // [Test, ExpectedException(typeof(EArgumentNilException))]
    [Test]
    procedure CallConvertNullToWord();
    procedure ConvertNullToSingle();
    // [Test, ExpectedException(typeof(EArgumentNilException))]
    [Test]
    procedure CallConvertNullToSingle();
    procedure ConvertNullToDouble();
    // [Test, ExpectedException(typeof(EArgumentNilException))]
    [Test]
    procedure CallConvertNullToDouble();

  end;

implementation

[Test]
procedure TExplicitConvertOpTest.ConvertToInteger();
var
  temp: TMyUInt32Array;
  n: Integer;
  IntX: TIntX;
  un: UInt32;
begin
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
  IntX := TIntX.Create(temp, False);
  Assert.AreEqual(n, Integer(IntX));
  IntX := TIntX.Create(temp, True);
  Assert.AreEqual(-n, Integer(IntX));
end;

[Test]
procedure TExplicitConvertOpTest.ConvertToUInt32();
var
  temp: TMyUInt32Array;
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
  IntX := TIntX.Create(temp, False);
  Assert.AreEqual(n, UInt32(IntX));
end;

[Test]
procedure TExplicitConvertOpTest.ConvertToInt64();
var
  temp: TMyUInt32Array;
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
  n := Int64((un or UInt64(un) shl 32));
  SetLength(temp, 5);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;
  temp[3] := un;
  temp[4] := un;
  IntX := TIntX.Create(temp, False);
  Assert.AreEqual(n, Int64(IntX));
  IntX := TIntX.Create(temp, True);
  Assert.AreEqual(-n, Int64(IntX));

  ni := 1234567890;
  n := ni;
  IntX := ni;
  Assert.AreEqual(n, Int64(IntX));
end;

[Test]
procedure TExplicitConvertOpTest.ConvertToUInt64();
var
  temp: TMyUInt32Array;
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
  n := un or UInt64(un) shl 32;
  SetLength(temp, 5);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;
  temp[3] := un;
  temp[4] := un;
  IntX := TIntX.Create(temp, False);
  Assert.AreEqual(n, UInt64(IntX));

  n := un;
  IntX := un;
  Assert.AreEqual(n, UInt64(IntX));
end;

[Test]
procedure TExplicitConvertOpTest.ConvertToWord();
var
  n: Word;
  IntX: TIntX;
begin
  n := 12345;
  IntX := n;
  Assert.AreEqual(n, Word(IntX));

  n := 0;
  IntX := n;
  Assert.AreEqual(n, Word(IntX));
end;

procedure TExplicitConvertOpTest.ConvertNullToInteger();

begin
  Integer(TIntX(Default (TIntX)));
end;

// [Test, ExpectedException(typeof(EArgumentNilException))]
[Test]
procedure TExplicitConvertOpTest.CallConvertNullToInteger();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := ConvertNullToInteger;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

procedure TExplicitConvertOpTest.ConvertNullToUInt32();

begin
  UInt32(TIntX(Default (TIntX)));

end;

// [Test, ExpectedException(typeof(EArgumentNilException))]
[Test]
procedure TExplicitConvertOpTest.CallConvertNullToUInt32();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := ConvertNullToUInt32;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

procedure TExplicitConvertOpTest.ConvertNullToInt64();

begin
  Int64(TIntX(Default (TIntX)));
end;

// [Test, ExpectedException(typeof(EArgumentNilException))]
[Test]
procedure TExplicitConvertOpTest.CallConvertNullToInt64();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := ConvertNullToInt64;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

procedure TExplicitConvertOpTest.ConvertNullToUInt64();

begin
  UInt64(TIntX(Default (TIntX)));

end;

// [Test, ExpectedException(typeof(EArgumentNilException))]
[Test]
procedure TExplicitConvertOpTest.CallConvertNullToUInt64();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := ConvertNullToUInt64;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

procedure TExplicitConvertOpTest.ConvertNullToWord();

begin
  Word(TIntX(Default (TIntX)));
end;

// [Test, ExpectedException(typeof(EArgumentNilException))]
[Test]
procedure TExplicitConvertOpTest.CallConvertNullToWord();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := ConvertNullToWord;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

procedure TExplicitConvertOpTest.ConvertNullToSingle();

begin
  Single(TIntX(Default (TIntX)));
end;

// [Test, ExpectedException(typeof(EArgumentNilException))]
[Test]
procedure TExplicitConvertOpTest.CallConvertNullToSingle();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := ConvertNullToSingle;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

procedure TExplicitConvertOpTest.ConvertNullToDouble();

begin
  Double(TIntX(Default (TIntX)));
end;

// [Test, ExpectedException(typeof(EArgumentNilException))]
[Test]
procedure TExplicitConvertOpTest.CallConvertNullToDouble();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := ConvertNullToDouble;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

initialization

TDUnitX.RegisterTestFixture(TExplicitConvertOpTest);

end.
