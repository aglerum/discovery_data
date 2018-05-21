(: Derived Title. td: 3,2,2,1; Omit initial articles, which was done to the source XML :)
declare boundary-space preserve;

declare variable $records := records/record;

        (: Create Derived Title search string :)
        (: [position() >= 301 and not(position() > 401)]
        [position() >= 401 and not(position() > 801)]:)
        (:return concat('nd: ', substring($titleWords[1],1,3),',',substring($titleWords[2],1,2),',',substring($titleWords[3],1,2),',',substring($titleWords[4],1,1),' or'):)
        
        for $record in $records[position() >= 401 and not(position() > 801)]
        let $record_number := $record/record_number/text()
        let $aleph := $record/aleph
        let $oclc := $record/oclc
        let $title := $record/titleNormal/text()
        let $publisher := $record/publisher/text()
        let $year := $record/year1/text()
        let $titleWords := tokenize($title,' ')
        let $newline := '&#xa;'              
        where $aleph = '' and $oclc = ''
        return concat('td: ', substring($titleWords[1],1,3),',',substring($titleWords[2],1,2),',',substring($titleWords[3],1,2),',',substring($titleWords[4],1,1),if ($year != '') then concat(' yr: ', $year) else (),' or',$newline)
    
