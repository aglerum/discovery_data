<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc xs" version="2.0">

    <!-- Last updated: March 11, 2018 -->

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!--
 <marc:datafield tag="024" ind1="8" ind2=" ">
            <marc:subfield code="a">0521846005 (hardback)</marc:subfield>
        </marc:datafield>
        <marc:datafield tag="024" ind1="8" ind2=" ">
            <marc:subfield code="a">0521608503 (pbk.)</marc:subfield>
        </marc:datafield>
        <marc:datafield tag="024" ind1="3" ind2=" ">
            <marc:subfield code="a">9780521846004 (hardback)</marc:subfield>
        </marc:datafield>
        <marc:datafield tag="024" ind1="3" ind2=" ">
            <marc:subfield code="a">9780521608503 (pbk.)</marc:subfield>
        </marc:datafield>
              <marc:datafield tag="024" ind1="8" ind2=" ">
         <marc:subfield code="a">9780330457408 (hbk.)</marc:subfield>
      </marc:datafield>
      <marc:datafield tag="024" ind1="8" ind2=" ">
         <marc:subfield code="a">0330457403 (hbk.)</marc:subfield>
      </marc:datafield>
      
          <xsl:template match="*/*/marc:datafield[@tag = '024'][marc:subfield[@code='a'][contains(.,'hardback') or contains(.,'hbk') or contains(.,'pbk') or contains(.,'pqper') or contains(.,'bdg') or contains(.,'discs') or contains(.,'v.') or contains(.,'v ') or contains(.,'cloth') or contains(.,'CDROM') or contains(.,'set') or contains(.,'ed.') or contains(.,':') or contains(.,'House') or contains(.,'cover') or contains(.,'PB')or contains(.,'binding') or contains(.,'hb') or contains(.,'hard') or contains(.,'ebook') or contains(.,'US') or contains(.,'UK') or contains(.,'hc') or contains(.,'editions')]]">
-->
    
    <xsl:template match="*/*/marc:datafield[@tag = '024'][marc:subfield[@code='a'][contains(.,'(') or contains(.,':')]]">
        <marc:datafield tag="020" ind1=" " ind2=" ">
            <marc:subfield code="a">
                <xsl:value-of select="."/>
            </marc:subfield>
        </marc:datafield>
    </xsl:template>
</xsl:stylesheet>
