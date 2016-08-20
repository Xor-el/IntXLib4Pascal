unit uClassicStringConverter;

{$I ..\Include\IntXLib.inc}

interface

uses
  uStringConverterBase,
  uIStringConverter,
  uDigitOpHelper,
  uIntXLibTypes;

type
  /// <summary>
  /// Classic ToString converting algorithm using division (O[n^2]).
  /// </summary>

  TClassicStringConverter = class sealed(TStringConverterBase)

  public
    /// <summary>
    /// Creates new <see cref="ClassicStringConverter" /> instance.
    /// </summary>
    /// <param name="pow2StringConverter">Converter for pow2 case.</param>
    constructor Create(pow2StringConverter: IIStringConverter);
    /// <summary>
    /// Converts digits from internal representaion into given base.
    /// </summary>
    /// <param name="digits">Big integer digits.</param>
    /// <param name="mlength">Big integer length.</param>
    /// <param name="numberBase">Base to use for output.</param>
    /// <param name="outputLength">Calculated output length (will be corrected inside).</param>
    /// <returns>Conversion result (later will be transformed to string).</returns>
    function ToString(digits: TIntXLibUInt32Array; mlength: UInt32;
      numberBase: UInt32; var outputLength: UInt32)
      : TIntXLibUInt32Array; override;

  end;

implementation

constructor TClassicStringConverter.Create(pow2StringConverter
  : IIStringConverter);

begin

  inherited Create(pow2StringConverter);

end;

function TClassicStringConverter.ToString(digits: TIntXLibUInt32Array;
  mlength: UInt32; numberBase: UInt32; var outputLength: UInt32)
  : TIntXLibUInt32Array;
var
  outputArray, digitsCopy: TIntXLibUInt32Array;
  outputIndex: UInt32;

begin
  outputArray := inherited ToString(digits, mlength, numberBase, outputLength);

  // Maybe base method already converted this number
  if (outputArray <> Nil) then
  begin
    result := outputArray;
    Exit;
  end;

  // Create an output array for storing of number in other base
  SetLength(outputArray, outputLength + 1);

  // Make a copy of initial data
  SetLength(digitsCopy, mlength);

  Move(digits[0], digitsCopy[0], mlength * SizeOf(UInt32));

  // Calculate output numbers by dividing
  outputIndex := 0;
  while (mlength) > 0 do
  begin
    mlength := TDigitOpHelper.DivMod(digitsCopy, mlength, numberBase,
      digitsCopy, outputArray[outputIndex]);
    Inc(outputIndex);
  end;
  outputLength := outputIndex;
  result := outputArray;
end;

end.
