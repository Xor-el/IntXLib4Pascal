unit ConstructorTest;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX,
  uConstants;

type

  { TTestConstructor }

  TTestConstructor = class(TTestCase)
  published

    procedure DefaultCtor();

    procedure IntCtor();

    procedure UInt32Ctor();

    procedure IntArrayCtor();

    procedure CallIntArrayNullCtor();

  private
    procedure IntArrayNullCtor();

  end;

implementation



procedure TTestConstructor.DefaultCtor();
begin
  TIntX.Create(0);
end;


procedure TTestConstructor.IntCtor();
begin
  TIntX.Create(7);
end;


procedure TTestConstructor.UInt32Ctor();
begin
  TIntX.Create(TConstants.MaxUInt32Value);
end;


procedure TTestConstructor.IntArrayCtor();
var
  temp: TIntXLibUInt32Array;
begin
  SetLength(temp, 3);
  temp[0] := 1;
  temp[1] := 2;
  temp[2] := 3;
  TIntX.Create(temp, True);
end;

procedure TTestConstructor.IntArrayNullCtor();
var
  temp: TIntXLibUInt32Array;
begin
  temp := nil;
  TIntX.Create(temp, False);
end;

procedure TTestConstructor.CallIntArrayNullCtor();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @IntArrayNullCtor;

  AssertException(EArgumentNilException, TempMethod);
end;


initialization

  RegisterTest(TTestConstructor);
end.

