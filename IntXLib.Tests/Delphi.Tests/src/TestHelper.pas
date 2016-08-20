unit TestHelper;

interface

uses
  DUnitX.TestFramework,
  SysUtils;

type

  // [TestFixture]
  TTestHelper = class(TObject)
  public
    class procedure Repeater(count: Integer; Body: TProc); static;
  end;

implementation

class procedure TTestHelper.Repeater(count: Integer; Body: TProc);

begin
  while count > 0 do
  begin
    Body;
    Dec(count);
  end;
end;

// initialization

// TDUnitX.RegisterTestFixture(TTestHelper);

end.
