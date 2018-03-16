<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="marc xd xs" version="2.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Last updated: </xd:b>February 1, 2018</xd:p>
            <xd:p><xd:b>Author: </xd:b>Annie Glerum</xd:p>
            <xd:p><xd:b>Organization: </xd:b>Florida State University Libraries</xd:p>
            <xd:p><xd:b>Title: </xd:b>Parse MARCXML by Record Number</xd:p>
            <xd:p>For processing Koha records provided by the London Study Center.</xd:p>
            <xd:p>Run first on the new batch varibale with the deleted batch variable commented out. Then run on the deleted batch variable with the new batch variable commented out.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <!-- Run with this variable on the new batch (i.e. the 2018-01 file) -->
    <!--    <xsl:variable name="numbers" select="doc('tables/London_records_added_2018-01.xml')/numbers"/>-->

    <!-- Run with this variable on the previous batch (i.e. the 2014 file) -->
    <xsl:variable name="numbers" select="doc('tables/London_records_deleted_2018-01.xml')/numbers"/>

    <xsl:template match="/marc:collection">

        <marc:collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:marc="http://www.loc.gov/MARC21/slim"
            xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">

            <xsl:for-each select="marc:record">
                <xsl:choose>
                    <xsl:when test="$numbers[number = current()/marc:datafield[@tag = '999']/marc:subfield[@code = 'c']]">
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
        </marc:collection>

    </xsl:template>
</xsl:stylesheet>
