<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd" version="2.0">

    <xsl:output method="text" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Last updated: </xd:b>October 2, 2021</xd:p>
            <xd:p><xd:b>Based on </xd:b>ybp2dsv.xsl</xd:p>
            <xd:p><xd:b>Author: </xd:b>Annie Glerum</xd:p>
            <xd:p><xd:b>Organization: </xd:b>Florida State University Libraries</xd:p>
            <xd:p><xd:b>Title: </xd:b>Quality check report for vendor-supplied MARC records: DSV Version</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="/">
        <xsl:text>Batch|Flag|OCLC|Title|Details&#13;</xsl:text>
        <xsl:for-each select="collection/record">
            <!-- ***Global variables*** -->
            <!-- Batch date -->
            <!-- Enter the batch name in this Format: GOBI-FIRM_UPDATE_11150708 or GOBI-APPROVAL_ap19150729 where the numbers are the name of the original file-->
            <xsl:variable name="batch">
                <xsl:value-of select="'GOBI-APPROVAL_ap21210916'"/>
            </xsl:variable>

            <!-- Encoding Variable -->
            <xsl:variable name="encoding" select="substring(leader, 18, 1)"/>

            <!-- Variables for eBooks -->
            <xsl:variable name="characteristics">
                <xsl:for-each select="controlfield[@tag = '007']">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rdaMediaA" select="datafield[@tag = '337']/subfield[@code = 'a']"/>
            <xsl:variable name="rdaMediaB" select="datafield[@tag = '337']/subfield[@code = 'b']"/>
            <xsl:variable name="rdaCarrierA" select="datafield[@tag = '338']/subfield[@code = 'a']"/>
            <xsl:variable name="rdaCarrierB" select="datafield[@tag = '338']/subfield[@code = 'b']"/>
            <xsl:variable name="form" select="substring(controlfield[@tag = '008']/subfield[@code = 'a'], 24, 1)"/>
            <xsl:variable name="titleH" select="datafield[@tag = '245']/subfield[@code = 'h']"/>

            <!-- ISBN fields -->
            <xsl:variable name="isbn">
                <xsl:value-of select="datafield[@tag = '020']"/>
            </xsl:variable>
            <xsl:variable name="isbnA">
                <xsl:value-of select="datafield[@tag = '020']/subfield[@code = 'a']"/>
            </xsl:variable>
            <xsl:variable name="isbnQ">
                <xsl:value-of select="datafield[@tag = '020']/subfield[@code = 'q']"/>
            </xsl:variable>
            <xsl:variable name="isbnZ">
                <xsl:value-of select="datafield[@tag = '020']/subfield[@code = 'z']"/>
            </xsl:variable>

            <!-- OCLC number -->
            <xsl:variable name="oclc">
                <xsl:value-of select="datafield[@tag = '035']/subfield[@code = 'a'][starts-with(.,'(OCoLC)') and not(starts-with(.,'(OCoLC)o'))]"/>
            </xsl:variable>

            <!-- Title and responsibility-->
            <xsl:variable name="title" select="datafield[@tag = '245']/*"/>

            <!-- Extent Variable -->
            <xsl:variable name="extent">
                <xsl:value-of select="datafield[@tag = '300']"/>
            </xsl:variable>

            <!-- Series Statement variables -->
            <xsl:variable name="series490">
                <xsl:value-of select="datafield[@tag = '490']"/>
            </xsl:variable>
            <xsl:variable name="series490_count" as="xs:integer">
                <xsl:value-of select="count(datafield[@tag = '490'])"/>
            </xsl:variable>
            <xsl:variable name="series490Ind1">
                <xsl:value-of select="datafield[@tag = '490']/@ind1"/>
            </xsl:variable>

            <!-- ***Recieved full or Provisional Plus*** -->
            <!-- Full level records -->
            <xsl:choose>
                <xsl:when test="
                        not($encoding = ' '
                        or $encoding = '4'
                        or $encoding = '1'
                        or $encoding = 'I'
                        or $encoding = 'L')
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-ENCODING'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('Encoding level: ', $encoding)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>

                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- YBP Enhanced -->
            <xsl:variable name="sourceA">
                <xsl:value-of select="datafield[@tag = '040']/subfield[@code = 'a']"/>
            </xsl:variable>

            <xsl:variable name="sourceD">
                <xsl:value-of select="datafield[@tag = '040']/subfield[@code = 'd']"/>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="
                        contains($sourceA, 'NhCcYBP') or contains($sourceD, 'NhCcYBP')
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-NhCcYBP'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="normalize-space(concat('Cataloging Source. Subfield A: ', $sourceA, ' SubfieldD: ', $sourceD))"/>
                    </xsl:variable>

                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>

                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Provisional Plus -->
            <xsl:variable name="control-001" select="controlfield[@tag = '001']"/>
            <xsl:choose>
                <xsl:when test="
                        contains($control-001, 'ybpprov')
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-ybpprov'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('Control Field 001: ', $control-001)"/>
                    </xsl:variable>

                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>


            <!-- ***YBP Enhancement Check*** -->
            <!-- CIP: ELvl 8 records without numbers in extent -->
            <xsl:choose>
                <xsl:when test="
                        $encoding = '8'
                        and not(matches(datafield[@tag = '300']/subfield[@code = 'a'], '[0-9]'))
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'EDIT-CIP'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('Extent: ', $extent)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- CallNo: Records with no call numbers or have call number without Cutter number -->
            <xsl:variable name="call050">
                <xsl:value-of select="datafield[@tag = '050']/subfield[@code = 'a']"/>
            </xsl:variable>
            <xsl:variable name="call090">
                <xsl:value-of select="datafield[@tag = '090']/subfield[@code = 'a']"/>
            </xsl:variable>
            <xsl:variable name="call050B">
                <xsl:value-of select="datafield[@tag = '050']/subfield[@code = 'b']"/>
            </xsl:variable>
            <xsl:variable name="call090B">
                <xsl:value-of select="datafield[@tag = '090']/subfield[@code = 'b']"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="
                        (not($call050
                        or $call090))
                        or
                        (not($call050B
                        or $call090B))
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-CallNo'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('050: ', $call050, $call050B, ' 090: ', $call090, $call090B)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Checks for two 050 fields -->
            <xsl:variable name="call050-1">
                <xsl:value-of select="datafield[@tag = '050'][1]"/>
            </xsl:variable>
            <xsl:variable name="call050-2">
                <xsl:value-of select="datafield[@tag = '050'][2]"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="
                        count(datafield[@tag = '050']) = 2
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-Multi050'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('050-1: ', $call050-1, ' 050-2: ', $call050-2)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- ***Checklists for possible errors -->

            <xsl:for-each select="datafield[@tag = '020']/subfield[@code = 'a']">
                <xsl:choose>
                    <xsl:when test="
                            (contains(subfield[@code = 'a'], '(') and subfield[@code = 'a'][not(following-sibling::subfield[@code = 'q'])])
                            and
                            (
                            not(contains($isbnA, 'paperback')
                            or contains($isbnA, 'hardcover')
                            or contains($isbnA, 'pbk')
                            or contains($isbnA, 'Pbk')
                            or contains($isbnA, 'pb')
                            or contains($isbnA, 'paper')
                            or contains($isbnA, 'Paper')
                            or contains($isbnA, 'hardbound')
                            or contains($isbnA, 'hardcover')
                            or contains($isbnA, 'hard cover')
                            or contains($isbnA, 'hardback')
                            or contains($isbnA, 'cloth')
                            or contains($isbnA, 'cl.')
                            or contains($isbnA, 'bound')
                            or contains($isbnA, 'hbk')
                            or contains($isbnA, 'Hhbk')
                            or contains($isbnA, 'hb')
                            or contains($isbnA, 'hc')
                            or contains($isbnA, 'HB')
                            or contains($isbnA, 'hdb.')
                            or contains($isbnA, 'hd.bd.')
                            or contains($isbnA, 'trade'))
                            )">
                        <!-- Batch is global variable -->
                        <xsl:variable name="flag">
                            <xsl:value-of select="'EDIT-ISBN_20a-to-q'"/>
                        </xsl:variable>
                        <xsl:variable name="this_oclc">
                            <xsl:value-of select="$oclc"/>
                        </xsl:variable>
                        <xsl:variable name="this_title">
                            <xsl:value-of select="$title"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of select="normalize-space(concat('020a: ', $isbnA))"/>
                        </xsl:variable>
                        <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>

            <!-- ISBN for e-books: Flags records with 020 fields that might be for ebooks -->
            <xsl:for-each select="datafield[@tag = '020']/subfield[@code = 'a']">

                <xsl:choose>
                    <xsl:when test="
                            (subfield[@code = 'a'] and datafield[@tag = '020']/subfield[@code = 'a'][not(following-sibling::subfield[@code = 'q'])])
                            and
                            not(contains($isbnQ, 'paperback')
                            or contains($isbnQ, 'hardcover')
                            or contains($isbnQ, 'pbk')
                            or contains($isbnQ, 'Pbk')
                            or contains($isbnQ, 'pb')
                            or contains($isbnQ, 'paper')
                            or contains($isbnQ, 'Paper')
                            or contains($isbnQ, 'hardbound')
                            or contains($isbnQ, 'hardcover')
                            or contains($isbnQ, 'hard cover')
                            or contains($isbnQ, 'hardback')
                            or contains($isbnQ, 'cloth')
                            or contains($isbnQ, 'cl.')
                            or contains($isbnQ, 'bound')
                            or contains($isbnQ, 'hbk')
                            or contains($isbnQ, 'Hhbk')
                            or contains($isbnQ, 'hb')
                            or contains($isbnQ, 'hc')
                            or contains($isbnQ, 'HB')
                            or contains($isbnQ, 'hdb.')
                            or contains($isbnQ, 'hd.bd.')
                            or contains($isbnQ, 'trade'))
                            ">
                        <!-- Batch is global variable -->
                        <xsl:variable name="flag">
                            <xsl:value-of select="'EDIT-ISBN_020q-to-z'"/>
                        </xsl:variable>
                        <xsl:variable name="this_oclc">
                            <xsl:value-of select="$oclc"/>
                        </xsl:variable>
                        <xsl:variable name="this_title">
                            <xsl:value-of select="$title"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of select="normalize-space(concat('020a: ', $isbnQ))"/>
                        </xsl:variable>
                        <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>

            <!-- Geo: Records with 043 but no 651 or 6xx $z; 651 or 6xx $z but no 043 -->
            <xsl:variable name="geoCode">
                <xsl:value-of select="datafield[@tag = '043']/*"/>
            </xsl:variable>
            <xsl:variable name="geoHdg">
                <xsl:value-of select="datafield[@tag = '651'][@ind1 = ' '][@ind2 = '0']"/>
            </xsl:variable>
            <xsl:variable name="geoHdgA">
                <xsl:value-of select="datafield[@tag = '651'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'a']"/>
            </xsl:variable>
            <xsl:variable name="geoHdgNameZ">
                <xsl:value-of select="datafield[@tag = '600'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z']"/>
            </xsl:variable>
            <xsl:variable name="geoHdgCorpZ">
                <xsl:value-of select="datafield[@tag = '610'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z']"/>
            </xsl:variable>
            <xsl:variable name="geoHdgMtgZ">
                <xsl:value-of select="datafield[@tag = '611'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z']"/>
            </xsl:variable>
            <xsl:variable name="geoHdgTopicZ">
                <xsl:value-of select="datafield[@tag = '650'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z']"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="
                        ((datafield[@tag = '651'][@ind1 = ' '][@ind2 = '0']
                        or datafield[@tag = '600'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z']
                        or datafield[@tag = '610'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z']
                        or datafield[@tag = '611'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z']
                        or datafield[@tag = '650'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z'])
                        and not(datafield[@tag = '043']))
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'EDIT-Geo'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="
                                concat('Geo Code: ', $geoCode, ' -- ', 'GeoHeadings: ', $geoHdgA, ' ; ', $geoHdgNameZ, ' ; ', $geoHdgCorpZ, ' ; ', $geoHdgMtgZ, ' ; ', $geoHdgTopicZ)
                                "/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Checks for incorrect 245 indicators -->
            <xsl:variable name="titleInd1" select="datafield[@tag = '245'][ind = '1']"/>
            <xsl:variable name="titleInd2" select="datafield[@tag = '245'][ind = '2']"/>
            <!-- Check 245 ind1 -->
            <xsl:choose>
                <xsl:when test="
                        ($titleInd1 eq '0' and datafield[@tag = '100'] or datafield[@tag = '110'] or datafield[@tag = '111'] or datafield[@tag = '130'])
                        or ($titleInd1 eq '1' and not(datafield[@tag = '100'] or datafield[@tag = '110'] or datafield[@tag = '111'] or datafield[@tag = '130']))">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'EDIT-245Ind1'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('245 Ind1: ', $titleInd1)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Check 245 ind2 for English articles -->
            <xsl:variable name="titleA">
                <xsl:value-of select="datafield[@tag = '264']/subfield[code = 'a']"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when
                    test="(starts-with($titleA, 'The ') and $titleInd2 ne '4') or (starts-with($titleA, 'An ') and $titleInd2 ne '3') or (starts-with($titleA, 'A ') and $titleInd2 ne '2')">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'EDIT-245Ind2'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('245 Ind2: ', $titleInd1, ' Title: ', $titleA)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Check 264 for missing ©  -->
            <xsl:variable name="copyright">
                <xsl:value-of select="datafield[@tag = '264'][ind = '4']"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="datafield[@tag = '264'][ind = '4'] and not(starts-with(., '©') or starts-with(., 'copyright'))">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'EDIT-264-missing-©'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('264_4: ', $copyright)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- SeriesObsolete: Generates list of records with 4401 fields to change to 490 ind1=1/830 pairs-->
            <xsl:choose>
                <xsl:when test="
                        datafield[@tag = '440']
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'EDIT-440'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('Series, obsolete field: ', string(datafield[@tag = '440']))"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Series490-untraced: Generates list of records with 490 Ind1=0 field to change to 490 ind1=1/830 pairs-->
            <xsl:if test="$series490_count eq 1">
                <xsl:choose>
                    <xsl:when test="
                            $series490Ind1 = '0'
                            ">
                        <!-- Batch is global variable -->
                        <xsl:variable name="flag">
                            <xsl:value-of select="'EDIT-Series490-untraced'"/>
                        </xsl:variable>
                        <xsl:variable name="this_oclc">
                            <xsl:value-of select="$oclc"/>
                        </xsl:variable>
                        <xsl:variable name="this_title">
                            <xsl:value-of select="$title"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of select="concat('Series statement (untraced): ', $series490)"/>
                        </xsl:variable>
                        <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:if>

            <!-- Series490-traced: Generates list of records with 490 Ind1=1 field to check for analysis and tracing -->
            <xsl:if test="$series490_count eq 1">
                <xsl:choose>
                    <xsl:when test="
                            $series490Ind1 = '0'
                            ">
                        <!-- Batch is global variable -->
                        <xsl:variable name="flag">
                            <xsl:value-of select="'EDIT-Series490-traced'"/>
                        </xsl:variable>
                        <xsl:variable name="this_oclc">
                            <xsl:value-of select="$oclc"/>
                        </xsl:variable>
                        <xsl:variable name="this_title">
                            <xsl:value-of select="$title"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of select="concat('Series statement (traced): ', $series490)"/>
                        </xsl:variable>
                        <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:if>

            <!-- Multiple 490 fields: Generates list of records with 490 to review manually -->

            <xsl:choose>
                <xsl:when test="
                        $series490_count > 1
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-MultipleSeries490'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="'Check Bib record'"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Contents: Records with contents notes containing "/" that are not coded 505 00 -->
            <xsl:variable name="contentsNote">
                <xsl:for-each select=".">
                    <xsl:value-of select="datafield[@tag = '505']/subfield[@code = 'a']"/>
                </xsl:for-each>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="
                        datafield[@tag = '505'][@ind1] != '0'
                        and contains($contentsNote, ' / ')
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'EDIT-Contents'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="'Edit bib record'"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Sets-Title: Generates checklist of possible set records based on title -->
            <!-- This conditional brings up too many false hits: matches($titleOnly, '[0-9]')-->
            <xsl:variable name="titleA">
                <xsl:value-of select="datafield[@tag = '245']/subfield[@code = 'a']"/>
            </xsl:variable>
            <xsl:variable name="titleB">
                <xsl:value-of select="datafield[@tag = '245']/subfield[@code = 'b']"/>
            </xsl:variable>
            <xsl:variable name="titleOnly">
                <xsl:value-of select="concat($titleA, $titleB)"/>
            </xsl:variable>
            <xsl:variable name="titleP">
                <xsl:value-of select="datafield[@tag = '245']/subfield[@code = 'p']"/>
            </xsl:variable>
            <xsl:variable name="titleN">
                <xsl:value-of select="datafield[@tag = '245']/subfield[@code = 'n']"/>
            </xsl:variable>
            <xsl:for-each select="datafield[@tag = '245']">
                <xsl:choose>
                    <xsl:when test="
                            not(datafield[@tag = '993']) and
                            (contains($titleOnly, ' volume ')
                            or contains($titleOnly, ' vol. ')
                            or contains($titleOnly, ' v. ')
                            or contains($titleOnly, ' part ')
                            or contains($titleOnly, ' pt. ')
                            or contains($titleOnly, ' number ')
                            or contains($titleOnly, ' no. ')
                            or contains($titleOnly, ' tome ')
                            or contains($titleOnly, ' t. ')
                            or contains($titleOnly, ' Volume ')
                            or contains($titleOnly, ' Vol. ')
                            or contains($titleOnly, ' V. ')
                            or contains($titleOnly, ' Part ')
                            or contains($titleOnly, ' Pt. ')
                            or contains($titleOnly, ' Number ')
                            or contains($titleOnly, ' No. ')
                            or contains($titleOnly, ' Tome ')
                            or contains($titleOnly, ' T. ')
                            or datafield[@tag = '245']/subfield[@code = 'p']
                            or datafield[@tag = '245']/subfield[@code = 'n'])
                            ">
                        <!-- Batch is global variable -->
                        <xsl:variable name="flag">
                            <xsl:value-of select="'CHECK-Sets-Title'"/>
                        </xsl:variable>
                        <xsl:variable name="this_oclc">
                            <xsl:value-of select="$oclc"/>
                        </xsl:variable>
                        <xsl:variable name="this_title">
                            <xsl:value-of select="$title"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of select="concat('Part number:', $titleN, ' -- ', 'Part Title:', $titleP)"/>
                        </xsl:variable>
                        <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>

            <!-- Sets-993: Generates checklist of possible set records based on presence of 993 field -->
            <xsl:if test="datafield[@tag = '993']">
                <xsl:for-each select="datafield[@tag = '993']">
                    <xsl:variable name="set993">
                        <xsl:value-of select="./*"/>
                    </xsl:variable>
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-Sets-993'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('993: ', $set993)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:for-each>
            </xsl:if>

            <!-- Sets-ISBN: Generates checklist of possible set records based on ISBN qualifiers -->
            <xsl:if test="not(datafield[@tag = '993'])">
                <xsl:for-each select="datafield[@tag = '020'][subfield[@code = 'a'] and not(subfield[@code = 'q'])]">
                    <xsl:choose>
                        <xsl:when test="
                                contains(., ' (')
                                and
                                (contains(upper-case($isbnA), 'SET') or contains(upper-case($isbnA), '(V')
                                )
                                ">
                            <!-- Batch is global variable -->
                            <xsl:variable name="flag">
                                <xsl:value-of select="'CHECK-Sets-ISBN_020A'"/>
                            </xsl:variable>
                            <xsl:variable name="this_oclc">
                                <xsl:value-of select="$oclc"/>
                            </xsl:variable>
                            <xsl:variable name="this_title">
                                <xsl:value-of select="$title"/>
                            </xsl:variable>
                            <xsl:variable name="details">
                                <xsl:value-of select="concat('ISBN:', $isbnA)"/>
                            </xsl:variable>
                            <xsl:value-of
                                select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>

            <!-- Sets-ISBN: Generates checklist of possible set records based on ISBN qualifiers -->
            <xsl:if test="not(datafield[@tag = '993'])">
                <xsl:for-each select="datafield[@tag = '020'][subfield[@code = 'a'] and subfield[@code = 'q']]">
                    <xsl:choose>
                        <xsl:when test="
                                contains(upper-case($isbnQ), 'SET') or contains(upper-case($isbnQ), '(V')
                                ">
                            <!-- Batch is global variable -->
                            <xsl:variable name="flag">
                                <xsl:value-of select="'CHECK-Sets-ISBN_020Q'"/>
                            </xsl:variable>
                            <xsl:variable name="this_oclc">
                                <xsl:value-of select="$oclc"/>
                            </xsl:variable>
                            <xsl:variable name="this_title">
                                <xsl:value-of select="$title"/>
                            </xsl:variable>
                            <xsl:variable name="details">
                                <xsl:value-of select="concat('ISBN:', $isbnA, 'Qualifier:', $isbnQ)"/>
                            </xsl:variable>
                            <xsl:value-of
                                select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>

            <!-- 300$e: Flags records with accompanying materials to check if they may need to be processed separated -->
            <xsl:variable name="accomp">
                <xsl:value-of select="datafield[@tag = '300']/subfield[@code = 'e']"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="datafield[@tag = '300']/subfield[@code = 'e']">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-300$e'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('Accompanying:', $accomp)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- NonPrint: Generates checklist of possible non-print records -->
            <xsl:choose>
                <xsl:when test="
                        not(datafield[@tag = '300']/subfield[@code = 'e'])
                        and
                        ($titleH
                        or starts-with($characteristics, 'c')
                        or starts-with($characteristics, 'd')
                        or starts-with($characteristics, 'o')
                        or starts-with($characteristics, 'a')
                        or starts-with($characteristics, 'h')
                        or starts-with($characteristics, 'm')
                        or starts-with($characteristics, 'k')
                        or starts-with($characteristics, 'q')
                        or starts-with($characteristics, 'g')
                        or starts-with($characteristics, 'r')
                        or starts-with($characteristics, 's')
                        or starts-with($characteristics, 'f')
                        or starts-with($characteristics, 'z')
                        or starts-with($characteristics, 'v')
                        or $rdaMediaA != 'unmediated'
                        or $rdaMediaB != 'n'
                        or $rdaCarrierA != 'volume'
                        or $rdaCarrierB != 'nc'
                        or $form = 'a'
                        or $form = 'b'
                        or $form = 'c'
                        or $form = 'd'
                        or $form = 'f'
                        or $form = 'o'
                        or $form = 'q'
                        or $form = 's')
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-NonPrint'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="'Check Bib record'"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- URL: Checks for URL  coding-->
            <xsl:variable name="url" select="datafield[@tag = '856']"/>
            <xsl:variable name="url1">
                <xsl:value-of select="$url[@ind = '1']"/>
            </xsl:variable>
            <xsl:variable name="url2">
                <xsl:value-of select="$url[@ind = '2']"/>
            </xsl:variable>

            <xsl:variable name="urlU">
                <xsl:value-of select="datafield[@tag = '856']/subfield[@code = 'u']"/>
            </xsl:variable>
            <xsl:variable name="urlY">
                <xsl:value-of select="datafield[@tag = '856']/subfield[@code = 'u']"/>
            </xsl:variable>
            <xsl:variable name="urlZ">
                <xsl:value-of select="datafield[@tag = '856']/subfield[@code = 'u']"/>
            </xsl:variable>
            <xsl:variable name="url3">
                <xsl:value-of select="datafield[@tag = '856']/subfield[@code = 'u']"/>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="
                        $url[@ind = '1'] != '4'
                        or $url[@ind = '2'] != ' '
                        or ($url[@ind = '1'] = '4' and $url[@ind = '2'] != ' ')
                        or ($url[@ind = '1'] = '4' and $url[@ind = '2'] != '0')
                        or ($url[@ind = '1'] = '4' and ($url[@ind = '2'] != '1' and contains($url3, 'contents')))
                        or ($url[@ind = '1'] = '4' and ($url[@ind = '2'] != '1' and contains($url3, 'Contents')))
                        or ($url[@ind = '1'] = '4' and ($url[@ind = '2'] != '1' and contains($url3, 'Inhaltsverzeichnis')))
                        or ($url[@ind = '1'] = '4' and ($url[@ind = '2'] != '2' and contains($urlZ, 'Inhaltsverzeichnis')))
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-URL-Coding'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('Ind1:', $url1, ' ; ', 'Ind2:', $url2, ' ; ', '$3: ', $url3, '$3: ', $urlY, '$z: ', $urlZ)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- URL: Checks for known inaccessible URLS (example: http://www.ilibri.casalini.it/toc) -->
            <xsl:variable name="url">
                <xsl:value-of select="datafield[@tag = '856']/subfield[@code = 'u']"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="starts-with($url, 'http://www.ilibri.casalini.it/toc')">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-URL-Access'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="'CHeck Bib record'"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Multiple 049: Checks for multiple 049 fields for multivolume sets -->
            <xsl:variable name="Hol049">
                <xsl:value-of select="datafield[@tag = '049']"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="count($Hol049) gt 1">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'CHECK-Multiple-049'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="$title"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('Number of 049 fields: ', count($Hol049))"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($batch, '|', $flag, '|', $this_oclc, '|', normalize-space($this_title), '|', $details, '&#13;')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
