<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc xs" version="2.0">
    
    <!-- Last updated: March 10, 2018 -->
    <!-- For Koha records provided by the London Study Center. -->

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Example Sources:
        BOOK
        <marc:datafield tag="952" ind1=" " ind2=" ">
         <marc:subfield code="p">31254044963763</marc:subfield>
         <marc:subfield code="u">12563</marc:subfield>
         <marc:subfield code="d">MAIN</marc:subfield>
         <marc:subfield code="o">PN1995 .C42 1979</marc:subfield>
         <marc:subfield code="v">2014-07-17</marc:subfield>
         <marc:subfield code="y">0</marc:subfield>
         <marc:subfield code="b">MAIN</marc:subfield>
      </marc:datafield>
      
      DVD
    
         <marc:subfield code="o">DVD</marc:subfield>
       
       Other videorecordings (all of thias type)
         <marc:subfield code="o">DVA 0210 (viewing copy)</marc:subfield>
         <marc:subfield code="o">VBX 9964 (viewing copy)</marc:subfield>
         <marc:subfield code="o">DVB 8435 (viewing copy)</marc:subfield>
         <marc:subfield code="o">VBV 2672 (viewing copy)</marc:subfield>
         <marc:subfield code="o">VBW 0913 (viewing copy)</marc:subfield>
         <marc:subfield code="o">VBX 8710 (viewing copy)</marc:subfield>
         <marc:subfield code="o">VAO 3071 (viewing copy)</marc:subfield>
         <marc:subfield code="o">DVA 0210 (viewing copy)</marc:subfield>
        
      </marc:datafield>
    
    -->

    <!-- Adds BK etc. Callnumber from 952 -->
    <xsl:template match="/*/*/marc:leader">
        <xsl:copy-of select="."/>
        <xsl:for-each select="following-sibling::marc:datafield[@tag='952'][1][marc:subfield[@code='o'][not(starts-with(.,'DVD'))]]">
            <xsl:variable name="normalized_class">
                <xsl:variable name="string" select="normalize-space(marc:subfield[@code='o'])"/>
                <xsl:analyze-string select="$string" regex="(^[A-Z]+\s)">
                    <xsl:matching-substring>
                        <xsl:value-of select="normalize-space(replace(., ' ', ''))"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            
            <xsl:variable name="date">
                <xsl:analyze-string select="string($normalized_class)" regex="\s([0-9]{{4}}[a-zA-Z]?)$">
                    <xsl:matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring/>
                </xsl:analyze-string>
            </xsl:variable>
            
            <xsl:variable name="before-date"
                select="
                if ($date != '') then
                substring-before($normalized_class, $date)
                else
                $normalized_class"/>
            <xsl:variable name="tokenized_before-date" select="tokenize($before-date, ' ')"/>
            <xsl:variable name="cutter"
                select="
                if (not(contains($before-date, ' '))) then
                ''
                else
                $tokenized_before-date[last()]"/>
            <xsl:variable name="base"
                select="
                if (count($tokenized_before-date) = 3) then
                (concat($tokenized_before-date[1], ' ', $tokenized_before-date[2]))
                else
                $tokenized_before-date[1]
                "/>
            <xsl:variable name="normalized_base"
                select="
                if (matches($base, '\s\.')) then
                replace($base, '\s\.', '.')
                else
                $base"/>
                   
            <marc:datafield tag="090" ind1=" " ind2=" ">
                <marc:subfield code="a">
                    <xsl:value-of select="normalize-space($normalized_base)"/>
                </marc:subfield>
                <marc:subfield code="b">
                    <xsl:value-of
                        select="
                        concat($cutter, if ($date != '') then
                        $date
                        else
                        '')"
                    />
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>

    <!-- Adds AV Callnumber from 952-->
        <xsl:for-each select="following-sibling::marc:datafield[@tag='952'][1][marc:subfield[@code='o'][starts-with(.,'DVD')]]">
        <marc:datafield tag="099" ind1=" " ind2=" ">
            <marc:subfield code="a">
                <xsl:value-of select="marc:subfield[@code='o']"/>
            </marc:subfield>
        </marc:datafield>
    </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
