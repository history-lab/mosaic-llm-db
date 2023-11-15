-- load cia
insert into mosaic.docs_oct73 
    (doc_id, corpus, title, doc_url, classification, authored, 
     frus_volume_id, body, pg_cnt, char_cnt)
select doc_id, 'cia' corpus, title, pdf doc_url, classification, authored, 
       NULL frus_volume_id, body, pages pg_cnt, length(body) char_cnt
    from declassification_cia.docs_view c
    where authored >= '1973-10-01' and authored < '1973-11-01';

-- load usddo
insert into mosaic.docs_oct73 
    (doc_id, corpus, title, doc_url, classification, authored, frus_volume_id,
     body, pg_cnt, char_cnt)


-- load from foiarchive (cfpf, frus, kissinger, nato)


-- populate word_cnt, fts

-- after load of body
--        generated always as (to_tsvector('english',                            coalesce(title, '')  || ' ' ||
--                             coalesce(body, '')   || ' ' ||
--                             'doc_id: ' || doc_id || ' ' ||
--                             coalesce ('frus_volume_id: ' ||
--                                        frus_volume_id, ''))
-- create index on mosaic.docs_oct73 using gin (fts);
-- references: corpus, classification
-- not null word_cnt, fts