SELECT sb.al_isbn.bib_doc_num BIB, sb.al_isbn.isbn, sb.al_isbn.paren, sb.al_items.sub_lib, sb.al_items.coll_code, sb.al_items.open_date, sb.al_items.ips
FROM sb.al_isbn
LEFT OUTER JOIN sb.al_items ON sb.al_items.bib_doc_num = sb.al_isbn.bib_doc_num
LEFT OUTER JOIN sb.al_bib_fmt ON sb.al_bib_fmt.bib_doc_num = sb.al_isbn.bib_doc_num
WHERE sb.al_isbn.scode = 'a'
AND sb.al_items.inst = 'FS'
AND (sb.al_items.sub_lib = 'FSUER' OR sb.al_items.sub_lib = 'FSOAR')
AND (sb.al_items.ips != 'WD' 
    AND sb.al_items.ips != 'VC' 
    AND sb.al_items.ips != 'MI' 
    AND sb.al_items.ips != 'LO' 
    AND sb.al_items.ips != 'LC' 
    AND sb.al_items.ips != 'FU' 
    AND sb.al_items.ips != 'FO' 
    AND sb.al_items.ips != 'DO' 
    AND sb.al_items.ips != 'CR' 
    AND sb.al_items.ips != 'CO' 
    AND sb.al_items.ips != 'CA' 
    AND sb.al_items.ips != 'AC'
    AND sb.al_items.ips != 'OR')
AND (sb.al_items.open_date LIKE '%AUG-18' 
    OR sb.al_items.open_date LIKE '%SEP-18' 
    OR sb.al_items.open_date LIKE '%OCT-18' 
    OR sb.al_items.open_date LIKE '%NOV-18' 
    OR sb.al_items.open_date LIKE '%DEC-18' 
    OR sb.al_items.open_date LIKE '%19' 
    OR sb.al_items.open_date LIKE '%20')
AND sb.al_bib_fmt.bib_fmt = 'BK';
