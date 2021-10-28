<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd" version="2.0">

    <xsl:output method="text" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Last updated: </xd:b>October 2, 2021</xd:p>
            <xd:p><xd:b>Based on </xd:b>ybp2dsv.xsl</xd:p>
            <xd:p><xd:b>Author: </xd:b>Annie Glerum</xd:p>
            <xd:p><xd:b>Organization: </xd:b>Florida State University Libraries</xd:p>
            <xd:p><xd:b>Title: </xd:b>Get Data</xd:p>
            <xd:p>Get key descriptive elements for specific review</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="/">
        <xsl:text>Batch|GOBI_024|GOBI_035|OCLC|Field_049|Field_980|Field_981|Title&#13;</xsl:text>
        <xsl:for-each select="collection/record">
            
            <!-- ***Global variables*** -->
            <!-- Batch date -->
            <!-- Enter the batch name in this Format: GOBI-FIRM_UPDATE_11150708 or GOBI-APPROVAL_ap19150729 where the numbers are the name of the original file-->
            <xsl:variable name="batch">
                <xsl:value-of select="'GOBI Approval_Imported_20211015'"/>
            </xsl:variable>
            
            <!-- GOBI_024 -->
            <xsl:variable name="gobi_024">
                <xsl:value-of select="datafield[@tag = '024'][@ind1 = '8']/subfield[@code = 'a']"/>
            </xsl:variable>
            
            <!-- GOBI_035 -->
            <xsl:variable name="gobi_035">
                <xsl:value-of select="datafield[@tag = '035']/subfield[@code = 'a'][string-length(.) = 11 and not(starts-with(.,'(OCoLC)') and not(starts-with(.,'(OCoLC)o')))]"/>
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

            <!-- Title and responsibility-->
            <xsl:variable name="title">
                <xsl:value-of select ="datafield[@tag = '245']/*"/>
            </xsl:variable>

            <xsl:value-of select="concat($batch, '|', $gobi_024, '|', $gobi_035, '|',$oclc, '|', $field_049,'|', $field_980, '|',$field_981, '|',normalize-space($title), '&#13;')"/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
