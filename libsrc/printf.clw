  MEMBER

  PRAGMA('compile(CWUTIL.CLW)')

  MAP
    INCLUDE('CWUTIL.INC'),ONCE
    INCLUDE('printf.inc'), ONCE
  END

printf                        PROCEDURE(STRING pFmt, | 
                                <? p1>,  <? p2>,  <? p3>,  <? p4>,  <? p5>,  <? p6>,  <? p7>,  <? p8>,  <? p9>,  <? p10>, |
                                <? p11>, <? p12>, <? p13>, <? p14>, <? p15>, <? p16>, <? p17>, <? p18>, <? p19>, <? p20>)
res                             ANY
numOfArgs                       LONG(0)   !- number of arguments
curArgNdx                       LONG(0)
curArg                          ANY
len                             LONG, AUTO
ch                              STRING(1), AUTO
i                               LONG, AUTO
tmp_int                         LONG, AUTO
tmp_double                      REAL, AUTO
tmp_case                        BYTE, AUTO
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
      
      IF INLIST(pFmt[i+1], 'c', 's', 'S', 'z', 'Z', 'i', 'x', 'X', 'f', 'e', 'd', 't')
        !- get next argument
        curArgNdx += 1
        IF curArgNdx > numOfArgs
          !- no more arguments, copy rest of format string into res and break the loop
          res = res & pFmt[i+1 : len]
          BREAK
        END
          
        DO GetArg
      END
        
      CASE pFmt[i+1]
      OF '%'  !%% - print out a single %
        res = res & pFmt[i]
        i +=1
        
      OF 'c'  !%c: print out a character
        res = res & SUB(curArg, 1, 1)
        i +=1

      OF   's'  !%s: print out a clipped string
      OROF 'z'  !%z: print out a string
        IF pFmt[i+1] = 's'
          res = res & CLIP(curArg)
        ELSE
          res = res & curArg
        END
        
        i +=1

      OF   'S'  !%s: print out a qouted clipped string
      OROF 'Z'  !%z: print out a qouted string
        IF pFmt[i+1] = 'S'
          res = res & ''''& CLIP(curArg) &''''
        ELSE
          res = res & ''''& curArg &''''
        END
        
        i +=1

      OF 'i'  !%i: print out an int
        tmp_int = curArg
        res = res & tmp_int
        i +=1
   
      OF 'x'    !%x: print out an int in hex (lower case)
      OROF 'X'  !%x: print out an int in hex (upper case)
        tmp_int = curArg

        IF pFmt[i+1] = 'x'
          tmp_case = TRUE
        ELSE
          tmp_case = FALSE
        END
        IF tmp_int < 256
          res = res & ByteToHex(curArg, tmp_case)
        ELSIF tmp_int < 65536
          res = res & ShortToHex(curArg, tmp_case)
        ELSE
          res = res & LongToHex(curArg, tmp_case)
        END
        
        i +=1
        
      OF 'f'
        tmp_double = curArg
        res = res & tmp_double
        i +=1

      OF   'e'
        tmp_double = curArg
        res = res & FORMAT(tmp_double, @E15.4)
        i +=1
             
      OF 'd'  !%d: print out a date (Windows setting for Short date)
        res = res & FORMAT(curArg, @d17)
        i +=1
             
      OF 't'  !%t: print out a time (Windows setting for Short time)
        res = res & FORMAT(curArg, @t7)
        i +=1
      END
    ELSE
      res = res & pFmt[i]
    END
  END
  
  RETURN res
  
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
  