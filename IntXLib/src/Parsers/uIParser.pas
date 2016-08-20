unit uIParser;

{$I ..\Include\IntXLib.inc}

interface

uses
{$IFDEF DELPHI}
  Generics.Collections,
{$ENDIF DELPHI}
{$IFDEF FPC}
  fgl,
{$ENDIF FPC}
  uIntX,
  uIntXLibTypes;

type
  /// <summary>
  /// Parser class interface.
  /// </summary>

  IIParser = interface(IInterface)
    ['{933EE4BE-5EC3-4E51-8EBB-033D0E10F793}']

    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="numberBase">Number base.</param>
    /// <param name="charToDigits">Char->digit dictionary.</param>
    /// <param name="checkFormat">Check actual format of number (0 or ("$" or "0x") at start).</param>
    /// <returns>Parsed object.</returns>

    function Parse(const value: String; numberBase: UInt32;
      charToDigits: TDictionary<Char, UInt32>; checkFormat: Boolean)
      : TIntX; overload;
    /// <summary>
    /// Parses provided string representation of <see cref="TIntX" /> object.
    /// </summary>
    /// <param name="value">Number as string.</param>
    /// <param name="startIndex">Index inside string from which to start.</param>
    /// <param name="endIndex">Index inside string on which to end.</param>
    /// <param name="numberBase">Number base.</param>
    /// <param name="charToDigits">Char->digit dictionary.</param>
    /// <param name="digitsRes">Resulting digits.</param>
    /// <returns>Parsed integer length.</returns>

    function Parse(const value: String; startIndex: Integer; endIndex: Integer;
      numberBase: UInt32; charToDigits: TDictionary<Char, UInt32>;
      digitsRes: TIntXLibUInt32Array): UInt32; overload;

  end;

implementation

end.
