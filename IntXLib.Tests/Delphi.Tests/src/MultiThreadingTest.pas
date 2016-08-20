unit MultiThreadingTest;

interface

uses
  DUnitX.TestFramework,
  SysUtils,
  Classes,
  Threading,
  uIntX;

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
      i := 0;
      while i <= Pred(1000000) do
      begin
        x := x shl 63;
        x := x shr 63;
        Assert.IsTrue(x = 1);
        Inc(i);
      end;
    end);
  result := myTask.Start;
end;

initialization

TDUnitX.RegisterTestFixture(TMultiThreadingTest);

end.
