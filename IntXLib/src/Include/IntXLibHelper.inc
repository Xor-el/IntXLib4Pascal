{ *********************************************************** }
{ *                     IntXLib Library                     * }
{ *       Copyright (c) Ugochukwu Mmaduekwe 2016            * }
{ *********************************************************** }

(* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& *)

{$MACRO ON}
// FPC 3.0.0 and Above
// Had to Include this here since Delphi does not allow it Compile in "IntXLib.inc".
{$IF FPC_FULLVERSION < 30000}
{$MESSAGE ERROR 'This Library requires FreePascal 3.0.0 or higher.'}
{$IFEND}
// FPC Less than 3.0.2
// Had to Include this here since Delphi does not allow it Compile in "IntXLib.inc".
{$IF FPC_FULLVERSION < 30002}
{$DEFINE FPC_LESS_THAN_3.0.2}
{$IFEND}
