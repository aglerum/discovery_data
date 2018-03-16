<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc xs" version="2.0">

    <!-- Last updated: March 11, 2018 -->

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
<!-- 
  
    Out of Order Subfields
    
      <marc:datafield tag="260" ind1=" " ind2=" ">
         <marc:subfield code="a">London</marc:subfield>
         <marc:subfield code="c">2001</marc:subfield>
         <marc:subfield code="b">London Topographical Society</marc:subfield>
      </marc:datafield>
    
    -->


    <xsl:template match="/*/*/marc:datafield[@tag = '260']">

            <xsl:copy>
                <xsl:copy-of select="@*" />
                <xsl:apply-templates select="marc:subfield[@code = 'a'], marc:subfield[@code = 'b'], marc:subfield[@code = 'c']"/>
            </xsl:copy>                
     </xsl:template>


</xsl:stylesheet>
