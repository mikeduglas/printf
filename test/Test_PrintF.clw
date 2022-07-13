  PROGRAM
  INCLUDE('KeyCodes.CLW')
  MAP
Test_Mike   PROCEDURE()  
Test_Carl   PROCEDURE()  
TestQAdd    PROCEDURE()
    INCLUDE('printf.inc'), ONCE
  END

G:SeqNo     LONG 

TestQAddGroup   GROUP,PRE()
Nam         STRING(255)
Fmt         STRING(1024)
Rez         STRING(2048)  
                END 
                
TestsQ  QUEUE,PRE(TestQ)
SeqNo       STRING(4)     ! TestQ:SeqNo
Nam         STRING(255)   ! TestQ:Nam   Name of Test
Fmt         STRING(1024)  ! TestQ:Fmt   Format to pass PrintF()
Rez         STRING(2048)  ! TestQ:Rez   Result from PrintF()  
!Failed STRING(6)    Future: Could Add Failed Flag that code could check for expected values in Rez
        END 

    CODE
    SYSTEM{PROP:PropVScroll}=1
    Test_Carl()
    ! Test_Mike()
    RETURN
    
Test_Mike   PROCEDURE()  
  CODE
  !- base64 encoding
  printd('%w', printf('%v', 'В Крыму заявили, что угрозы украинских властей отреагировать на запуск поездов по Крымскому мосту являются попыткой вмешательства во внутренние дела России.'))
  
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
  !- url encode (the spaces get encoded to %20)
  MESSAGE(printf('%u', 'This is a simple & short test.'))
  !- url encode (the spaces get encoded to '+' sign)
  MESSAGE(printf('%U', 'This is a simple & short test.'))
  !- error message
  COPY('w:\($$$)\???.txt', '1.txt')
  IF ERRORCODE()
    MESSAGE(printf('COPY(%Z, %Z) failed, error: %m', 'w:\($$$)\???.txt', '1.txt'))
  END
  !- Multiline message
  MESSAGE(printf('%s%|%s%|%s', 'Line 1', 'Line 2', 'Line 3'))
  RETURN
!==========================================
Test_Carl   PROCEDURE()
Window WINDOW('PrintF() Tests'),AT(,,350,350),GRAY,SYSTEM,FONT('Segoe UI',9),RESIZE
        BUTTON('&Run Tests'),AT(4,2),USE(?TestBtn)
        BUTTON('&Mike Tests'),AT(55,2),USE(?MikeBtn)
        LIST,AT(3,19),FULL,USE(?List:TestQ),VSCROLL,FROM(TestsQ),FORMAT('20L(2)~Seq~@s4@[200L(2)~Tes' & |
                't Name~@s255@/200L(2)~PrintF() Format Parameter       (Double Click to View)~/200L(' & |
                '2)~Result from PrintF()~]_')
    END
    CODE
    OPEN(Window)
    DISPLAY
    DO RunTestsRtn
    ACCEPT
        CASE ACCEPTED()
        OF ?TestBtn ; DO RunTestsRtn 
        OF ?MikeBtn ; Test_Mike()
        OF ?List:TestQ
           GET(TestsQ,CHOICE(?List:TestQ))
           IF KEYCODE()=MouseLeft2 THEN       !Double Click to view 
              SetKeyCode(0)
              Message(  'Name:    ' & CLIP(TestQ:Nam) & |
                      '||Format:  ' & CLIP(TestQ:Fmt) & |
                      '||Result:  ' & CLIP(TestQ:Rez) , |
                      'PrintF() Test ' & TestQ:SeqNo, ,'Close',,MSGMODE:CANCOPY + MSGMODE:FIXEDFONT )
           END 
        END 
    END
    CLOSE(Window)

