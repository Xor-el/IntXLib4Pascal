unit IntXSettings;

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
  Enums, IntXGlobalSettings;

type
  /// <summary>
  /// <see cref="TIntX" /> instance settings.
  /// </summary>

  TIntXSettings = class sealed

  private
    /// <summary>
    /// <see cref="TToStringMode" /> Instance.
    /// </summary>
    F_toStringMode: TToStringMode;
    /// <summary>
    /// autoNormalize Flag (Boolean value that indicates if to autoNormalize or not).
    /// </summary>
    F_autoNormalize: Boolean;

  public

    /// <summary>
    /// Creates new <see cref="IntXSettings" /> instance.
    /// </summary>
    /// <param name="globalSettings">IntX global settings to copy.</param>

    constructor Create(globalSettings: TIntXGlobalSettings);

    /// <summary>
    /// Destructor.
    /// </summary>

    destructor Destroy(); override;

    /// <summary>
    /// To string conversion mode used in this <see cref="TIntX" /> instance.
    /// Set to value from <see cref="TIntX.GlobalSettings" /> by default.
    /// </summary>

    function GetToStringMode: TToStringMode;
    /// <summary>
    /// Setter procedure for <see cref="TToStringMode" />.
    /// </summary>
    /// <param name="value">value to use.</param>
    procedure SetToStringMode(value: TToStringMode);

    /// <summary>
    /// If true then each operation is ended with big integer normalization.
    /// Set to value from <see cref="TIntX.GlobalSettings" /> by default.
    /// </summary>

    function GetAutoNormalize: Boolean;
    /// <summary>
    /// Setter procedure for autoNormalize.
    /// </summary>
    /// <param name="value">value to use.</param>
    procedure SetAutoNormalize(value: Boolean);
    /// <summary>
    /// property for <see cref="TToStringMode" />.
    /// </summary>
    property ToStringMode: TToStringMode read GetToStringMode
      write SetToStringMode;
    /// <summary>
    /// property for AutoNormalize.
    /// </summary>
    property AutoNormalize: Boolean read GetAutoNormalize
      write SetAutoNormalize;

  end;

implementation

uses
  IntX;

constructor TIntXSettings.Create(globalSettings: TIntXGlobalSettings);
begin
  Inherited Create;
  // Copy local settings from global ones
  F_autoNormalize := globalSettings.AutoNormalize;
  F_toStringMode := globalSettings.ToStringMode;

end;

destructor TIntXSettings.Destroy();
begin
  Inherited Destroy;
end;

function TIntXSettings.GetToStringMode: TToStringMode;
begin
  result := F_toStringMode;
end;

procedure TIntXSettings.SetToStringMode(value: TToStringMode);
begin
  F_toStringMode := value;
end;

function TIntXSettings.GetAutoNormalize: Boolean;
begin
  result := F_autoNormalize;
end;

procedure TIntXSettings.SetAutoNormalize(value: Boolean);
begin
  F_autoNormalize := value;
end;

end.
