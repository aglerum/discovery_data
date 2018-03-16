<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc xs" version="2.0">
    
    <!-- Last Updated: May 9, 2017. -->
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <!-- Generic identity template -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="marc:collection/marc:record/marc:leader">
        <xsl:variable name="substring" select="substring(.,6,3)"/>
        <marc:leader><xsl:value-of select="replace(.,$substring,'nam')"/></marc:leader>
    </xsl:template>
        
</xsl:stylesheet>