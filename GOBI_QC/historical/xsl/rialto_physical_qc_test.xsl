<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd" version="2.0">

    <xsl:output method="text" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Last updated: </xd:b>December 4, 2021</xd:p>
            <xd:p><xd:b>Author: </xd:b>Annie Glerum</xd:p>
            <xd:p><xd:b>Organization: </xd:b>Florida State University Libraries</xd:p>
            <xd:p><xd:b>Title: </xd:b>Quality check report for vendor-supplied MARC records: TSV
                Version</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="/">
        <xsl:variable name="batch">
            <!--<xsl:value-of select="'GOBI Approval_Imported_20211106'"/>-->
            <xsl:value-of
                select="substring-before(substring-after(document-uri(.), 'file:/Users/annieglerum/Documents/GOBI_QC_local/XML/Current_Batch/'), '.xml')"
            />
        </xsl:variable>
        <xsl:text>Batch&#x9;Flag&#x9;MMS&#x9;OCLC&#x9;Details&#x9;Title&#13;</xsl:text>
        <xsl:for-each select="collection/record">
            <!-- ***Global variables*** -->
            <!-- Delimiter -->
            <xsl:variable name="delimiter" select="'&#x9;'"/>
            <!-- Batch date -->

            <!-- MMS -->
            <xsl:variable name="mms" select="controlfield[@tag = '001']"/>

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
            <xsl:variable name="form"
                select="substring(controlfield[@tag = '008']/subfield[@code = 'a'], 24, 1)"/>
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
                <xsl:value-of
                    select="datafield[@tag = '035']/subfield[@code = 'a'][starts-with(., '(OCoLC)') and not(starts-with(., '(OCoLC)o'))]"
                />
            </xsl:variable>

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
                <xsl:when
                    test="
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
                        <xsl:value-of select="datafield[@tag = '245']/*"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('Encoding level: ', $encoding)"/>
                    </xsl:variable>
                    <xsl:value-of
                        select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"/>

                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- CIP: ELvl 8 records without numbers in extent -->
            <xsl:choose>
                <xsl:when
                    test="
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
                        <xsl:value-of select="datafield[@tag = '245']/*"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('Extent: ', $extent)"/>
                    </xsl:variable>
                    <xsl:value-of
                        select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                    />
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>


            <!-- OCLC Check: records without OCLC numbers will be flagged -->
            <xsl:choose>
                <xsl:when
                    test="not(datafield[@tag = '035']/subfield[@code = 'a'][starts-with(., '(OCoLC)') or (starts-with(., '(OCoLC)o'))])">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'Find OCLC'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="datafield[@tag = '245']/*"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="'Bib has no OCLC num'"/>
                    </xsl:variable>
                    <xsl:value-of
                        select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                    />
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- CallNo: Records with no call numbers or have call number without Cutter number -->
            <xsl:for-each select="datafield[@tag = '050']">
                <xsl:variable name="call050">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </xsl:variable>
                <xsl:variable name="call090">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </xsl:variable>
                <xsl:variable name="call050B">
                    <xsl:value-of select="subfield[@code = 'b']"/>
                </xsl:variable>
                <xsl:variable name="call090B">
                    <xsl:value-of select="subfield[@code = 'b']"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when
                        test="
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
                            <xsl:value-of select="datafield[@tag = '245']/*"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of
                                select="concat('050: ', $call050, $call050B, ' 090: ', $call090, $call090B)"
                            />
                        </xsl:variable>
                        <xsl:value-of
                            select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>

            <!-- Checks for fields with $5 -->
            <xsl:for-each
                select="datafield[subfield[@code = '5']]">
                <xsl:variable name="tag">
                    <xsl:value-of select="@tag"/>
                </xsl:variable>
                <!-- Batch is global variable -->
                <xsl:variable name="flag">
                    <xsl:value-of select="'Has_$5'"/>
                </xsl:variable>
                <xsl:variable name="this_oclc">
                    <xsl:value-of select="$oclc"/>
                </xsl:variable>
                <xsl:variable name="this_title">
                    <xsl:value-of select="datafield[@tag = '245']/*"/>
                </xsl:variable>
                <xsl:variable name="details">
                    <xsl:for-each select=".">
                        <xsl:value-of select="normalize-space(concat('Field with $5 :', $tag))"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:value-of
                    select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                />
            </xsl:for-each>
            
            <!-- Checks for two 050 fields -->
            <xsl:variable name="call050-1">
                <xsl:value-of select="datafield[@tag = '050'][1]"/>
            </xsl:variable>
            <xsl:variable name="call050-2">
                <xsl:value-of select="datafield[@tag = '050'][2]"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when
                    test="
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
                        <xsl:value-of select="datafield[@tag = '245']/*"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('050-1: ', $call050-1, ' 050-2: ', $call050-2)"
                        />
                    </xsl:variable>
                    <xsl:value-of
                        select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                    />
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- ***Checklists for possible errors -->
            <!-- ISBN for e-books: Flags records with 020 fields without $q that might be for ebooks -->
            <xsl:for-each
                select="
                    datafield[@tag = '020']/subfield[@code = 'a'][contains(., '(') and (contains(upper-case(.), 'ELECTRONIC')
                    or contains(upper-case(.), 'EBOOK')
                    or contains(upper-case(.), 'MOBI')
                    or contains(upper-case(.), 'PDF')
                    or contains(upper-case(.), 'EPUB'))]">
                <!-- Batch is global variable -->
                <xsl:variable name="flag">
                    <xsl:value-of select="'EDIT-ISBN_20a-to-z'"/>
                </xsl:variable>
                <xsl:variable name="this_oclc">
                    <xsl:value-of select="$oclc"/>
                </xsl:variable>
                <xsl:variable name="this_title">
                    <xsl:value-of select="datafield[@tag = '245']/*"/>
                </xsl:variable>
                <xsl:variable name="details">
                    <xsl:for-each select=".">
                        <xsl:value-of select="normalize-space(concat('020a: ', .))"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:value-of
                    select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                />
            </xsl:for-each>

            <!-- ISBN for e-books: Flags records with 020 fields with $q that might be for ebooks -->
            <xsl:for-each
                select="
                    datafield[@tag = '020'][subfield[@code = 'a']/subfield[@code = 'q'][
                    contains(upper-case(.), 'ELECTRONIC')
                    or contains(upper-case(.), 'EBOOK')
                    or contains(upper-case(.), 'MOBI')
                    or contains(upper-case(.), 'PDF')
                    or contains(upper-case(.), 'EPUB')]]">

                <!-- Batch is global variable -->
                <xsl:variable name="flag">
                    <xsl:value-of select="'EDIT-ISBN_020aq-to-z'"/>
                </xsl:variable>
                <xsl:variable name="this_oclc">
                    <xsl:value-of select="$oclc"/>
                </xsl:variable>
                <xsl:variable name="this_title">
                    <xsl:value-of select="datafield[@tag = '245']/*"/>
                </xsl:variable>
                <xsl:variable name="details">
                    <xsl:value-of
                        select="normalize-space(concat('020a: ', preceding-sibling::subfield[@code = 'a'], ' 020q: ', .))"
                    />
                </xsl:variable>
                <xsl:value-of
                    select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                />
            </xsl:for-each>

            <!-- Checks for incorrect 100 indicators -->
            <xsl:for-each select="datafield[@tag = '100']">
                <xsl:variable name="authorInd1" select="@ind1"/>
                <xsl:variable name="authorInd2" select="@ind2"/>
                <!-- Check 100 indicators -->
                <xsl:choose>
                    <xsl:when
                        test="
                            not(($authorInd1 = '0' or $authorInd1 = '1' or $authorInd1 = '3') or $authorInd2 = '')">
                        <!-- Batch is global variable -->
                        <xsl:variable name="flag">
                            <xsl:value-of select="'CHECK-100-INDICATOR'"/>
                        </xsl:variable>
                        <xsl:variable name="this_oclc">
                            <xsl:value-of select="$oclc"/>
                        </xsl:variable>
                        <xsl:variable name="this_title">
                            <xsl:value-of select="datafield[@tag = '245']/*"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of
                                select="concat('Ind1: ', $authorInd1, ', Ind2: ', $authorInd2)"/>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>

            <!-- Geo: Records with 651 or 6xx $z but no 043 -->
            <xsl:choose>
                <xsl:when
                    test="
                        (datafield[@tag = '651'][@ind1 = ' '][@ind2 = '0']
                        or datafield[@tag = '600'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z']
                        or datafield[@tag = '610'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z']
                        or datafield[@tag = '611'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z']
                        or datafield[@tag = '650'][@ind1 = ' '][@ind2 = '0']/subfield[@code = 'z'])
                        and not(datafield[@tag = '043'])
                        ">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'EDIT-Geo'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="datafield[@tag = '245']/*"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="'No Geo Code; Check Bib Record for Geo Headings'"/>
                    </xsl:variable>
                    <xsl:value-of
                        select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                    />
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Check 245 ind1 -->
            <xsl:choose>
                <xsl:when
                    test="
                        ((datafield[@tag = '245'][@ind1 = '0'] and (datafield[@tag = '100'] or datafield[@tag = '110'] or datafield[@tag = '130']))
                        or (datafield[@tag = '245'][@ind1 = '1'] and not(datafield[@tag = '100'] or datafield[@tag = '110'] or datafield[@tag = '130'])))">
                    <!-- Batch is global variable -->
                    <xsl:variable name="flag">
                        <xsl:value-of select="'EDIT-245Ind1'"/>
                    </xsl:variable>
                    <xsl:variable name="this_oclc">
                        <xsl:value-of select="$oclc"/>
                    </xsl:variable>
                    <xsl:variable name="this_title">
                        <xsl:value-of select="datafield[@tag = '245']/*"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="concat('245 Ind1: ', datafield[@tag = '245']/[@ind1])"
                        />
                    </xsl:variable>
                    <xsl:value-of
                        select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                    />
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Check 245 ind2 for English articles -->
            <xsl:for-each select="datafield[@tag = '245']">
                <xsl:variable name="titleA" select="subfield[@code = 'a']"/>
                <xsl:variable name="titleInd2" select="@ind2"/>
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
                            <xsl:value-of select="datafield[@tag = '245']/*"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of
                                select="concat('245 Ind2: ', $titleInd2, ' Title: ', $titleA)"/>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>

            <!-- Check 264 for missing ©  -->
            <xsl:for-each select="datafield[@tag = '264'][@ind2 = '4']">
                <xsl:variable name="copyright" select="subfield[@code = 'c']"/>
                <xsl:choose>
                    <xsl:when
                        test="(not(starts-with($copyright, '©')) or starts-with($copyright, 'copyright'))">

                        <!-- Batch is global variable -->
                        <xsl:variable name="flag">
                            <xsl:value-of select="'EDIT-264-missing-©'"/>
                        </xsl:variable>
                        <xsl:variable name="this_oclc">
                            <xsl:value-of select="$oclc"/>
                        </xsl:variable>
                        <xsl:variable name="this_title">
                            <xsl:value-of select="datafield[@tag = '245']/*"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of select="$copyright"/>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>

            <!-- SeriesObsolete: Generates list of records with 4401 fields to change to 490 ind1=1/830 pairs-->
            <xsl:for-each select="datafield[@tag = '440']">
                <!-- Batch is global variable -->
                <xsl:variable name="flag">
                    <xsl:value-of select="'EDIT-440'"/>
                </xsl:variable>
                <xsl:variable name="this_oclc">
                    <xsl:value-of select="$oclc"/>
                </xsl:variable>
                <xsl:variable name="this_title">
                    <xsl:value-of select="datafield[@tag = '245']/*"/>
                </xsl:variable>
                <xsl:variable name="details">
                    <xsl:value-of select="concat('Series, obsolete field: ', string(.))"/>
                </xsl:variable>
                <xsl:value-of
                    select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                />
            </xsl:for-each>

            <!-- Series490-untraced: Generates list of records with 490 Ind1=0 field to change to 490 ind1=1/830 pairs-->
            <xsl:for-each select="datafield[@tag = '490'][@ind1 = '0']">
                <!-- Batch is global variable -->
                <xsl:variable name="flag">
                    <xsl:value-of select="'EDIT-Series490-untraced'"/>
                </xsl:variable>
                <xsl:variable name="this_oclc">
                    <xsl:value-of select="$oclc"/>
                </xsl:variable>
                <xsl:variable name="this_title">
                    <xsl:value-of select="datafield[@tag = '245']/*"/>
                </xsl:variable>
                <xsl:variable name="details">
                    <xsl:value-of
                        select="concat('Series statement (untraced): ', normalize-space(.))"/>
                </xsl:variable>
                <xsl:value-of
                    select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                />
            </xsl:for-each>

            <!-- Series490-traced: Generates list of records with 490 Ind1=1 field to check for analysis and tracing -->
            <xsl:for-each select="datafield[@tag = '490'][@ind1 = '1']">
                <!-- Batch is global variable -->
                <xsl:variable name="flag">
                    <xsl:value-of select="'CHECK-Series490-traced'"/>
                </xsl:variable>
                <xsl:variable name="this_oclc">
                    <xsl:value-of select="$oclc"/>
                </xsl:variable>
                <xsl:variable name="this_title">
                    <xsl:value-of select="datafield[@tag = '245']/*"/>
                </xsl:variable>
                <xsl:variable name="details">
                    <xsl:value-of select="concat('Series statement (traced): ', normalize-space(.))"
                    />
                </xsl:variable>
                <xsl:value-of
                    select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                />
            </xsl:for-each>

            <!-- Multiple 490 fields: Generates list of records with 490 to review manually -->

            <xsl:choose>
                <xsl:when
                    test="
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
                        <xsl:value-of select="datafield[@tag = '245']/*"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="'Check Bib record'"/>
                    </xsl:variable>
                    <xsl:value-of
                        select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                    />
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- Contents: Records with contents notes containing "/" that are not coded 505 00 -->
            <xsl:for-each select="datafield[@tag = '505']">
                <xsl:choose>
                    <xsl:when
                        test="
                            @ind1 != '0'
                            and contains(subfield[@code = 'a'], ' / ')
                            ">
                        <!-- Batch is global variable -->
                        <xsl:variable name="flag">
                            <xsl:value-of select="'EDIT-Contents'"/>
                        </xsl:variable>
                        <xsl:variable name="this_oclc">
                            <xsl:value-of select="$oclc"/>
                        </xsl:variable>
                        <xsl:variable name="this_title">
                            <xsl:value-of select="datafield[@tag = '245']/*"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of select="'Enhance Contents Field'"/>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>

            <!-- Sets-Title: Generates checklist of possible set records based on title -->
            <xsl:if test="not(datafield[@tag = '993'])">
                <xsl:for-each select="datafield[@tag = '245']">
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
                    <xsl:choose>
                        <xsl:when
                            test="
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
                                <xsl:value-of select="datafield[@tag = '245']/*"/>
                            </xsl:variable>
                            <xsl:variable name="details">
                                <xsl:value-of
                                    select="concat('Part number:', $titleN, ' -- ', 'Part Title:', $titleP)"
                                />
                            </xsl:variable>
                            <xsl:value-of
                                select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                            />
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>

            <!-- Sets-ISBN: Generates checklist of possible set records based on ISBN qualifiers -->
            <xsl:if test="not(datafield[@tag = '993'])">
                <xsl:for-each
                    select="datafield[@tag = '020'][subfield[@code = 'a'] and not(subfield[@code = 'q'])]">
                    <xsl:choose>
                        <xsl:when
                            test="
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
                                <xsl:value-of select="datafield[@tag = '245']/*"/>
                            </xsl:variable>
                            <xsl:variable name="details">
                                <xsl:value-of select="concat('ISBN:', $isbnA)"/>
                            </xsl:variable>
                            <xsl:value-of
                                select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                            />
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>

            <!-- Sets-ISBN: Generates checklist of possible set records based on ISBN qualifiers -->
            <xsl:if test="not(datafield[@tag = '993'])">
                <xsl:for-each
                    select="datafield[@tag = '020'][subfield[@code = 'a'] and subfield[@code = 'q']]">
                    <xsl:choose>
                        <xsl:when
                            test="
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
                                <xsl:value-of select="datafield[@tag = '245']/*"/>
                            </xsl:variable>
                            <xsl:variable name="details">
                                <xsl:value-of select="concat('ISBN:', $isbnA, 'Qualifier:', $isbnQ)"
                                />
                            </xsl:variable>
                            <xsl:value-of
                                select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                            />
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>

            <!-- Sets-993: Generates checklist of possible set records based on presence of 993 field -->
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
                    <xsl:value-of select="datafield[@tag = '245']/*"/>
                </xsl:variable>
                <xsl:variable name="details">
                    <xsl:value-of select="concat('993: ', $set993)"/>
                </xsl:variable>
                <xsl:value-of
                    select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                />
            </xsl:for-each>

            <!-- 300$e: Flags records with accompanying materials to check if they may need to be processed separated -->
            <xsl:for-each select="datafield[@tag = '300']/subfield[@code = 'e']">
                <!-- Batch is global variable -->
                <xsl:variable name="flag">
                    <xsl:value-of select="'CHECK-300$e'"/>
                </xsl:variable>
                <xsl:variable name="this_oclc">
                    <xsl:value-of select="$oclc"/>
                </xsl:variable>
                <xsl:variable name="this_title">
                    <xsl:value-of select="datafield[@tag = '245']/*"/>
                </xsl:variable>
                <xsl:variable name="details">
                    <xsl:value-of select="concat('Accompanying:', normalize-space(.))"/>
                </xsl:variable>
                <xsl:value-of
                    select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                />
            </xsl:for-each>

            <!-- NonPrint: Generates checklist of possible non-print records -->
            <xsl:choose>
                <xsl:when
                    test="
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
                        <xsl:value-of select="datafield[@tag = '245']/*"/>
                    </xsl:variable>
                    <xsl:variable name="details">
                        <xsl:value-of select="'Check Bib record'"/>
                    </xsl:variable>
                    <xsl:value-of
                        select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                    />
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>

            <!-- URL: Checks for URL  coding-->

            <xsl:for-each select="datafield[@tag = '856']">
                <xsl:choose>
                    <xsl:when
                        test="
                            (@ind1 = '4' and @ind2 = '0')
                            ">
                        <!-- Batch is global variable -->
                        <xsl:variable name="flag">
                            <xsl:value-of select="'CHECK-URL'"/>
                        </xsl:variable>
                        <xsl:variable name="this_oclc">
                            <xsl:value-of select="$oclc"/>
                        </xsl:variable>
                        <xsl:variable name="this_title">
                            <xsl:value-of select="datafield[@tag = '245']/*"/>
                        </xsl:variable>
                        <xsl:variable name="details">
                            <xsl:value-of select="subfield[@code = 'u']"/>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                        />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>


            <!-- URL: Checks for known inaccessible URLS (example: http://www.ilibri.casalini.it/toc) -->
            <xsl:for-each
                select="datafield[@tag = '856'][starts-with(subfield[@code = 'u'], 'http://www.ilibri.casalini.it/toc')]">
                <!-- Batch is global variable -->
                <xsl:variable name="flag">
                    <xsl:value-of select="'CHECK-URL-Access'"/>
                </xsl:variable>
                <xsl:variable name="this_oclc">
                    <xsl:value-of select="$oclc"/>
                </xsl:variable>
                <xsl:variable name="this_title">
                    <xsl:value-of select="datafield[@tag = '245']/*"/>
                </xsl:variable>
                <xsl:variable name="details">
                    <xsl:value-of select="subfield[@code = 'u']"/>
                </xsl:variable>
                <xsl:value-of
                    select="concat($batch, $delimiter, $flag, $delimiter, $mms, $delimiter, $this_oclc, $delimiter, $details, $delimiter, normalize-space($this_title), '&#13;')"
                />
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
