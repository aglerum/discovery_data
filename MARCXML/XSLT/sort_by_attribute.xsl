<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc xs" version="2.0">
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
        <xsl:template match="@* | node()">
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
        </xsl:template>
        
    <xsl:template match="marc:collection/marc:record">       
            <xsl:copy>
                <xsl:apply-templates select="marc:leader"/>
                <xsl:apply-templates select="marc:controlfield"> 
                    <xsl:sort select="@tag" order="ascending"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="marc:datafield">
                    <xsl:sort select="@tag" order="ascending"/>
                </xsl:apply-templates>
            </xsl:copy>           
        </xsl:template>
    
</xsl:stylesheet>