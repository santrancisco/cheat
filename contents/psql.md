### Tips

Just an example creating TABLE with some tricks
```
CREATE TABLE test(
  id             bigint      NOT NULL,
  varcharmaxlen  varchar(60) NOT NULL,    -- varchar can set max lenght, text type cannot
  timez          timestamptz NOT NULL DEFAULT now(),
  stringarray    varchar[]   NOT NULL,
  jsondoc        json        NOT NULL DEFAULT '[]'::json,
  positivenum    integer     NOT NULL CHECK (positivenum > 0),
  CONSTRAINT pkeys_for_this_table PRIMARY KEY (id, varcharmaxlen)  -- combination of all these values have to be unique
);
INSERT INTO test(id,varcharmaxlen,stringarray,positivenum,jsondoc) VALUES (1,'varchar','{"hellow","world"}', 42,'[{"a":1,"b":2},{"c":"d"}]');
```

Example to CREATE a domain that validate email addresses. We can take out the plus(+) sign here to ignore alias addresses.

```
CREATE EXTENSION citext;
CREATE DOMAIN email AS citext
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

CREATE TABLE IF NOT EXISTS users (
    id                   bigserial      primary key,
    email       	       email			    NOT NULL unique
)

INSERT INTO users(email) VALUES ('test+test@blah.com');
select * from users where email = 'Test+TEST@BlAh.cOm';
```