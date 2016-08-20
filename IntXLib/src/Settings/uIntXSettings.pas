unit uIntXSettings;

{$I ..\Include\IntXLib.inc}

interface

uses
  uEnums,
  uIntXGlobalSettings;

type
  /// <summary>
  /// <see cref="TIntX" /> instance settings.
  /// </summary>

  TIntXSettings = class sealed(TObject)

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

constructor TIntXSettings.Create(globalSettings: TIntXGlobalSettings);
begin
  Inherited Create;
  // Copy local settings from global ones
  F_autoNormalize := globalSettings.AutoNormalize;
  F_toStringMode := globalSettings.ToStringMode;

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
