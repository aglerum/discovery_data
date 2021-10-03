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

                <!-- OCLC number -->
                <xsl:variable name="oclc">
                    <xsl:choose>
                        <xsl:when
                            test="
                        starts-with(marc:controlfield[@tag='001'], 'ocn')">
                            <xsl:value-of
                                select="normalize-space(substring-after(marc:controlfield[@tag='001'], 'ocn'))"
                            />
                        </xsl:when>
                        <xsl:when
                            test="
                        starts-with(marc:controlfield[@tag='001'], 'ocm')">
                            <xsl:value-of
                                select="normalize-space(substring-after(marc:controlfield[@tag='001'], 'ocm'))"
                            />
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:variable>

                <!-- Title and responsibility-->
                <xsl:variable name="title" select="marc:datafield[@tag='245']/*"/>

                        <rows>

                            <column>
                                <xsl:value-of select="$oclc"/>
                            </column>
                            <column>
                                <xsl:value-of select="$title"/>
                            </column>

                        </rows>
            </xsl:for-each>
        </root>
    </xsl:template>
    
</xsl:stylesheet>
