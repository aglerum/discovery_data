<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fsul="http://www.lib.fsu.edu"
    exclude-result-prefixes="fsul xs" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>


    <xsl:template match="/collection">
        <records>
            <xsl:for-each select="record">
                <record>
                    <record_number/>
                    <aleph>
                        <xsl:value-of select="controlfield[@tag = '001']"/>
                    </aleph>
                    <oclc>
                        <xsl:value-of
                            select="
                                if (datafield[@tag = '035']/subfield[@code = 'a'][starts-with(., '(OCo')]) then
                                    datafield[@tag = '035']/subfield[@code = 'a'][starts-with(., '(OCo')]
                                else
                                    'No OCLC'"
                        />
                    </oclc>
                    <author>
                        <xsl:value-of
                            select="
                                if (datafield[@tag = '100']) then
                                    datafield[@tag = '100']/subfield[@code = 'a']
                                else
                                    'No author'"
                        />
                    </author>
                    <title>
                        <xsl:value-of
                            select="normalize-space(concat(datafield[@tag = '245']/subfield[@code = 'a'], ' ', datafield[@tag = '245']/subfield[@code = 'b']))"
                        />
                    </title>
                    <titleNormal/>
                    <titleKeyword/>
                    <publication>
                        <xsl:if test="datafield[@tag = '260']">
                            <xsl:variable name="PubA">
                                <xsl:value-of
                                    select="string-join(datafield[@tag = '260']/subfield[@code = 'a'], ' ')"
                                />
                            </xsl:variable>
                            <xsl:variable name="PubB">
                                <xsl:value-of
                                    select="
                                        string-join(if (datafield[@tag = '260']/subfield[@code = 'b']) then
                                            datafield[@tag = '260']/subfield[@code = 'b']
                                        else
                                            (), ' ')"
                                />
                            </xsl:variable>
                            <xsl:variable name="PubC">
                                <xsl:value-of
                                    select="
                                        string-join(if (datafield[@tag = '260']/subfield[@code = 'c']) then
                                            datafield[@tag = '260']/subfield[@code = 'c']
                                        else
                                            (), ' ')"
                                />
                            </xsl:variable>
                            <xsl:value-of
                                select="
                                    concat($PubA, ' ', $PubB, ' ', $PubC)"
                            />
                        </xsl:if>

                        <xsl:if test="datafield[@tag = '264']">
                            <xsl:variable name="PubA">
                                <xsl:value-of
                                    select="string-join(datafield[@tag = '264']/subfield[@code = 'a'], ' ')"
                                />
                            </xsl:variable>
                            <xsl:variable name="PubB">
                                <xsl:value-of
                                    select="
                                    string-join(if (datafield[@tag = '264']/subfield[@code = 'b']) then
                                    datafield[@tag = '264']/subfield[@code = 'b']
                                    else
                                    (), ' ')"
                                />
                            </xsl:variable>
                            <xsl:variable name="PubC">
                                <xsl:value-of
                                    select="
                                    string-join(if (datafield[@tag = '264']/subfield[@code = 'c']) then
                                    datafield[@tag = '264']/subfield[@code = 'c']
                                    else
                                    (), ' ')"
                                />
                            </xsl:variable>
                            <xsl:value-of
                                select="
                                concat($PubA, ' ', $PubB, ' ', $PubC)"
                            />
                        </xsl:if>
                    </publication>
                    <year1>
                        <xsl:value-of select="substring(controlfield[@tag = '008'], 8, 4)"/>
                    </year1>
                    <year2/>
                    <extent>
                        <xsl:value-of select="datafield[@tag = '300']/subfield[@code = 'a']"/>
                    </extent>
                    <notes>
                        <xsl:for-each select="datafield[@tag = '500']">
                            <xsl:for-each select="subfield[@code = 'a']">
                                <xsl:value-of select="concat(., ' ')"/>
                            </xsl:for-each>
                        </xsl:for-each>
                    </notes>
                    <cat_note/>
                </record>
            </xsl:for-each>
        </records>
    </xsl:template>
</xsl:stylesheet>
