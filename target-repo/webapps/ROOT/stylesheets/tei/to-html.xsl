<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">

  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->

  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl" />
  
  <xsl:template priority="100" match="*[@xml:lang!=$language]"/>
  
  <xsl:template match="//tei:div[@type='bibliography'][@xml:id='imported-biblio-al']">
    <xsl:apply-templates select="document(concat('file:',system-property('user.dir'), '/webapps/ROOT/content/xml/authority/bibliography.xml'))//tei:div[@type='bibliography']"/>
  </xsl:template>
  
  <!--<xsl:template match="//tei:bibl[not(ancestor::tei:bibl)]">
    <p id="{@xml:id}">
      <xsl:if test="ancestor::tei:div[@xml:id='series_collections']"><b><i><xsl:value-of select="@xml:id"/></i></b><xsl:text> - </xsl:text></xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="//tei:bibl[ancestor::tei:bibl]">
    <xsl:apply-templates/>
  </xsl:template>-->
  
  <xsl:template match="//tei:bibl">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="//tei:title[not(@level='a')]">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="//tei:foreign">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="//tei:title[@level='a']">
    <xsl:text>«</xsl:text><xsl:apply-templates/><xsl:text>»</xsl:text>
  </xsl:template>
  
  <xsl:template match="//tei:head[not(@type='subheading')]">
    <h2><xsl:apply-templates/></h2>
  </xsl:template>
  
  <xsl:template match="//tei:head[@type='subheading']">
    <h4><xsl:apply-templates/></h4>
  </xsl:template>
  
  <xsl:template priority="10" match="//tei:ref[starts-with(@target, 'http')]">
    <a target="_blank" href="{@target}"><xsl:apply-templates/></a>
  </xsl:template>
  
  <xsl:template priority="10" match="//tei:hi[@rend='inverted' or @rend='reversed']">
    <xsl:text>((</xsl:text><xsl:apply-templates/><xsl:text>))</xsl:text>
  </xsl:template>
  
  <xsl:template priority="10" match="//tei:hi[@rend='ligature']">
    <span class="inslibligature"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template priority="10" match="//tei:hi[@rend='superscript']">
    <sup><xsl:apply-templates/></sup>
  </xsl:template>
  
  <xsl:template priority="10" match="//tei:hi[@rend='underline']">
    <span class="previouslyread"><xsl:apply-templates/></span>
  </xsl:template>
  
  <!-- this should be limited to inslib igcyr2 -->
  <xsl:template priority="10" match="tei:ptr[@target]">
        <!-- if you are running this template outside EFES, change the path to the bibliography authority list accordingly -->
        <xsl:variable name="bibliography-al" select="concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/bibliography.xml')"/>
        <xsl:variable name="bibl-ref" select="translate(@target, '#', '')"/>
        <xsl:choose>
          <xsl:when test="doc-available($bibliography-al) = fn:true()">
            <xsl:variable name="bibl" select="document($bibliography-al)//tei:bibl[@xml:id=$bibl-ref][not(@sameAs)]"/>
            <a href="../concordance/bibliography/{$bibl-ref}.html" target="_blank"> <!-- this should be limited to inslib igcyr2: otherwise '../concordance' -->
              <xsl:choose>
                <xsl:when test="$bibl//tei:bibl[@type='abbrev']">
                  <xsl:apply-templates select="$bibl//tei:bibl[@type='abbrev'][1]"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$bibl[ancestor::tei:div[@xml:id='authored_editions']]">
                      <xsl:for-each select="$bibl//tei:name[@type='surname'][not(parent::*/preceding-sibling::tei:title)]">
                        <xsl:apply-templates select="."/>
                        <xsl:if test="position()!=last()"> – </xsl:if>
                      </xsl:for-each>
                      <xsl:text> </xsl:text>
                      <xsl:apply-templates select="$bibl//tei:date"/>
                    </xsl:when>
                    <xsl:when test="$bibl[ancestor::tei:div[@xml:id='series_collections']]">
                      <i><xsl:value-of select="$bibl/@xml:id"/></i>
                    </xsl:when>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$bibl-ref"/>
          </xsl:otherwise>
        </xsl:choose>
  </xsl:template>
  
  <!-- commented for inslib igcyr2 -->
  <!--<xsl:template priority="10" match="//tei:ptr[@target]">
    <xsl:variable name="target" select="translate(@target, '#', '')"/>
    <xsl:variable name="bibl" select="ancestor::tei:div/descendant::tei:bibl[@xml:id=$target][not(@sameAs)]"/>
    <xsl:choose>
      <xsl:when test="$bibl">
        <a href="../concordance/bibliography/{$target}.html">
      <xsl:choose>
        <xsl:when test="$bibl//tei:bibl[@type='abbrev']">
          <xsl:apply-templates select="$bibl//tei:bibl[@type='abbrev'][1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$bibl[ancestor::tei:div[@xml:id='authored_editions']]">
              <xsl:for-each select="$bibl//tei:name[@type='surname'][not(parent::*/preceding-sibling::tei:title)]">
                <xsl:apply-templates select="."/>
                <xsl:if test="position()!=last()"> – </xsl:if>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:apply-templates select="$bibl//tei:date"/>
            </xsl:when>
            <xsl:when test="$bibl[ancestor::tei:div[@xml:id='series_collections']]">
              <i><xsl:value-of select="$bibl/@xml:id"/></i>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$target"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </a>
      </xsl:when>
      <xsl:when test="starts-with($target, 'http')">
        <a target="_blank" href="{$target}"><xsl:value-of select="$target"/></a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$target"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->
  
  <xsl:template priority="10" match="tei:author|tei:pubPlace|tei:publisher"><xsl:apply-templates/></xsl:template>
  
  <xsl:template match="//tei:div[@xml:id='all_places']">
    <div class="row map_box">
      <div id="mapid" class="map"></div>
      <xsl:variable name="points">
        <xsl:text>{</xsl:text>
        <xsl:for-each select="document(concat('file:',system-property('user.dir'), '/webapps/ROOT/content/xml/authority/places.xml'))//tei:place">
          <xsl:variable name="place-name" select="descendant::tei:placeName[@xml:lang='en'][1]"/>
          <xsl:variable name="coord" select="descendant::tei:geo"/>
          <xsl:variable name="place-id" select="substring-after(descendant::tei:idno[@type='hgl'][1], 'slsgazetteer.org/')"/>
          <!--<xsl:variable name="counter" select="count(collection(concat('file:',system-property('user.dir'), '/webapps/ROOT/content/xml/epidoc/?select=*.xml;recurse=yes'))/tei:TEI/tei:teiHeader[descendant::tei:provenance[@type='found']//tei:placeName[@type='ancientFindspot'][1]=$place-name])"/>-->
          <xsl:variable name="counter" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/places.xml'))//tei:place[descendant::tei:placeName=$place-name][1]//tei:note[@type='total_inscriptions']"/>
          <xsl:text>"</xsl:text>
          <xsl:value-of select="$place-name"/>
          <xsl:text>#</xsl:text>
          <xsl:value-of select="$counter"/>
          <xsl:text>@</xsl:text>
          <xsl:value-of select="$place-id"/>
          <xsl:text>": "</xsl:text>
          <xsl:value-of select="$coord"/>
          <xsl:text>"</xsl:text>
          <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>}</xsl:text>
      </xsl:variable>
      <script type="text/javascript">
        var points = <xsl:value-of select="$points"/>;
        <!--var points = {"Al Ardam#xxx@2049": "32.6, 22.53333", 
        "Berenike#xxx@910": "32.125787, 20.064946",
        "Cyrenaica#xxx@908": "32.4996533333, 20.8717433333",
        "Cyrene#835@909": "32.827778, 21.8622219",
        "El Gubba#xxx@1638": "32.766626, 22.249934",
        "Euesperides#xxx@1464": "32.13472, 20.090833",
        "Faidia#xxx@1428": "32.687583, 21.906877",
        "Martūbah#xxx@1427": "32.575739, 22.761505",
        "Massah#xxx@1184": "32.75194, 21.62667",
        "Mgarnes#xxx@1196": "32.81744, 21.99178",
        "Port of Cyrene, later Apollonia#xxx@911": "32.9023435505, 21.9708306931",
        "Ptolemais#xxx@912": "32.708807, 20.9507545",
        "Qasr Libya#xxx@1618": "32.6314, 21.3965",
        "Taucheira#32@913": "32.54, 20.568",
        "Taurguni#xxx@1186": "32.7525387, 21.5698339",
        "Wadi al Khalij#xxx@1460": "32.665092, 22.924136"};-->
      </script>
      <script type="text/javascript" src="../../assets/scripts/maps.js"></script>
      <script type="text/javascript">
        var mymap = L.map('mapid', { center: [32, 22], zoom: 7, fullscreenControl: true, layers: layers });
        L.control.layers(baseMaps, overlayMaps).addTo(mymap);
        L.control.scale().addTo(mymap);
        L.Control.geocoder().addTo(mymap);
        toggle_places.addTo(mymap); 
      </script>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:figure">
    <xsl:choose>
      <!--<img alt="{@xml:id}" class="image" src="{lower-case(@corresp)}" usemap="#annotations">
          <map name="annotations">
                <area style="outline: 10px solid green" shape="rect" coords="2880,2309,85,80" title="Palace of the Dux" alt="Palace of the Dux" target="_blank" href="http://www.slsgazetteer.org/918"/>
                <area shape="rect" coords="154,71,220,180" title="East Church" alt="East Church" target="_blank" href="http://www.slsgazetteer.org/914"/>
          </map>
        </img>-->
      <xsl:when test="@type='annotations' and @xml:id='map_Apollonia'">
        <svg viewBox="0 0 5466 3966">
          <image type="full_archeo_map" width="5466" height="3966" href="{lower-case(@corresp)}"/>
          <g class="annotation_group">
            <a href="http://www.slsgazetteer.org/1399" target="_blank">
              <rect class="annotation" x="3700" y="2271" fill="#0080FF30" width="100" height="91" stroke="blue" stroke-width="10" ></rect>
              <rect class="info_bg" x="3200" y="2149" width="1100" height="130" fill="#d5eaf2"></rect>
              <text class="info" x="3750" y="2241" font-size="92" text-anchor="middle">25 - Byzantine warehouses</text>
            </a>
          </g>
          <g class="annotation_group">
            <a href="http://www.slsgazetteer.org/1400" target="_blank">
              <rect class="annotation" x="3414" y="2676" fill="#0080FF30" width="96" height="75" stroke="blue" stroke-width="10" ></rect>
              <rect class="info_bg" x="3030" y="2554" width="880" height="130" fill="#d5eaf2"></rect>
              <text class="info" x="3462" y="2646" font-size="92" text-anchor="middle">26 - Kallikrateia Rock</text>
            </a>
          </g>
          <g class="annotation_group">
            <a href="http://www.slsgazetteer.org/922" target="_blank">
              <rect class="annotation" x="697" y="3015" fill="#0080FF30" width="74" height="91" stroke="blue" stroke-width="10" ></rect>
              <rect class="info_bg" x="400" y="2886" width="680" height="130" fill="#d5eaf2"></rect>
              <text class="info" x="734" y="2978" font-size="92" text-anchor="middle">3 - West Church</text>
            </a>
          </g>
          <g class="annotation_group">
            <a href="http://www.slsgazetteer.org/911" target="_blank">
              <rect class="annotation" x="4326" y="109" fill="#0080FF30" width="1004" height="235" stroke="blue" stroke-width="10" ></rect>
              <rect class="info_bg" x="4240" y="350" width="1180" height="130" fill="#d5eaf2"></rect>
              <text class="info" x="4828" y="445" font-size="92" text-anchor="middle">Port of Cyrene, later Apollonia</text>
            </a>
          </g>
          <g class="annotation_group">
            <a href="http://www.slsgazetteer.org/925" target="_blank">
              <rect class="annotation" x="4785" y="1615" fill="#0080FF30" width="475" height="171" stroke="blue" stroke-width="10" ></rect>
              <rect class="info_bg" x="4660" y="1493" width="735" height="130" fill="#d5eaf2"></rect>
              <text class="info" x="5022" y="1585" font-size="92" text-anchor="middle">Apollonia seashore</text>
            </a>
          </g>
          <g class="annotation_group">
            <a href="http://www.slsgazetteer.org/920" target="_blank">
              <rect class="annotation" x="2006" y="2404" fill="#0080FF30" width="60" height="75" stroke="blue" stroke-width="10" ></rect>
              <rect class="info_bg" x="1700" y="2282" width="670" height="130" fill="#d5eaf2"></rect>
              <text class="info" x="2033" y="2374" font-size="92" text-anchor="middle">6 - Roman Baths</text>
            </a>
          </g>
          <g class="annotation_group">
            <a href="http://www.slsgazetteer.org/931" target="_blank">
              <g transform="translate(17,3101)">
                <g transform="rotate(-39.47)">
                  <rect class="annotation" x="0" y="0" fill="#0080FF30" width="147" height="61" stroke="blue" stroke-width="10" ></rect>
                  <rect class="info_bg" x="30" y="-107" width="680" height="130" fill="#d5eaf2"></rect>
                  <text class="info" x="73" y="-15" font-size="92" text-anchor="start">West Necropolis</text>
                </g>
              </g>
            </a>
          </g>
          <g class="annotation_group">
            <a href="http://www.slsgazetteer.org/918" target="_blank">
              <rect class="annotation" x="2072" y="2708" fill="#0080FF30" width="91" height="80" stroke="blue" stroke-width="10" ></rect>
              <rect class="info_bg" x="1690" y="2586" width="875" height="130" fill="#d5eaf2"></rect>
              <text class="info" x="2117" y="2678" font-size="92" text-anchor="middle">17 - Palace of the Dux</text>
            </a>
          </g>
          <g class="annotation_group">
            <a href="http://www.slsgazetteer.org/914" target="_blank">
              <rect class="annotation" x="2870" y="2309" fill="#0080FF30" width="95" height="85" stroke="blue" stroke-width="10" ></rect>
              <rect class="info_bg" x="2580" y="2187" width="700" height="130" fill="#d5eaf2"></rect>
              <text class="info" x="2922" y="2279" font-size="92" text-anchor="middle">19 - East Church</text>
            </a>
          </g>
        </svg>
        </xsl:when>
      <xsl:when test="@type='annotations' and @xml:id='map_Berenike'">
                <svg  viewBox="0 0 2362 1583">
                  <image type="full_archeo_map" width="2362" height="1583" href="{lower-case(@corresp)}"></image>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/910" target="_blank">
                      <rect class="info_bg" x="56" y="1101" width="186" height="65" fill="#d5eaf2"></rect>
                      <text class="info" x="77" y="1141" font-size="40" text-anchor="start">Berenike</text>
                      <rect class="annotation" x="61" y="1171" fill="#0080FF30" width="175" height="276" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <rect class="info_bg" x="1530" y="640" width="350" height="60" fill="#d5eaf2"></rect>
                    <text class="info" x="1702" y="680" font-size="40" text-anchor="middle">Hellenistic city walls</text>
                    <rect class="annotation" x="1660" y="700" fill="#0080FF30" width="78" height="83" stroke="blue" stroke-width="10"></rect>
                  </g>
                  <g class="annotation_group">
                    <rect class="info_bg" x="1805" y="820" width="170" height="60" fill="#d5eaf2"></rect>
                    <text class="info" x="1887" y="860" font-size="40" text-anchor="middle">Church</text>
                    <rect class="annotation" x="1848" y="883" fill="#0080FF30" width="78" height="83" stroke="blue" stroke-width="10"></rect>
                  </g>
                </svg>
              </xsl:when>
      <xsl:when test="@type='annotations' and @xml:id='map_Cyrene_agora'">
                <svg viewBox="0 0 4252 2244">
                  <image type="full_archeo_map" width="4252" height="2244" href="{lower-case(@corresp)}"></image>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/989" target="_blank">
                      <rect class="info_bg" x="3170" y="1840" width="670" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3500" y="1910" font-size="72" text-anchor="middle">12 - Temple of Venus</text>
                      <rect class="annotation" x="3455" y="1757" fill="#0080FF30" width="100" height="80" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1328" target="_blank">
                      <rect class="info_bg" x="690" y="407" width="840" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1100" y="480" font-size="72" text-anchor="middle">36 - Monument to the Gods</text>
                      <rect class="annotation" x="1030" y="520" fill="#0080FF30" width="100" height="80" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/992" target="_blank">
                      <rect class="info_bg" x="1827" y="1043" width="700" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2170" y="1115" font-size="72" text-anchor="middle">19 - Temple of Hermes</text>
                      <rect class="annotation" x="2238" y="1140" fill="#0080FF30" width="95" height="80" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/991" target="_blank">
                      <rect class="info_bg" x="2105" y="1353" width="842" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2520" y="1425" font-size="72" text-anchor="middle">17 - House of Jason Magnus</text>
                      <rect class="annotation" x="2470" y="1460" fill="#0080FF30" width="90" height="90" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1009" target="_blank">
                      <rect class="info_bg" x="240" y="1611" width="216" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="348" y="1683" font-size="72" text-anchor="middle">Agora</text>
                      <rect class="annotation" x="195" y="1713" fill="#0080FF30" width="307" height="295" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1380" target="_blank">
                      <rect class="info_bg" x="10" y="490" width="1000" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="507" y="562" font-size="72" text-anchor="middle">32 - Temple of Demeter and Kore</text>
                      <rect class="annotation" x="874" y="596" fill="#0080FF30" width="100" height="90" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1309" target="_blank">
                      <rect class="info_bg" x="27" y="840" width="600" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="61" y="912" font-size="72" text-anchor="start">3 - Street of Battos</text>
                      <rect class="annotation" x="31" y="950" fill="#0080FF30" width="70" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1309" target="_blank">
                      <rect class="info_bg" x="3655" y="960" width="575" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="4205" y="1032" font-size="72" text-anchor="end">3 - Street of Battos</text>
                      <rect class="annotation" x="4180" y="1060" fill="#0080FF30" width="70" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1314" target="_blank">
                      <rect class="info_bg" x="2675" y="1188" width="810" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3081" y="1260" font-size="72" text-anchor="middle">8 - Temple of the Dioscuri</text>
                      <rect class="annotation" x="3052" y="1288" fill="#0080FF30" width="70" height="80" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/987" target="_blank">
                      <rect class="info_bg" x="3450" y="735" width="480" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3689" y="807" font-size="72" text-anchor="middle">2 - Cesareum</text>
                      <rect class="annotation" x="3646" y="837" fill="#0080FF30" width="87" height="83" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1005" target="_blank">
                      <rect class="info_bg" x="375" y="1279" width="1020" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="884" y="1351" font-size="72" text-anchor="middle">25 - Temple of Zeus on the Agora</text>
                      <rect class="annotation" x="836" y="1381" fill="#0080FF30" width="100" height="80" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1010" target="_blank">
                      <rect class="info_bg" x="300" y="344" width="430" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="520" y="416" font-size="72" text-anchor="middle">33 - West Stoa</text>
                      <rect class="annotation" x="592" y="446" fill="#0080FF30" width="104" height="85" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1333" target="_blank">
                      <rect class="info_bg" x="10" y="548" width="900" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="450" y="620" font-size="72" text-anchor="middle">42 - House by the Propylaeum</text>
                      <rect class="annotation" x="323" y="650" fill="#0080FF30" width="110" height="87" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1329" target="_blank">
                      <rect class="info_bg" x="1250" y="390" width="435" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1464" y="462" font-size="72" text-anchor="middle">38 - East Stoa</text>
                      <rect class="annotation" x="1414" y="490" fill="#0080FF30" width="104" height="80" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1224" target="_blank">
                      <rect class="info_bg" x="2710" y="547" width="490" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2943" y="619" font-size="72" text-anchor="middle">15 - Theatre 2</text>
                      <rect class="annotation" x="2900" y="646" fill="#0080FF30" width="90" height="80" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1321" target="_blank">
                      <rect class="info_bg" x="1110" y="884" width="790" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1503" y="956" font-size="72" text-anchor="middle">22 - Temple of Asklepios</text>
                      <rect class="annotation" x="1453" y="980" fill="#0080FF30" width="100" height="80" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1225" target="_blank">
                      <rect class="info_bg" x="910" y="1108" width="500" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1152" y="1180" font-size="72" text-anchor="middle">24 - Prytaneum</text>
                      <rect class="annotation" x="1105" y="1210" fill="#0080FF30" width="95" height="80" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1483" target="_blank">
                      <rect class="info_bg" x="545" y="228" width="510" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="801" y="300" font-size="72" text-anchor="middle">34 - Augusteum</text>
                      <rect class="annotation" x="756" y="329" fill="#0080FF30" width="90" height="75" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1319" target="_blank">
                      <rect class="info_bg" x="2370" y="1046" width="880" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2800" y="1118" font-size="72" text-anchor="middle">18 - House of the Orthostats</text>
                      <rect class="annotation" x="2522" y="1146" fill="#0080FF30" width="85" height="80" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1334" target="_blank">
                      <rect class="info_bg" x="3050" y="1562" width="675" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3383" y="1634" font-size="72" text-anchor="middle">11 - Temple of Cybele</text>
                      <rect class="annotation" x="3345" y="1655" fill="#0080FF30" width="80" height="90" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1326" target="_blank">
                      <rect class="info_bg" x="430" y="830" width="1000" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="926" y="902" font-size="72" text-anchor="middle">30 - Temple of Apollo Archegetes</text>
                      <rect class="annotation" x="876" y="737" fill="#0080FF30" width="100" height="87" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1006" target="_blank">
                      <rect class="info_bg" x="100" y="1465" width="655" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="425" y="1535" font-size="72" text-anchor="middle">26 - Nomophylakeion</text>
                      <rect class="annotation" x="760" y="1468" fill="#0080FF30" width="108" height="87" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                </svg>
              </xsl:when>
      <xsl:when test="@type='annotations' and @xml:id='map_Cyrene_central_quarter'">
                <svg viewBox="0 0 2383 1349">
                  <image type="full_archeo_map" width="2383" height="1349" href="{lower-case(@corresp)}"></image>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/909" target="_blank">
                      <g transform="translate(2171,1205)">
                        <g transform="rotate(-109.23)">
                          <rect class="info_bg" x="-54" y="-70" width="300" height="65" fill="#d5eaf2"></rect>
                          <text class="info" x="210" y="-30" font-size="40" text-anchor="end">Central quarter</text>
                          <rect class="annotation" x="-45" y="0" fill="#0080FF30" width="290" height="105" stroke="blue" stroke-width="10"></rect>
                        </g>
                      </g>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1338" target="_blank">
                      <rect class="info_bg" x="800" y="171" width="380" height="65" fill="#d5eaf2"></rect>
                      <text class="info" x="988" y="211" font-size="40" text-anchor="middle">50 - Public Building D</text>
                      <rect class="annotation" x="940" y="241" fill="#0080FF30" width="96" height="72" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                </svg>
              </xsl:when>
      <xsl:when test="@type='annotations' and @xml:id='map_Cyrene_general_plan'">
                <svg viewBox="0 0 4866 4253">
                  <image type="full_archeo_map" width="4866" height="4253" href="{lower-case(@corresp)}"></image>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1382" target="_blank">
                      <rect class="info_bg" x="1650" y="3423" width="640" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="1962" y="3507" font-size="82" text-anchor="middle">115 - Theatre 5</text>
                      <rect class="annotation" x="1890" y="3543" fill="#0080FF30" width="143" height="100" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1240" target="_blank">
                      <rect class="info_bg" x="50" y="1430" width="370" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="87" y="1510" font-size="82" text-anchor="start">City Wall</text>
                      <rect class="annotation" x="138" y="1556" width="60" height="60" fill="#0080FF30" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1226" target="_blank">
                      <rect class="info_bg" x="3850" y="2283" width="690" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="4186" y="2370" font-size="82" text-anchor="middle">110 - East Church</text>
                      <rect class="annotation" x="4113" y="2409" fill="#0080FF30" width="147" height="129" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1379" target="_blank">
                      <g transform="translate(252,2568)">
                        <g transform="rotate(18.54)">
                          <rect class="info_bg" x="34" y="-127" width="738" height="120" fill="#d5eaf2"></rect>
                          <text class="info" x="403" y="-35" font-size="82" text-anchor="middle">Wadi Bel Ghadir</text>
                          <rect class="annotation" x="0" y="0" fill="#0080FF30" width="807" height="210" stroke="blue" stroke-width="10"></rect>
                        </g>
                      </g>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1066" target="_blank">
                      <rect class="info_bg" x="3345" y="1366" width="810" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="3740" y="1450" font-size="82" text-anchor="middle">106 - Temple of Zeus</text>
                      <rect class="annotation" x="3664" y="1490" fill="#0080FF30" width="152" height="90" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1477" target="_blank">
                      <rect class="info_bg" x="1500" y="3943" width="1050" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="2024" y="4025" font-size="82" text-anchor="middle">117 - Southern temple precint</text>
                      <rect class="annotation" x="1950" y="4065" fill="#0080FF30" width="145" height="100" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1381" target="_blank">
                      <rect class="info_bg" x="760" y="2945" width="1630" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="1565" y="3030" font-size="82" text-anchor="middle">116 - Enclosed sanctuary of Demeter and Kore</text>
                      <rect class="annotation" x="1495" y="3067" fill="#0080FF30" width="140" height="110" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1473" target="_blank">
                      <rect class="info_bg" x="1020" y="3592" width="1240" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="1644" y="3675" font-size="82" text-anchor="middle">Southern Extra-Mural Sacred Zone</text>
                      <rect class="annotation" x="1644" y="3718" width="70" height="70" fill="#0080FF30" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1475" target="_blank">
                      <rect class="info_bg" x="1700" y="3747" width="1300" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="2352" y="3830" font-size="82" text-anchor="middle">114 - Extra-Mural Temple of Demeter</text>
                      <rect class="annotation" x="2280" y="3875" fill="#0080FF30" width="135" height="105" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/933" target="_blank">
                      <rect class="info_bg" x="4031" y="2715" width="639" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="4350" y="2800" font-size="82" text-anchor="middle">Cyrene Museum</text>
                      <rect class="annotation" x="4233" y="2842" fill="#0080FF30" width="240" height="100" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/909" target="_blank">
                      <rect class="info_bg" x="10" y="3053" width="480" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="242" y="3132" font-size="82" text-anchor="middle">general plan</text>
                      <rect class="annotation" x="115" y="3180" fill="#0080FF30" width="234" height="520" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1020" target="_blank">
                      <rect class="info_bg" x="1030" y="1775" width="470" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="1261" y="1860" font-size="82" text-anchor="middle">44 - Iseum</text>
                      <rect class="annotation" x="1212" y="1900" fill="#0080FF30" width="112" height="95" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1016" target="_blank">
                      <rect class="info_bg" x="574" y="2157" width="442" height="120" fill="#d5eaf2"></rect>
                      <text class="info" x="795" y="2239" font-size="82" text-anchor="middle">Acropolis</text>
                      <rect class="annotation" x="489" y="2269" fill="#0080FF30" width="613" height="124" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                </svg>
              </xsl:when>
      <xsl:when test="@type='annotations' and @xml:id='map_Cyrene_north_necropolis'">
                <svg viewBox="0 0 2244 1654">
                  <image type="full_archeo_map" width="2244" height="1654" href="{lower-case(@corresp)}"></image>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/934" target="_blank">
                      <g transform="translate(1245,1383)">
                        <g transform="rotate(16.30)">
                          <rect class="info_bg" x="-5" y="-66" width="319" height="60" fill="#d5eaf2"></rect>
                          <text class="info" x="154" y="-25" font-size="38" text-anchor="middle">Sculpture Museum</text>
                          <rect class="annotation" x="0" y="0" fill="#0080FF30" width="308" height="69" stroke="blue" stroke-width="10"></rect>
                        </g>
                      </g>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1487" target="_blank">
                      <rect class="info_bg" x="280" y="1360" width="655" height="65" fill="#d5eaf2"></rect>
                      <text class="info" x="604" y="1400" font-size="38" text-anchor="middle">Terrace of the Department of Antiquities</text>
                      <rect class="annotation" x="604" y="1426" width="23" height="23" fill="#0080FF30" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1073" target="_blank">
                      <rect class="info_bg" x="2005" y="630" width="212" height="60" fill="#d5eaf2"></rect>
                      <text class="info" x="2182" y="666" font-size="38" text-anchor="end">Kinissieh</text>
                      <rect class="annotation" x="2010" y="682" fill="#0080FF30" width="201" height="96" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1071" target="_blank">
                      <rect class="info_bg" x="1812" y="1205" width="335" height="65" fill="#d5eaf2"></rect>
                      <text class="info" x="1979" y="1250" font-size="38" text-anchor="middle">North Necropolis</text>
                      <rect class="annotation" x="1817" y="1273" fill="#0080FF30" width="324" height="311" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                </svg>
              </xsl:when>
      <xsl:when test="@type='annotations' and @xml:id='map_Cyrene_sanctuary_of_Apollo'">
                <svg viewBox="0 0 4252 2362">
                  <image type="full_archeo_map" width="4252" height="2362" href="{lower-case(@corresp)}"></image>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1287" target="_blank">
                      <rect class="info_bg" x="1100" y="1345" width="1170" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1680" y="1417" font-size="72" text-anchor="middle">99 - Fountain of Apollo, Spring of Kyra</text>
                      <rect class="annotation" x="2124" y="1447" fill="#0080FF30" width="80" height="79" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1060" target="_blank">
                      <rect class="info_bg" x="1460" y="1122" width="780" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1844" y="1194" font-size="72" text-anchor="middle">92 - Grotto of the Priests</text>
                      <rect class="annotation" x="1810" y="1215" fill="#0080FF30" width="80" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1033" target="_blank">
                      <rect class="info_bg" x="700" y="990" width="1290" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1355" y="1062" font-size="72" text-anchor="middle">77 - Temple of Apollo (Cella and Peristasis)</text>
                      <rect class="annotation" x="1993" y="995" fill="#0080FF30" width="80" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1360" target="_blank">
                      <rect class="info_bg" x="760" y="486" width="740" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1131" y="558" font-size="72" text-anchor="middle">87 - Wall of Nicodamos</text>
                      <rect class="annotation" x="1091" y="588" fill="#0080FF30" width="75" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1352" target="_blank">
                      <rect class="info_bg" x="2410" y="1072" width="600" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2713" y="1144" font-size="72" text-anchor="middle">69 - Doric Fountain</text>
                      <rect class="annotation" x="2680" y="1174" fill="#0080FF30" width="75" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1372" target="_blank">
                      <rect class="info_bg" x="3380" y="1740" width="660" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3704" y="1810" font-size="72" text-anchor="middle">104 - Stepped Portico</text>
                      <rect class="annotation" x="3655" y="1665" fill="#0080FF30" width="100" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1369" target="_blank">
                      <rect class="info_bg" x="2160" y="1533" width="690" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2500" y="1605" font-size="72" text-anchor="middle">101 - Bench of Elaiitas</text>
                      <rect class="annotation" x="2638" y="1450" fill="#0080FF30" width="100" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1359" target="_blank">
                      <rect class="info_bg" x="840" y="802" width="620" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1149" y="874" font-size="72" text-anchor="middle">86 - Doric Treasury</text>
                      <rect class="annotation" x="1110" y="900" fill="#0080FF30" width="80" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1356" target="_blank">
                      <rect class="info_bg" x="1365" y="778" width="550" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1645" y="850" font-size="72" text-anchor="middle">82 - Myrtle Bower</text>
                      <rect class="annotation" x="1923" y="785" fill="#0080FF30" width="80" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1047" target="_blank">
                      <rect class="info_bg" x="2440" y="858" width="730" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2800" y="930" font-size="72" text-anchor="middle">73 - Temple of Dioscuri</text>
                      <rect class="annotation" x="2434" y="960" fill="#0080FF30" width="70" height="60" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1355" target="_blank">
                      <rect class="info_bg" x="2030" y="630" width="375" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2220" y="702" font-size="72" text-anchor="middle">80 - Lesche</text>
                      <rect class="annotation" x="2052" y="742" fill="#0080FF30" width="72" height="60" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/2081" target="_blank">
                      <rect class="info_bg" x="1555" y="1554" width="2660" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2880" y="1625" font-size="72" text-anchor="middle">102 - Rock-cut sanctuary near the Sacred Cave just south of the central lime-kiln of the series</text>
                      <rect class="annotation" x="2833" y="1480" fill="#0080FF30" width="105" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1054" target="_blank">
                      <rect class="info_bg" x="2310" y="1010" width="875" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2740" y="1082" font-size="72" text-anchor="middle">97 - Temple of Jason Magnus</text>
                      <rect class="annotation" x="2351" y="1100" fill="#0080FF30" width="75" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1350" target="_blank">
                      <rect class="info_bg" x="3085" y="1400" width="690" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3425" y="1480" font-size="72" text-anchor="middle">64 - Greek Propylaeum</text>
                      <rect class="annotation" x="3000" y="1445" fill="#0080FF30" width="80" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1043" target="_blank">
                      <rect class="info_bg" x="2810" y="1101" width="740" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3180" y="1173" font-size="72" text-anchor="middle">68 - Roman Propylaeum</text>
                      <rect class="annotation" x="2815" y="1190" fill="#0080FF30" width="77" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1366" target="_blank">
                      <rect class="info_bg" x="2000" y="1271" width="699" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2350" y="1343" font-size="72" text-anchor="middle">98 - Agora of the Gods</text>
                      <rect class="annotation" x="2701" y="1260" fill="#0080FF30" width="73" height="60" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1353" target="_blank">
                      <rect class="info_bg" x="2420" y="1078" width="690" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2763" y="1150" font-size="72" text-anchor="middle">70 - Temple of Athena</text>
                      <rect class="annotation" x="2587" y="1180" fill="#0080FF30" width="72" height="60" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1062" target="_blank">
                      <rect class="info_bg" x="160" y="518" width="600" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="457" y="590" font-size="72" text-anchor="middle">89 - Greek Theatre</text>
                      <rect class="annotation" x="418" y="614" fill="#0080FF30" width="85" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1041" target="_blank">
                      <rect class="info_bg" x="2775" y="735" width="600" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3070" y="807" font-size="72" text-anchor="middle">75 - Trajanic Baths</text>
                      <rect class="annotation" x="2703" y="755" fill="#0080FF30" width="74" height="60" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1365" target="_blank">
                      <rect class="info_bg" x="1280" y="1054" width="940" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1750" y="1126" font-size="72" text-anchor="middle">96 - Exedra of Apollo Karneios</text>
                      <rect class="annotation" x="2230" y="1052" fill="#0080FF30" width="80" height="60" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1230" target="_blank">
                      <rect class="info_bg" x="1540" y="850" width="670" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1873" y="920" font-size="72" text-anchor="middle">78 - Temple of Latona</text>
                      <rect class="annotation" x="2216" y="860" fill="#0080FF30" width="75" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1227" target="_blank">
                      <rect class="info_bg" x="3050" y="1030" width="650" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3370" y="1105" font-size="72" text-anchor="middle">66 - Byzantine Baths</text>
                      <rect class="annotation" x="2977" y="1035" fill="#0080FF30" width="75" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1049" target="_blank">
                      <rect class="info_bg" x="2300" y="854" width="610" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2600" y="926" font-size="72" text-anchor="middle">76 - Altar of Apollo</text>
                      <rect class="annotation" x="2334" y="954" fill="#0080FF30" width="75" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1042" target="_blank">
                      <rect class="info_bg" x="3020" y="1246" width="500" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3260" y="1318" font-size="72" text-anchor="middle">67 - Strategeion</text>
                      <rect class="annotation" x="2938" y="1260" fill="#0080FF30" width="75" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1468" target="_blank">
                      <rect class="info_bg" x="1560" y="1128" width="780" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1948" y="1200" font-size="72" text-anchor="middle">Naiskos of the Carneadae</text>
                      <rect class="annotation" x="1917" y="1233" fill="#0080FF30" width="63" height="42" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1051" target="_blank">
                      <rect class="info_bg" x="1350" y="603" width="700" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="1695" y="675" font-size="72" text-anchor="middle">79 - Temple of Artemis</text>
                      <rect class="annotation" x="1963" y="710" fill="#0080FF30" width="75" height="65" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1363" target="_blank">
                      <rect class="info_bg" x="1700" y="1122" width="840" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2116" y="1194" font-size="72" text-anchor="middle">94 - Fountain of Philothales</text>
                      <rect class="annotation" x="2078" y="1218" fill="#0080FF30" width="80" height="60" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1052" target="_blank">
                      <rect class="info_bg" x="2160" y="612" width="690" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2500" y="684" font-size="72" text-anchor="middle">81 - Temple of Hekate</text>
                      <rect class="annotation" x="2272" y="724" fill="#0080FF30" width="70" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1231" target="_blank">
                      <rect class="info_bg" x="2110" y="664" width="650" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2425" y="740" font-size="72" text-anchor="middle">74 - Altar of Artemis</text>
                      <rect class="annotation" x="2360" y="780" fill="#0080FF30" width="75" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1024" target="_blank">
                      <rect class="info_bg" x="3380" y="1334" width="800" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="3752" y="1406" font-size="72" text-anchor="middle">Valley Street, North Side</text>
                      <rect class="annotation" x="3752" y="1460" width="45" height="45" fill="#0080FF30" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1045" target="_blank">
                      <rect class="info_bg" x="2010" y="1347" width="620" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="2320" y="1419" font-size="72" text-anchor="middle">Temple of Asklepios</text>
                      <rect class="annotation" x="2638" y="1373" width="45" height="45" fill="#0080FF30" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1228" target="_blank">
                      <rect class="info_bg" x="32" y="1438" width="630" height="110" fill="#d5eaf2"></rect>
                      <text class="info" x="65" y="1510" font-size="72" text-anchor="start">Sanctuary of Apollo</text>
                      <rect class="annotation" x="35" y="1543" fill="#0080FF30" width="494" height="556" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                </svg>
              </xsl:when>
      <xsl:when test="@type='annotations' and @xml:id='map_Euesperides'">
                <svg viewBox="0 0 1371 2126">
                  <image type="full_archeo_map" width="1371" height="2126" href="{lower-case(@corresp)}"></image>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1464" target="_blank">
                      <g transform="translate(1208,1030)">
                        <g transform="rotate(-109.98)">
                          <rect class="info_bg" x="42" y="-50" width="130" height="50" fill="#d5eaf2"></rect>
                          <text class="info" x="160" y="-20" font-size="23" text-anchor="end">Euesperides</text>
                          <rect class="annotation" x="-20" y="0" fill="#0080FF30" width="250" height="134" stroke="blue" stroke-width="10"></rect>
                        </g>
                      </g>
                    </a>
                  </g>
                </svg>
              </xsl:when>
      <xsl:when test="@type='annotations' and @xml:id='map_Ptolemais_inner'">
                <svg viewBox="0 0 2480 2835">
                  <image type="full_archeo_map" width="2480" height="2835" href="{lower-case(@corresp)}"></image>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/912" target="_blank">
                      <g transform="translate(305,2315)">
                        <g transform="rotate(-49.08)">
                          <rect class="info_bg" x="-35" y="-200" width="270" height="65" fill="#d5eaf2"></rect>
                          <text class="info" x="100" y="-157" font-size="41" text-anchor="middle">Site plan inner</text>
                          <rect class="annotation" x="-30" y="-130" fill="#0080FF30" width="260" height="150" stroke="blue" stroke-width="10"></rect>
                        </g>
                      </g>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/948" target="_blank">
                      <rect class="info_bg" x="770" y="2151" width="480" height="65" fill="#d5eaf2"></rect>
                      <text class="info" x="1006" y="2192" font-size="41" text-anchor="middle">17 - Square of the Cisterns</text>
                      <rect class="annotation" x="970" y="2218" fill="#0080FF30" width="76" height="63" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/946" target="_blank">
                      <rect class="info_bg" x="470" y="2378" width="270" height="65" fill="#d5eaf2"></rect>
                      <text class="info" x="606" y="2419" font-size="41" text-anchor="middle">21 - Theatre</text>
                      <rect class="annotation" x="566" y="2448" fill="#0080FF30" width="80" height="69" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/983" target="_blank">
                      <rect class="info_bg" x="1640" y="814" width="445" height="65" fill="#d5eaf2"></rect>
                      <text class="info" x="1853" y="855" font-size="41" text-anchor="middle">12 - Fortress of the Dux</text>
                      <rect class="annotation" x="1815" y="880" fill="#0080FF30" width="77" height="72" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1295" target="_blank">
                      <rect class="info_bg" x="1420" y="791" width="280" height="65" fill="#d5eaf2"></rect>
                      <text class="info" x="1558" y="832" font-size="41" text-anchor="middle">8 - Tetrastylon</text>
                      <rect class="annotation" x="1532" y="862" fill="#0080FF30" width="56" height="67" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1296" target="_blank">
                      <rect class="info_bg" x="1500" y="614" width="445" height="65" fill="#d5eaf2"></rect>
                      <text class="info" x="1721" y="655" font-size="41" text-anchor="middle">9 - North-East quadrant</text>
                      <rect class="annotation" x="1696" y="685" fill="#0080FF30" width="50" height="64" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                </svg>
              </xsl:when>
      <xsl:when test="@type='annotations' and @xml:id='map_Ptolemais_outer'">
                <svg viewBox="0 0 2480 1819">
                  <image type="full_archeo_map" width="2480" height="1819" href="{lower-case(@corresp)}"></image>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/942" target="_blank">
                      <rect class="info_bg" x="1165" y="822" width="260" height="60" fill="#d5eaf2"></rect>
                      <text class="info" x="1289" y="865" font-size="41" text-anchor="middle">31 - Basilica</text>
                      <rect class="annotation" x="1258" y="888" fill="#0080FF30" width="63" height="60" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1443" target="_blank">
                      <rect class="info_bg" x="30" y="1078" width="550" height="60" fill="#d5eaf2"></rect>
                      <text class="info" x="51" y="1119" font-size="41" text-anchor="start">36 - West Necropolis, Quarry 1</text>
                      <rect class="annotation" x="22" y="1140" fill="#0080FF30" width="83" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/912" target="_blank">
                      <rect class="info_bg" x="90" y="180" width="270" height="70" fill="#d5eaf2"></rect>
                      <text class="info" x="110" y="230" font-size="41" text-anchor="start">Site plan outer</text>
                      <rect class="annotation" x="50" y="63" fill="#0080FF30" width="720" height="120" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <g transform="translate(1127,1127)">
                      <g transform="rotate(31.10)">
                        <rect class="info_bg" x="-120" y="-64" width="405" height="60" fill="#d5eaf2"></rect>
                        <text class="info" x="82" y="-22" font-size="41" text-anchor="middle">South-West Necropolis</text>
                        <rect class="annotation" x="0" y="0" fill="#0080FF30" width="164" height="114" stroke="blue" stroke-width="10"></rect>
                      </g>
                    </g>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/976" target="_blank">
                      <g transform="translate(1861,251)">
                        <g transform="rotate(54.30)">
                          <rect class="info_bg" x="18" y="-56" width="270" height="60" fill="#d5eaf2"></rect>
                          <text class="info" x="153" y="-15" font-size="41" text-anchor="middle">Wadi Ziwana</text>
                          <rect class="annotation" x="0" y="0" fill="#0080FF30" width="307" height="73" stroke="blue" stroke-width="10"></rect>
                        </g>
                      </g>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/939" target="_blank">
                      <rect class="info_bg" x="1140" y="926" width="330" height="60" fill="#d5eaf2"></rect>
                      <text class="info" x="1304" y="970" font-size="41" text-anchor="middle">30 - Tokra Gate</text>
                      <rect class="annotation" x="1270" y="992" fill="#0080FF30" width="68" height="65" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1096" target="_blank">
                      <rect class="info_bg" x="900" y="51" width="335" height="60" fill="#d5eaf2"></rect>
                      <text class="info" x="1066" y="92" font-size="41" text-anchor="middle">Tolmeita Museum</text>
                      <rect class="annotation" x="960" y="118" fill="#0080FF30" width="218" height="75" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <rect class="info_bg" x="801" y="641" width="270" height="60" fill="#d5eaf2"></rect>
                    <text class="info" x="936" y="682" font-size="41" text-anchor="middle">Quarry Gate</text>
                    <rect class="annotation" x="936" y="713" width="26" height="26" fill="#0080FF30" stroke="blue" stroke-width="10"></rect>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/2080" target="_blank">
                      <rect class="info_bg" x="1970" y="447" width="310" height="60" fill="#d5eaf2"></rect>
                      <text class="info" x="2120" y="490" font-size="41" text-anchor="middle">East Necropolis</text>
                      <rect class="annotation" x="2120" y="512" width="50" height="50" fill="#0080FF30" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/967" target="_blank">
                      <g transform="translate(1304,1292)">
                        <g transform="rotate(40.30)">
                          <rect class="info_bg" x="19" y="-76" width="319" height="60" fill="#d5eaf2"></rect>
                          <text class="info" x="178" y="-35" font-size="41" text-anchor="middle">Wadi Khambish</text>
                          <rect class="annotation" x="0" y="-10" fill="#0080FF30" width="356" height="75" stroke="blue" stroke-width="10"></rect>
                        </g>
                      </g>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/965" target="_blank">
                      <rect class="info_bg" x="990" y="632" width="360" height="60" fill="#d5eaf2"></rect>
                      <text class="info" x="1168" y="675" font-size="41" text-anchor="middle">32 - Amphitheatre</text>
                      <rect class="annotation" x="1130" y="696" fill="#0080FF30" width="77" height="73" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                </svg>
              </xsl:when>
      <xsl:when test="@type='annotations' and @xml:id='map_Tocra'">
                <svg viewBox="0 0 3732 2292">
                  <image type="full_archeo_map" width="3732" height="2292" href="{lower-case(@corresp)}"></image>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1136" target="_blank">
                      <rect class="info_bg" x="2200" y="328" width="780" height="96" fill="#d5eaf2"></rect>
                      <text class="info" x="2591" y="391" font-size="63" text-anchor="middle">1 - Necropolis, Quarry East 3</text>
                      <rect class="annotation" x="2558" y="421" fill="#0080FF30" width="65" height="65" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1116" target="_blank">
                      <rect class="info_bg" x="1630" y="568" width="460" height="96" fill="#d5eaf2"></rect>
                      <text class="info" x="1860" y="631" font-size="63" text-anchor="middle">9 - East Church</text>
                      <rect class="annotation" x="1824" y="661" fill="#0080FF30" width="73" height="73" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1131" target="_blank">
                      <rect class="info_bg" x="1920" y="1251" width="385" height="96" fill="#d5eaf2"></rect>
                      <text class="info" x="2110" y="1314" font-size="63" text-anchor="middle">8 - East gate</text>
                      <rect class="annotation" x="2075" y="1340" fill="#0080FF30" width="65" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1095" target="_blank">
                      <rect class="info_bg" x="2100" y="142" width="530" height="96" fill="#d5eaf2"></rect>
                      <text class="info" x="2365" y="205" font-size="63" text-anchor="middle">3 - Tocra Museum</text>
                      <rect class="annotation" x="2330" y="235" fill="#0080FF30" width="65" height="65" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/913" target="_blank">
                      <rect class="info_bg" x="3110" y="180" width="310" height="100" fill="#d5eaf2"></rect>
                      <text class="info" x="3261" y="250" font-size="63" text-anchor="middle">Taucheira</text>
                      <rect class="annotation" x="2890" y="55" fill="#0080FF30" width="740" height="130" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1118" target="_blank">
                      <rect class="info_bg" x="1455" y="145" width="700" height="96" fill="#d5eaf2"></rect>
                      <text class="info" x="1803" y="208" font-size="63" text-anchor="middle">4 - Archaic votive deposit</text>
                      <rect class="annotation" x="1770" y="233" fill="#0080FF30" width="65" height="70" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1128" target="_blank">
                      <rect class="info_bg" x="1300" y="1556" width="650" height="96" fill="#d5eaf2"></rect>
                      <text class="info" x="1623" y="1619" font-size="63" text-anchor="middle">12 - Byzantine 'fortress'</text>
                      <rect class="annotation" x="1576" y="1655" fill="#0080FF30" width="95" height="75" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                  <g class="annotation_group">
                    <a href="http://www.slsgazetteer.org/1124" target="_blank">
                      <rect class="info_bg" x="1665" y="1396" width="520" height="96" fill="#d5eaf2"></rect>
                      <text class="info" x="1918" y="1465" font-size="63" text-anchor="middle">11 - Gymnasium</text>
                      <rect class="annotation" x="1878" y="1495" fill="#0080FF30" width="85" height="75" stroke="blue" stroke-width="10"></rect>
                    </a>
                  </g>
                </svg>
              </xsl:when>
      <xsl:otherwise>
        <img alt="image" class="image" src="{lower-case(@corresp)}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
