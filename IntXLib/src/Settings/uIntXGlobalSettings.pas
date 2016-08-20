unit uIntXGlobalSettings;

{$I ..\Include\IntXLib.inc}

interface

uses

  uEnums;

type
  /// <summary>
  /// <see cref="TIntX" /> global settings.
  /// </summary>

  TIntXGlobalSettings = class sealed(TObject)

  private
    /// <summary>
    /// <see cref="TMultiplyMode" /> Instance.
    /// </summary>
    F_multiplyMode: TMultiplyMode;
    /// <summary>
    /// <see cref="TDivideMode" /> Instance.
    /// </summary>
    F_divideMode: TDivideMode;
    /// <summary>
    /// <see cref="TParseMode" /> Instance.
    /// </summary>
    F_parseMode: TParseMode;
    /// <summary>
    /// <see cref="TToStringMode" /> Instance.
    /// </summary>
    F_toStringMode: TToStringMode;
    /// <summary>
    /// Boolean value indicating if to apply autoNormalize.
    /// </summary>
    F_autoNormalize: Boolean;
    /// <summary>
    /// Boolean value indicating if to apply FhtValidityCheck.
    /// </summary>
    F_applyFhtValidityCheck: Boolean;

  public
    /// <summary>
    /// Constructor.
    /// </summary>
    constructor Create();
    /// <summary>
    /// Multiply operation mode used in all <see cref="TIntX" /> instances.
    /// Set to auto-FHT by default.
    /// </summary>
    function GetMultiplyMode: TMultiplyMode;
    /// <summary>
    /// Setter procedure for <see cref="TMultiplyMode" />.
    /// </summary>
    /// <param name="value">value to use.</param>
    procedure SetMultiplyMode(value: TMultiplyMode);
    /// <summary>
    /// Divide operation mode used in all <see cref="TIntX" /> instances.
    /// Set to auto-Newton by default.
    /// </summary>
    function GetDivideMode: TDivideMode;
    /// <summary>
    /// Setter procedure for <see cref="TDivideMode" />.
    /// </summary>
    /// <param name="value">value to use.</param>
    procedure SetDivideMode(value: TDivideMode);
    /// <summary>
    /// Parse mode used in all <see cref="TIntX" /> instances.
    /// Set to Fast by default.
    /// </summary>
    function GetParseMode: TParseMode;
    /// <summary>
    /// Setter procedure for <see cref="TParseMode" />.
    /// </summary>
    /// <param name="value">value to use.</param>
    procedure SetParseMode(value: TParseMode);
    /// <summary>
    /// To string conversion mode used in all <see cref="TIntX" /> instances.
    /// Set to Fast by default.
    /// </summary>
    function GetToStringMode: TToStringMode;
    /// <summary>
    /// Setter procedure for <see cref="TToStringMode" />.
    /// </summary>
    /// <param name="value">value to use.</param>
    procedure SetToStringMode(value: TToStringMode);
    /// <summary>
    /// If true then each operation is ended with big integer normalization.
    /// Set to false by default.
    /// </summary>
    function GetAutoNormalize: Boolean;
    /// <summary>
    /// Setter procedure for autoNormalize.
    /// </summary>
    /// <param name="value">value to use.</param>
    procedure SetAutoNormalize(value: Boolean);
    /// <summary>
    /// If true then FHT multiplication result is always checked for validity
    /// by multiplying integers lower digits using classic algorithm and comparing with FHT result.
    /// Set to true by default.
    /// </summary>
    function GetApplyFhtValidityCheck: Boolean;
    /// <summary>
    /// Setter procedure for FhtValidityCheck.
    /// </summary>
    /// <param name="value">value to use.</param>
    procedure SetApplyFhtValidityCheck(value: Boolean);
    /// <summary>
    /// property for <see cref="TMultiplyMode" />.
    /// </summary>
    property MultiplyMode: TMultiplyMode read GetMultiplyMode
      write SetMultiplyMode;
    /// <summary>
    /// property for <see cref="TDivideMode" />.
    /// </summary>
    property DivideMode: TDivideMode read GetDivideMode write SetDivideMode;
    /// <summary>
    /// property for <see cref="TParseMode" />.
    /// </summary>
    property ParseMode: TParseMode read GetParseMode write SetParseMode;
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
    /// <summary>
    /// property for ApplyFhtValidityCheck.
    /// </summary>
    property ApplyFhtValidityCheck: Boolean read GetApplyFhtValidityCheck
      write SetApplyFhtValidityCheck;

  end;

implementation

constructor TIntXGlobalSettings.Create();
begin
  Inherited Create;

  F_multiplyMode := TMultiplyMode.mmAutoFht;
  F_divideMode := TDivideMode.dmAutoNewton;
  F_parseMode := TParseMode.pmFast;
  F_toStringMode := TToStringMode.tsmFast;
  F_autoNormalize := False;
  F_applyFhtValidityCheck := True;

end;

function TIntXGlobalSettings.GetMultiplyMode: TMultiplyMode;
begin
  result := F_multiplyMode;
end;

procedure TIntXGlobalSettings.SetMultiplyMode(value: TMultiplyMode);
begin
  F_multiplyMode := value;
end;

function TIntXGlobalSettings.GetDivideMode: TDivideMode;
begin
  result := F_divideMode;
end;

procedure TIntXGlobalSettings.SetDivideMode(value: TDivideMode);
begin
  F_divideMode := value;
end;

function TIntXGlobalSettings.GetParseMode: TParseMode;
begin
  result := F_parseMode;
end;

procedure TIntXGlobalSettings.SetParseMode(value: TParseMode);
begin
  F_parseMode := value;
end;

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

function TIntXGlobalSettings.GetApplyFhtValidityCheck: Boolean;
begin
  result := F_applyFhtValidityCheck;
end;

procedure TIntXGlobalSettings.SetApplyFhtValidityCheck(value: Boolean);
begin
  F_applyFhtValidityCheck := value;
end;

end.
