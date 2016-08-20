unit IntegerSquareRootTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX;

type

  { TTestIntegerSquareRoot }

  TTestIntegerSquareRoot = class(TTestCase)
  published


    procedure SquareRootOfZero();

    procedure SquareRootOfOne();

    procedure SquareRootof4();

    procedure SquareRootof25();

    procedure SquareRootof27();

    procedure SquareRootofVeryBigValue();


    procedure CallSquareRootofNull();

    procedure CallSquareRootofNegativeNumber();

  private
    procedure SquareRootofNull();
    procedure SquareRootofNegativeNumber();

  end;

implementation


procedure TTestIntegerSquareRoot.SquareRootOfZero();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(0);
  AssertTrue(TIntX.IntegerSquareRoot(int1) = 0);
end;


procedure TTestIntegerSquareRoot.SquareRootOfOne();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(1);
  AssertTrue(TIntX.IntegerSquareRoot(int1) = 1);
end;


procedure TTestIntegerSquareRoot.SquareRootof4();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(4);
  AssertTrue(TIntX.IntegerSquareRoot(int1) = 2);
end;


procedure TTestIntegerSquareRoot.SquareRootof25();
var
  int1, res: TIntX;
begin
  int1 := TIntX.Create(25);
  res := TIntX.IntegerSquareRoot(int1);
  AssertTrue(res = 5);
end;


procedure TTestIntegerSquareRoot.SquareRootof27();
var
  int1, res: TIntX;
begin
  int1 := TIntX.Create(27);
  res := TIntX.IntegerSquareRoot(int1);
  AssertTrue(res = 5);
end;


procedure TTestIntegerSquareRoot.SquareRootofVeryBigValue();
var
  int1: TIntX;
begin
  int1 := TIntX.Create('783648276815623658365871365876257862874628734627835648726');
  AssertEquals('27993718524262253829858552106', TIntX.IntegerSquareRoot(int1).ToString);
end;

procedure TTestIntegerSquareRoot.SquareRootofNull();
begin
  TIntX.Create(Default(TIntX));
end;



procedure TTestIntegerSquareRoot.CallSquareRootofNull();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @SquareRootofNull;

  AssertException(EArgumentNilException, TempMethod);
end;

procedure TTestIntegerSquareRoot.SquareRootofNegativeNumber();
var
  int1: TIntX;
begin
  int1 := TIntX.Create(-25);
  TIntX.IntegerSquareRoot(int1);
end;

procedure TTestIntegerSquareRoot.CallSquareRootofNegativeNumber();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @SquareRootofNegativeNumber;

  AssertException(EArgumentException, TempMethod);
end;


initialization

  RegisterTest(TTestIntegerSquareRoot);
end.


