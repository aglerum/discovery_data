<?xml version="1.0" encoding="UTF-8"?>
    <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
        xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd" exclude-result-prefixes="#all">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Last updated: </xd:b>March 1, 2017</xd:p>
            <xd:p><xd:b>Author: </xd:b>Annie Glerum</xd:p>
            <xd:p><xd:b>Organization: </xd:b>Florida State University Libraries</xd:p>
            <xd:p><xd:b>Title: </xd:b>marcxml2sequential</xd:p>
            <xd:p>Transformation of MARCXML to Aleph Sequential: No namespace</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output indent="yes" encoding="UTF-8" method="text"/>
    
    <xsl:template match="/marc:collection">
        <xsl:param name="break" select="'&#xA;'" />
        <xsl:param name="space" select="' '" />
        <xsl:param name="spaces" select="'   '" />
        <xsl:param name="L" select="'L'" />
        <xsl:param name="delimiters" select="'$$'" />
        <xsl:for-each select="marc:record">            
            <!-- First row -->          
            <xsl:value-of select="marc:controlfield[@tag = '001']"/>
            <xsl:value-of select="$space"/>
            <xsl:value-of select="'001'"/>
            <xsl:value-of select="$spaces"/>
            <xsl:value-of select="$L"/>
            <xsl:value-of select="$space"/>
            <xsl:value-of select="marc:controlfield[@tag = '001']"/>
            <xsl:value-of select="$break"/>
            <!-- Other Control fields -->  
            <xsl:for-each select="marc:controlfield[@tag != '001']">
                <xsl:value-of select="preceding-sibling::marc:controlfield[@tag = '001']"/>
                <xsl:value-of select="$space"/>
                <xsl:value-of select="@tag"/>
                <xsl:value-of select="$spaces"/>
                <xsl:value-of select="$L"/>
                <xsl:value-of select="$space"/>
                <xsl:value-of select="."/>
                <xsl:value-of select="$break"/>
            </xsl:for-each>            
            <!-- Datafields -->   
            <xsl:for-each select="marc:datafield">
                <xsl:value-of select="preceding-sibling::marc:controlfield[@tag = '001']"/>
                <xsl:value-of select="$space"/>
                <xsl:value-of select="@tag"/>
                <xsl:value-of select="$spaces"/>
                <xsl:value-of select="$L"/>
                <xsl:value-of select="$space"/>
                <xsl:for-each select="marc:subfield">
                    <xsl:value-of select="$delimiters"/>
                    <xsl:value-of select="@code"/>
                    <xsl:value-of select="."/>
                </xsl:for-each>
                <xsl:value-of select="$break"/>                
            </xsl:for-each>             
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>