unit PowTest;

interface

uses
  DUnitX.TestFramework,
  // Classes,
  uEnums,
  uIntX;

type

  [TestFixture]
  TPowTest = class(TObject)
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure Simple();
    [Test]
    procedure Zero();
    [Test]
    procedure PowZero();
    [Test]
    procedure PowOne();
    [Test]
    procedure Big();

    {
      Simple output (2^65536). Uncomment to see
      [Test]
      procedure TwoNOut();
    }

  end;

implementation

procedure TPowTest.Setup;
begin
  TIntX.GlobalSettings.MultiplyMode := TMultiplyMode.mmClassic;
end;

[Test]
procedure TPowTest.Simple();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(-1);
  Assert.IsTrue(TIntX.Pow(IntX, 17) = -1);
  Assert.IsTrue(TIntX.Pow(IntX, 18) = 1);
end;

[Test]
procedure TPowTest.Zero();
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(0);
  Assert.IsTrue(TIntX.Pow(IntX, 77) = 0);
end;

[Test]
procedure TPowTest.PowZero();
begin
  Assert.IsTrue(TIntX.Pow(0, 0) = 1);
end;

[Test]
procedure TPowTest.PowOne();
begin
  Assert.IsTrue(TIntX.Pow(7, 1) = 7);
end;

[Test]
procedure TPowTest.Big();
begin
  Assert.AreEqual(TIntX.Pow(2, 65).ToString(), '36893488147419103232');
end;

// Simple output (2^65536). uncomment to see
(* [Test]
  procedure TPowTest.TwoNOut();
  var
  Writer: TStreamWriter;

  begin
  Writer := TStreamWriter.Create('2n65536.txt');
  try
  Writer.WriteLine(TIntX.Pow(2, 65536).ToString);
  finally
  Writer.Free;
  end;

  end; *)

initialization

TDUnitX.RegisterTestFixture(TPowTest);

end.