RunTestsRtn ROUTINE
    FREE(TestsQ) ; G:SeqNo=0 ; CLEAR(TestQAddGroup) 

    Nam ='CLIPped strings' 
    Fmt ='%s %s!'       !was    Fmt ='Hello %s!'
    Rez =PrintF(Fmt,'Hello     ','world     ')
    TestQAdd()

    Nam ='Character %c %C %c -- "Hello ","world ","world "'   !Carl changed the 'C" code so test it
    Fmt ='c=%c C=%C c=%c' 
    Rez =PrintF(Fmt,'Hello ','world ','world ')
    TestQAdd()

    Nam ='CLIPped string, unCLIPped string, number, hex, HEX'
    Fmt ='%s, %z, %i, %x, %X'
    Rez =PrintF(Fmt,'Some string    ', 'Some string   ', 100, 43981, 43981)
    TestQAdd()

    Nam ='Hex <<= FFh, <<=FFFFh, 3xFF, 4xFF - Both hex, HEX'
    Fmt ='FFh=%x,%X -- FFFFh=%x,%X -- FFFFFFh=%x,%X -- FFFFFFFFh=%x,%X'
    Rez =PrintF(Fmt,0FFh, 0FFh, 0FFFFh, 0FFFFh, 0FFFFFFh, 0FFFFFFh ,0FFFFFFFFh, 0FFFFFFFFh)
    TestQAdd()

    Nam ='Hex 12h, 1234h, 123456h, 12345678h - Both hex, HEX'
    Fmt ='12h=%x,%X -- 1234h=%x,%X -- 123456h=%x,%X -- 12345678h=%x,%X'
    Rez =PrintF(Fmt,12h, 12h, 1234h, 1234h, 123456h, 123456h , 12345678h, 12345678h)
    TestQAdd()

    Nam ='Hex 1h, 123h, 12345h, 1234567h - Odd Digits Both hex, HEX'
    Fmt ='1h=%x,%X -- 123h=%x,%X -- 12345h=%x,%X -- 1234567h=%x,%X'
    Rez =PrintF(Fmt,1h, 1h, 123h, 123h, 12345h, 12345h , 1234567h, 1234567h)
    TestQAdd()

    Nam ='CLIPped quoted "string", unCLIPped quoted "string", signed number, formatted number'
    Fmt ='%S, %Z, %I, %i@n12@'
    Rez =PrintF(Fmt, 'Some string    ', 'Some string   ', 100, 987654321)
    TestQAdd()

    Nam = 'date, time (default format)'
    Fmt = 'Current datetime is %d %t'
    Rez =PrintF(Fmt,TODAY(), CLOCK())
    TestQAdd()

    Nam = 'date, time (custom format d1 t4)'
    Fmt = 'Current datetime is %d@d1-@ %t@t4@'
    Rez =PrintF(Fmt,TODAY(), CLOCK())
    TestQAdd()

    Nam = 'float, float in scientific notation'
    Fmt = '%f = %e'
    Rez =PrintF(Fmt,10.0/3.0, 10.0/3.0)
    TestQAdd()

    Nam = 'url encode (the spaces get encoded to %20)'
    Fmt = '%u'
    Rez =PrintF(Fmt,'This is a simple & short test.')
    TestQAdd()

    Nam = 'url encode (the spaces get encoded to "+" sign) Plus<<9>Tab and<<160>NBSP'
    Fmt = '%U'
    Rez =PrintF(Fmt,'This is a simple & short test.  Plus<9>Tab and<160>NBSP')
    TestQAdd()

    COPY('w:\($$$)\:::???.txt', '1:::.txt')     !File name with Colons will always fail
    Nam = 'Copy Error'
    Fmt = 'COPY(%Z, %Z) failed, error: %m'
    Rez =PrintF(Fmt,'w:\($$$)\???.txt', '1.txt')
    TestQAdd()

    Nam = 'Multiline message'
    Fmt = '%s%|%s%|%s'
    Rez =PrintF(Fmt,'Line 1', 'Line 2', 'Line 3')
    TestQAdd()

    Nam = 'Boolean %b %B True/False'
    Fmt = 'b T/F=%b/%b, B T/F=%B/%B, B 99/0 %B/%B'
    Rez =PrintF(Fmt,True,False,True,False,99,0)
    TestQAdd()
    
    EXIT
    
    OMIT('**END**')

    Nam = ''
    Fmt =
    Rez =PrintF(Fmt,)
    TestQAdd()

    !end of OMIT('**END**')


TestQAdd PROCEDURE()
    CODE
    G:SeqNo += 1
    TestQ:SeqNo = G:SeqNo
    TestQ:Nam   = Nam  
    TestQ:Fmt   = Fmt  
    TestQ:Rez   = Rez  
    ADD(TestsQ)
    CLEAR(TestQAddGroup)        !to prevent left over data being used
    DISPLAY
    RETURN 
    