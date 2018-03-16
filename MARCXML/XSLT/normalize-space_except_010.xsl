<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc xs" version="2.0">
    
    <!-- Last updated: September 18, 2017 -->
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/*/*/marc:datafield[not(@tag='010')]">
        <xsl:variable name="tag" select="@tag"/>
        <xsl:variable name="ind1" select="@ind1"/>
        <xsl:variable name="ind2" select="@ind2"/>
        <marc:datafield tag="{$tag}" ind1="{$ind1}" ind2="{$ind2}">
            <xsl:for-each select="marc:subfield">
                <xsl:variable name="code" select="@code"/>
                <marc:subfield code="{$code}"><xsl:value-of select="normalize-space(.)"/></marc:subfield>
            </xsl:for-each>
        </marc:datafield>
    </xsl:template>

</xsl:stylesheet>