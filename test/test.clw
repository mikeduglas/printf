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
