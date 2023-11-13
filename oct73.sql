create or replace view mosaic.oct73 as 
select doc_id, corpus, classification, authored, 
       coalesce(source, 'http://history-lab.org/documents/' || doc_id) source, 
       substring(body, 1, 1024) body_1k, 
       frus_volume_id
    from mosaic.docs
    where authored >= '1973-10-01' and authored < '1973-11-01';