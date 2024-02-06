-- recap of oct73
-- totals
select count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from mosaic.docs_oct73; 

-- total by corpus
select corpus, count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from mosaic.docs_oct73
    group by corpus
    order by corpus;

-- total by classification
select classification, count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from mosaic.docs_oct73
    group by classification
    order by classification;

-- total by corpus and classification
select corpus, classification, count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from mosaic.docs_oct73
    group by corpus, classification
    order by corpus, classification;

-- Next iteration
-- totals
select count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from foiarchive.docs 
    where authored >= '1956-01-01' and authored <  '1961-01-01'; 

-- total by corpus
select corpus, count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from foiarchive.docs 
    where authored >= '1956-01-01' and authored <  '1961-01-01'
    group by corpus
    order by corpus;

-- total by classification
select classification, count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from foiarchive.docs 
    where authored >= '1956-01-01' and authored <  '1961-01-01'
    group by classification
    order by classification;

-- total by corpus and classification
select corpus, classification, count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from foiarchive.docs 
    where authored >= '1956-01-01' and authored <  '1961-01-01'
    group by corpus, classification
    order by corpus, classification;

-- CIA contenttype
select contenttype, count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from foiarchive.docs join declassification_cia.metadata on (docs.doc_id = metadata.id)
    where corpus = 'cia' and 
          authored >= '1956-01-01' and authored <  '1961-01-01'
    group by contenttype
    order by contenttype;

-- total by year
select date_trunc('year', authored), count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from foiarchive.docs 
    where authored >= '1956-01-01' and authored <  '1961-01-01'
    group by date_trunc('year', authored)
    order by date_trunc('year', authored);

select extract('year' from authored), count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from foiarchive.docs 
    where authored >= '1956-01-01' and authored <  '1961-01-01'
    group by extract('year' from authored)
    order by extract('year' from  authored);

-- '56-57
select count(doc_id) docs, sum(pg_cnt) pages, sum(word_cnt) words
    from foiarchive.docs 
    where authored >= '1956-01-01' and authored <  '1958-01-01'; 

-- CIA duplicate detection
with cdc (authored, title, pg_cnt, duplicates, duplicate_pages) as 
(select authored, title, pg_cnt, count(*)-1, sum(pg_cnt)-pg_cnt
    from foiarchive.docs
    where corpus = 'cia' and 
          authored >= '1956-01-01' and authored <  '1961-01-01'
    group by authored, title, pg_cnt 
    having count(*) > 1)
select count(*) uniq_docs, sum(duplicates) duplicate_copies, sum(duplicate_pages) duplicate_pages from cdc;

-- top 50 CIA docs by size
select authored, title, pg_cnt, word_cnt, source
    from foiarchive.docs
    where corpus = 'cia' and 
          authored >= '1956-01-01' and authored <  '1961-01-01'
    order by word_cnt desc
    limit 50;

