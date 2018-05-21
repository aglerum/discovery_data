<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>
    <!-- 
    ORIGINAL
    <record>
      <record_number>267</record_number>
      <aleph/>
      <oclc/>
      <author>Chateaubriand, Francois Auguste Rene, vicomte de</author>
      <title>Memoires d'outre-tombe: Premiere partie-livres VIII et IX (Chateaubriand en Angleterre). Cambridge, University Press, 1920. 93p. edited, with introduction and notes, by A Hamilton Thompson. Also, Paris, Nelson, ed. 558p (?) White cloth/white buckram, orig.</title>
      <publication/>
      <extent/>
      <notes/>
   </record>
     
   PARSE DATA 1
    <record>
      <record_number>267</record_number>
      <aleph/>
      <oclc/>
      <author>Chateaubriand, Francois Auguste Rene, vicomte de</author>
      <title/>
      <publication> </publication>
      <extent>93p 558p</extent>
      <notes> </notes>
   </record>
    
    -->
    <!--    
    <xsl:for-each select="record_number">
        <xsl:value-of select="$bib_data_original[record_number=current()]/*[(self::aleph_number)]"/>
    </xsl:for-each>
    
    -->

    <!-- Generic identity template -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:variable name="bib_data_original" select="document('../XML/bib_data/bib_data_18-05-16.xml')/records/record"/>

    <xsl:template match="records">
        <records>
            <xsl:for-each select="record">                
                    <xsl:choose>
                        <xsl:when test=".[title = '']">
                            <xsl:variable name="original_title">
                                <xsl:for-each select="record_number">
                                    <xsl:value-of select="$bib_data_original[record_number = current()]/*[(self::title)]"/>
                                </xsl:for-each>
                            </xsl:variable>

                            <xsl:variable name="original_publication">
                                <xsl:for-each select="record_number">
                                    <xsl:value-of select="$bib_data_original[record_number = current()]/*[(self::title)]"/>
                                </xsl:for-each>
                            </xsl:variable>


                            <xsl:variable name="extent_string">
                                <xsl:analyze-string select="$original_title" regex="(\s{{1}}[0-9]{{1,2}}v)|(\s{{1}}[0-9]{{1,4}}p)">
                                    <xsl:matching-substring>
                                        <xsl:value-of
                                            select="
                                                if (. != '') then
                                                    .
                                                else
                                                    ''"
                                        />
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring/>
                                </xsl:analyze-string>
                            </xsl:variable>
                            <xsl:variable name="extent" select="tokenize($extent_string, ' ')[2]"/>
                            <xsl:variable name="original_notes" select="substring-after($original_title, $extent)"/>
                            <xsl:variable name="original_title_pub" select="normalize-space(substring-before($original_title, $extent))"/>
                            <xsl:variable name="original_publication" select="substring-after($original_title_pub, '.')"/>
                            <xsl:variable name="original_title"
                                select="substring-before($original_title_pub, substring-after($original_title_pub, '.'))"/>
                            <record>
                            <xsl:copy-of select="record_number"/>
                            <xsl:copy-of select="aleph"/>
                            <xsl:copy-of select="oclc"/>
                            <xsl:copy-of select="author"/>
                            <!--                    <original_title><xsl:value-of
                        select="$original_title"/></original_title>
                    <extent_string><xsl:value-of
                        select="$extent_string"/></extent_string>
                    <original_publication><xsl:value-of
                        select="$original_publication"/></original_publication>
                    <extent><xsl:value-of
                        select="$extent"/></extent>
                    <original_notes><xsl:value-of
                        select="$original_notes"/></original_notes>-->

                            <title>
                                <xsl:value-of select="replace($original_title, $extent, '')"/>
                            </title>
                            <publication>
                                <xsl:value-of
                                    select="
                                        normalize-space(if ($original_publication != '') then
                                            $original_publication
                                        else
                                            $original_publication)"
                                />
                            </publication>
                            <extent>
                                <xsl:value-of
                                    select="
                                        normalize-space(if ($extent = '') then
                                            '1 v. [1 volume?]'
                                        else
                                            $extent)"
                                />
                            </extent>
                            <notes>
                                <xsl:value-of select="
                                        normalize-space(substring($original_notes, 2))"/>
                            </notes>
                            </record>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>               
            </xsl:for-each>
        </records>
    </xsl:template>
</xsl:stylesheet>
