To see who has access to a file:

```bash
gpg --no-default-keyring --secret-keyring /dev/null -a --list-only ops.md.gpg
```

To read a file (on STDOUT):

```bash
gpg --decrypt ops.md.gpg
```

To encrypt a file:

```bash
gpg --output ops.md.gpg --encrypt \
  --recipient san.tran@ebfe.pw \
  --recipient someoneelse@email.com \
  ops.md
```

To encrypt a group of files or folder:

```bash
tar -c {{file* | folder_name}} | gpg --output output.tar.gpg --encrypt --recipient  san.tran@ebfe.pw --recipient someoneelse@email.com
```

To decrypt a TAR file:

```bash
gpg --decrypt staging-pcf.ssl.tar.gpg | tar xv
```

Symmetric encrypting file:

```bash
# Encrypting file
gpg —symmetric —armor <filename>
# Encyrpting/Decrypting clipboard.
pbpaste | gpg -o - --symmetric  --armor 
pbpaste | gpg -o - --decrypt
```