unit ParseTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TParseTest = class(TObject)
  public
    [Test]
    procedure Zero();
    [Test]
    procedure WhiteSpace();
    [Test]
    procedure Sign();
    [Test]
    procedure Base();
    procedure Null();
    [Test]
    procedure CallNull();
    procedure InvalidFormat();
    [Test]
    procedure CallInvalidFormat();
    procedure InvalidFormat2();
    [Test]
    procedure CallInvalidFormat2();
    procedure InvalidFormat3();
    [Test]
    procedure CallInvalidFormat3();
    [Test]
    procedure BigDec();
  end;

implementation

[Test]
procedure TParseTest.Zero();
var
  int1: TIntX;
begin
  int1 := TIntX.Parse('0');
  Assert.IsTrue(int1 = 0);
end;

[Test]
procedure TParseTest.WhiteSpace();
var
  int1: TIntX;
begin
  int1 := TIntX.Parse('  7 ');
  Assert.IsTrue(int1 = 7);
end;

[Test]
procedure TParseTest.Sign();
var
  int1: TIntX;
begin
  int1 := TIntX.Parse('-7');
  Assert.IsTrue(int1 = -7);
  int1 := TIntX.Parse('+7');
  Assert.IsTrue(int1 = 7);
end;

[Test]
procedure TParseTest.Base();
var
  int1: TIntX;
begin
  int1 := TIntX.Parse('abcdef', 16);
  Assert.IsTrue(int1 = $ABCDEF);
  int1 := TIntX.Parse('100', 8);
  Assert.IsTrue(int1 = 64);
  int1 := TIntX.Parse('0100');
  Assert.IsTrue(int1 = 64);
  int1 := TIntX.Parse('0100000000000');
  Assert.IsTrue(int1 = $200000000);
  int1 := TIntX.Parse('$abcdef');
  Assert.IsTrue(int1 = $ABCDEF);
  int1 := TIntX.Parse('$ABCDEF');
  Assert.IsTrue(int1 = $ABCDEF);
  int1 := TIntX.Parse('020000000000');
  Assert.IsTrue(int1 = $80000000);
  int1 := TIntX.Parse('0xdeadbeef');
  Assert.IsTrue(int1 = $DEADBEEF);
  int1 := TIntX.Parse('0Xdeadbeef');
  Assert.IsTrue(int1 = $DEADBEEF);
end;

procedure TParseTest.Null();
begin
  TIntX.Parse('');
end;

[Test]
procedure TParseTest.CallNull();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := Null;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

procedure TParseTest.InvalidFormat();
begin
  TIntX.Parse('-123-');
end;

[Test]
procedure TParseTest.CallInvalidFormat();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := InvalidFormat;

  Assert.WillRaise(TempMethod, EFormatException);
end;

procedure TParseTest.InvalidFormat2();
begin
  TIntX.Parse('abc');
end;

[Test]
procedure TParseTest.CallInvalidFormat2();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := InvalidFormat2;

  Assert.WillRaise(TempMethod, EFormatException);
end;

procedure TParseTest.InvalidFormat3();
begin
  TIntX.Parse('987', 2);
end;

[Test]
procedure TParseTest.CallInvalidFormat3();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := InvalidFormat3;

  Assert.WillRaise(TempMethod, EFormatException);
end;

[Test]
procedure TParseTest.BigDec();
var
  IntX: TIntX;
begin
  IntX := TIntX.Parse
    ('34589238954389567586547689234723587070897800300450823748275895896384753238944985');
  Assert.AreEqual(IntX.ToString(),
    '34589238954389567586547689234723587070897800300450823748275895896384753238944985');
end;

initialization

TDUnitX.RegisterTestFixture(TParseTest);

end.
