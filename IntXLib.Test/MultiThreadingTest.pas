unit MultiThreadingTest;

interface

uses
  DUnitX.TestFramework, IntX, SysUtils, Classes, Threading;

type

  [TestFixture]
  TMultiThreadingTest = class(TObject)
  strict private
    function StartNewShiftMemoryCorruptionTask(): ITask;
  public
    [Test]
    procedure ShiftMemoryCorruptionTasks();
  end;

implementation

[Test]
procedure TMultiThreadingTest.ShiftMemoryCorruptionTasks();
var
  ATasks: Array of ITask;
begin
  SetLength(ATasks, 2);
  ATasks[0] := StartNewShiftMemoryCorruptionTask();
  ATasks[1] := StartNewShiftMemoryCorruptionTask();
  ATasks[0].Start;
  ATasks[1].Start;
  TTask.WaitForAll(ATasks);
end;

function TMultiThreadingTest.StartNewShiftMemoryCorruptionTask(): ITask;
var
  myTask: ITask;
  x: TIntX;
begin
  x := 1;
  myTask := TTask.Create(
    procedure
    var
      i: Integer;
    begin
      for i := 0 to Pred(1000000) do
      begin
        x := x shl 63;
        x := x shr 63;
        Assert.IsTrue(x = 1);
      end;
    end);
  result := myTask;
end;

initialization

TDUnitX.RegisterTestFixture(TMultiThreadingTest);

end.
