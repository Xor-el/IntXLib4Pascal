program IntXLib.Tests;

{$mode objfpc}{$H+}

uses
  consoletestrunner,
  AbsoluteValueTest,
  AddOpTest,
  BitwiseAndOpTest,
  BitwiseOrOpTest,
  ConstructorTest,
  CustomAlphabetTest,
  TestHelper,
  DivOpNewtonTest,
  DivOpTest,
  EqualsOpTest,
  ExclusiveOrOpTest,
  ExplicitConvertOpTest,
  GreaterEqOpTest,
  GreaterOpTest,
  ImplicitConvertOpTest,
  IntegerLogNTest,
  IntegerSquareRootTest,
  IntXZeroandOneTest,
  IsOddTest,
  LessEqOpTest,
  LessOpTest,
  ModOpTest,
  MulOpFhtTest,
  MulOpTest,
  NormalizeTest,
  OnesComplementOpTest,
  ParseFastTest,
  ParseTest,
  PerformanceTest,
  PowTest,
  ShiftOpTest,
  SubOpTest,
  ToStringFastTest,
  ToStringTest,
  UnaryOpTest,
  LogNTest,
  GCDOpTest,
  InvModOpTest,
  ModPowOpTest,
  BezoutsIdentityOpTest,
  IsProbablyPrimeOpTest,
  AsConvertOpTest;

type

  { TIntXLibConsoleTestRunner }

  TIntXLibConsoleTestRunner = class(TTestRunner)
  protected
    // override the protected methods of TTestRunner to customize its behaviour
end;

var
Application: TIntXLibConsoleTestRunner;

begin
  Application := TIntXLibConsoleTestRunner.Create(nil);
  Application.Initialize;
  Application.Run;
  Application.Free;
end.
                                
