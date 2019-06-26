!** printf function.
!** 26.06.2019
!** mikeduglas66@yandex.com

  MEMBER

  PRAGMA('compile(CWUTIL.CLW)')

  MAP
    MODULE('win api')
      winapi::OutputDebugString(*CSTRING lpOutputString), PASCAL, RAW, NAME('OutputDebugStringA')
    END

    INCLUDE('CWUTIL.INC'),ONCE
    INCLUDE('printf.inc'), ONCE

    urlEncode(STRING str, BOOL spaceAsPlus), STRING, PRIVATE
    DebugInfo(STRING pMsg), PRIVATE
  END

printf                        PROCEDURE(STRING pFmt, | 
                                <? p1>,  <? p2>,  <? p3>,  <? p4>,  <? p5>,  <? p6>,  <? p7>,  <? p8>,  <? p9>,  <? p10>, |
                                <? p11>, <? p12>, <? p13>, <? p14>, <? p15>, <? p16>, <? p17>, <? p18>, <? p19>, <? p20>)
allSpecifiers                   STRING('cCsSzZbBiIxXfedtuUmM')
noArgSpecifiers                 STRING('mM')
res                             ANY
numOfArgs                       LONG(0)   !- number of arguments
curArgNdx                       LONG(0)
curArg                          ANY
len                             LONG, AUTO
ch                              STRING(1), AUTO
i                               LONG, AUTO
j                               LONG, AUTO
k                               LONG, AUTO
tmp_int                         LONG, AUTO
tmp_uint                        ULONG, AUTO
tmp_double                      REAL, AUTO
tmp_case                        BYTE, AUTO
tmp_picture                     STRING(20), AUTO
  CODE
  IF NOT OMITTED(p1); numOfArgs += 1
    IF NOT OMITTED(p2); numOfArgs += 1
      IF NOT OMITTED(p3); numOfArgs += 1
        IF NOT OMITTED(p4); numOfArgs += 1
          IF NOT OMITTED(p5); numOfArgs += 1
            IF NOT OMITTED(p6); numOfArgs += 1
              IF NOT OMITTED(p7); numOfArgs += 1
                IF NOT OMITTED(p8); numOfArgs += 1
                  IF NOT OMITTED(p9); numOfArgs += 1
                    IF NOT OMITTED(p10); numOfArgs += 1
                      IF NOT OMITTED(p11); numOfArgs += 1
                        IF NOT OMITTED(p12); numOfArgs += 1
                          IF NOT OMITTED(p13); numOfArgs += 1
                            IF NOT OMITTED(p14); numOfArgs += 1
                              IF NOT OMITTED(p15); numOfArgs += 1
                                IF NOT OMITTED(p16); numOfArgs += 1
                                  IF NOT OMITTED(p17); numOfArgs += 1
                                    IF NOT OMITTED(p18); numOfArgs += 1
                                      IF NOT OMITTED(p19); numOfArgs += 1
                                        IF NOT OMITTED(p20); numOfArgs += 1
                                        END
                                      END
                                    END
                                  END
                                END
                              END
                            END
                          END
                        END
                      END
                    END
                  END
                END
              END
            END
          END
        END
      END
    END
  END
  
  len = LEN(pFmt)

  LOOP i = 1 TO len
    IF pFmt[i] = '%'
      IF i = len
        BREAK
      END
      
      IF INSTRING(pFmt[i+1], allSpecifiers)
        IF NOT INSTRING(pFmt[i+1], noArgSpecifiers)
          !- get next argument
          curArgNdx += 1
          IF curArgNdx > numOfArgs
            !- no more arguments, copy rest of format string into res and break the loop
            res = res & pFmt[i+1 : len]
            BREAK
          END
          
          DO GetArg
        END
      END
        
      DO GetPictureToken
      
      CASE pFmt[i+1]
      OF '%'  !%% - print out a single %
        res = res & pFmt[i]
        i += 1
        
      OF    'c'  !%c: print out a character
      OROF  'C'  !%C: print out an uppercased Character
        IF pFmt[i+1] = 'c'
          res = res & SUB(curArg, 1, 1)
        ELSE
          res = res & UPPER(SUB(curArg, 1, 1))
        END
        
        i += 1

      OF   's'  !%s: print out a clipped string
      OROF 'z'  !%z: print out a string
        IF j = 0  !- no picture token
          IF pFmt[i+1] = 's'
            res = res & CLIP(curArg)
          ELSE
            res = res & curArg
          END
        
          i += 1
        ELSE
          IF pFmt[i+1] = 's'
            res = res & FORMAT(CLIP(curArg), tmp_picture)
          ELSE
            res = res & FORMAT(curArg, tmp_picture)
          END
        
          i += 1 + (k-j+1)
        END
        
      OF   'S'  !%s: print out a qouted clipped string
      OROF 'Z'  !%z: print out a qouted string
        IF j = 0  !- no picture token
          IF pFmt[i+1] = 'S'
            res = res & ''''& CLIP(curArg) &''''
          ELSE
            res = res & ''''& curArg &''''
          END
        
          i += 1
        ELSE
          IF pFmt[i+1] = 'S'
            res = res & ''''& FORMAT(CLIP(curArg), tmp_picture) &''''
          ELSE
            res = res & ''''& FORMAT(curArg, tmp_picture) &''''
          END
        
          i += 1 + (k-j+1)
        END
        
      OF 'b'      !%b: print out a true/false
      OROF 'B'    !%B: print out a TRUE/FALSE
        tmp_uint = curArg

        IF pFmt[i+1] = 'b'
          res = res & CHOOSE(tmp_uint <> 0, 'true', 'false')
        ELSE
          res = res & CHOOSE(tmp_uint <> 0, 'TRUE', 'FALSE')
        END
        
        i += 1

      OF 'i'  !%i: print out an int
        tmp_int = curArg
        IF j = 0  !- no picture token
          res = res & tmp_int
          i += 1
        ELSE
          res = res & FORMAT(tmp_int, tmp_picture)
          i += 1 + (k-j+1)
        END

      OF 'I'  !%i: print out an int with sign +/-
        tmp_int = curArg
        IF j = 0  !- no picture token
          IF tmp_int > 0
            res = res &'+'& tmp_int
          ELSE
            res = res & tmp_int
          END
        
          i += 1
        ELSE
          IF tmp_int > 0
            res = res &'+'& FORMAT(tmp_int, tmp_picture)
          ELSE
            res = res & FORMAT(tmp_int, tmp_picture)
          END
        
          i += 1 + (k-j+1)
        END
        
      OF 'x'    !%x: print out an int in hex (lower case)
      OROF 'X'  !%x: print out an int in hex (upper case)
        tmp_uint = curArg

        IF pFmt[i+1] = 'x'
          tmp_case = TRUE
        ELSE
          tmp_case = FALSE
        END
        IF tmp_uint < 256
          res = res & ByteToHex(curArg, tmp_case)
        ELSIF tmp_uint < 65536
          res = res & ShortToHex(curArg, tmp_case)
        ELSE
          res = res & LongToHex(curArg, tmp_case)
        END
        
        i += 1
        
      OF 'f'
        tmp_double = curArg
        IF j = 0  !- no picture token
          res = res & tmp_double
          i += 1
        ELSE
          res = res & FORMAT(tmp_double, tmp_picture)
          i += 1 + (k-j+1)
        END

      OF   'e'
        tmp_double = curArg
        IF j = 0  !- no picture token
          !- default scientific picture token: @E15.4
          res = res & FORMAT(tmp_double, @E15.4)
          i += 1
        ELSE
          res = res & FORMAT(tmp_double, tmp_picture)
          i += 1 + (k-j+1)
        END

      OF 'd'  !%d: print out a date
        IF j = 0  !- no picture token        
          !- default picture token: Windows setting for Short date
          res = res & FORMAT(curArg, @d17)
          i += 1
        ELSE
          res = res & FORMAT(curArg, tmp_picture)
          i += 1 + (k-j+1)
        END
             
      OF 't'  !%t: print out a time
        IF j = 0  !- no picture token        
          !- default picture token: Windows setting for Short time
          res = res & FORMAT(curArg, @t7)
          i += 1
        ELSE
          res = res & FORMAT(curArg, tmp_picture)
          i += 1 + (k-j+1)
        END
        
      OF    'u' !- url encoded string (the spaces get encoded to %20)
      OROF  'U' !- url encoded string (the spaces get encoded to '+' sign)
        IF pFmt[i+1] = 'u' 
          res = res & urlEncode(curArg, FALSE)
        ELSE
          res = res & urlEncode(curArg, TRUE)
        END
        
        i += 1

      OF 'm'
        res = res & ERROR()
        i += 1
     
      OF 'M'
        res = res & FILEERROR()
        i += 1

      END
    ELSE
      res = res & pFmt[i]
    END
  END
  
  RETURN res

