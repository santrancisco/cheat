Comparing 2 binary files using xxd and diff:

```bash
diff -y <(xxd foo1.bin) <(xxd foo2.bin)
```