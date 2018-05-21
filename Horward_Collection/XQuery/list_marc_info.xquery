declare boundary-space preserve;

declare variable $records := collection/record;

        (: List element :)
        
        for $record in $records
        let $record_number := $record/controlfield[@tag = '001']
        let $LocalCall := $record/datafield[@tag='099'][1]/subfield[@code='a']/text()
        let $title := $record/datafield[@tag='245']
        let $titleH := $title/subfield[@code='h']
        let $OtherFormat := $record/datafield[@tag='533']/subfield[@code='a']
        let $newline := '&#xa;'
        return concat($record_number,' ',$LocalCall, ' ',$newline)
    
