# printf

Function *printf* returns the string pointed by 1st argument pFmt.  
If pFmt includes format specifiers (subsequences beginning with %),  
the additional arguments following format are formatted and inserted in the resulting string replacing their respective specifiers.  
  
## Format specifiers
```
%% - a single %
%c - a character
%s - a CLIPped string
%S - a quoted CLIPped string
%z - a string
%Z - a quoted string
%i - an integer
%x - an int in hex (lower case)
%X - an int in hex (upper case)
%f - a float
%e - a float in scientific notation (@E15.4)
%d - a date (Windows setting for Short date)
%t - a time (Windows setting for Short time)
```

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
  MESSAGE(printf('%s, %z, %i, %x, %X', 'Some string    ', 'Some string   ', 1, 0abcdh, 0abcdh))
  !- CLIPped quoted 'string', unCLIPped quoted 'string', number, hex, HEX
  MESSAGE(printf('%S, %Z, %i, %x, %X', 'Some string    ', 'Some string   ', 1, 0abcdh, 0abcdh))
  !- date, time
  MESSAGE(printf('Current datetime is %d %t', TODAY(), CLOCK()))
  !- float, float in scientific notation
  MESSAGE(printf('%f  %e', 10.0/3.0, 10.0/3.0))
```

## Requirements  
C6.3 and newer.

## How to install
Hit the 'Clone or Download' button and select 'Download Zip'.  
Now unzip printf-master.zip into a temporary folder somewhere.

Copy the contents of "libsrc" folder into %ClarionRoot%\Accessory\libsrc\win  
where %ClarionRoot% is the folder into which you installed Clarion.

## Contacts
- <mikeduglas@yandex.ru>
- <mikeduglas66@gmail.com>

## Price
Free

