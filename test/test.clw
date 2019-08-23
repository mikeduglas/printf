  PROGRAM

  MAP
    INCLUDE('printf.inc'), ONCE
  END

  CODE
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
  MESSAGE(printf('%s|%s|%s', 'Line 1', 'Line 2', 'Line 3'))
  printd('%s|%s||%s', 'Line 1', 'Line 2', 'Line 2 continued')
  RETURN
