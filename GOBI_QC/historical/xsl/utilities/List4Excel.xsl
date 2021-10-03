<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Last updated:</xd:b> November 13, 2015</xd:p>
            <xd:p><xd:b>Author:</xd:b> Annie Glerum</xd:p>
            <xd:p><xd:b>Organization:</xd:b> Florida State University Libraries</xd:p>
            <xd:p><xd:b>Title:</xd:b> Generic list of MARC elements</xd:p>
            <xd:p>Run this transfomation on a collection of MARC record then run XML2Excel on the
                result of this transformation.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="/">
        <root>


            <!-- **Variables** -->
            <!-- Control field 001 -->
            <xsl:variable name="controlfield001">
                <xsl:value-of select="marc:controlfield[@tag='001']"/>
            </xsl:variable>
            <!-- OCLC number -->
            <xsl:variable name="oclc">
                <xsl:choose>
                    <xsl:when test="
                        starts-with($controlfield001, 'ocn')">
                        <xsl:value-of
                            select="normalize-space(substring-after($controlfield001, 'ocn'))"/>
                    </xsl:when>
                    <xsl:when test="
                        starts-with($controlfield001, 'ocm')">
                        <xsl:value-of
                            select="normalize-space(substring-after($controlfield001, 'ocm'))"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>

            <!-- Encoding Level -->
            <xsl:variable name="encoding" select="substring(marc:leader,18,1)"/>

            <!-- ISBN1 -->
            <xsl:variable name="ISBN">
                <xsl:value-of select="marc:datafield[@tag='020'][1]/marc:subfield[@code='a']"/>
            </xsl:variable>

            <!-- Title -->
            <xsl:variable name="title">
                <xsl:for-each select="marc:datafield[@tag='245']">
                <xsl:choose>
                    <xsl:when test="count(marc:subfield[@code='b']) eq 1">
                        <xsl:value-of
                            select="if (marc:subfield[@code='b']) then concat(marc:subfield[@code='a'], ' ',marc:subfield[@code='b']) else (marc:subfield[@code='a'])"
                        />
                    </xsl:when>
                    <xsl:when test="count(./marc:subfield[@code='b']) gt 1">
                        <xsl:value-of select="./marc:subfield[@code='a']"/>
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="marc:subfield[@code='b']">
                            <xsl:value-of select=".[1]"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select=".[2]"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="marc:subfield[@code='a']"/>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:for-each>

            </xsl:variable>
            <!-- **List** -->
            <rows>
                <column>
                    <xsl:value-of select="$encoding"/>
                </column>
                <column>
                    <xsl:value-of select="$ISBN"/>
                </column>
                <column>
                    <xsl:value-of select="$controlfield001"/>
                </column>
                <column>
                    <xsl:value-of
                        select="if (ends-with($title,' ')) then substring($title, 1, string-length($title) - 1) else $title"
                    />
                </column>
            </rows>
        </root>
    </xsl:template>

</xsl:stylesheet>
