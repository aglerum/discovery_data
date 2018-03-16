<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:fsul="http://www.lib.fsu.edu" exclude-result-prefixes="fsul marc xs" version="2.0">

    <!-- Last updated: March 11, 2018 -->

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <!--    @param $string is string to process  -->
    <xsl:function name="fsul:strip-punct">
        <xsl:param name="string" as="xs:string"/>
        <xsl:value-of
            select="
                normalize-space(
                if (ends-with($string, '.') or ends-with($string, ',') or ends-with($string, ':') or ends-with($string, ';') or ends-with($string, '.')) then
                    (substring($string, 1, (string-length($string) - 1)))
                else
                    $string
                )"
        />
    </xsl:function>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Better method would have been to strip the punctuation from the end of each subfeild string and then add depending on the situation.-->

    <!-- 
      
     Normal order, not ISBD
     
     <marc:datafield tag="260" ind1=" " ind2=" ">
        <marc:subfield code="a">Culver City, CA</marc:subfield>
        <marc:subfield code="b">Columbia TriStar Home Entertainment</marc:subfield>
        <marc:subfield code="c">2003</marc:subfield>
     </marc:datafield>
      
      Missing $c
      
      <marc:datafield tag="260" ind1=" " ind2=" ">
         <marc:subfield code="a">London</marc:subfield>
         <marc:subfield code="b">Vintage</marc:subfield>
      </marc:datafield>
      
      These were reviewed and or fixed first. Exclude from this transformation.
      
      Out of Order Subfields
    
      <marc:datafield tag="260" ind1=" " ind2=" ">
         <marc:subfield code="a">London</marc:subfield>
         <marc:subfield code="c">2001</marc:subfield>
         <marc:subfield code="b">London Topographical Society</marc:subfield>
      </marc:datafield>
      
      Missing $b has $a and $c - 
      
      <marc:datafield tag="260" ind1=" " ind2=" ">
         <marc:subfield code="a">United Kingdom</marc:subfield>
         <marc:subfield code="c">3 April 2010</marc:subfield>
      </marc:datafield>
      
     Missing $a 
     <marc:datafield tag="260" ind1=" " ind2=" ">
         <marc:subfield code="b">Universal</marc:subfield>
         <marc:subfield code="c">2009.</marc:subfield>
      </marc:datafield>
      
      Missing $a & $b 
      
      <marc:datafield tag="260" ind1=" " ind2=" ">
         <marc:subfield code="c">2001.</marc:subfield>
      </marc:datafield>
    
    -->

    <xsl:template match="/*/*/marc:datafield[@tag = '260']">
        <xsl:variable name="subfieldA">
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </xsl:variable>
        <xsl:variable name="subfieldB">
            <xsl:value-of select="marc:subfield[@code = 'b']"/>
        </xsl:variable>
        <xsl:variable name="subfieldC">
            <xsl:value-of select="marc:subfield[@code = 'c']"/>
        </xsl:variable>
        <xsl:variable name="subfieldA_string">
            <xsl:value-of select="fsul:strip-punct($subfieldA)"/>
        </xsl:variable>
        <xsl:variable name="subfieldB_string">
            <xsl:value-of select="fsul:strip-punct($subfieldB)"/>
        </xsl:variable>

        <marc:datafield tag="260" ind1=" " ind2=" ">
            <!-- Use count to skip fields with more than one $a -->
            <xsl:if test="marc:subfield[@code = 'a']">
                <xsl:choose>
                    <xsl:when test="count(marc:subfield[@code = 'a']) eq 1">
                        <!-- Choose punctuation for $a -->
                        <marc:subfield code="a">
                            <xsl:choose>
                                <!-- If $a and $b -->
                                <xsl:when test="marc:subfield[@code = 'a'] and marc:subfield[@code = 'b']">
                                    <xsl:value-of select="concat($subfieldA_string, ' :')"/>
                                </xsl:when>
                                <!-- If $a and $c but not $b -->
                                <xsl:when test="marc:subfield[@code = 'a'] and not(marc:subfield[@code = 'b']) and marc:subfield[@code = 'c']">
                                    <xsl:value-of select="concat($subfieldA_string, ',')"/>
                                </xsl:when>
                                <!-- If $a only -->
                                <xsl:when test="marc:subfield[@code = 'a'] and not(marc:subfield[@code = 'b']) and not(marc:subfield[@code = 'c'])">
                                    <xsl:value-of select="concat($subfieldA_string, '.')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$subfieldA"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </marc:subfield>
                    </xsl:when>
                    <xsl:when test="count(marc:subfield[@code = 'a']) gt 1">
                        <xsl:copy-of select="marc:subfield[@code = 'a']"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <!-- Choose punctuation for $b -->
            <xsl:if test="marc:subfield[@code = 'b']">
                <xsl:choose>
                    <xsl:when test="count(marc:subfield[@code = 'b']) eq 1">
                        <marc:subfield code="b">
                            <xsl:choose>
                                <!-- If $b and $c-->
                                <xsl:when test="marc:subfield[@code = 'b'] and marc:subfield[@code = 'c']">
                                    <xsl:value-of select="concat($subfieldB_string, ',')"/>
                                </xsl:when>
                                <!-- If $b but not $c -->
                                <xsl:when test="marc:subfield[@code = 'b'] and not(marc:subfield[@code = 'c'])">
                                    <xsl:value-of select="concat($subfieldB_string, '.')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$subfieldB"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </marc:subfield>
                    </xsl:when>
                    <xsl:when test="count(marc:subfield[@code = 'b']) gt 1">
                        <xsl:copy-of select="marc:subfield[@code = 'b']"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <!-- Choose punctuation for $c. Not this does not fix $c ending with ' .' - That was not an issue with the London 20181-01 set. -->
            <xsl:if test="marc:subfield[@code = 'c']">
                <marc:subfield code="c">
                    <xsl:choose>
                        <xsl:when test="ends-with($subfieldC, '.') or ends-with($subfieldC, ']') or ends-with($subfieldC, '-')">
                            <xsl:value-of select="$subfieldC"/>
                        </xsl:when>
                        <xsl:when test="not(ends-with($subfieldC, '.')) or not(ends-with($subfieldC, ']')) or not(ends-with($subfieldC, '-'))">
                            <xsl:value-of select="concat($subfieldC, '.')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$subfieldC"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </marc:subfield>
            </xsl:if>
        </marc:datafield>
    </xsl:template>

</xsl:stylesheet>
