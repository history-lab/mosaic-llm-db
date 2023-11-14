create or replace view mosaic.oct73 as 
select doc_id, corpus, classification, authored, doc_url, 
       substring(body, 1, 1024) body_1k, 
       frus_volume_id
    from mosaic.docs
    where authored >= '1973-10-01' and authored < '1973-11-01'
    order by authored;