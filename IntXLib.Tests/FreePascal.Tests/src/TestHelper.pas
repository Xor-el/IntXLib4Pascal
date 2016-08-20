unit TestHelper;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry;

type

  { TTestHelper }

  TTestHelper = class(TObject)
  public
    class procedure Repeater(Count: integer; Body: TRunMethod); static;

  end;

implementation

class procedure TTestHelper.Repeater(Count: integer; Body: TRunMethod);
begin
  while Count > 0 do
  begin
    Body;
    Dec(Count);
  end;
end;

end.

