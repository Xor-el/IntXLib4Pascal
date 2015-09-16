program IntXLib;

uses
  Vcl.Forms,
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
  MillerRabin in 'IntXLib\MillerRabin\MillerRabin.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Run;

{$WARNINGS OFF}
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
{$WARNINGS ON}

end.
