unit IntegerSquareRootTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TIntegerSquareRootTest = class(TObject)
  public
    [Test]
    procedure SquareRootOfZero();
    [Test]
    procedure SquareRootOfOne();
    [Test]
    procedure SquareRootof4();
    [Test]
    procedure SquareRootof25();
    [Test]
    procedure SquareRootof27();
    [Test]
    procedure SquareRootofVeryBigValue();
    procedure SquareRootofNull();

    [Test]
    procedure CallSquareRootofNull();
    procedure SquareRootofNegativeNumber();

    [Test]
    procedure CallSquareRootofNegativeNumber();
  end;

implementation

[Test]
procedure TIntegerSquareRootTest.SquareRootOfZero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(0);
  Assert.IsTrue(TIntX.IntegerSquareRoot(int1) = 0);
end;

[Test]
procedure TIntegerSquareRootTest.SquareRootOfOne();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(1);
  Assert.IsTrue(TIntX.IntegerSquareRoot(int1) = 1);
end;

[Test]
procedure TIntegerSquareRootTest.SquareRootof4();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(4);
  Assert.IsTrue(TIntX.IntegerSquareRoot(int1) = 2);
end;

[Test]
procedure TIntegerSquareRootTest.SquareRootof25();
var
  int1, res: TIntX;
begin
  int1 := TIntX.Create(25);
  res := TIntX.IntegerSquareRoot(int1);
  Assert.IsTrue(res = 5);
end;

[Test]
procedure TIntegerSquareRootTest.SquareRootof27();
var
  int1, res: TIntX;
begin
  int1 := TIntX.Create(27);
  res := TIntX.IntegerSquareRoot(int1);
  Assert.IsTrue(res = 5);
end;

[Test]
procedure TIntegerSquareRootTest.SquareRootofVeryBigValue();
var
  int1: TIntX;
begin
  int1 := TIntX.Create
    ('783648276815623658365871365876257862874628734627835648726');
  Assert.AreEqual(TIntX.IntegerSquareRoot(int1).ToString,
    '27993718524262253829858552106');
end;

procedure TIntegerSquareRootTest.SquareRootofNull();
begin
  TIntX.Create(Default (TIntX));
end;

[Test]
procedure TIntegerSquareRootTest.CallSquareRootofNull();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := SquareRootofNull;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

procedure TIntegerSquareRootTest.SquareRootofNegativeNumber();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(-25);
  TIntX.IntegerSquareRoot(int1);
end;

[Test]
procedure TIntegerSquareRootTest.CallSquareRootofNegativeNumber();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := SquareRootofNegativeNumber;

  Assert.WillRaise(TempMethod, EArgumentException);
end;

initialization

TDUnitX.RegisterTestFixture(TIntegerSquareRootTest);

end.
