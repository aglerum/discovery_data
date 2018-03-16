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

    <!--<xsl:template match="*/*/marc:datafield[@tag = '020'][not(string-length(.) eq 10 or string-length(.) eq 13)]">
        <marc:datafield tag="024" ind1="8" ind2=" ">
            <marc:subfield code="a">
                <xsl:value-of select="."/>
            </marc:subfield>
        </marc:datafield>
    </xsl:template>
-->
    
    <xsl:template match="*/*/marc:datafield[@tag = '020'][string-length(.) eq 13 and starts-with(.,'5')]">
        <marc:datafield tag="024" ind1="8" ind2=" ">
            <marc:subfield code="a">
                <xsl:value-of select="."/>
            </marc:subfield>
        </marc:datafield>
    </xsl:template>
    

</xsl:stylesheet>
