CREATE TABLE punti
(pk_p INTEGER PRIMARY KEY autoincrement NOT NULL,
nome_strada TEXT,
data_ins datetime,
note TEXT,
distanza DOUBLE);

SELECT AddGeometryColumn('punti','geom',3004,'POINT',2);

CREATE TABLE strade
(pk_l INTEGER PRIMARY KEY autoincrement NOT NULL,
nome_strada TEXT
);

SELECT AddGeometryColumn('strade','geom',3004,'LINESTRING',2);


CREATE TRIGGER ins_punti AFTER INSERT ON punti
BEGIN
   UPDATE punti SET data_ins = DATETIME ('NOW')
   WHERE rowid = new.rowid ;

UPDATE punti SET distanza = 
(
   SELECT k.distance 
   FROM knn k, punti p
   WHERE f_table_name = 'strade' 
   AND ref_geometry = p.geom
   AND max_items = 1
   AND p.ROWID=NEW.ROWID
) 
WHERE punti.ROWID=NEW.ROWID;

UPDATE punti SET nome_strada =
(
   SELECT s.nome_strada
   FROM 
    (
     SELECT k.fid
     FROM knn k, punti p
     WHERE f_table_name = 'strade' 
     AND ref_geometry = p.geom
     AND max_items = 1
     AND p.ROWID=NEW.ROWID
    ) t left join strade s ON t.fid = s.pk_l
)
WHERE punti.ROWID=NEW.ROWID;
END;
