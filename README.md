# printf

Function *printf* returns the string pointed by 1st argument pFmt.  
If pFmt includes format specifiers (subsequences beginning with %),  
the additional arguments following format are formatted and inserted in the resulting string replacing their respective specifiers.  

Function *printd* outputs formatted string into debug log.  
  
  
## Format specifiers
```
%% - a single % (percent sign)
%c - a character (first character of passed argument)
%C - a Character in upper case (first character of passed argument)
%s - a CLIPped string
%S - a quoted CLIPped string
%z - a not clipped string
%Z - a quoted not clipped string
%b - a boolean (true/false)
%B - a boolean (TRUE/FALSE)
%i - an integer
%I - signed integer (with leading + for positive argument)
%x - an int in hex (lower case)
%X - an int in HEX (UPPER CASE)
%f - a float
%e - a float in scientific notation (default picture token: @E15.4)
%d - a date (default picture token: @d17, Windows setting for Short date)
%t - a time (default picture token: @t7, Windows setting for Short time)
%u - an url encoded string (the spaces get encoded to %20)
%U - an url encoded string (the spaces get encoded to '+' sign)
%v - a base64 encoded string
%w - a base64 decoded string
%m - an error message returned by ERROR(); don't pass smth
%M - an error message returned by FILEERROR(); don't pass smth
%| - CRLF sequence (new line)
```
s,S,z,Z,i,I,f,e,d,t specifiers may have additional picture token.  
Picture token must be any valid Clarion picture token terminated by @.  
For example: %d@d10-@ - date value formatted as yyyy-mm-dd.

## How to use
Add following line inside the global map:  
```
    INCLUDE('printf.inc'), ONCE
```
then call printf(fmt, ...)  !- up to 21 arguments:
```
  !- CLIPped string
  MESSAGE(printf('Hello %s!', 'world'))
  !- CLIPped string, unCLIPped string, number, hex, HEX
  MESSAGE(printf('%s, %z, %i, %x, %X', 'Some string    ', 'Some string   ', 100, 43981, 43981))
  !- CLIPped quoted 'string', unCLIPped quoted 'string', signed number, formatted number
  MESSAGE(printf('%S, %Z, %I, %i@n12@', 'Some string    ', 'Some string   ', 100, 987654321))
  !- date, time (default format)
  MESSAGE(printf('Current datetime is %d %t', TODAY(), CLOCK()))
  !- date, time (custom format)
  MESSAGE(printf('Current datetime is %d@d1@ %t@t4@', TODAY(), CLOCK()))
  !- float, float in scientific notation
  MESSAGE(printf('%f = %e', 10.0/3.0, 10.0/3.0))
```

## Requirements  
C6.3 and newer.

## How to install
Hit the 'Code' green button and select 'Download Zip'.  
Now unzip printf-master.zip into a temporary folder somewhere.

Copy the contents of "libsrc" folder into %ClarionRoot%\Accessory\libsrc\win  
where %ClarionRoot% is the folder into which you installed Clarion.

## Contacts
- <mikeduglas@yandex.ru>
- <mikeduglas66@gmail.com>

## Price
Free

