SELECT sb.al_isbn.bib_doc_num BIB, sb.al_isbn.isbn, sb.al_isbn.paren, sb.al_items.sub_lib, sb.al_items.coll_code, sb.al_items.open_date, sb.al_items.ips
FROM sb.al_isbn
LEFT JOIN sb.al_items ON sb.al_items.bib_doc_num = sb.al_isbn.bib_doc_num
LEFT JOIN sb.al_bib_fmt ON sb.al_bib_fmt.bib_doc_num = sb.al_isbn.bib_doc_num
WHERE sb.al_isbn.scode = 'a'
AND sb.al_items.inst = 'FS'
AND (sb.al_items.sub_lib != 'FSUER' 
    AND sb.al_items.sub_lib != 'FSUDG' 
    AND sb.al_items.sub_lib != 'FSUMC')
AND (sb.al_items.sub_lib != 'WD' 
    OR sb.al_items.sub_lib != 'VC' 
    OR sb.al_items.sub_lib != 'SP' 
    OR sb.al_items.sub_lib != 'MI' 
    OR sb.al_items.sub_lib != 'LO' 
    OR sb.al_items.sub_lib != 'LC' 
    OR sb.al_items.sub_lib != 'FU' 
    OR sb.al_items.sub_lib != 'FO' 
    OR sb.al_items.sub_lib != 'DO' 
    OR sb.al_items.sub_lib != 'CR' 
    OR sb.al_items.sub_lib != 'CO' 
    OR sb.al_items.sub_lib != 'CA' 
    OR sb.al_items.sub_lib != 'AC')
AND (sb.al_items.open_date LIKE '%AUG-18' 
    OR sb.al_items.open_date LIKE '%SEP-18' 
    OR sb.al_items.open_date LIKE '%OCT-18' 
    OR sb.al_items.open_date LIKE '%NOV-18' 
    OR sb.al_items.open_date LIKE '%DEC-18' 
    OR sb.al_items.open_date LIKE '%19' 
    OR sb.al_items.open_date LIKE '%20')
AND sb.al_bib_fmt.bib_fmt = 'BK';