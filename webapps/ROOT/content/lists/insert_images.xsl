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
    
    <!-- to update links -->
    <!--<xsl:template match="//t:facsimile/t:graphic">
        <xsl:variable name="old-link" select="descendant::t:ref/@target/string()"/>
        <xsl:variable name="new-item" select="document('./all_images.xml')//row[old_url[.!=''] = $old-link][1]"/>
        <graphic url="{$new-item/image_link/text()}" corresp="{@corresp}" decls="{@decls}">
            <desc resp="{t:desc/@resp}" source="{t:desc/@source}" n="{t:desc/@n}">
                <ref target="{$new-item/entity_link/text()}" source="{t:desc/t:ref/@source}">
                    <xsl:value-of select="$new-item/caption"/>
                </ref>
            </desc>
        </graphic>
    </xsl:template>-->
    
    <!-- to add new images -->
    <xsl:template match="//t:facsimile[descendant::t:graphic[@url='-']]">
        <xsl:variable name="filename" select="lower-case(normalize-space(string(ancestor::t:TEI//t:idno[@type='filename'])))"/>
        <xsl:variable name="new-item" select="document('./all_images.xml')//row[id = $filename]"/>
        <xsl:element name="{local-name()}">
            <xsl:for-each select="$new-item">
                <xsl:variable name="item" select="."/>
                <graphic url="{$item/image_link/text()}">
                    <desc>
                        <ref target="{$item/entity_link/text()}">
                            <xsl:value-of select="$item/caption"/>
                        </ref>
                    </desc>
                </graphic>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <!-- ||||||||||||||||||||||   change  ||||||||||||||||||||||||| -->
    
    <xsl:template match="t:revisionDesc">
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
                    <xsl:text>inserted images links</xsl:text>
                </xsl:element>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
