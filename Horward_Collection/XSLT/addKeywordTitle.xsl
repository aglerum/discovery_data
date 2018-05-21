<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

    <!-- 
    *Keyword stopwords*
    a be an but and by are for as from at had has in of that have into on the he is or their her it she there his its so this if not than to was you were when which with would   
    -->

    <!-- Global variables -->
    <xsl:variable name="list">
        <stopwords>
            <word>A</word>
            <word>BE</word>
            <word>AN</word>
            <word>BUT</word>
            <word>AND</word>
            <word>BY</word>
            <word>ARE</word>
            <word>FOR</word>
            <word>AS</word>
            <word>FROM</word>
            <word>AT</word>
            <word>HAD</word>
            <word>HAS</word>
            <word>IN</word>
            <word>OF</word>
            <word>THAT</word>
            <word>HAVE</word>
            <word>INTO</word>
            <word>ON</word>
            <word>THE</word>
            <word>HE</word>
            <word>IS</word>
            <word>OR</word>
            <word>THEIR</word>
            <word>HER</word>
            <word>IT</word>
            <word>SHE</word>
            <word>THERE</word>
            <word>HIS</word>
            <word>ITS</word>
            <word>SO</word>
            <word>THIS</word>
            <word>IF</word>
            <word>NOT</word>
            <word>THAN</word>
            <word>TO</word>
            <word>WAS</word>
            <word>YOU</word>
            <word>WERE</word>
            <word>WHEN</word>
            <word>WHICH</word>
            <word>WITH</word>
            <word>WOULD</word>
            <word>LE</word>
            <word>LES</word>
            <word>LA</word>
            <word>LAS</word>
            <word>ET</word>
            <word>DE</word> 
            <word>DU</word>
            
        </stopwords>
    </xsl:variable>

    <xsl:function name="fsul:no-stopwords">
        <xsl:param name="string"/>
        <xsl:variable name="stopword" select="$list/stopwords/word"/>
        <xsl:analyze-string select="$string" regex="\w+" flags="i">           
            <xsl:matching-substring>
                <xsl:value-of select="if (upper-case(.)=$stopword) then '' else concat(.,' ')"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring/>
        </xsl:analyze-string>
    </xsl:function>

    <xsl:template match="records">
        <records>
            <xsl:for-each select="record">
                <record>
                    <xsl:copy-of select="*[position() lt 7]"/>
                    <titleKeyword>
                        <xsl:value-of select="fsul:no-stopwords(titleNormal)"/>
                    </titleKeyword>
                    <xsl:copy-of select="*[position() gt 6]"/>
                </record>
            </xsl:for-each>
        </records>

    </xsl:template>

</xsl:stylesheet>
