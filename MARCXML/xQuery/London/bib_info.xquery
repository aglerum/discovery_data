declare boundary-space preserve;

declare namespace marc = "http://www.loc.gov/MARC21/slim";

declare variable $records := marc:collection/marc:record;

<records>{
        
        (: List bibliographic information :)
        
        for $record in $records
        let $number := $record/marc:datafield[@tag = '999']/marc:subfield[@code = 'c']/text()
        let $bibLevel := $record/normalize-space(substring(marc:leader, 8, 1))
        let $bibLevelName :=
        if ($bibLevel eq 'a') then
            'Monographic component part'
        else
            if ($bibLevel eq 'b') then
                'Serial component part'
            else
                if ($bibLevel eq 'c') then
                    'Collection'
                else
                    if ($bibLevel eq 'd') then
                        'Subunit'
                    else
                        if ($bibLevel eq 'i') then
                            'Integrating resource'
                        else
                            if ($bibLevel eq 'm') then
                                'Monograph'
                            else
                                if ($bibLevel eq 's') then
                                    'Serial'
                                else
                                    ()
        let $lccn := $record/marc:datafield[@tag = '010']
        let $isbn := $record/marc:datafield[@tag = '020']
        let $standard := $record/marc:datafield[@tag = '024']
        let $author := $record/marc:datafield[@tag = '100']
        let $title := $record/marc:datafield[@tag = '245']
        let $title-proper := $title/marc:subfield[@code = 'a']
        let $subtitle := $title/marc:subfield[@code = 'b']
        let $pubinfo := $record/marc:datafield[@tag = '260']
        let $publocation := $pubinfo//marc:subfield[@code = 'a']
        let $pubname := $pubinfo//marc:subfield[@code = 'b']
        let $pubdate := $pubinfo//marc:subfield[@code = 'c']
        let $extent := $record/marc:datafield[@tag = '300']/marc:subfield[@code = 'a']
        return
            <record>
<KOHA>{$number}</KOHA>
<bibLvl>{$bibLevelName}</bibLvl>
<LCCN>{
                        if ($lccn) then
                            string-join($lccn/marc:subfield[@code = 'a'],'||')
                        else
                            'NO LCCN'
                    }</LCCN>
<ISBN>{
                        if ($isbn) then
                            string-join($isbn/marc:subfield[@code = 'a'],'||')
                        else
                            'NO ISBN'
                    }</ISBN>
<Standard_Num>{
                        if ($standard) then
                            string-join($standard/marc:subfield[@code = 'a'],'||')
                        else
                            'NO STANDARD NUM'
                    }</Standard_Num>
<Author>{
                        if ($author) then
                            $author/marc:subfield[@code = 'a']/text()
                        else
                            'NO AUTHOR'
                    }</Author> 
<Title>{$title-proper/text()}</Title>
<Subtitle>{
                        if ($subtitle) then
                            $subtitle/text()
                        else
                            ()
                    }</Subtitle>
<Publisher_location>{
                        if ($pubinfo) then
                            if ($publocation) then
                                string-join($publocation,'||')
                            else
                                'NO PUB LOCATION'
                        else
                            'NO PUB INFO'
                    
                    }</Publisher_location>
<Publisher_name>{
                        if ($pubinfo) then
                            if ($pubname) then
                                string-join($pubname,'||')
                            else
                                'NO PUB NAME'
                        else
                            'NO PUB INFO'
                    }</Publisher_name>
<Publication_date>{
                        if ($pubinfo) then
                           if ($pubdate) then
                                string-join($pubdate,'||')
                            else
                                'NO PUB DATE'
                        else
                            'NO PUB INFO'
                    }</Publication_date>
<Extent>{
                        if ($extent) then
                            $extent/text()
                        else
                            'NO EXTENT'
                    }</Extent>                   
</record>    
    }</records>