unit AsConvertOpTest;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry,
  uIntXLibTypes,
  uIntX;

type

  { TTestAsConvertOp }

  TTestAsConvertOp = class(TTestCase)
  published

    procedure AsInteger();

    procedure AsUInt32();

    procedure AsInt64();

    procedure AsUInt64();

  private

    procedure ProcIntegerOne();
    procedure ProcIntegerTwo();
    procedure ProcIntegerThree();
    procedure ProcIntegerFour();
    procedure ProcIntegerFive();

    procedure ProcUInt32One();
    procedure ProcUInt32Two();
    procedure ProcUInt32Three();

    procedure ProcInt64One();
    procedure ProcInt64Two();
    procedure ProcInt64Three();
    procedure ProcInt64Four();

    procedure ProcUInt64One();
    procedure ProcUInt64Two();
    procedure ProcUInt64Three();

  end;

implementation


{ TTestAsConvertOp }

procedure TTestAsConvertOp.AsInteger;
var
  n: integer;
  IntX: TIntX;
begin
  AssertException(EOverflowException, @ProcIntegerOne);
  n := 1234567890;
  IntX := n;
  AssertEquals(n, integer(IntX));

  n := -n;
  IntX := n;
  AssertEquals(n, integer(IntX));

  n := 0;
  IntX := n;
  AssertEquals(n, integer(IntX));

  AssertException(EOverflowException, @ProcIntegerTwo);

  AssertException(EOverflowException, @ProcIntegerThree);

  AssertException(EOverflowException, @ProcIntegerFour);

  AssertException(EOverflowException, @ProcIntegerFive);

end;

procedure TTestAsConvertOp.AsUInt32;
var
  IntX: TIntX;
  n: UInt32;
begin
  n := 1234567890;
  IntX := n;
  AssertEquals(n, UInt32(IntX));

  n := 0;
  IntX := n;
  AssertEquals(n, UInt32(IntX));

  AssertException(EOverflowException, @ProcUInt32One);

  AssertException(EOverflowException, @ProcUInt32Two);

  AssertException(EOverflowException, @ProcUInt32Three);

end;

procedure TTestAsConvertOp.AsInt64;
var
  IntX: TIntX;
  n: int64;
  ni: integer;
begin
  n := 1234567890123456789;
  IntX := n;
  AssertEquals(n, int64(IntX));

  n := -n;
  IntX := n;
  AssertEquals(n, int64(IntX));

  n := 0;
  IntX := n;
  AssertEquals(n, int64(IntX));

  ni := 1234567890;
  n := ni;
  IntX := ni;
  AssertEquals(n, int64(IntX));

  AssertException(EOverflowException, @ProcInt64One);

  AssertException(EOverflowException, @ProcInt64Two);

  AssertException(EOverflowException, @ProcInt64Three);

  AssertException(EOverflowException, @ProcInt64Four);

end;

procedure TTestAsConvertOp.AsUInt64;
var
  IntX: TIntX;
  n: UInt64;
begin

  n := 1234567890123456789;
  IntX := n;
  AssertTrue(n = UInt64(IntX));

  n := 0;
  IntX := n;
  AssertTrue(n = UInt64(IntX));

  AssertException(EOverflowException, @ProcUInt64One);

  AssertException(EOverflowException, @ProcUInt64Two);

  AssertException(EOverflowException, @ProcUInt64Three);

end;

procedure TTestAsConvertOp.ProcIntegerOne;
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(High(UInt32));
  IntX.AsInteger;
end;

procedure TTestAsConvertOp.ProcIntegerTwo;
var
  temp: TIntXLibUInt32Array;
  n: integer;
  IntX: TIntX;
  un: UInt32;
begin
  n := 1234567890;
  un := UInt32(n);

  SetLength(temp, 3);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;

  IntX := TIntX.Create(temp, False);
  IntX.AsInteger;
end;

procedure TTestAsConvertOp.ProcIntegerThree;
var
  temp: TIntXLibUInt32Array;
  n: integer;
  IntX: TIntX;
  un: UInt32;
begin
  n := 1234567890;
  un := UInt32(n);

  SetLength(temp, 3);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;

  IntX := TIntX.Create(temp, True);
  IntX.AsInteger;
end;

procedure TTestAsConvertOp.ProcIntegerFour;
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(High(integer)) + 10;
  IntX.AsInteger;
end;

procedure TTestAsConvertOp.ProcIntegerFive;
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(Low(integer)) - 10;
  IntX.AsInteger;
end;

procedure TTestAsConvertOp.ProcUInt32One;
var
  temp: TIntXLibUInt32Array;
  IntX: TIntX;
  n: UInt32;
begin
  n := 1234567890;
  SetLength(temp, 3);
  temp[0] := n;
  temp[1] := n;
  temp[2] := n;

  IntX := TIntX.Create(temp, False);
  IntX.AsUInt32;

end;

procedure TTestAsConvertOp.ProcUInt32Two;
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(High(UInt32)) + 10;
  IntX.AsUInt32;
end;

procedure TTestAsConvertOp.ProcUInt32Three;
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(Low(UInt32)) - 10;
  IntX.AsUInt32;
end;

procedure TTestAsConvertOp.ProcInt64One;
var
  temp: TIntXLibUInt32Array;
  IntX: TIntX;
  un: UInt32;
begin
  un := 1234567890;
  SetLength(temp, 5);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;
  temp[3] := un;
  temp[4] := un;

  IntX := TIntX.Create(temp, False);
  IntX.AsInt64;
end;

procedure TTestAsConvertOp.ProcInt64Two;
var
  temp: TIntXLibUInt32Array;
  IntX: TIntX;
  un: UInt32;
begin
  un := 1234567890;
  SetLength(temp, 5);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;
  temp[3] := un;
  temp[4] := un;

  IntX := TIntX.Create(temp, True);
  IntX.AsInt64;
end;

procedure TTestAsConvertOp.ProcInt64Three;
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(High(int64)) + 10;

  IntX.AsInt64;
end;

procedure TTestAsConvertOp.ProcInt64Four;
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(Low(int64)) - 10;
  IntX.AsInt64;
end;

procedure TTestAsConvertOp.ProcUInt64One;
var
  temp: TIntXLibUInt32Array;
  IntX: TIntX;
  un: UInt32;
begin
  un := 1234567890;

  SetLength(temp, 5);
  temp[0] := un;
  temp[1] := un;
  temp[2] := un;
  temp[3] := un;
  temp[4] := un;

  IntX := TIntX.Create(temp, False);
  IntX.AsUInt64;
end;

procedure TTestAsConvertOp.ProcUInt64Two;
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(High(UInt64)) + 10;
  IntX.AsUInt64;
end;

procedure TTestAsConvertOp.ProcUInt64Three;
var
  IntX: TIntX;
begin
  IntX := TIntX.Create(Low(UInt64)) - 10;
  IntX.AsUInt64;
end;

initialization

  RegisterTest(TTestAsConvertOp);
end.
