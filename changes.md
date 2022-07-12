12.07.2022
- FIX: %u, %U: extra 0 added for values < 16. For example, printf('%x', 1) returned %001 instead of %01.
- CHG [potentially breaking change]: %x, %X: now hex values are not padded with zeros on the left. For example, printf('%X',10) returned 0A, now it returns A.
- CHG: DebugInfo now uses faster SIZE(string) instead of LEN(string).
- CHG: Removed dependency on CWUtil.clw.

Thanks to Carl Barnes for the comments and suggestions.