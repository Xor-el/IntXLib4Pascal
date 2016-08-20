unit CustomAlphabetTest;

interface

uses
  DUnitX.TestFramework,
  uEnums,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TCustomAlphabetTest = class(TObject)
  public
    procedure AlphabetNull();

    [Test]
    procedure CallAlphabetNull();
    procedure AlphabetShort();

    [Test]
    procedure CallAlphabetShort();
    procedure AlphabetRepeatingChars();

    [Test]
    procedure CallAlphabetRepeatingChars();
    [Test]
    procedure Parse();
    [Test]
    procedure ToStringTest();

  end;

implementation

procedure TCustomAlphabetTest.AlphabetNull();
begin
  TIntX.Parse('', 20, pmFast);
end;

[Test]
procedure TCustomAlphabetTest.CallAlphabetNull();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := AlphabetNull;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

procedure TCustomAlphabetTest.AlphabetShort();
begin
  TIntX.Parse('', 20, '1234');
end;

[Test]
procedure TCustomAlphabetTest.CallAlphabetShort();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := AlphabetShort;
  Assert.WillRaise(TempMethod, EArgumentException);
end;

procedure TCustomAlphabetTest.AlphabetRepeatingChars();
begin
  TIntX.Parse('', 20, '0123456789ABCDEFGHIJ0');
end;

[Test]
procedure TCustomAlphabetTest.CallAlphabetRepeatingChars();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := AlphabetRepeatingChars;
  Assert.WillRaise(TempMethod, EArgumentException);
end;

[Test]
procedure TCustomAlphabetTest.Parse();
begin
  Assert.AreEqual(19 * 20 + 18,
    Integer(TIntX.Parse('JI', 20, '0123456789ABCDEFGHIJ')));
end;

[Test]
procedure TCustomAlphabetTest.ToStringTest();
begin
  Assert.AreEqual('JI', TIntX.Create(19 * 20 + 18).ToString(20,
    '0123456789ABCDEFGHIJ'));

end;

initialization

TDUnitX.RegisterTestFixture(TCustomAlphabetTest);

end.
