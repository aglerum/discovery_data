declare boundary-space preserve;

declare namespace marc = "http://www.loc.gov/MARC21/slim";

declare variable $records := marc:collection/marc:record;

<records>{

        (: List Missing subfields :)
        
        for $record in $records
        let $number := $record/marc:datafield[@tag = '999']/marc:subfield[@code = 'c']/text()
        let $title := $record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/text()
        let $field952:= $record/marc:datafield[@tag = '260']
        where $field952/marc:subfield[@code = 'a'] and $field952/marc:subfield[@code = 'c'] and not($field952/marc:subfield[@code = 'b'])
        return
            <record>
<error>Missing 260$b (has $a and $c)</error>
<number>{$number}</number>
<title>{$title}</title>
</record>
    
    }</records>