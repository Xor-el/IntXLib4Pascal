unit CustomAlphabetTest;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  fpcunit,
  testregistry,
  uEnums,
  uIntXLibTypes,
  uIntX;

type

  { TTestCustomAlphabet }

  TTestCustomAlphabet = class(TTestCase)
  published

    procedure CallAlphabetNull();

    procedure CallAlphabetShort();

    procedure CallAlphabetRepeatingChars();

    procedure Parse();

    procedure ToStringTest();

  private
    procedure AlphabetNull();
    procedure AlphabetShort();
    procedure AlphabetRepeatingChars();

  end;

implementation

procedure TTestCustomAlphabet.AlphabetNull();
begin
  TIntX.Parse('', 20, pmFast);
end;

procedure TTestCustomAlphabet.CallAlphabetNull();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @AlphabetNull;

  AssertException(EArgumentNilException, TempMethod);
end;

procedure TTestCustomAlphabet.AlphabetShort();
begin
  TIntX.Parse('', 20, '1234');
end;

procedure TTestCustomAlphabet.CallAlphabetShort();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @AlphabetShort;
  AssertException(EArgumentException, TempMethod);
end;

procedure TTestCustomAlphabet.AlphabetRepeatingChars();
begin
  TIntX.Parse('', 20, '0123456789ABCDEFGHIJ0');
end;

procedure TTestCustomAlphabet.CallAlphabetRepeatingChars();
var
  TempMethod: TRunMethod;
begin
  TempMethod := @AlphabetRepeatingChars;
  AssertException(EArgumentException, TempMethod);
end;


procedure TTestCustomAlphabet.Parse();
begin
  AssertEquals(integer(TIntX.Parse('JI', 20, '0123456789ABCDEFGHIJ')), 19 * 20 + 18);
end;


procedure TTestCustomAlphabet.ToStringTest();
begin
  AssertEquals(TIntX.Create(19 * 20 + 18).ToString(20, '0123456789ABCDEFGHIJ'), 'JI');

end;

initialization

  RegisterTest(TTestCustomAlphabet);

end.



