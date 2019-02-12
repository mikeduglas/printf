  MODULE('printf.clw')

!!!<summary>Returns the string pointed by pFmt. 
!!!If pFmt includes format specifiers (subsequences beginning with %), 
!!!the additional arguments following format are formatted and inserted in the resulting string replacing their respective specifiers.
!!!</summary>
!!!<param name="pFmt">
!!!%% - a single %
!!!%c - a character
!!!%s - a CLIPped string
!!!%S - a quoted CLIPped string
!!!%z - a string
!!!%Z - a quoted string
!!!%i - an integer
!!!%x - an int in hex (lower case)
!!!%X - an int in hex (upper case)
!!!%f - a float
!!!%e - a float in scientific notation (@E15.4)
!!!%d - a date (Windows setting for Short date)
!!!%t - a time (Windows setting for Short time)
!!!</param>
!!!<returns>Formtted string</returns>
printf  PROCEDURE(STRING pFmt, | 
      <? p1>,  <? p2>,  <? p3>,  <? p4>,  <? p5>,  <? p6>,  <? p7>,  <? p8>,  <? p9>,  <? p10>, |
      <? p11>, <? p12>, <? p13>, <? p14>, <? p15>, <? p16>, <? p17>, <? p18>, <? p19>, <? p20>), STRING
  END

  PRAGMA('compile(printf.CLW)')
