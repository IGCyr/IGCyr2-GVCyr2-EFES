<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:t="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <!-- ============== run against all_inscriptions.xml ============== -->
    
    <xsl:template match="/">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Personal Names Authority list for IGCyr2/GVCyr2</title>
                    </titleStmt>
                    <publicationStmt>
                        <p/>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Generated from the tagged EpiDoc</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <listNym>
                        <xsl:variable name="nymRefs">
                        <xsl:for-each select="//t:list/t:item">
                            <xsl:variable name="filename">
                                <xsl:text>../xml/epidoc/</xsl:text>
                                <xsl:value-of select="@n"/>
                            </xsl:variable>
                                <xsl:for-each select="document($filename)//t:name/@nymRef">
                                    <xsl:value-of select="translate(., '#', '')"/><xsl:text> </xsl:text>
                                </xsl:for-each>
                            <xsl:text> </xsl:text>
                        </xsl:for-each>
                        </xsl:variable>
                        
                        <xsl:variable name="unique_nymRefs" select="distinct-values(tokenize(normalize-space($nymRefs), '\s+?'))"/>
                        
                        <xsl:variable name="sorted_nymRefs">
                            <xsl:for-each select="$unique_nymRefs">
                                <xsl:sort/><xsl:value-of select="."/>
                                <xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        
                        <xsl:for-each select="tokenize(normalize-space($sorted_nymRefs), '\s+?')">
                            <xsl:variable name="nymRef" select="."/>
                            <nym xml:id="{$nymRef}">
                                <orth><xsl:value-of select="translate($nymRef, '_', '-')"/></orth>
                            </nym>
                        </xsl:for-each>
                    </listNym>
                </body>
            </text>
        </TEI>
    </xsl:template>

</xsl:stylesheet>
