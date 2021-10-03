<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    version="2.0">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Last updated:</xd:b> October 31, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Annie Glerum</xd:p>
            <xd:p><xd:b>Organization:</xd:b> Florida State University Libraries</xd:p>
            <xd:p><xd:b>Title:</xd:b> Quality check report for venodr-supplied MARC records</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template name="hol" match="/">
        <root>
            <xsl:for-each select="*/marc:record">
                <!-- ***Global variables*** -->
                <!-- Batch date -->
                <xsl:variable name="batch">
                    <xsl:value-of select="'20141029FIRM-ORD'"/>
                </xsl:variable>
                
                <!-- Encoding Variable -->
                <xsl:variable name="encoding" select="substring(marc:leader,18,1)"/>
                <encoding><xsl:value-of select="$encoding"></xsl:value-of></encoding>
            </xsl:for-each>
            
        </root>
        
    </xsl:template>
</xsl:stylesheet>