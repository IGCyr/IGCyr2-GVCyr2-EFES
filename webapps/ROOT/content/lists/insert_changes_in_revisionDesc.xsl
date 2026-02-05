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
    
    <xsl:template match="//t:revisionDesc">
        <xsl:variable name="fileNumber" select="lower-case(ancestor::t:teiHeader//t:idno[@type='filename'][1])"/>
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:if test="document('./changes_in_revisionDesc.xml')//item[descendant::file[.=$fileNumber]][descendant::content[.='file updated']]">
                <xsl:variable name="changeItem" select="document('./changes_in_revisionDesc.xml')//item[descendant::file[.=$fileNumber]][descendant::content[.='file updated']]"/>
                <xsl:if test="not(descendant::t:change[@when=$changeItem/when and upper-case(@who)=$changeItem/who])">
                <xsl:text>
                </xsl:text>
                <xsl:element name="change">
                    <xsl:attribute name="when" select="$changeItem/when"/>
                    <xsl:attribute name="who" select="$changeItem/who"/>
                    <xsl:value-of select="$changeItem/content"/>
                </xsl:element>
                </xsl:if>
            </xsl:if>
            <xsl:if test="document('./changes_in_revisionDesc.xml')//item[descendant::file[.=$fileNumber]][descendant::content[.='file created']]">
                <xsl:variable name="changeItem" select="document('./changes_in_revisionDesc.xml')//item[descendant::file[.=$fileNumber]][descendant::content[.='file created']]"/>
                <xsl:if test="not(descendant::t:change[@when=$changeItem/when and upper-case(@who)=$changeItem/who])">
                <xsl:text>
                </xsl:text>
                <xsl:element name="change">
                    <xsl:attribute name="when" select="$changeItem/when"/>
                    <xsl:attribute name="who" select="$changeItem/who"/>
                    <xsl:value-of select="$changeItem/content"/>
                </xsl:element>
                </xsl:if>
            </xsl:if>
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
