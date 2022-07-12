!** printf function.
!** 12.07.2022
!** mikeduglas@yandex.ru

  MEMBER

  MAP
    MODULE('win api')
      winapi::OutputDebugString(*CSTRING lpOutputString), PASCAL, RAW, NAME('OutputDebugStringA')
    END

    INCLUDE('printf.inc'), ONCE

    Url::Encode(STRING str, BOOL spaceAsPlus), STRING, PRIVATE

    Base64::EncodeBlock(STRING in, *STRING out, LONG len), PRIVATE
    Base64::Encode(STRING input_buf), STRING, PRIVATE
    Base64::Decode(STRING input_buf), STRING, PRIVATE

    DecToHex(LONG pDecVal, BOOL pLowerCase=FALSE), STRING, PRIVATE

    DebugInfo(STRING pMsg), PRIVATE
  END

!- base64 encoding data
cb64                          STRING('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')
DECODED_BUF_SIZE              EQUATE(54)    !54 characters per line
ENCODED_BUF_SIZE              EQUATE(72)    !54 * 4 / 3

!- base64 decoding data
B64index                      STRING('<0>{43}<62,63,62,62,63,52,53,54,55,56,57,58,59,60,61><0>{8}<1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,0,0,0,0,63,0,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51><0>{133}')

printf                        PROCEDURE(STRING pFmt, | 
                                <? p1>,  <? p2>,  <? p3>,  <? p4>,  <? p5>,  <? p6>,  <? p7>,  <? p8>,  <? p9>,  <? p10>, |
                                <? p11>, <? p12>, <? p13>, <? p14>, <? p15>, <? p16>, <? p17>, <? p18>, <? p19>, <? p20>)
allSpecifiers                   STRING('cCsSzZbBiIxXfedtuUmMvw')
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
eqCRLF                          STRING('<13,10>')
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
    CASE pFmt[i] 
    OF '%'
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
        
      OF 'c'   !%c: print out a character
        res = res & SUB(curArg, 1, 1)
        i += 1
      OF 'C'  !%C: print out an uppercased Character
        res = res & UPPER(SUB(curArg, 1, 1))
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
        tmp_uint = curArg
        res = res & CHOOSE(tmp_uint <> 0, 'true', 'false')
        i += 1
      OF 'B'      !%B: print out a TRUE/FALSE
        tmp_uint = curArg
        res = res & CHOOSE(tmp_uint <> 0, 'TRUE', 'FALSE')
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
        tmp_uint = curArg
        res = res & DecToHex(tmp_uint, TRUE)
        i += 1
      OF 'X'    !%X: print out an int in hex (upper case)
        tmp_uint = curArg
        res = res & DecToHex(tmp_uint, FALSE)
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
        
      OF 'u' !- url encoded string (the spaces get encoded to %20)
        res = res & Url::Encode(curArg, FALSE)
        i += 1
      OF 'U' !- url encoded string (the spaces get encoded to '+' sign)
        res = res & Url::Encode(curArg, TRUE)
        i += 1

      OF 'v'    !- base64 encoding
        res = res & Base64::Encode(CLIP(curArg))
        i += 1

      OF 'w'    !- base64 decoding
        res = res & Base64::Decode(CLIP(curArg))
        i += 1

      OF 'm'    !- ERROR()
        res = res & ERROR()
        i += 1
     
      OF 'M'    !- FILEERROR()
        res = res & FILEERROR()
        i += 1

      OF '|'    !- CRLF
        res = res & eqCRLF
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
  
Url::Encode                   PROCEDURE(STRING str, BOOL spaceAsPlus)
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
      encoded = encoded & DecToHex(v)
    END
  END
  
  RETURN encoded
  
Base64::EncodeBlock           PROCEDURE(STRING in, *STRING out, LONG len)
  CODE
!  {
!  out[0] = cb64[ in[0] >> 2 ];
!  out[1] = cb64[ ((in[0] & 0x03) << 4) | ((in[1] & 0xf0) >> 4) ];
!  out[2] = (unsigned char) (len > 1 ? cb64[ ((in[1] & 0x0f) << 2) | ((in[2] & 0xc0) >> 6) ] : '=');
!  out[3] = (unsigned char) (len > 2 ? cb64[ in[2] & 0x3f ] : '=');
!  }

  ASSERT(LEN(in) = 3 AND LEN(out) = 4)
  out[1] = cb64[BSHIFT(VAL(in[1]), -2) + 1]
  out[2] = cb64[BOR(BSHIFT(BAND(VAL(in[1]), 003h), 4), BSHIFT(BAND(VAL(in[2]), 0f0h), -4)) + 1]
  IF len > 1
    out[3] = cb64[BOR(BSHIFT(BAND(VAL(in[2]), 00fh), 2), BSHIFT(BAND(VAL(in[3]), 0c0h), -6)) + 1]
  ELSE
    out[3] = '='
  END
  IF len > 2
    out[4] = cb64[BAND(VAL(in[3]), 03fh) + 1]
  ELSE
    out[4] = '='
  END
    
