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
    (doc_id, corpus, 
     title, 
     doc_url, 
     classification, authored, 
     frus_volume_id, body, pg_cnt, char_cnt)
select id doc_id, 'usddo' corpus, 
       case when title is null then 'US DDO Document ' || id || ' (Untitled)'
            else title
        end title, 
       'http://history-lab.org/documents/' || id doc_url,
       lower(g.classification) classification, date authored, 
       NULL frus_volume_id, body, pages pg_cnt, length(body) char_cnt
   from declassification_ddrs.docs g
   where date >= '1973-10-01' and date < '1973-11-01';

-- load from foiarchive (cfpf, frus, kissinger, nato)
insert into mosaic.docs_oct73 
    (doc_id, corpus, title, 
     doc_url, 
     classification, authored, 
     frus_volume_id, body, char_cnt)
select d.doc_id, corpus, title,
       case when source is not null then source
            else 'http://history-lab.org/documents/' || d.doc_id
       end doc_url,
       classification, authored, f.volume_id, 
       d.body, length(d.body) body_cnt
    from foiarchive.docs d left join foiarchive.docs_frus f 
                                        on d.doc_id = f.doc_id
    where /* exclude no body documents from CFPF */
          d.body != '' and
          d.body != 'No Text Body Available for Document' and
          d.body not like 'MRN: %TEXT FOR THIS MRN IS UNAVAILABLE%' and 
          authored >= '1973-10-01' and authored < '1973-11-01';

-- set word_cnt
update mosaic.docs_oct73 d73
    set word_cnt = (select count(*) 
                       from mosaic.docs_oct73 wc , ts_parse('default', wc.body) t
                       where t.tokid = 1 and
                             wc.doc_id = d73.doc_id
                       group by wc.doc_id);
-- 24 Records are null

-- set FTS
update mosaic.docs_oct73
    set fts = to_tsvector('english', 
                          title || ' ' || body  || ' doc_id: ' || doc_id || 
                          coalesce ('frus_volume_id: ' || frus_volume_id, ''));
alter table mosaic.docs_oct73 alter column fts set not null;
create index on mosaic.docs_oct73 using gin (fts);

-- set pg_cnt where availble
update mosaic.docs_oct73 d73 
   set pg_cnt = (select page_count 
                    from declassification_cables.docs c
                    where c.id = d73.doc_id)
   where corpus = 'cfpf';

update mosaic.docs_oct73 d73 
   set pg_cnt = (select page_count 
                    from declassification_pdb.docs p
                    where p.id = d73.doc_id)
   where corpus = 'pdb';

update mosaic.docs_oct73 d73 
   set pg_cnt = (select pg_cnt 
                    from nato_archives.docs n
                    where n.doc_id::text = d73.doc_id)
   where corpus = 'nato';

-- kissinger, frus don't have pg_cnts