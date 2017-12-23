# database SpatiaLite e i trigger per lo spatial-join
trigger per risolvere il problema dello spatiali join 

prima prova - `funziona!`

```
CREATE TRIGGER ins_punti AFTER INSERT ON punti
BEGIN
   UPDATE punti SET nome_strada =
(
   select k.nome_strada
   from 
   (select NEW.pk_p,l.nome_strada
   from punti as  p, strade as l
   group by NEW.pk_p
   having min ( distance(l.geom, NEW.geom)) AND punti.ROWID=NEW.ROWID
   ) k
)
WHERE punti.ROWID=NEW.ROWID;
END
```

seconda prova - `funziona!`

```
CREATE TRIGGER ins_punti AFTER INSERT ON punti
BEGIN
   UPDATE punti SET nome_strada =
(
   select k.nome_strada
   from 
   (
   select l.nome_strada 
   from punti as  p, strade as l
   where p.pk_p||l.nome_strada IN 
        (
	      SELECT pu.pk_p||li.nome_strada 
         from punti as  pu, strade as li 
         group by pu.pk_p
         having min ( distance(li.geom, pu.geom))AND pu.ROWID=NEW.ROWID
         ) 		 
   ) k
)
WHERE punti.ROWID=NEW.ROWID;
END
```

quale delle due prove è la più corretta? funzionano entrambe!!!

- [ ] prima
- [ ] seconda
- [ ] nessuna delle due

----

