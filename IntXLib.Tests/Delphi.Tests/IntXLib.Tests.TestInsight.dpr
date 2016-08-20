program IntXLib.Tests.TestInsight;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}// {$STRONGLINKTYPES ON}
// Commented out "{$STRONGLINKTYPES ON}" because this prevents
// the test from compiling in Delphi 2010.

uses
  SysUtils,
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
{$ENDIF }
{$IF CompilerVersion = 24.0}
  DUnitX.Init,
{$IFEND }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  uAutoNewtonDivider in '..\..\IntXLib\src\Dividers\uAutoNewtonDivider.pas',
  uClassicDivider in '..\..\IntXLib\src\Dividers\uClassicDivider.pas',
  uDivideManager in '..\..\IntXLib\src\Dividers\uDivideManager.pas',
  uDividerBase in '..\..\IntXLib\src\Dividers\uDividerBase.pas',
  uIDivider in '..\..\IntXLib\src\Dividers\uIDivider.pas',
  uIntX in '..\..\IntXLib\src\IntX\uIntX.pas',
  uMillerRabin in '..\..\IntXLib\src\MillerRabin\uMillerRabin.pas',
  uAutoFhtMultiplier in '..\..\IntXLib\src\Multipliers\uAutoFhtMultiplier.pas',
  uClassicMultiplier in '..\..\IntXLib\src\Multipliers\uClassicMultiplier.pas',
  uIMultiplier in '..\..\IntXLib\src\Multipliers\uIMultiplier.pas',
  uMultiplierBase in '..\..\IntXLib\src\Multipliers\uMultiplierBase.pas',
  uMultiplyManager in '..\..\IntXLib\src\Multipliers\uMultiplyManager.pas',
  uDigitHelper in '..\..\IntXLib\src\OpHelpers\uDigitHelper.pas',
  uDigitOpHelper in '..\..\IntXLib\src\OpHelpers\uDigitOpHelper.pas',
  uFhtHelper in '..\..\IntXLib\src\OpHelpers\uFhtHelper.pas',
  uNewtonHelper in '..\..\IntXLib\src\OpHelpers\uNewtonHelper.pas',
  uOpHelper in '..\..\IntXLib\src\OpHelpers\uOpHelper.pas',
  uStrRepHelper in '..\..\IntXLib\src\OpHelpers\uStrRepHelper.pas',
  uClassicParser in '..\..\IntXLib\src\Parsers\uClassicParser.pas',
  uFastParser in '..\..\IntXLib\src\Parsers\uFastParser.pas',
  uIParser in '..\..\IntXLib\src\Parsers\uIParser.pas',
  uParseManager in '..\..\IntXLib\src\Parsers\uParseManager.pas',
  uParserBase in '..\..\IntXLib\src\Parsers\uParserBase.pas',
  uPow2Parser in '..\..\IntXLib\src\Parsers\uPow2Parser.pas',
  uPcgRandomMinimal in '..\..\IntXLib\src\PcgRandom\uPcgRandomMinimal.pas',
  uIntXGlobalSettings in '..\..\IntXLib\src\Settings\uIntXGlobalSettings.pas',
  uIntXSettings in '..\..\IntXLib\src\Settings\uIntXSettings.pas',
  uClassicStringConverter
    in '..\..\IntXLib\src\StringConverters\uClassicStringConverter.pas',
  uFastStringConverter
    in '..\..\IntXLib\src\StringConverters\uFastStringConverter.pas',
  uIStringConverter
    in '..\..\IntXLib\src\StringConverters\uIStringConverter.pas',
  uPow2StringConverter
    in '..\..\IntXLib\src\StringConverters\uPow2StringConverter.pas',
  uStringConverterBase
    in '..\..\IntXLib\src\StringConverters\uStringConverterBase.pas',
  uStringConvertManager
    in '..\..\IntXLib\src\StringConverters\uStringConvertManager.pas',
  uXBits in '..\..\IntXLib\src\Utils\uXBits.pas',
  uConstants in '..\..\IntXLib\src\Utils\uConstants.pas',
  uDigitConverter in '..\..\IntXLib\src\Utils\uDigitConverter.pas',
  uEnums in '..\..\IntXLib\src\Utils\uEnums.pas',
  uIntXLibTypes in '..\..\IntXLib\src\Utils\uIntXLibTypes.pas',
  uStrings in '..\..\IntXLib\src\Utils\uStrings.pas',
  uUtils in '..\..\IntXLib\src\Utils\uUtils.pas',
  AbsoluteValueTest in 'src\AbsoluteValueTest.pas',
  AddOpTest in 'src\AddOpTest.pas',
  BitwiseAndOpTest in 'src\BitwiseAndOpTest.pas',
  BitwiseOrOpTest in 'src\BitwiseOrOpTest.pas',
  ConstructorTest in 'src\ConstructorTest.pas',
  CustomAlphabetTest in 'src\CustomAlphabetTest.pas',
  DivOpNewtonTest in 'src\DivOpNewtonTest.pas',
  DivOpTest in 'src\DivOpTest.pas',
  EqualsOpTest in 'src\EqualsOpTest.pas',
  ExclusiveOrOpTest in 'src\ExclusiveOrOpTest.pas',
  ExplicitConvertOpTest in 'src\ExplicitConvertOpTest.pas',
  GreaterEqOpTest in 'src\GreaterEqOpTest.pas',
  GreaterOpTest in 'src\GreaterOpTest.pas',
  ImplicitConvertOpTest in 'src\ImplicitConvertOpTest.pas',
  IntegerLogNTest in 'src\IntegerLogNTest.pas',
  IntegerSquareRootTest in 'src\IntegerSquareRootTest.pas',
  IntXZeroandOneTest in 'src\IntXZeroandOneTest.pas',
  IsOddTest in 'src\IsOddTest.pas',
  LessEqOpTest in 'src\LessEqOpTest.pas',
  LessOpTest in 'src\LessOpTest.pas',
  ModOpTest in 'src\ModOpTest.pas',
  MulOpFhtTest in 'src\MulOpFhtTest.pas',
  MulOpTest in 'src\MulOpTest.pas',
{$IF CompilerVersion >= 28.0}
  MultiThreadingTest in 'src\MultiThreadingTest.pas',
{$IFEND }
  NormalizeTest in 'src\NormalizeTest.pas',
  OnesComplementOpTest in 'src\OnesComplementOpTest.pas',
  ParseFastTest in 'src\ParseFastTest.pas',
  ParseTest in 'src\ParseTest.pas',
  PerformanceTest in 'src\PerformanceTest.pas',
  PowTest in 'src\PowTest.pas',
  ShiftOpTest in 'src\ShiftOpTest.pas',
  SubOpTest in 'src\SubOpTest.pas',
  TestHelper in 'src\TestHelper.pas',
  ToStringFastTest in 'src\ToStringFastTest.pas',
  ToStringTest in 'src\ToStringTest.pas',
  UnaryOpTest in 'src\UnaryOpTest.pas',
  LogNTest in 'src\LogNTest.pas',
  AsConvertOpTest in 'src\AsConvertOpTest.pas',
  LCMOpTest in 'src\LCMOpTest.pas',
  GCDOpTest in 'src\GCDOpTest.pas',
  InvModOpTest in 'src\InvModOpTest.pas',
  ModPowOpTest in 'src\ModPowOpTest.pas',
  BezoutsIdentityOpTest in 'src\BezoutsIdentityOpTest.pas',
  IsProbablyPrimeOpTest in 'src\IsProbablyPrimeOpTest.pas';

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
