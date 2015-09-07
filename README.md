TIntX
====

 **`TIntX`** is a Delphi Port of [IntX](https://github.com/devoyster/IntXLib) arbitrary precision integers library with fast about **`O(N * log N)`** multiplication/division algorithms implementation. It provides all the basic arithmetic operations on integers, comparing, bitwise shifting etc. It also allows parsing numbers in different bases and converting them to string, also in any base. The advantage of this library is fast multiplication, division and from base/to base conversion algorithms. all the fast versions of the algorithms are based on fast multiplication of big integers using Fast Hartley Transform which runs for **`O(N * log N * log log N)`** time instead of classic **`O(N^2)`**.

**`Porting guidelines:`**

    1. All file names (units) are the same. 
    2. Most variables were closely named. 
    3. Some functions were written by me because I could not find a Delphi Equivalent
       of the C# function used, in the RTL or for Backwards Compatibility with older
       Unicode versions of Delphi.

    
**`Hints about the code:`**
    1.  Multi-condition "for" loops and loops where iterator gets changed inside 
      the loop were converted to while loops. 
    2.  All Strings were ported as 1-Based (Index) because that is what Delphi Desktop 
       Compilers Uses by Default.
    3.  Delphi needs manual disposal of objects created , as they don't have built-in 
        destructor (automatic garbage collectors) support in them.
    4.  This Library is written with (Delphi XE7 Update 1). 
        This Library have been tested to work properly with 
        Delphi (XE7 Update 1). 
        This Library might work with other Unicode versions of Delphi (XE to Latest 
        versions) with little or no modifications but have not been tested by me.   
    5.  Mobile Compilers are NOT Supported. you could make a fork and implement it.
  
   
**`Common pitfalls during porting:`**

    1. Wrong Indexing of values from Strings.

Code Example
------------

Here is the sample of code which uses TIntX and calculates 42 in power 1048576 (which is 2^20):

```pascal
uses
SysUtils, IntX, Enums;

procedure Calc();
var
  stopwatch: TStopwatch;

begin
  stopwatch := TStopwatch.Create;
  stopwatch.Start;
  TIntX.Pow(42, 1 shl 20);
  stopwatch.Stop;
  ShowMessage(Format('time elapsed is %d ms', [stopwatch.ElapsedMilliseconds]));
end;

procedure TForm1.Button1Click(Sender: TObject);

begin
  Calc();
  TIntX.GlobalSettings.MultiplyMode := TMultiplyMode.mmClassic;
  Calc();
end;
```

      First `Calc()` call uses fast multiplication implementation (which is default), 
    second classic one. On my machine (Windows 8.1 Update 3, Intel Core i3 2.53 GHz, 
    6 GB RAM), Compiled with 64 bits, first call took 0.933 seconds while the second one 
    took 42 seconds.Resulting number has 1,702,101 digits.

**Some other functions implemented internally by me are**

	
	SquareRoot (Integer SquareRoot) 
	Square 
	GCD (Greatest Common Divisor) 
	AbsoluteValue (Get Absolute Value of a Negative TIntX)
	Bézouts Identity
	InvMod (Modular Inverse)
	Factorial
	LogN(base, number) (Get Log of a number using a specified base)

As you can see, `TIntX` implements all the standard arithmetic operators using `operator overloading` so its usage is transparent for developers, like if you're working with usual integers.

FHT and Calculations Precision
------------------------------

Internally TIntX library operates with floating-point numbers when multiplication using FHT (Fast Hartley Transform) is performed so at some point it stops working correctly and loses precision. Luckily, this unpleasant side-effects effects are starting to appear when integer size is about 2^28 bytes i.e. for really huge integers. Anyway, to catch such errors some code was added FHT multiplication result validity check into code -- it takes N last digits of each big integer, multiplies them using classic approach and then compares last N digits of classic result with last N digits of FHT result (so it's kind of simplified CRC check). If any inconsistency is found then an Exception is thrown; this check can be disabled using global settings.

Internal Representation and ToString() Performance
--------------------------------------------------

      For a really huge integer numbers (like 42 in power 1048576 above) `ToString()` 
    call can take a quite some time to execute. This is because internally TIntX big 
    integer is stored as 2^32-base number in 'UInt32' array and to generate decimal 
    string output it should be converted from 2^32 base to decimal base. Such digits 
    storage approach was chosen intentionally -- it makes 'ToString' slower but uses 
    memory efficiently and makes primitive operations on digits faster than power of 
    10-base storage (which would make 'ToString()' working faster) and 
    usually computations are used more often than 'ToString()'.

Unit Tests
--------------------------------------------------
      Unit Tests can be found in the 'IntXLib.Test' Folder.
    The Unit tests uses DUnitX and TestInsight. 
    (Thanks to the developers of DunitX and TestInsight) for making tools that makes 
    Unit testing fun.

Conclusion
--------------------------------------------------

      Special Thanks to first of all, (Andriy Kozachuk) for creating the 
    Original CSharp version, members of Delphi Developers Community on Google Plus,
    Uncle Midnight,Ron4Fun for various support offered.
