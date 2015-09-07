unit ParseManager;

{
  * Copyright (c) 2015 Ugochukwu Mmaduekwe ugo4brain@gmail.com

  *   This Source Code Form is subject to the terms of the Mozilla Public License
  * v. 2.0. If a copy of the MPL was not distributed with this file, You can
  * obtain one at http://mozilla.org/MPL/2.0/.

  *   Neither the name of Ugochukwu Mmaduekwe nor the names of its contributors may
  *  be used to endorse or promote products derived from this software without
  *  specific prior written permission.

}

interface

uses
  SysUtils, IParser, Enums, Pow2Parser, ClassicParser, FastParser, IntX;

type
  /// <summary>
  /// Used to retrieve needed parser.
  /// </summary>

  TParseManager = class

  public

    class constructor Create();
    class destructor Destroy();
    class function GetParser(mode: TParseMode): IIParser;
    class function GetCurrentParser(): IIParser;

  class var
    /// <summary>
    /// Classic parser instance.
    /// </summary>

    FClassicParser: IIParser;

    /// <summary>
    /// Fast parser instance.
    /// </summary>

    FFastParser: IIParser;

  end;

implementation

// static class constructor
class constructor TParseManager.Create();
var
  Pow2Parser: IIParser;
  mclassicParser: IIParser;
begin
  // Create new pow2 parser instance
  Pow2Parser := TPow2Parser.Create();

  // Create new classic parser instance
  mclassicParser := TClassicParser.Create(Pow2Parser);

  // Fill publicity visible parser fields
  FClassicParser := mclassicParser;
  FFastParser := TFastParser.Create(Pow2Parser, mclassicParser);
end;

class destructor TParseManager.Destroy();
begin

  FClassicParser := Nil;
  FFastParser := Nil;
end;

/// <summary>
/// Returns parser instance for given parse mode.
/// </summary>
/// <param name="mode">Parse mode.</param>
/// <returns>Parser instance.</returns>
/// <exception cref="EArgumentOutOfRangeException"><paramref name="mode" /> is out of range.</exception>

class function TParseManager.GetParser(mode: TParseMode): IIParser;
begin
  case (mode) of
    TParseMode.pmFast:
      begin
        result := FFastParser;
        Exit;
      end;
    TParseMode.pmClassic:
      begin
        result := FClassicParser;
        Exit;
      end
  else
    begin
      raise EArgumentOutOfRangeException.Create('mode');
    end;
  end;
end;

/// <summary>
/// Returns current parser instance.
/// </summary>
/// <returns>Current parser instance.</returns>

class function TParseManager.GetCurrentParser(): IIParser;
begin
  result := GetParser(TIntX.GlobalSettings.ParseMode);
end;

end.
