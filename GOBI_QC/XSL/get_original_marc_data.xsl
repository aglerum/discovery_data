<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd" version="2.0">
    
    <xsl:output method="text" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Last updated: </xd:b>November 1, 2021</xd:p>
            <xd:p><xd:b>Author: </xd:b>Annie Glerum</xd:p>
            <xd:p><xd:b>Organization: </xd:b>Florida State University Libraries</xd:p>
            <xd:p><xd:b>Title: </xd:b>Get MARC Data</xd:p>
            <xd:p>Get key descriptive elements for specific review</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <xsl:text>Batch&#x9;GOBI_024&#x9;GOBI_035&#x9;OCLC&#x9;Field_049&#x9;Field_980&#x9;Field_981&#x9;Field_993&#x9;Title&#13;</xsl:text>
        <xsl:for-each select="collection/record">
            <!-- Delimiter -->
            <xsl:variable name="delimiter" select="'&#x9;'"/>
            
            <!-- Batch date -->
            <xsl:variable name="batch">
                <!--<xsl:value-of select="datafield[@tag = '999']/subfield[@code = 'a']"/>-->
                <xsl:value-of select="'GOBI_Update_Not_Imported_20211119'"/>
            </xsl:variable>
                    
            <!-- GOBI_024 -->
            <xsl:variable name="gobi_024">
                <xsl:value-of select="datafield[@tag = '024'][@ind1 = '8']/subfield[@code = 'a']"/>
            </xsl:variable>
            
            <!-- GOBI_035 -->
            <xsl:variable name="gobi_035">
                <xsl:value-of select="datafield[@tag = '035']/subfield[@code = 'a'][string-length(.) = 11 and not(starts-with(.,'(OCoLC)'))]"/>
            </xsl:variable>
            
            <!-- OCLC number -->
            <xsl:variable name="oclc">
                <xsl:value-of select="datafield[@tag = '035']/subfield[@code = 'a'][starts-with(.,'(OCoLC)') and not(starts-with(.,'(OCoLC)o'))]"/>
            </xsl:variable>
            
            <!-- Field_049 -->
            <xsl:variable name="field_049">
                <xsl:value-of select="datafield[@tag = '049']/*" separator="#"/>
            </xsl:variable>
            
            <!-- Field_980 -->
            <xsl:variable name="field_980">
                <xsl:value-of select="datafield[@tag = '980']/*" separator="#"/>
            </xsl:variable>
            
            <!-- Field_981 -->
            <xsl:variable name="field_981">
                <xsl:value-of select="datafield[@tag = '981']/*"  separator="#"/>
            </xsl:variable>
            
            <!-- Field_993 -->
            <xsl:variable name="field_993">
                <xsl:value-of select="datafield[@tag = '993']/*"  separator="#"/>
            </xsl:variable>
            
            <!-- Title and responsibility-->
            <xsl:variable name="title">
                <xsl:value-of select ="datafield[@tag = '245']/*"/>
            </xsl:variable>
            
            <xsl:value-of select="concat($batch, $delimiter, $gobi_024, $delimiter, $gobi_035, $delimiter, $oclc, $delimiter, $field_049, $delimiter, $field_980, $delimiter, $field_981, $delimiter, $field_993
                , $delimiter, normalize-space($title), '&#13;')"/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>