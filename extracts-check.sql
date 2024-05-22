create table mosaic.extracts_check (
  check_id     integer generated always as identity primary key, 
  doc_id       text,
  andrew_check text);
\copy mosaic.extracts_check(doc_id, andrew_check) from 'reconciliation/extracts-check.csv' delimiter ',' csv noheader;

create materialized view mosaic.extracts_validation_temp as
select check_id, ec.doc_id, ec.andrew_check, 
       case when d.doc_id is not null then 'YES' else 'NO' end in_mosaic_docs,
       d.authored, d.title, d.corpus, length(d.body) doc_char_cnt,
       case when d.authored is null and d.doc_id is not null 
                then 'NULL date excludes this doc from query result'
            when d.doc_id is null then 'Not in Mosaic docs'  
            else 'Appears in query result' 
       end note 
    from mosaic.extracts_check ec left join mosaic.docs d on ec.doc_id::foiarchive.id_d = d.doc_id
    where ec.doc_id not like '%20BULL%'
union all
select check_id, ec.doc_id, ec.andrew_check, -- substr(ec.doc_id, 31, 10)  
        case when d.doc_id is not null then 'YES' else 'NO' end in_mosaic_docs,
        d.authored, d.title, d.corpus::text, length(d.body) doc_char_cnt,
        case when d.authored is null and d.doc_id is not null 
                then 'NULL date excludes this doc from query result'
            when d.doc_id is null then 'Not in Mosaic docs'  
            else 'DOC_ID not provided but doc appears in query result' 
        end note 
from mosaic.extracts_check ec left join foiarchive.docs d 
        on d.source like '%' || ec.doc_id || '%'
where ec.doc_id like '%20BULL%' 
order by check_id;

\copy (select * from mosaic.extracts_validation_temp) to 'reconciliation/extracts-validation.csv' delimiter ',' csv header;