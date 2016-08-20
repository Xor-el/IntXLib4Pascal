unit OnesComplementOpTest;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uConstants,
  uIntX;

type

  { TTestOnesComplementOp }

  TTestOnesComplementOp = class(TTestCase)
  published


    procedure ShouldOnesComplementIntX();

    procedure ShouldOnesComplementNegativeIntX();

    procedure ShouldOnesComplementZero();

    procedure ShouldOnesComplementBigIntX();

  end;

implementation

procedure TTestOnesComplementOp.ShouldOnesComplementIntX();
var
  Value, Result: TIntX;
  val: UInt32;
begin
  val := 11;
  Value := TIntX.Create(11);
  Result := not Value;
  AssertTrue(Result = (- Int64(not val)));
end;

procedure TTestOnesComplementOp.ShouldOnesComplementNegativeIntX();
var
  Value, Result: TIntX;
  val: UInt32;
begin
  val := 11;
  Value := TIntX.Create(-11);
  Result := not Value;
  AssertTrue(Result = UInt32(not val));
end;

procedure TTestOnesComplementOp.ShouldOnesComplementZero();
var
  Value, Result: TIntX;
begin
  Value := TIntX.Create(0);
  Result := not Value;
  AssertTrue(Result = 0);
end;

procedure TTestOnesComplementOp.ShouldOnesComplementBigIntX();
var
  temp1, temp2: TIntXLibUInt32Array;
  Value, Result: TIntX;
begin
  SetLength(temp1, 3);
  temp1[0] := 3;
  temp1[1] := 5;
  temp1[2] := TConstants.MaxUInt32Value;
  SetLength(temp2, 2);
  temp2[0] := UInt32(not UInt32(3));
  temp2[1] := UInt32(not UInt32(5));
  Value := TIntX.Create(temp1, False);
  Result := not Value;
  AssertTrue(Result = TIntX.Create(temp2, True));
end;


initialization

  RegisterTest(TTestOnesComplementOp);
end.

