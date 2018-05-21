<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Need to fix $numbers path -->
    
    <xsl:variable name="numbers" select="document('../XML/bib_data/record-aleph.xml')/numbers/number"/>

    <xsl:template match="/records">
        <records>
            <xsl:for-each select="record"> 
                <xsl:variable name="aleph">
                    <xsl:for-each select="record_number">
                        <xsl:value-of select="$numbers[record_number=current()]/*[(self::aleph_number)]"/>
                    </xsl:for-each>
                </xsl:variable>
                <record>                
                    <xsl:copy-of select="record_number"/>
                    <aleph>
                        <xsl:value-of select="$aleph"/>
                    </aleph>
                <xsl:copy-of select="*[position() gt 2]"/>
                </record>
            </xsl:for-each>
        </records>           
    </xsl:template>

</xsl:stylesheet>