Base64::Encode                PROCEDURE(STRING input_buf)
input_size                      LONG, AUTO
output_buf                      STRING((LEN(input_buf)/DECODED_BUF_SIZE + 1) * ENCODED_BUF_SIZE)
in                              STRING(3), AUTO
out                             STRING(4), AUTO
iIndex                          LONG, AUTO
block_size                      LONG, AUTO    !block size
sIndex                          LONG, AUTO    !pos in input_buf
n_block                         LONG, AUTO    !block number
  CODE
  input_size = LEN(input_buf)
  n_block = 0
  
  LOOP sIndex = 1 TO input_size BY 3
    block_size = 0
    LOOP iIndex = 1 TO 3
      IF sIndex + (iIndex - 1) <= input_size
        in[iIndex] = input_buf[sIndex + (iIndex - 1)]
        block_size += 1
      ELSE
        in[iIndex] = 0
      END
    END
    
    IF block_size
      Base64::EncodeBlock(in, out, block_size)

      n_block += 1
      output_buf[(n_block - 1) * 4 + 1 : n_block * 4] = out
    END
  END
  
  RETURN CLIP(output_buf)

Base64::Decode                PROCEDURE(STRING input_buf)
len                             LONG, AUTO
str                             STRING((3 * (LEN(CLIP(input_buf)) + 3) / 4) + 1)
pad                             LONG(0)
L                               LONG, AUTO
i                               LONG, AUTO
j                               LONG, AUTO
c1                              BYTE, AUTO
c2                              BYTE, AUTO
c3                              BYTE, AUTO
c4                              BYTE, AUTO
n                               LONG, AUTO
  CODE
  len = LEN(CLIP(input_buf))
  IF len AND ((len % 4) OR input_buf[len] = '=')
    pad = 1
  END
  
  L = INT((len + 3) / 4 - pad) * 4
  
  j = 1
  LOOP i = 1 TO L BY 4
    c1 = VAL(input_buf[i+0])+1; c1 = VAL(B64index[c1])
    c2 = VAL(input_buf[i+1])+1; c2 = VAL(B64index[c2])
    c3 = VAL(input_buf[i+2])+1; c3 = VAL(B64index[c3])
    c4 = VAL(input_buf[i+3])+1; c4 = VAL(B64index[c4])
    n = BOR(BSHIFT(c1, 18), BOR(BSHIFT(c2, 12), BOR(BSHIFT(c3, 6), c4)))
    
    str[j] = CHR(BSHIFT(n, -16));             j+=1
    str[j] = CHR(BAND(BSHIFT(n, -8), 0FFh));  j+=1
    str[j] = CHR(BAND(n, 0FFh));              j+=1
  END
  
  IF pad
    c1 = VAL(input_buf[L+1])+1; c1 = VAL(B64index[c1])
    c2 = VAL(input_buf[L+2])+1; c2 = VAL(B64index[c2])
    n = BOR(BSHIFT(c1, 18), BSHIFT(c2, 12))
    str[j] = CHR(BSHIFT(n, -16))
    
    IF (len > L + 2) AND (input_buf[L + 3] <> '=')
      c3 = VAL(input_buf[L+3])+1; c3 = VAL(B64index[c3])
      n = BOR(n, BSHIFT(c3, 6))
      str[j+1] = CHR(BAND(BSHIFT(n, -8), 0FFh))
    END
  END
  
  RETURN CLIP(str)

DecToHex                      PROCEDURE(LONG pDecVal, BOOL pLowerCase=FALSE)
sHex                            STRING(30)
  CODE
  LOOP UNTIL(~pDecVal)
    sHex = SUB('0123456789ABCDEF',1+pDecVal % 16,1) & sHex
    pDecVal = INT(pDecVal / 16)
  END
  RETURN CHOOSE(NOT pLowerCase, CLIP(sHex), LOWER(CLIP(sHex)))

DebugInfo                     PROCEDURE(STRING pMsg)
cs                              &CSTRING
  CODE
  cs &= NEW CSTRING(SIZE(pMsg) + 1)
  cs = CLIP(pMsg)
  winapi::OutputDebugString(cs)
  DISPOSE(cs)

printd                        PROCEDURE(STRING pFmt, | 
                                <? p1>,  <? p2>,  <? p3>,  <? p4>,  <? p5>,  <? p6>,  <? p7>,  <? p8>,  <? p9>,  <? p10>, |
                                <? p11>, <? p12>, <? p13>, <? p14>, <? p15>, <? p16>, <? p17>, <? p18>, <? p19>, <? p20>)
  CODE
  DebugInfo(printf(pFmt, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20))