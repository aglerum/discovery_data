declare boundary-space preserve;

declare namespace marc = "http://www.loc.gov/MARC21/slim";

declare variable $records := marc:collection/marc:record;

<records>{

        (: List Missing subfields :)
        
        for $record in $records
        let $number := $record/marc:datafield[@tag = '999']/marc:subfield[@code = 'c']/text()
        let $title := $record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/text()
        let $field:= $record/marc:datafield[@tag = '260']
        let $subfieldA:= $record/marc:subfield[@code = 'a']
        let $subfieldB:= $record/marc:subfield[@code = 'b']
        let $subfieldC:= $record/marc:subfield[@code = 'c']
        where $subfieldB ne following-sibling::marc:datafield[@tag = '260']/marc:subfield[@code = 'a']
        return
            <record>
<error>Subfield B not following Subfield A</error>
<number>{$number}</number>
<title>{$title}</title>
</record>
    
    }</records>