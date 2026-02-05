<?xml version="1.0"?>

<!-- XSLT to insert images from all_images.xml -->

<!-- |||||||||||||||  run against files inside webapps/ROOT/content/xml/epidoc |||||||||||||| -->
<!--  ||||||||||||||  NB do it without an internet connection, otherwise some unwanted attributes will be added, among which @default="false", @part="N",  @instant="false", @status="draft", @full="yes", @org="uniform", @sample="complete" |||||||||||||| -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:date="http://exslt.org/dates-and-times" >
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
    
    <!-- ||||||||||||||||||||||  copy all existing elements, comments  |||||||||||||||| -->
    
    <xsl:template match="t:*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="//comment()">
        <xsl:copy>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="//processing-instruction()">
        <xsl:text>
</xsl:text>
        <xsl:copy>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>    
    
    <xsl:template match="t:TEI">
        <xsl:text>
</xsl:text>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <!-- ||||||||||||||||||||||   images  ||||||||||||||||||||||||| -->
    
    <xsl:template match="//t:desc[ancestor::t:graphic]">
        <xsl:variable name="imageID" select="descendant::t:ref/@target"/>
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="resp" select="document('./images_extra_data.xml')//graphic[descendant::ref[.=$imageID]][1]/author"/>
            <xsl:attribute name="source" select="document('./images_extra_data.xml')//graphic[descendant::ref[.=$imageID]][1]/repository"/>
            <xsl:attribute name="n" select="document('./images_extra_data.xml')//graphic[descendant::ref[.=$imageID]][1]/date"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- ||||||||||||||||||||||   change  ||||||||||||||||||||||||| -->
    
    <!--<xsl:template match="t:revisionDesc">
        <xsl:element name="{local-name()}">
            <xsl:if test="//t:facsimile">
                <xsl:text>
         </xsl:text>
                <xsl:element name="change">
                    <xsl:attribute name="when">
                        <xsl:value-of select="substring(date:date(),1,10)"/>
                    </xsl:attribute>
                    <xsl:attribute name="who">
                        <xsl:text>IV</xsl:text>
                    </xsl:attribute>
                    <xsl:text>inserted images</xsl:text>
                </xsl:element>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>-->
    
</xsl:stylesheet>
