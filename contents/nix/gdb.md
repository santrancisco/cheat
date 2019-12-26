### Dashboard

gdb dashboard is pretty damn neat if you have nothing.

```
curl https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit -o ~/.gdbinit
```


### Instructions

quickly peek at the asm around it and navigate using TUI: `layout asm`

---
 - Next instruction:  `stepi`  (`si`)
 - Go over call:      `nexti` (`ni`)
 - Go to return of current frame: `finish`
----
 - List breakpoints:  `show breakpoint`
 - Breakpoint at 0x123: `b *0x123`  (* is very important here!)
 - Disable 1st breakpoint: `disable 1`
---
 - Show custom layout to navigate through the code: `layout asm`
 - Show reg: `layout reg`
 - Quit custom layout: ctrl+x+a
---
 - Run shell command: `!{command here, eg ls}`
 - Show stactrace: `backtrace`
 - Show current instruction `x/i $pc`