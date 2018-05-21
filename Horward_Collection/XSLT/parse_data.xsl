<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

    <!-- 
        <record>
        <record_number> </record_number>
      <aleph> </aleph>
      <oclc> </oclc>
      <author>Barante, Amable Guillaume Prosper Brugiere, baron de</author>
      <title>Histoire du directoire de la Republique francaise. Paris, Didier, 1855. 3v. Blue leather binding-Almeida.</title>
      <publication> </publication>
      <extent> </extent>
      <notes> </notes>
   </record>-->

    <xsl:template match="records">
        <records>
            <xsl:for-each select="record">
                <xsl:variable name="extent">
                    <xsl:analyze-string select="title" regex="(\s{{1}}[0-9]{{1,2}}v)|(\s{{1}}[0-9]{{1,4}}p)">
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
                <xsl:variable name="notes"
                    select="
                    if ($extent != '') then
                    substring-after(title, $extent)
                    else
                    ''"/>
                <xsl:variable name="title_pub" select="normalize-space(substring-before(title, $extent))"/>
                <xsl:variable name="publication" select="substring-after($title_pub, '.')"/>
                <xsl:variable name="title" select="substring-before($title_pub, substring-after($title_pub, '.'))"/>

                <record>
                    
                    <!-- Variable Test -->
<!--                    <extent><xsl:value-of select="$extent"/></extent>
                    <notes><xsl:value-of select="if (starts-with($notes,'. ')) then substring($notes,3) else $notes"/></notes>
                    <title_pub><xsl:value-of select="$title_pub"/></title_pub>
                    <title><xsl:value-of select="$title"/></title>-->
                    
                    <xsl:copy-of select="record_number"/>
                    <xsl:copy-of select="aleph"/>
                        <xsl:copy-of select="oclc"/>
                    <xsl:copy-of select="author"/>
                    <title>
                        <xsl:value-of
                            select="
                            normalize-space(if ($extent = '') then
                                   concat('FIX: ', title)
                                else
                                    $title)"/>
                    </title>
                    <publication>
                        <xsl:value-of
                            select="
                                normalize-space($publication)"
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
                        <xsl:value-of select="normalize-space(if (starts-with($notes,'. ')) then substring($notes,3) else $notes)"/>
                    </notes>
                </record>
            </xsl:for-each>
        </records>
    </xsl:template>
</xsl:stylesheet>
