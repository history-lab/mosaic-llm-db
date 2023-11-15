create table mosaic.docs_oct73 (
    doc_id              varchar(40) primary key,
    corpus              varchar(10) not null /* add reference */,
    title               text        not null,
    doc_url             text        not null, 
    classification      varchar(20) /* add reference */,
    authored            timestamp with time zone,
    frus_volume_id      text,
    body                text        not null,
    pg_cnt              integer,
    word_cnt            integer     /* not null */,
    char_cnt            integer     not null,
    fts                 tsvector    /* not null */
);
