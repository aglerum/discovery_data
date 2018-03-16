declare boundary-space preserve;

declare namespace marc = "http://www.loc.gov/MARC21/slim";

declare variable $records := marc:collection/marc:record;

<records>{

        (: Check for 022 $a for no hypens :)
        
        for $record in $records
        let $number := $record/marc:datafield[@tag = '999']/marc:subfield[@code = 'c']/text()
        let $title := $record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/text()
        let $issn := $record/marc:datafield[@tag = '022']/marc:subfield[@code = 'a']/text()
        where $record/marc:datafield[@tag = '022'] and not(contains($issn, '-'))
        return
            <record>
<error>ISSN no hypen</error>
<number>{$number}</number>
<issn>{$issn}</issn>
<title>{$title}</title>
</record>
    
    }</records>