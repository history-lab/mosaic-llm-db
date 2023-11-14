create table mosaic.oct73_word_cnt_temp as 
   select doc_id, corpus, count(*) word_count
      from mosaic.docs d, ts_parse('default', d.body) t
      where t.tokid = 1 and
            d.authored >= '1973-10-01' and d.authored < '1973-11-01'
      group by d.doc_id, d.corpus;

select corpus, sum(word_count) total_words, round(avg(word_count)) avg_words_per_doc,
       round(stddev(word_count)) std_dev, 
       min(word_count) min_words_in_doc, max(word_count) max_words_in_doc, count(*) doccnt
    from mosaic.oct73_word_cnt_temp 
    group by corpus;