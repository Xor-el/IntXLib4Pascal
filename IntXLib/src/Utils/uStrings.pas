unit uStrings;

{$I ..\Include\IntXLib.inc}

interface

resourcestring
  AlphabetRepeatingChars = 'Alphabet characters must be unique.';
  AlphabetTooSmall = 'Alphabet is too small to represent numbers in base %u.';
  CantBeNull = 'Operand(s) can''t be null.';
  CantBeNullCmp = 'Can''t use null in comparison operations.';
  CantBeNullOne = 'Operand can''t be null.';
  DigitBytesLengthInvalid = 'Digit bytes array length is invalid.';
  FhtMultiplicationError =
    'FHT multiplication returned invalid results for TIntX objects with lengths %u and %u.';
  IntegerTooBig = 'One of the operated big integers is too big.';
  ParseBaseInvalid = 'Base is invalid.';
  ParseInvalidChar = 'Invalid character in input.';
  ParseNoDigits = 'No digits in string.';
  ParseTooBigDigit = 'Digit is too big for this base.';
  ToStringSmallBase = 'Base must be between 2 and 65536.';
  DivideByZero = 'Attempted to divide by Zero.';
  DivisionUndefined = 'Division undefined (0/0)';
  NegativeFactorial = 'Can''t calculate factorial for negative number %s.';
  BezoutNegativeNotAllowed = 'Negative value not allowed for Bézouts identity.';
  BezoutNegativeCantComputeZero = 'One or more parameters are Zero.';
  NegativeSquareRoot = 'Cannot compute squareroot of Negative number.';
  LogCantComputeZero = 'One or more parameters are Zero.';
  LogNegativeNotAllowed = 'Negative value not allowed for LogN';
  InvModNegativeNotAllowed = 'Negative value not allowed for Modular Inverse.';
  ModPowExponentCantbeNegative =
    'Exponent Can''t be Negative for Modular Exponentiation.';
  ModPowModulusCantbeZeroorNegative = 'Modulus Can''t be Zero or Negative';
  Overflow_TIntXInfinity = 'TIntX cannot represent infinity.';
  Overflow_NotANumber = 'The value is not a number.';
  OverFlow_Data = 'TIntX value won''t fit in destination type';

implementation

end.
