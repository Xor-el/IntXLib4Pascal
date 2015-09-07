unit IntXGlobalSettings;

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

  SyncObjs, Enums;

type
  /// <summary>
  /// <see cref="IntX" /> global settings.
  /// </summary>

  TIntXGlobalSettings = class sealed

  private
    F_multiplyMode: TMultiplyMode;

    F_divideMode: TDivideMode;

    F_parseMode: TParseMode;

    F_toStringMode: TToStringMode;

    F_autoNormalize: Boolean;

    F_applyFhtValidityCheck: Boolean;

  public

    constructor Create();
    destructor Destroy(); override;

    function GetMultiplyMode: TMultiplyMode;
    procedure SetMultiplyMode(value: TMultiplyMode);
    function GetDivideMode: TDivideMode;
    procedure SetDivideMode(value: TDivideMode);
    function GetParseMode: TParseMode;
    procedure SetParseMode(value: TParseMode);
    function GetToStringMode: TToStringMode;
    procedure SetToStringMode(value: TToStringMode);
    function GetAutoNormalize: Boolean;
    procedure SetAutoNormalize(value: Boolean);
    function GetApplyFhtValidityCheck: Boolean;
    procedure SetApplyFhtValidityCheck(value: Boolean);

    property MultiplyMode: TMultiplyMode read GetMultiplyMode
      write SetMultiplyMode;
    property DivideMode: TDivideMode read GetDivideMode write SetDivideMode;
    property ParseMode: TParseMode read GetParseMode write SetParseMode;
    property ToStringMode: TToStringMode read GetToStringMode
      write SetToStringMode;
    property AutoNormalize: Boolean read GetAutoNormalize
      write SetAutoNormalize;
    property ApplyFhtValidityCheck: Boolean read GetApplyFhtValidityCheck
      write SetApplyFhtValidityCheck;

  var
    FLock: TCriticalSection;
  end;

implementation

constructor TIntXGlobalSettings.Create();
begin
  Inherited Create;
  // Creating a Critical Section to make the variables Thread-Safe
  FLock := TCriticalSection.Create;
  FLock.Acquire;
  try
    F_multiplyMode := TMultiplyMode.mmAutoFht;
    F_divideMode := TDivideMode.dmAutoNewton;
    F_parseMode := TParseMode.pmFast;
    F_toStringMode := TToStringMode.tsmFast;
    F_autoNormalize := False;
    F_applyFhtValidityCheck := True;
  finally
    FLock.Release;
  end;

end;

destructor TIntXGlobalSettings.Destroy();
begin
  FLock.Free;
  Inherited Destroy;
end;

/// <summary>
/// Multiply operation mode used in all <see cref="IntX" /> instances.
/// Set to auto-FHT by default.
/// </summary>

function TIntXGlobalSettings.GetMultiplyMode: TMultiplyMode;
begin
  result := F_multiplyMode;
end;

procedure TIntXGlobalSettings.SetMultiplyMode(value: TMultiplyMode);
begin
  F_multiplyMode := value;
end;

/// <summary>
/// Divide operation mode used in all <see cref="IntX" /> instances.
/// Set to auto-Newton by default.
/// </summary>

function TIntXGlobalSettings.GetDivideMode: TDivideMode;
begin
  result := F_divideMode;
end;

procedure TIntXGlobalSettings.SetDivideMode(value: TDivideMode);
begin
  F_divideMode := value;
end;

/// <summary>
/// Parse mode used in all <see cref="IntX" /> instances.
/// Set to Fast by default.
/// </summary>

function TIntXGlobalSettings.GetParseMode: TParseMode;
begin
  result := F_parseMode;
end;

procedure TIntXGlobalSettings.SetParseMode(value: TParseMode);
begin
  F_parseMode := value;
end;

/// <summary>
/// If true then each operation is ended with big integer normalization.
/// Set to false by default.
/// </summary>

function TIntXGlobalSettings.GetToStringMode: TToStringMode;
begin
  result := F_toStringMode;
end;

procedure TIntXGlobalSettings.SetToStringMode(value: TToStringMode);
begin
  F_toStringMode := value;
end;

function TIntXGlobalSettings.GetAutoNormalize: Boolean;
begin
  result := F_autoNormalize;
end;

procedure TIntXGlobalSettings.SetAutoNormalize(value: Boolean);
begin
  F_autoNormalize := value;
end;

/// <summary>
/// If true then FHT multiplication result is always checked for validity
/// by multiplying integers lower digits using classic algorithm and comparing with FHT result.
/// Set to true by default.
/// </summary>

function TIntXGlobalSettings.GetApplyFhtValidityCheck: Boolean;
begin
  result := F_applyFhtValidityCheck;
end;

procedure TIntXGlobalSettings.SetApplyFhtValidityCheck(value: Boolean);
begin
  F_applyFhtValidityCheck := value;
end;

end.
