
### Syntax

```bash
Min  Hour Day  Mon  Weekday
*    *    *    *    *   command to be executed
┬    ┬    ┬    ┬    ┬
│    │    │    │    └─  Weekday  (0=Sun .. 6=Sat)
│    │    │    └──────  Month    (1..12)
│    │    └───────────  Day      (1..31)
│    └────────────────  Hour     (0..23)
└─────────────────────  Minute   (0..59)
```

### Examples

```bash
0    *   * * *	every hour
*/15 *   * * *	every 15 mins
0    */2 * * *	every 2 hours
0    0   * * 0	every Sunday midnight
@reboot	        every reboot
```