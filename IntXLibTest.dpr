program IntXLibTest;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}

uses
  SysUtils,
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
{$ENDIF }

  //DUnitX.Init,  // <== Uncomment this line if you use Delphi XE3
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Constants in 'IntXLib\Utils\Constants.pas',
  StrRepHelper in 'IntXLib\OpHelpers\StrRepHelper.pas',
  Strings in 'IntXLib\Utils\Strings.pas',
  Enums in 'IntXLib\Utils\Enums.pas',
  Bits in 'IntXLib\Bits.pas',
  DigitConverter in 'IntXLib\DigitConverter.pas',
  NewtonHelper in 'IntXLib\OpHelpers\NewtonHelper.pas',
  DigitOpHelper in 'IntXLib\OpHelpers\DigitOpHelper.pas',
  DTypes in 'IntXLib\Utils\DTypes.pas',
  DigitHelper in 'IntXLib\OpHelpers\DigitHelper.pas',
  IMultiplier in 'IntXLib\Multipliers\IMultiplier.pas',
  MultiplyManager in 'IntXLib\Multipliers\MultiplyManager.pas',
  MultiplierBase in 'IntXLib\Multipliers\MultiplierBase.pas',
  ClassicMultiplier in 'IntXLib\Multipliers\ClassicMultiplier.pas',
  AutoFhtMultiplier in 'IntXLib\Multipliers\AutoFhtMultiplier.pas',
  FhtHelper in 'IntXLib\OpHelpers\FhtHelper.pas',
  IDivider in 'IntXLib\Dividers\IDivider.pas',
  DivideManager in 'IntXLib\Dividers\DivideManager.pas',
  DividerBase in 'IntXLib\Dividers\DividerBase.pas',
  AutoNewtonDivider in 'IntXLib\Dividers\AutoNewtonDivider.pas',
  ClassicDivider in 'IntXLib\Dividers\ClassicDivider.pas',
  IStringConverter in 'IntXLib\StringConverters\IStringConverter.pas',
  ClassicStringConverter
    in 'IntXLib\StringConverters\ClassicStringConverter.pas',
  Pow2StringConverter in 'IntXLib\StringConverters\Pow2StringConverter.pas',
  FastStringConverter in 'IntXLib\StringConverters\FastStringConverter.pas',
  IntXGlobalSettings in 'IntXLib\Settings\IntXGlobalSettings.pas',
  IntXSettings in 'IntXLib\Settings\IntXSettings.pas',
  IntX in 'IntXLib\IntX.pas',
  IParser in 'IntXLib\Parsers\IParser.pas',
  ParseManager in 'IntXLib\Parsers\ParseManager.pas',
  Pow2Parser in 'IntXLib\Parsers\Pow2Parser.pas',
  ClassicParser in 'IntXLib\Parsers\ClassicParser.pas',
  ParserBase in 'IntXLib\Parsers\ParserBase.pas',
  FastParser in 'IntXLib\Parsers\FastParser.pas',
  StringConverterBase in 'IntXLib\StringConverters\StringConverterBase.pas',
  StringConvertManager in 'IntXLib\StringConverters\StringConvertManager.pas',
  OpHelper in 'IntXLib\OpHelpers\OpHelper.pas',
  MT19937_32 in 'IntXLib\MersenneTwister\MT19937_32.pas',
  AddOpTest in 'IntXLib.Test\AddOpTest.pas',
  BitwiseAndOpTest in 'IntXLib.Test\BitwiseAndOpTest.pas',
  BitwiseOrOpTest in 'IntXLib.Test\BitwiseOrOpTest.pas',
  ConstructorTest in 'IntXLib.Test\ConstructorTest.pas',
  CustomAlphabetTest in 'IntXLib.Test\CustomAlphabetTest.pas',
  DivOpTest in 'IntXLib.Test\DivOpTest.pas',
  EqualsOpTest in 'IntXLib.Test\EqualsOpTest.pas',
  ExclusiveOrOpTest in 'IntXLib.Test\ExclusiveOrOpTest.pas',
  ExplicitConvertOpTest in 'IntXLib.Test\ExplicitConvertOpTest.pas',
  GreaterEqOpTest in 'IntXLib.Test\GreaterEqOpTest.pas',
  GreaterOpTest in 'IntXLib.Test\GreaterOpTest.pas',
  ImplicitConvertOpTest in 'IntXLib.Test\ImplicitConvertOpTest.pas',
  IsOddTest in 'IntXLib.Test\IsOddTest.pas',
  LessEqOpTest in 'IntXLib.Test\LessEqOpTest.pas',
  LessOpTest in 'IntXLib.Test\LessOpTest.pas',
  ModOpTest in 'IntXLib.Test\ModOpTest.pas',
  MulOpTest in 'IntXLib.Test\MulOpTest.pas',
  NormalizeTest in 'IntXLib.Test\NormalizeTest.pas',
  OnesComplementOpTest in 'IntXLib.Test\OnesComplementOpTest.pas',
  ParseTest in 'IntXLib.Test\ParseTest.pas',
  PowTest in 'IntXLib.Test\PowTest.pas',
  ShiftOpTest in 'IntXLib.Test\ShiftOpTest.pas',
  SubOpTest in 'IntXLib.Test\SubOpTest.pas',
  ToStringTest in 'IntXLib.Test\ToStringTest.pas',
  UnaryOpTest in 'IntXLib.Test\UnaryOpTest.pas',
  TestHelper in 'IntXLib.Test\TestHelper.pas',
  PerformanceTest in 'IntXLib.Test\PerformanceTest.pas',
  ToStringFastTest in 'IntXLib.Test\ToStringFastTest.pas',
  ParseFastTest in 'IntXLib.Test\ParseFastTest.pas',
  DivOpNewtonTest in 'IntXLib.Test\DivOpNewtonTest.pas',
  MulOpFhtTest in 'IntXLib.Test\MulOpFhtTest.pas',
  SquareRootTest in 'IntXLib.Test\SquareRootTest.pas',
  MultiThreadingTest in 'IntXLib.Test\MultiThreadingTest.pas',
  IntXZeroandOneTest in 'IntXLib.Test\IntXZeroandOneTest.pas',
  AbsoluteValueTest in 'IntXLib.Test\AbsoluteValueTest.pas',
  LogNTest in 'IntXLib.Test\LogNTest.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger: ITestLogger;

begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    // Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    // Create the test runner
    runner := TDUnitX.CreateRunner;
    // Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    // tell the runner how we will log things
    // Log to the console window
    logger := TDUnitXConsoleLogger.Create(True);
    runner.AddLogger(logger);
    // Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create
      (TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False;
    // When true, Assertions must be made during tests;

    // Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

{$IFNDEF CI}
    // We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
{$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;

end.
