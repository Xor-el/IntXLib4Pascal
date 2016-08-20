unit uIntXLibTypes;

{$I ..\Include\IntXLib.inc}

interface

uses
{$IFDEF FPC}
  fgl,
{$ENDIF FPC}
  SysUtils;

type

  TFormatSettings = SysUtils.TFormatSettings;
  EOverflowException = EOverflow;
  EArgumentNilException = class(Exception);
  EFhtMultiplicationException = class(Exception);
  EFormatException = class(Exception);
  EArithmeticException = SysUtils.EMathError;
  EArgumentException = SysUtils.EArgumentException;
  EArgumentOutOfRangeException = SysUtils.EArgumentOutOfRangeException;
  EDivByZero = SysUtils.EDivByZero;

{$IFDEF FPC}
  TDictionary<TKey, TValue> = class(TFPGMap<TKey, TValue>);
{$ENDIF FPC}
{$IFDEF DELPHIXE_UP}
  /// <summary>
  /// Represents a dynamic array of UInt32.
  /// </summary>
  TIntXLibUInt32Array = TArray<UInt32>;

  /// <summary>
  /// Represents a dynamic array of Double.
  /// </summary>
  TIntXLibDoubleArray = TArray<Double>;

  /// <summary>
  /// Represents a dynamic array of char.
  /// </summary>
  TIntXLibCharArray = TArray<Char>;

{$ELSE}
  /// <summary>
  /// Represents a dynamic array of UInt32.
  /// </summary>
  TIntXLibUInt32Array = array of UInt32;

  /// <summary>
  /// Represents a dynamic array of Double.
  /// </summary>
  TIntXLibDoubleArray = array of Double;

  /// <summary>
  /// Represents a dynamic array of char.
  /// </summary>
  TIntXLibCharArray = array of Char;

{$ENDIF DELPHIXE_UP}

implementation

end.
