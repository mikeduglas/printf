  PROGRAM

  MAP
    INCLUDE('printf.inc'), ONCE
  END

  CODE
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
