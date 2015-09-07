unit SquareRootTest;

interface

uses
  DUnitX.TestFramework, SysUtils, IntX;

type

  [TestFixture]
  TSquareRootTest = class(TObject)
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
    // [Test, ExpectedException(typeof(EArgumentNilException))]
    [Test]
    procedure CallSquareRootofNull();
    procedure SquareRootofNegativeNumber();
    // [Test, ExpectedException(typeof(EArgumentException))]
    [Test]
    procedure CallSquareRootofNegativeNumber();
  end;

implementation

[Test]
procedure TSquareRootTest.SquareRootOfZero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(0);
  Assert.IsTrue(TIntX.SquareRoot(int1) = 0);
end;

[Test]
procedure TSquareRootTest.SquareRootOfOne();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(1);
  Assert.IsTrue(TIntX.SquareRoot(int1) = 1);
end;

[Test]
procedure TSquareRootTest.SquareRootof4();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(4);
  Assert.IsTrue(TIntX.SquareRoot(int1) = 2);
end;

[Test]
procedure TSquareRootTest.SquareRootof25();
var
  int1, res : TIntX;
begin
  int1 := TIntX.Create(25);
  res := TIntX.SquareRoot(int1);
  Assert.IsTrue(res = 5);
end;

[Test]
procedure TSquareRootTest.SquareRootof27();
var
  int1, res: TIntX;
begin
  int1 := TIntX.Create(27);
  res := TIntX.SquareRoot(int1);
  Assert.IsTrue(res = 5);
end;

[Test]
procedure TSquareRootTest.SquareRootofVeryBigValue();
var
  int1: TIntX;
begin
  int1 := TIntX.Create
    ('783648276815623658365871365876257862874628734627835648726');
  Assert.AreEqual(TIntX.SquareRoot(int1).ToString,
    '27993718524262253829858552106');
end;

procedure TSquareRootTest.SquareRootofNull();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(Default (TIntX));
end;

// [Test, ExpectedException(typeof(EArgumentNilException))]
[Test]
procedure TSquareRootTest.CallSquareRootofNull();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := SquareRootofNull;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

procedure TSquareRootTest.SquareRootofNegativeNumber();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(-25);
  TIntX.SquareRoot(int1);
end;

// [Test, ExpectedException(typeof(EArgumentException))]
[Test]
procedure TSquareRootTest.CallSquareRootofNegativeNumber();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := SquareRootofNegativeNumber;

  Assert.WillRaise(TempMethod, EArgumentException);
end;

initialization

TDUnitX.RegisterTestFixture(TSquareRootTest);

end.
