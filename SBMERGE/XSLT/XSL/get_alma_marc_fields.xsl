<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd" version="2.0">

    <xsl:output method="text" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">

        <xsl:text>IZ_MMS&#x9;NZ_MMS&#x9;OCLC&#x9;TAG&#x9;FIELD&#13;</xsl:text>

        <xsl:for-each select="collection/record/datafield[subfield[@code = '5']]">

            <!-- Double quote -->
            <xsl:variable name="quotes">
                <xsl:text>"</xsl:text>
            </xsl:variable>
            <!-- Tab Delimiter -->
            <xsl:variable name="delimiter" select="'&#x9;'"/>

            <!-- IZ MMS -->
            <xsl:variable name="IZ_MMS" select="preceding-sibling::controlfield[@tag = '001']"/>
            
            <!-- NZ MMS -->
            <xsl:variable name="NZ_MMS" select="substring-after(preceding-sibling::datafield[@tag = '035'][starts-with(subfield[@code='a'],'(EXLNZ-01FALSC_NETWORK)')],'(EXLNZ-01FALSC_NETWORK)')"/>
            
            <!-- OCLC -->
            <xsl:variable name="oclc" select="substring-after(preceding-sibling::datafield[@tag = '035'][starts-with(subfield[@code='a'],'(OCoLC)')],'(OCoLC)')"/>
            
            <!-- field -->
            <xsl:variable name="tag_name" select="@tag"/>
            <xsl:variable name="indicators" select="concat(@ind1,@ind2)"/> 
            <xsl:variable name="values">
                <xsl:for-each select="./*">
                    <xsl:variable name="code_name" select="@code"/>
                    <xsl:variable name="subfield_value" select="."/>
                    <xsl:value-of select="concat('$',$code_name,' ',$subfield_value,' ')"/>
                </xsl:for-each>
            </xsl:variable> 

            <xsl:value-of
                select="concat($IZ_MMS, $delimiter,$NZ_MMS,$delimiter,$oclc,$delimiter,$tag_name,$indicators,$delimiter,normalize-space(replace($values,$quotes,'')),'&#13;')"/>

        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