GetPictureToken               ROUTINE
  !- find picture token (ex. @d10-b@)
  tmp_picture = ''
  j = 0
  k = 0
  !- check if there is a space at least for shortest token like '@d1@'
  IF i+1+4 <= len AND pFmt[i+2] = '@'
    k = INSTRING('@', pFmt, 1, i+3)
    IF k > i+4
      j = i+2
      tmp_picture = pFmt[j : k - 1]
    END
  END

GetArg                        ROUTINE
  EXECUTE curArgNdx
    curArg = p1
    curArg = p2
    curArg = p3
    curArg = p4
    curArg = p5
    curArg = p6
    curArg = p7
    curArg = p8
    curArg = p9
    curArg = p10
    curArg = p11
    curArg = p12
    curArg = p13
    curArg = p14
    curArg = p15
    curArg = p16
    curArg = p17
    curArg = p18
    curArg = p19
    curArg = p20
  END
  
urlEncode                     PROCEDURE(STRING str, BOOL spaceAsPlus)
encoded                         ANY
c                               STRING(1), AUTO
v                               BYTE, AUTO
i                               LONG, AUTO
  CODE
  LOOP i = 1 TO LEN(CLIP(str))
    c = str[i]
    IF ISALPHA(c) OR NUMERIC(c) OR INLIST(c, '-', '_', '.', '~')
      encoded = encoded & c
    ELSIF spaceAsPlus AND c = ' '
      encoded = encoded &'+'      
    ELSE
      v = VAL(c)
      IF v < 16
        encoded = encoded &'%0'
      ELSE
        encoded = encoded &'%'
      END
      
      encoded = encoded & ByteToHex(v)
    END
  END
  
  RETURN encoded

DebugInfo                     PROCEDURE(STRING pMsg)
cs                              &CSTRING
  CODE
  cs &= NEW CSTRING(LEN(pMsg) + 1)
  cs = CLIP(pMsg)
  winapi::OutputDebugString(cs)
  DISPOSE(cs)

printd                        PROCEDURE(STRING pFmt, | 
                                <? p1>,  <? p2>,  <? p3>,  <? p4>,  <? p5>,  <? p6>,  <? p7>,  <? p8>,  <? p9>,  <? p10>, |
                                <? p11>, <? p12>, <? p13>, <? p14>, <? p15>, <? p16>, <? p17>, <? p18>, <? p19>, <? p20>)
  CODE
  DebugInfo(printf(pFmt, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20))