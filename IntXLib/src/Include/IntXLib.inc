{ *********************************************************** }
{ *                     IntXLib Library                     * }
{ *       Copyright (c) Ugochukwu Mmaduekwe 2016            * }
{ *********************************************************** }

(* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& *)


 {$DEFINE DELPHI}

(* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& *)
{$IFDEF FPC}
{$UNDEF DELPHI}
{$MODE delphi}

// Disable Overflow and RangeChecks.
{$OVERFLOWCHECKS OFF}
{$RANGECHECKS OFF}

// Enable Pointer Math
{$POINTERMATH ON}

// Disable Warnings and Hints.
{$WARNINGS OFF}
{$HINTS OFF}
{$NOTES OFF}

{$I IntXLibHelper.inc} // Had to Include this Since Delphi Does not allow "FPC_FULLVERSION" to Compile.
{$ENDIF FPC}

(* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& *)

{$IFDEF DELPHI}
// This option is needed to enable code browsing (aka Ctrl+Click)
// It does not affect the binary size or generated code
{$DEFINITIONINFO ON}

// Disable Overflow and RangeChecks.
{$OVERFLOWCHECKS OFF}
{$RANGECHECKS OFF}

// Disable String Checks
{$STRINGCHECKS OFF}

// Enable Pointer Math Arithmetic
{$POINTERMATH ON}

 // XE3 and Above
{$IF CompilerVersion >= 24.0}
{$DEFINE DELPHIXE3_UP}
{$LEGACYIFEND ON}
{$ZEROBASEDSTRINGS OFF}
{$IFEND}

 // 2010 only
{$IF CompilerVersion = 21.0}
{$DEFINE DELPHI2010}
{$IFEND}

  // 2010 and Above
{$IF CompilerVersion >= 21.0}
{$DEFINE DELPHI2010_UP}
{$IFEND}

  // XE and Above
{$IF CompilerVersion >= 22.0}
{$DEFINE DELPHIXE_UP}
{$IFEND}

  // XE2 and Above
{$IF CompilerVersion >= 23.0}
{$DEFINE DELPHIXE2_UP}
{$DEFINE HAS_UNITSCOPE}
{$IFEND}

  // XE7 and Above
{$IF CompilerVersion >= 28.0}
{$DEFINE DELPHIXE7_UP}
{$IFEND}

// 10.2 Tokyo and Above
{$IF CompilerVersion >= 32.0}
{$DEFINE DELPHI10.2_TOKYO_UP}
{$IFEND}

  // 2010 and Above
{$IFNDEF DELPHI2010_UP}
{$MESSAGE ERROR 'This Library requires Delphi 2010 or higher.'}
{$ENDIF}

// 10.2 Tokyo and Above
{$IFDEF DELPHI10.2_TOKYO_UP}
{$WARN COMBINING_SIGNED_UNSIGNED OFF}
{$WARN COMBINING_SIGNED_UNSIGNED64 OFF}
{$ENDIF}


{$ENDIF DELPHI}

(* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& *)
