<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc xs" version="2.0">

        <!-- Last Updated: March 10, 2018 -->

        <xsl:output indent="yes" method="xml"/>
        <xsl:strip-space elements="*"/>


        <xsl:template match="node() | @*">
                <xsl:copy>
                        <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
        </xsl:template>

        <!--<xsl:template match="/marc:collection/marc:record/marc:datafield[@tag = '050' or @tag = '090' or @tag = '099']"/>-->
        <!--<xsl:template match="/marc:collection/marc:record[not(marc:datafield[@tag = '952'])]"/>-->
        <xsl:template match="/marc:collection/marc:record/marc:datafield[@tag = '245']/marc:subfield[@code = 'h']"/>
</xsl:stylesheet>
