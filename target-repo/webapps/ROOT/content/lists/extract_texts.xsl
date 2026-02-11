<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:t="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:template name="ignore" match="t:TEI//t:teiHeader |t:TEI//t:div[not(@type='translation')] |t:TEI//t:div[@type='translation'][not(@xml:lang='en')]|t:TEI//t:facsimile"></xsl:template>
    <xsl:template match="t:TEI//t:div[@type='translation'][@xml:lang='en']">
<?xml-model href="http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng" schematypens="http://relaxng.org/ns/structure/1.0"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0">
    <teiHeader xml:lang="en">
        <fileDesc>
            <titleStmt>
                <title></title>
            </titleStmt>
            <sourceDesc>
                <msDesc>
                    <msIdentifier>
                        <altIdentifier>
                            <idno type="uri"/>
                        </altIdentifier>
                    </msIdentifier>
                </msDesc>
            </sourceDesc>
        </fileDesc>
    </teiHeader>
    <text>
        <body>
            <div type="translation">
                <xsl:value-of select="."/>
            </div>
        </body>
    </text>
</TEI>
</xsl:template>
</xsl:stylesheet>