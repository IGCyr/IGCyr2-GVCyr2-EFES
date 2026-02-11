<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
  version="2.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of symbols in those
       documents. -->
  
  <xsl:import href="epidoc-index-utils.xsl" />
  
  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />
  
  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:measure[@type='volume']|//tei:measure[@type='weight']" group-by="concat(normalize-unicode(normalize-space(string-join(., ''))), '-', normalize-unicode(@type), '-', normalize-unicode(@unit))">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:choose>
              <xsl:when test="normalize-space(string-join(., ''))!=''">
                <xsl:value-of select="normalize-unicode(normalize-space(string-join(., '')))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>?</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_item_type">
            <xsl:value-of select="concat(upper-case(substring(normalize-unicode(@type), 1, 1)), substring(normalize-unicode(@type), 2))"/>
            <xsl:if test="@unit"><xsl:value-of select="concat(': ', normalize-unicode(@unit))"/></xsl:if>
          </field>
          <field name="index_item_sort_name">
            <xsl:value-of select="concat(@type,'-',@unit)"/>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>
  
  <xsl:template match="tei:measure[@type='volume']|tei:measure[@type='weight']">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>
  
</xsl:stylesheet>