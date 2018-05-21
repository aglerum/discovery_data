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
        <xsl:variable name="fixed_string">
            <xsl:analyze-string select="." regex="\[[0-9]{{4}}\]\s">
                <xsl:matching-substring>
                    <xsl:value-of
                        select="
                        if (. != '') then
                        replace(.,'\]\s',']. ')
                        else
                        ."
                    />
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
<!--        <title_original>
            <xsl:value-of select="."/>
        </title_original>-->
        <title>
            <xsl:value-of select="$fixed_string"/>
        </title>
    </xsl:template>

</xsl:stylesheet>
