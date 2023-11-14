create schema mosaic;
create or replace view mosaic.docs (
       doc_id, corpus, classification, authored, title, 
       body, full_text, doc_url, frus_volume_id) 
as 
select d.doc_id, d.corpus::text, d.classification::text, d.authored, d.title, 
       d.body, d.full_text, 
       coalesce(d.source, 'http://history-lab.org/documents/' || d.doc_id) doc_url, 
       f.volume_id
    from foiarchive.docs d left join foiarchive.docs_frus f 
                                        on d.doc_id = f.doc_id
    where /* exclude no body documents from CFPF */
          d.body != '' and
          d.body != 'No Text Body Available for Document' and
          d.body not like 'MRN: %TEXT FOR THIS MRN IS UNAVAILABLE%'
union all
select c.doc_id::id_d, 'cia' corpus, c.classification, c.authored, c.title,
       c.body, NULL::tsvector full_text, pdf doc_url, NULL::id_d frus_volume_id
    from declassification_cia.docs_view c
union all
select g.id::id_d doc_id, 'usddo' corpus, lower(g.classification) classification,
       g.date authored, g.title, g.body, NULL::tsvector full_text,
       'http://history-lab.org/documents/' || g.id doc_url, 
       NULL::id_d frus_volume_id
   from declassification_ddrs.docs g;


create role mosaic_team_member;
grant usage on schema mosaic to mosaic_team_member;
grant select on mosaic.docs to mosaic_team_member
