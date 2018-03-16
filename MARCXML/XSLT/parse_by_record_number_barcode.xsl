<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc xs" version="2.0">

    <!-- Last Updated: February 13, 2018 -->
    
<!--    <marc:datafield tag="049" ind1=" " ind2=" ">
        <marc:subfield code="a">FDAA-LNBKS</marc:subfield>
        <marc:subfield code="l">31254031380450</marc:subfield>
    </marc:datafield>-->

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <xsl:variable name="barcodes" select="doc('../../XSLT/tables/deleted_barcodes.xml')/records/record"/>

    <xsl:template match="/marc:collection">
        
        <marc:collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:marc="http://www.loc.gov/MARC21/slim"
            xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
            
            <xsl:for-each select="marc:record/marc:datafield[@tag = '049']/marc:subfield[@code = 'l']">
                    <xsl:choose>
                        <xsl:when
                            test="$barcodes[barcode = current()]">
                            <xsl:copy-of select="../.."/>                          
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose> 
                </xsl:for-each>
          
        </marc:collection>
        
    </xsl:template>
</xsl:stylesheet>
