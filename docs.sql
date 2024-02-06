drop view if exists mosaic.docs;
create or replace view mosaic.docs (
       doc_id, corpus, classification, authored, title, 
       body, full_text, doc_url) 
as 
select d.doc_id, d.corpus::text, d.classification::text, d.authored, d.title, 
       d.body, d.full_text, 
       coalesce(d.source, 'http://history-lab.org/documents/' || d.doc_id) doc_url
    from foiarchive.docs d 
union all
select g.id::foiarchive.id_d doc_id, 'usddo' corpus, lower(g.classification) classification,
       g.date authored, g.title, g.body, NULL::tsvector full_text,
       'http://history-lab.org/documents/' || g.id doc_url
   from declassification_ddrs.docs g;


create role mosaic_team_member;
grant usage on schema mosaic to mosaic_team_member;
grant select on mosaic.docs to mosaic_team_member;
