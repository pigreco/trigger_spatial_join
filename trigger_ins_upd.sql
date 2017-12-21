-- creo tabella punti
CREATE TABLE punti
(pk_p INTEGER PRIMARY KEY autoincrement NOT NULL,
nome_strada TEXT,
data_ins datetime,
note TEXT,
distanza DOUBLE);

SELECT AddGeometryColumn('punti','geom',3004,'POINT',2);

-- creo tabella strade
CREATE TABLE strade
(pk_l INTEGER PRIMARY KEY autoincrement NOT NULL,
nome_strada TEXT
);

SELECT AddGeometryColumn('strade','geom',3004,'LINESTRING',2);

-- creo trigger: popola i campi data_ins, distanza e nome_strada appena inserisco la geometria del punto
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
END;

-- creo trigger: aggiorna i campi data_ins, distanza e nome_strada appena modifico la SOLA geometria del punto
CREATE TRIGGER upd_punti AFTER UPDATE OF geom ON punti
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
END;
