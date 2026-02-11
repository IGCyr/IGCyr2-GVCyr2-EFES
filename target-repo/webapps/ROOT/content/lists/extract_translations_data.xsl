<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:t="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <!-- ============== run against all_inscriptions.xml ============== -->
    
    <xsl:template match="/">
        <body>
                <xsl:for-each select="//t:list/t:item">
                <xsl:variable name="filename">
                    <xsl:text>../xml/epidoc/html/</xsl:text>
                    <xsl:value-of select="replace(@n, '.xml', '.html')"/>
                </xsl:variable>
                    <xsl:for-each select="document($filename)//html">
                        <filename><xsl:value-of select="$filename"/></filename>
                        <text><xsl:copy-of select="//div[@class='section-container tabs']/section[1]/div[1]/div[@id='edition']"/></text>
                        <translations><xsl:copy-of select="//div[@id='translation']"/></translations>
                    </xsl:for-each>
                </xsl:for-each>
        </body>
    </xsl:template>

</xsl:stylesheet>
