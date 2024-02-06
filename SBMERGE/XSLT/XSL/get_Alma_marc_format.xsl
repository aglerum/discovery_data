<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    exclude-result-prefixes="xs xd" version="2.0">

    <xsl:output method="text" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>


    <xsl:template match="/">
        <xsl:text>035&#x9;019&#x9;LDRpos6&#x9;007pos0&#x9;008form&#x9;300&#x9;336&#x9;338&#x9;533&#x9;538&#x9;776$i$w&#x9;856&#13;</xsl:text>
        <!-- Tab Delimiter -->
        <xsl:variable name="delimiter" select="'&#x9;'"/>

        <xsl:for-each select="collection/record">

            <!-- LDR -->
            <xsl:variable name="LDR">
                <xsl:value-of select="substring(leader, 7, 1)"/>
            </xsl:variable>

            <!-- 007 field -->
            <xsl:variable name="field_007">
                <xsl:for-each select="controlfield[@tag = '007']">
                    <xsl:value-of select="substring(., 1, 1)"/>
                    <xsl:text>; </xsl:text>
                </xsl:for-each>
            </xsl:variable>

            <!-- 008 form  -->
            <xsl:variable name="field_008">
                <!-- Checks the LDR to see what position the form is in -->
                <xsl:choose>
                    <xsl:when test="$LDR = 'e'">
                        <xsl:value-of select="substring(controlfield[@tag = '008'], 30, 1)"/>
                    </xsl:when>
                    <xsl:when test="$LDR = 'f'">
                        <xsl:value-of select="substring(controlfield[@tag = '008'], 30, 1)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(controlfield[@tag = '008'], 24, 1)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>


            <!-- 035 field -->
            <xsl:variable name="field_035">
                <xsl:value-of select="datafield[@tag = '035']/subfield[@code = 'a']"/>
            </xsl:variable>

            <!-- 019 field -->
            <xsl:variable name="field_019">
                <xsl:for-each select="datafield[@tag = '019']/subfield[@code = 'a']">
                    <xsl:value-of select="."/>
                    <xsl:text>; </xsl:text>
                </xsl:for-each>
            </xsl:variable>

            <!-- 300 field> -->
            <xsl:variable name="field_300">
                <xsl:value-of select="datafield[@tag = '300']"/>
            </xsl:variable>

            <!-- 336 field -->
            <xsl:variable name="field_336">
                <xsl:value-of select="datafield[@tag = '336']/subfield[@code = 'a']"/>
            </xsl:variable>

            <!-- 338 field -->
            <xsl:variable name="field_338">
                <xsl:value-of select="datafield[@tag = '338']/subfield[@code = 'a']"/>
            </xsl:variable>

            <!-- 533 field -->
            <xsl:variable name="field_533">
                <xsl:value-of select="datafield[@tag = '533']"/>
            </xsl:variable>

            <!-- 538 field -->
            <xsl:variable name="field_538">
                <xsl:value-of select="datafield[@tag = '538']"/>
            </xsl:variable>

            <!-- 776 field -->
            <xsl:variable name="field_776">
                <xsl:for-each select="datafield[@tag = '776']">
                    <xsl:value-of select="subfield[@code = 'i']"/>
                    <xsl:value-of select="subfield[@code = 'w']"/>
                    <xsl:text>; </xsl:text>
                </xsl:for-each>
            </xsl:variable>
            
            
            <!-- 856 field -->
            <xsl:variable name="field_856">
                <xsl:for-each select="datafield[@tag = '856'][@ind1='4'][@ind2='0']">
                    <xsl:value-of select="subfield[@code = 'u']"/>
                    <xsl:text>; </xsl:text>
                </xsl:for-each>
            </xsl:variable>

            <xsl:value-of
                select="concat(normalize-space($field_035), $delimiter, normalize-space($field_019), $delimiter, $LDR, $delimiter, $field_007, $delimiter, $field_008, $delimiter, normalize-space($field_300), $delimiter, normalize-space($field_336), $delimiter, normalize-space($field_338), $delimiter, normalize-space($field_533), $delimiter, normalize-space($field_538), $delimiter, $field_776, $delimiter, $field_856, '&#13;')"
            />
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
