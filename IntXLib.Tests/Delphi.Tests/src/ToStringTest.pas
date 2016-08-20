unit ToStringTest;

interface

uses
  DUnitX.TestFramework,
  SysUtils,
  uIntX,
  uConstants;

type

  [TestFixture]
  TToStringTest = class(TObject)
  public
    [Test]
    procedure VerySimple();
    [Test]
    procedure Simple();
    [Test]
    procedure Zero();
    [Test]
    procedure Neg();
    [Test]
    procedure Big();
    [Test]
    procedure Binary();
    [Test]
    procedure Octal();
    [Test]
    procedure Octal2();
    [Test]
    procedure Octal3();
    [Test]
    procedure Hex();
    [Test]
    procedure HexLower();
    [Test]
    procedure OtherBase();
  end;

implementation

[Test]
procedure TToStringTest.VerySimple();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(11);
  Assert.AreEqual(IntX.ToString(), '11');
end;

[Test]
procedure TToStringTest.Simple();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(12345670);
  Assert.AreEqual(IntX.ToString(), '12345670');
end;

[Test]
procedure TToStringTest.Zero();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(0);
  Assert.AreEqual(IntX.ToString(), '0');
end;

[Test]
procedure TToStringTest.Neg();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(TConstants.MinIntValue);
  Assert.AreEqual(IntX.ToString(), InttoStr(TConstants.MinIntValue));
end;

[Test]
procedure TToStringTest.Big();
var
  IntX: TIntX;
  Int64X: Int64;
begin
  IntX := TIntX.Create(TConstants.MaxIntValue);
  IntX := IntX + IntX + IntX + IntX + IntX + IntX + IntX + IntX;
  Int64X := TConstants.MaxIntValue;
  Int64X := Int64X + Int64X + Int64X + Int64X + Int64X + Int64X +
    Int64X + Int64X;
  Assert.AreEqual(IntX.ToString(), InttoStr(Int64X));
end;

[Test]
procedure TToStringTest.Binary();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(19);
  Assert.AreEqual(IntX.ToString(2), '10011');
end;

[Test]
procedure TToStringTest.Octal();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(100);
  Assert.AreEqual(IntX.ToString(8), '144');
end;

[Test]
procedure TToStringTest.Octal2();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(901);
  Assert.AreEqual(IntX.ToString(8), '1605');
end;

[Test]
procedure TToStringTest.Octal3();
var
  IntX: TIntX;
begin
  IntX := $80000000;
  Assert.AreEqual(IntX.ToString(8), '20000000000');
  IntX := $100000000;
  Assert.AreEqual(IntX.ToString(8), '40000000000');
end;

[Test]
procedure TToStringTest.Hex();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create($ABCDEF);
  Assert.AreEqual(IntX.ToString(16), 'ABCDEF');
end;

[Test]
procedure TToStringTest.HexLower();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create($FF00FF00FF00FF);
  Assert.AreEqual(IntX.ToString(16, False), 'ff00ff00ff00ff');
end;

[Test]
procedure TToStringTest.OtherBase();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(-144);
  Assert.AreEqual(IntX.ToString(140), '-{1}{4}');
end;

initialization

TDUnitX.RegisterTestFixture(TToStringTest);

end.
