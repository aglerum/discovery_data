<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

    <!--    @param $string is string to process  -->
    <xsl:function name="fsul:strip-punctuation">
        <xsl:param name="string" as="xs:string"/>
        <xsl:analyze-string select="$string" regex="[\.,':;\?#\+=()/_\[\]-]">
            <xsl:matching-substring/>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>

    <xsl:function name="fsul:strip-boolean">
        <xsl:param name="string" as="xs:string"/>
        <xsl:value-of select="replace(replace(replace(replace($string, ' or,', ' '), ' not ', ' '), ' and ', ' '), ' or ', ' ')"/>
    </xsl:function>
    
    <xsl:function name="fsul:strip-article">
        <xsl:param name="string" as="xs:string"/>
        <xsl:value-of select="if (starts-with($string,'The ')) then replace($string,'The ','') else (if (starts-with($string,'An ')) then replace($string,'An ','') else (if (starts-with($string,'A ')) then replace($string,'A ','') else (if (starts-with($string,'Les ')) then replace($string,'Les ','') else (if (starts-with($string,'The ')) then replace($string,'The ','') else (if (starts-with($string,'La ')) then replace($string,'La ','') else $string)))))"/>
    </xsl:function>

    <xsl:template match="records">
        <records>
            <xsl:for-each select="record">
                <record>
                    <xsl:copy-of select="*[position() lt 6]"/>
                    <titleNormal>
                        <xsl:value-of select="fsul:strip-punctuation(replace(fsul:strip-article(title), '-', ' '))"/>
                    </titleNormal>
                    <xsl:copy-of select="*[position() gt 5]"/>
                </record>
            </xsl:for-each>
        </records>

    </xsl:template>

</xsl:stylesheet>
