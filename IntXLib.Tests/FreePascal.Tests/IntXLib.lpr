program IntXLib;

{$mode objfpc}{$H+}

uses
  Interfaces,
  Forms,
  GuiTestRunner,
  //fpcunittestrunner,
  AbsoluteValueTest,
  AddOpTest,
  BitwiseAndOpTest,
  BitwiseOrOpTest,
  ConstructorTest,
  CustomAlphabetTest,
  // TestHelper,
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

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.
