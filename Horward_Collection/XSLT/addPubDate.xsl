<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:function name="fsul:strip-punct">
        <xsl:param name="string" as="xs:string"/>
        <xsl:analyze-string select="$string" regex="\.">
            <xsl:matching-substring/>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>


    <xsl:template match="/records">
        <records>
            <xsl:for-each select="record/publication">
                <xsl:variable name="date1">
                    <xsl:choose>
                        <xsl:when test="matches(.,'\s?\[?[0-9]{4}\-\s?\[?([0-9]{4})\.?\]?\s?')">
                            <xsl:analyze-string select="." regex="(\s?\[?[0-9]{{4}})\-(\s?\[?([0-9]{{4}})\.?\]?\s?)">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring/>
                        </xsl:analyze-string>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:analyze-string select="." regex="\s?\[?([0-9]{{4}})\.?\]?\s?">
                                <xsl:matching-substring>
                                    <xsl:value-of select="."/>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring/>
                            </xsl:analyze-string>
                        </xsl:otherwise>
                    </xsl:choose>
                   
                    
                </xsl:variable>
                <xsl:variable name="date2">
                    <xsl:analyze-string select="." regex="(\s?\[?[0-9]{{4}})\-(\s?\[?([0-9]{{4}})\.?\]?\s?)">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(2)"/>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring/>
                        </xsl:analyze-string>
                    
                </xsl:variable>
                <record>
                    <xsl:copy-of select="preceding-sibling::*[position() lt 7]"/>
                    <xsl:copy-of select="."/>
                    <year1>
                        <xsl:value-of select="normalize-space(replace(replace(replace(replace($date1,'\-',''),'\]',''),'\[',''),'\.',''))"/>
                    </year1>
                    <year2>
                        <xsl:value-of select="normalize-space(replace(replace(replace(replace($date2,'\-',''),'\]',''),'\[',''),'\.',''))"/>
                    </year2>
                    <xsl:copy-of select="following-sibling::extent"/>
                    <xsl:copy-of select="following-sibling::notes"/>
                </record>
            </xsl:for-each>
        </records>
    </xsl:template>

</xsl:stylesheet>
