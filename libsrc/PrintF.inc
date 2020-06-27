!** printf function.
!** 24.08.2019
!** mikeduglas@yandex.ru

  MODULE('printf')

!!!<summary>Returns the string pointed by pFmt. 
!!!If pFmt includes format specifiers (subsequences beginning with %), 
!!!the additional arguments following format are formatted and inserted in the resulting string replacing their respective specifiers.
!!!</summary>
!!!<param name="pFmt">
!!!%% - a single % (percent sign)
!!!%c - a character (first character of passed argument)
!!!%C - a Character in upper case (first character of passed argument)
!!!%s - a CLIPped string
!!!%S - a quoted CLIPped string
!!!%z - a not clipped string
!!!%Z - a quoted not clipped string
!!!%b - a boolean (true/false)
!!!%B - a boolean (TRUE/FALSE)
!!!%i - an integer
!!!%I - signed integer (with leading + for positive argument)
!!!%x - an int in hex (lower case)
!!!%X - an int in HEX (upper case)
!!!%f - a float
!!!%e - a float in scientific notation (default picture token: @E15.4)
!!!%d - a date (default picture token: @d17, Windows setting for Short date)
!!!%t - a time (default picture token: @t7, Windows setting for Short time)
!!!%u - an url encoded string (the spaces get encoded to %20)
!!!%U - an url encoded string (the spaces get encoded to '+' sign)
!!!%v - a base64 encoded string
!!!%w - a base64 decoded string
!!!%m - an error message returned by ERROR(); don't pass smth
!!!%M - an error message returned by FILEERROR(); don't pass smth
!!!%| - CRLF sequence (new line)
!!!
!!!s,S,z,Z,i,I,f,e,d,t specifiers may have additional picture token.
!!!Picture token must be any valid Clarion picture token terminated by @.
!!!For example: %d@d10-@ - date value formatted as yyyy-mm-dd.
!!!</param>
!!!<returns>Formatted string</returns>
printf  PROCEDURE(STRING pFmt, | 
      <? p1>,  <? p2>,  <? p3>,  <? p4>,  <? p5>,  <? p6>,  <? p7>,  <? p8>,  <? p9>,  <? p10>, |
      <? p11>, <? p12>, <? p13>, <? p14>, <? p15>, <? p16>, <? p17>, <? p18>, <? p19>, <? p20>), STRING

!!!<summary>Outputs formatted string into debug log.
!!!</summary>
printd  PROCEDURE(STRING pFmt, | 
          <? p1>,  <? p2>,  <? p3>,  <? p4>,  <? p5>,  <? p6>,  <? p7>,  <? p8>,  <? p9>,  <? p10>, |
          <? p11>, <? p12>, <? p13>, <? p14>, <? p15>, <? p16>, <? p17>, <? p18>, <? p19>, <? p20>)
  END

  PRAGMA('compile(printf.CLW)')
