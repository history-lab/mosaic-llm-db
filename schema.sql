create schema mosaic;
create or replace view mosaic.docs (
       doc_id, corpus, classification, authored, title, 
       body, full_text, source, frus_volume_id) 
as 
select d.doc_id, d.corpus, d.classification, d.authored, d.title, 
       d.body, d.full_text, d.source, f.volume_id
    from foiarchive.docs d left join foiarchive.docs_frus f 
                                        on d.doc_id = f.doc_id;

create role mosaic_team_member;
grant usage on schema mosaic to mosaic_team_member;
grant select on mosaic.docs to mosaic_team_member;