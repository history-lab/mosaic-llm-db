create table mosaic.classifications
    (classification     text        primary key,
     sensitivity_level  smallint    not null);
insert into mosaic.classifications 
    (classification, sensitivity_level) values
    ('top secret', 1),
    ('secret', 2),
    ('confidential', 3),
    ('limited official use', 5),
    ('unknown', 6),
    ('unclassified', 7);
alter table mosaic.docs_oct73
    add foreign key (classification)
        references mosaic.classifications;
    
create table mosaic.corpora
    (corpus varchar(10) primary key);
insert into mosaic.corpora(corpus)
    select distinct corpus
        from mosaic.docs_oct73; 
alter table mosaic.docs_oct73
    add foreign key (corpus)
        references mosaic.corpora;
    