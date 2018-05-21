<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

    <!-- Generic identity template -->
    <!--    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>-->

    <!--  tokenize($title, '\.')[2]-->

    <xsl:template match="/records">
        <records>
            <xsl:for-each select="record">
                <record>
                    <xsl:variable name="title" select="title" as="xs:string"/>
                    <xsl:variable name="note-words">
                        <xsl:analyze-string select="." regex="(\sTranslated\sfrom.*?\.)">
                            <xsl:matching-substring>
                                <xsl:value-of
                                    select="
                                        normalize-space(
                                        if (contains($title, .)) then
                                            .
                                        else
                                            ())"
                                />
                            </xsl:matching-substring>
                            <xsl:non-matching-substring/>
                        </xsl:analyze-string>
                    </xsl:variable>

                    <xsl:variable name="title-notes-at-end">
                        <xsl:variable name="title_no_note-words">
                            <xsl:value-of
                                select="
                                    if (contains($title, $note-words) and $note-words != '') then
                                        replace($title, $note-words, '')
                                    else
                                        $title"
                            />
                        </xsl:variable>
                        <xsl:value-of select="concat($title_no_note-words, ' ', $note-words)"/>
                    </xsl:variable>
                    <xsl:copy-of select="record_number"/>
                    <xsl:copy-of select="aleph"/>
                    <xsl:copy-of select="oclc"/>
                    <xsl:copy-of select="author"/>
                    <title>
                        <xsl:value-of select="normalize-space($title-notes-at-end)"/>
                    </title>
                    <xsl:copy-of select="publication"/>
                    <xsl:copy-of select="extent"/>
                    <xsl:copy-of select="notes"/>
                </record>
            </xsl:for-each>
        </records>
    </xsl:template>

</xsl:stylesheet>
