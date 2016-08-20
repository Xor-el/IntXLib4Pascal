unit PerformanceTest;

interface

uses
  DUnitX.TestFramework,
  SysUtils,
  // Classes,
  Diagnostics,
  uEnums,
  TestHelper,
  uIntXLibTypes,
  uIntX;

type

  [TestFixture]
  TPerformanceTest = class(TObject)
  var
    Fint1, Fint2: TIntX;
  public
    [Test]
    procedure Multiply128BitNumbers();
  end;

implementation

[Test]
procedure TPerformanceTest.Multiply128BitNumbers();
var
  temp1, temp2: TIntXLibUInt32Array;
  StopWatch: TStopwatch;
  // Writer: TStreamWriter;
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
  StopWatch := TStopwatch.Create;
  StopWatch.Start;

  TTestHelper.Repeater(100000,
    procedure
    begin
      TIntX.Multiply(Fint1, Fint2, TMultiplyMode.mmClassic);
    end);
  StopWatch.Stop();
  System.WriteLn(Format('classic multiply operation took %d ms',
    [StopWatch.ElapsedMilliseconds]));

  {
    // uncomment to save to file.
    Writer := TStreamWriter.Create('timetaken.txt');
    try
    Writer.WriteLine(Format('classic multiply operation took %d ms',
    [StopWatch.ElapsedMilliseconds]));
    finally
    Writer.Free;
    end;
  }

end;

initialization

TDUnitX.RegisterTestFixture(TPerformanceTest);

end.
