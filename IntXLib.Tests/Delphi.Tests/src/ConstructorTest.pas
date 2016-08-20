unit ConstructorTest;

interface

uses
  DUnitX.TestFramework,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  [TestFixture]
  TConstructorTest = class(TObject)
  public
    [Test]
    procedure DefaultCtor();
    [Test]
    procedure IntCtor();
    [Test]
    procedure UInt32Ctor();
    [Test]
    procedure IntArrayCtor();

    procedure IntArrayNullCtor();

    [Test]
    procedure CallIntArrayNullCtor();

  end;

implementation

[Test]
procedure TConstructorTest.DefaultCtor();
begin
  TIntX.Create(0);
end;

[Test]
procedure TConstructorTest.IntCtor();
begin
  TIntX.Create(7);
end;

[Test]
procedure TConstructorTest.UInt32Ctor();
begin
  TIntX.Create(TConstants.MaxUInt32Value);
end;

[Test]
procedure TConstructorTest.IntArrayCtor();
var
  temp: TIntXLibUInt32Array;
begin
  SetLength(temp, 3);
  temp[0] := 1;
  temp[1] := 2;
  temp[2] := 3;
  TIntX.Create(temp, True);
end;

procedure TConstructorTest.IntArrayNullCtor();
var
  temp: TIntXLibUInt32Array;
begin
  temp := Nil;
  TIntX.Create(temp, False);
end;

[Test]
procedure TConstructorTest.CallIntArrayNullCtor();
var
  TempMethod: TTestLocalMethod;
begin
  TempMethod := IntArrayNullCtor;

  Assert.WillRaise(TempMethod, EArgumentNilException);
end;

initialization

TDUnitX.RegisterTestFixture(TConstructorTest);

end.
