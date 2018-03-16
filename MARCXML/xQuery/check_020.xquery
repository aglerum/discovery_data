declare boundary-space preserve;

declare namespace marc = "http://www.loc.gov/MARC21/slim";

declare variable $records := marc:collection/marc:record;

<records>{

        (: List 020 fields :)
        
        for $record in $records
        let $number := $record/marc:datafield[@tag = '999']/marc:subfield[@code = 'c']/text()
        let $title := $record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/text()
        let $field := $record/marc:datafield[@tag = '020']/marc:subfield[@code = 'a']/text()
        where $field
        return
            <record>
<error>List 020</error>
<number>{$number}</number>
<field>{string-join($field,' || ')}</field>
<title>{$title}</title>
</record>
    
    }</records>