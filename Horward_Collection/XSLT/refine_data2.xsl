<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

    <!-- Generic identity template -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="records/record/title">
        <xsl:variable name="extent"
            select="following-sibling::extent"
            as="xs:string"/>
        <title_original>
            <xsl:value-of select="."/>
        </title_original>
        <title_changed>
            <xsl:choose>
                <xsl:when test="contains(., $extent)">
                    <xsl:value-of select="replace(., $extent, '')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </title_changed>
    </xsl:template>

</xsl:stylesheet>
