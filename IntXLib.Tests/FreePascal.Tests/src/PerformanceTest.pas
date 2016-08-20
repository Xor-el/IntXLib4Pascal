unit PerformanceTest;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  fpcunit,
  testregistry,
  LCLIntf,
  uEnums,
  TestHelper,
  uIntXLibTypes,
  uIntX;

type

  { TTestPerformance }

  TTestPerformance = class(TTestCase)
  published
    procedure Multiply128BitNumbers();

  private
    Fint1, Fint2: TIntX;

    procedure Inner();

  end;

implementation

procedure TTestPerformance.Multiply128BitNumbers();
var
  temp1, temp2: TIntXLibUInt32Array;
  A, B: UInt32;
begin
  SetLength(temp1, 4);
  temp1[0] := 47668;
  temp1[1] := 58687;
  temp1[2] := 223234234;
  temp1[3] := 42424242;
  SetLength(temp2, 4);
  temp2[0] := 5674356;
  temp2[1] := 34656476;
  temp2[2] := 45667;
  temp2[3] := 678645646;

  Fint1 := TIntX.Create(temp1, False);
  Fint2 := TIntX.Create(temp2, False);

  A := GetTickCount;

  TTestHelper.Repeater(100000, @Inner);
  B := GetTickCount;
  WriteLn(Format('classic multiply operation took %u ms', [B - A]));

end;

procedure TTestPerformance.Inner();
begin
  TIntX.Multiply(Fint1, Fint2, TMultiplyMode.mmClassic);
end;


initialization

  RegisterTest(TTestPerformance);
end.


