<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/TaggedPDF-doc">
        <records>
            <xsl:for-each select="P">
                <record>
                    <aleph/>
                    <oclc/>
                    <author>
                        <xsl:value-of select="normalize-space(substring-before(., '.'))"/>
                    </author>
                    <title>
                        <xsl:value-of select="normalize-space(substring-after(., '.'))"/>
                    </title>
                    <publication/>
                    <extent/>
                    <notes/>
                </record>
            </xsl:for-each>
        </records>
    </xsl:template>
</xsl:stylesheet>
