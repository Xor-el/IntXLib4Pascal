TIntX
====

 **`TIntX`** is a Pascal port of [IntX](https://github.com/devoyster/IntXLib) arbitrary precision Integer library with fast, about **`O(N * log N)`** multiplication/division algorithms implementation. It provides all the basic arithmetic operations on Integers, comparing, bitwise shifting etc. It also allows parsing numbers in different bases and converting them to string, also in any base. The advantage of this library is its fast multiplication, division and from base/to base conversion algorithms. all the fast versions of the algorithms are based on fast multiplication of big Integers using [Fast Hartley Transform](http://en.wikipedia.org/wiki/Discrete_Hartley_transform) which runs for **`O(N * log N * log log N)`** time instead of classic **`O(N^2)`**.
  

Code Example
------------

Here is a sample of code which uses `TIntX` to calculate 42 in power 1048576 (which is 2^20 (1 shl 20)):

```pascal
uses //including only the non-obvious
SysUtils, uIntX, uEnums;

procedure Calc();
var
  valA, valB: UInt32;
  Delta: Double;

begin
  valA := GetTickCount;
  TIntX.Pow(42, 1048576);
  valB := GetTickCount;
  Delta := (valB - valA) / 1000;
  ShowMessage(Format('time elapsed is %f seconds', [Delta]));
end;

procedure TForm1.Button1Click(Sender: TObject);

begin
  Calc();
  TIntX.GlobalSettings.MultiplyMode := TMultiplyMode.mmClassic;
  Calc();
end;
```

      First 'Calc()' call uses fast multiplication implementation (which is default), 
    second, classic one. On my machine (Windows 10 Update 2, Intel Core i3 2.53 GHz, 
    6 GB RAM), Compiled with 64 bits, first call took 0.30 seconds while the second one 
    took 17.91 seconds.Resulting number has 1,702,101 digits.

**Some other functions implemented internally by me are**

  
      IntegerSquareRoot (Integer SquareRoot) 
      Square 
      GCD (Greatest Common Divisor (HCF)) 
      LCM (Least Common Multiple)
      AbsoluteValue (Get Absolute Value of a Negative TIntX)
      Bézouts Identity
      InvMod (Modular Inverse)
      Factorial
      IntegerLogN (base, number) (Gets IntegerLog of a number using a specified base)
	  Ln (The natural logarithm)
	  Log10 (The base-10 logarithm)
	  LogN (Logarithm of a number for a specified base)
      Random (Now Uses PcgRandom Instead of Mersemme Twister)
      Modular Exponentiation (ModPow)
      IsProbablyPrime (based on Miller Rabin Primality Test)

As you can see, `TIntX` implements all the standard arithmetic operators using `operator overloading` so its usage is transparent for developers, like if you're working with usual Integers.

FHT and Calculations Precision
------------------------------

Internally `TIntX` library operates with floating-point numbers when multiplication using FHT (Fast Hartley Transform) is performed so at some point it stops working correctly and loses precision. Luckily, this unpleasant side-effects effects starts to appear when Integer size is about 2^28 bytes i.e. for really huge Integers. Anyway, to catch such errors some code was added, FHT multiplication result validity check into code -- it takes N last digits of each big Integer, multiplies them using classic approach and then compares last N digits of classic result with last N digits of FHT result (so it's kind of  a simplified CRC check). If any inconsistency is found, then an 
`EFhtMultiplicationException` is thrown; this check can be disabled using global settings.

Internal Representation and ToString() Performance
--------------------------------------------------

   For a really huge Integer numbers (like 42 in power 1048576 above) `ToString()` 
 call can take quite some time to execute. This is because, internally `TIntX` big 
 Integers are stored as `2^32`-base number in `UInt32` array and to generate decimal 
 string output it should be converted from `2^32` base to decimal base. Such digits 
 storage approach was chosen intentionally -- it makes `ToString()` slower but uses 
 memory efficiently and makes primitive operations on digits faster than power of 
 10-base storage (which would make `ToString()` work faster) and 
 usually computations are used more often than `ToString()`.

**Supported Compilers**
 
    FreePascal 3.0.0 and Above.
    
    Delphi 2010 and Above.

**Installing the Library.**

**Method One:**

 Use the Provided Packages in the "Packages" Folder.

**Method Two:**

 Add the Library Path and Sub Path to your Project Search Path.

 **Unit Tests.**

To Run Unit Tests,

**For FPC 3.0.0 and above**


    Simply compile and run "IntXLib.Tests" project in "FreePascal.Tests" Folder.
    
 **Method One (Using TestInsight and DUnitX) (Preferred).**

    1). Download and Install TestInsight (and DunitX if not available).
    
    2). Open Project Options of Unit Test (IntXLib.Tests.TestInsight) in "Delphi.Tests" 
        Folder.

    3). To Use TestInsight, right-click on the project, then select 
		"Enable for TestInsight" or "TestInsight Project".
        Save Project then Build and Run Test Project through TestInsight. 

**Method Two (Using DUnitX Console Runner).**

    1). Download and Install DunitX (if not available).
    
    2). Open Project Options of Unit Test (IntXLib.Tests.TestInsight) in "Delphi.Tests" 
        Folder.

    3). Save Project then Build and Run Test Project.. 

###License

This "Software" is Licensed Under  **`MIT License (MIT)`** .
    

Conclusion
--------------------------------------------------

      Special Thanks to first of all, (Andriy Kozachuk) for creating the 
    Original CSharp version, members of Delphi Developers Community on Google Plus,
    Uncle Midnight,Ron4Fun for various support offered.
