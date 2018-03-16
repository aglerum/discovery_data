declare boundary-space preserve;

declare namespace marc = "http://www.loc.gov/MARC21/slim";

declare variable $records := marc:collection/marc:record;

<records>{

        (: List Missing fields :)
        
        for $record in $records
        let $number := $record/marc:datafield[@tag = '999']/marc:subfield[@code = 'c']/text()
        let $title := $record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/text()
        let $field952:= $record/marc:datafield[@tag = '952']
        where not($field952)
        return
            <record>
<error>Missing 952</error>
<number>{$number}</number>
<title>{$title}</title>
</record>
    
    }</records>