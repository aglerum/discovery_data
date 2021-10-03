<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Last updated:</xd:b> March 9, 2015</xd:p>
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
                    <xsl:value-of select="'15150305FIRM-Print'"/>
                </xsl:variable>

                <row>
                    <xsl:variable name="oclc" select="marc:controlfield[@tag='001']"/>
                    <xsl:variable name="ybpid" select="marc:datafield[@tag='024'][@ind1='8']"/>
                    <column>
                        <xsl:value-of select="$oclc"/>
                    </column>
                        <xsl:value-of select="$ybpid"/>
                    </column>

                </row>
            </xsl:for-each>

        </root>

    </xsl:template>
</xsl:stylesheet>
