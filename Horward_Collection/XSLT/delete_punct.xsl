<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

    <!--    @param $string is string to process  -->
    <xsl:function name="fsul:strip-punctuation">
        <xsl:param name="string" as="xs:string"/>
        <xsl:analyze-string select="$string" regex="\[\]-">
            <xsl:matching-substring/>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <!-- Generic identity template -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="records/record/titleNormal">
        <titleNormal>
            <xsl:value-of select="fsul:strip-punctuation(.)"/>
        </titleNormal>
    </xsl:template>

</xsl:stylesheet>
