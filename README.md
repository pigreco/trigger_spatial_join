# database SpatiaLite e i trigger per lo spatial-join
trigger per risolvere il problema dello spatiali join 

prima prova - `funziona!`

```
CREATE TRIGGER ins_punti AFTER INSERT ON punti
BEGIN
   UPDATE punti SET data_ins = DATETIME ('NOW')
   WHERE rowid = new.rowid ;

   UPDATE punti SET distanza = 
(
   select j.dista
   from 
   (select NEW.pk_p,distance(l.geom, NEW.geom) as dista
   from punti as  p, strade as l
   group by NEW.pk_p
   having min ( distance(l.geom, NEW.geom)) AND punti.ROWID=NEW.ROWID
   ) j
) 
WHERE punti.ROWID=NEW.ROWID;
END
```

seconda prova - `funziona!`

```
CREATE TRIGGER ins_punti AFTER INSERT ON punti
BEGIN
   UPDATE punti SET data_ins = DATETIME ('NOW')
   WHERE rowid = new.rowid ;

   UPDATE punti SET distanza = 
(
   select j.dista
   from 
   (select NEW.pk_p,min(distance(l.geom, NEW.geom)) as dista
   from punti as  p, strade as l
   group by NEW.pk_p
   having min ( distance(l.geom, NEW.geom)) AND punti.ROWID=NEW.ROWID
   ) j
) 
WHERE punti.ROWID=NEW.ROWID;
END
```

quale delle due prove è la più corretta?

- [ ] prima
- [ ] seconda
- [ ] nessuna delle due

----

