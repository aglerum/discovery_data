declare boundary-space preserve;

declare namespace marc = "http://www.loc.gov/MARC21/slim";

declare variable $records := marc:collection/marc:record;

<records>{

        (: List 010 fields :)
        
        for $record in $records
        let $number := $record/marc:datafield[@tag = '999']/marc:subfield[@code = 'c']/text()
        let $title := $record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/text()
        let $lccn := $record/marc:datafield[@tag = '010']/marc:subfield[@code = 'a']/text()
        where $record/marc:datafield[@tag = '010']
        return
            <record>
<error>List 010</error>
<number>{$number}</number>
<lccn>{$lccn}</lccn>
<title>{$title}</title>
</record>
    
    }</records>