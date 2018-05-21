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

    <xsl:template match="records/record/author">
        <author>
            <xsl:value-of select="normalize-space(.)"/>
        </author>
    </xsl:template>

    <xsl:template match="records/record/title">
        <title>
            <xsl:value-of select="normalize-space(.)"/>
        </title>
    </xsl:template>
    
    <xsl:template match="records/record/titleNormal">
        <titleNormal>
            <xsl:value-of select="normalize-space(.)"/>
        </titleNormal>
    </xsl:template>
    
    <xsl:template match="records/record/titleKeyword">
        <titleKeyword>
            <xsl:value-of select="normalize-space(.)"/>
        </titleKeyword>
    </xsl:template>

    <xsl:template match="records/record/publication">
        <publication>
            <xsl:for-each select="*">
                <xsl:copy-of select="normalize-space(.)"/>
            </xsl:for-each>
        </publication>
    </xsl:template>

    <xsl:template match="records/record/extent">
        <extent>
            <xsl:value-of select="normalize-space(.)"/>
        </extent>
    </xsl:template>

    <xsl:template match="records/record/notes">
        <notes>
            <xsl:value-of select="normalize-space(.)"/>
        </notes>
    </xsl:template>

</xsl:stylesheet>
