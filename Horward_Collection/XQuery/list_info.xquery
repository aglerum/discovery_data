declare boundary-space preserve;

declare variable $records := records/record;

        (: List element :)
        
        for $record in $records
        let $record_number := $record/record_number/text()
        let $author := $record/author/text()
        let $title := $record/title/text()
        let $titleNormal := $record/titleNormal/text()
        let $token2 := tokenize($title, '\.')[2]
        let $token3 := tokenize($title, '\.')[3]
        let $publication := $record/publication/text()
        let $newline := '&#xa;'
        (:return if (contains($token, ' 2v')) then concat($record_number,': ',$author,$newline) else ():)
        (:return if (matches($token2, '(\s{1}[0-9]{1,2}v)|(\s{1}[0-9]{1,3}p)')) then concat($record_number,': ',$title,$newline) else ():)
        (:return concat($record_number,'# ',$token,$newline):)
    
