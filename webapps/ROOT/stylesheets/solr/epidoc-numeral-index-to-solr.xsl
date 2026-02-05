<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of numerals in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <!-- to index <g> inside <num> -->
      <xsl:for-each-group select="//tei:g[@type=('acrophonic','alphabetic','papyrologic','cyrnum')][ancestor::tei:num][ancestor::tei:div/@type='edition']" group-by="concat(normalize-unicode(normalize-space(string-join(.//text(), ''))),'-',@type)">
        <xsl:variable name="numeral_type">
          <xsl:choose>
            <xsl:when test="@type='acrophonic'"><xsl:text>Acrophonic</xsl:text></xsl:when>
            <xsl:when test="@type='alphabetic'"><xsl:text>Alphabetic</xsl:text></xsl:when>
            <xsl:when test="@type='papyrologic'"><xsl:text>Papyrologic</xsl:text></xsl:when>
            <xsl:when test="@type='cyrnum'"><xsl:text>Cyrenean</xsl:text></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="normalize-unicode(normalize-space(string-join(.//text(), '')))" />
          </field>
          <field name="index_item_type">
            <xsl:value-of select="$numeral_type"/>
          </field>
          <field name="index_item_sort_name">
            <xsl:value-of select="$numeral_type"/>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
      
      <!-- to index <num> -->
      <!--<xsl:for-each-group select="//tei:num[@value or @atLeast][ancestor::tei:div/@type='edition']" group-by="concat(normalize-unicode(normalize-space(string-join(.//text(), ''))),'##',@value, @atLeast, string-join(distinct-values(descendant::tei:g[@type=('acrophonic','alphabetic','papyrologic','cyrnum')]/@type), ', '))">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="normalize-unicode(normalize-space(string-join(.//text(), '')))" />
          </field>
          <field name="index_item_type">
              <xsl:if test="descendant::tei:g[@type=('acrophonic','alphabetic','papyrologic','cyrnum')]">
                <xsl:value-of select="string-join(distinct-values(descendant::tei:g[@type=('acrophonic','alphabetic','papyrologic','cyrnum')]/@type), ', ')"/>
              </xsl:if>
          </field>
          <field name="index_numeral_value">
            <xsl:choose>
              <xsl:when test="@value">
                <xsl:value-of select="@value"/>
              </xsl:when>
              <xsl:when test="@atLeast">
                <xsl:value-of select="concat('At least ', @atLeast)"/>
              </xsl:when>
            </xsl:choose>
          </field>
          <field name="index_item_sort_name">
            <xsl:value-of select="string-join(distinct-values(descendant::tei:g[@type=('acrophonic','alphabetic','papyrologic','cyrnum')]/@type), ', ')"/>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>-->
    </add>
  </xsl:template>

  <xsl:template match="tei:num|tei:g[ancestor::tei:num]">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
