xquery version "3.1" encoding "UTF-8";
declare namespace t = "http://www.tei-c.org/ns/1.0";

let $col := collection('../xml/epidoc/?select=*.xml')
(:let $list := doc('images_extra_data.xml'):)
return
          for $image in $col/t:TEI/t:facsimile//t:graphic[descendant::t:ref[text()!='']]
          let $root := $image//ancestor::t:TEI
          (:for $root in $col/t:TEI
          let $image := $root//t:facsimile[1]//t:graphic[descendant::t:ref[text()!='']][1]:)
          
          let $caption := normalize-space(string-join($image/t:desc/t:ref//text(), ' '))
          let $amshistorica := $image/t:desc/t:ref/@target/string()
          let $idno :=  $root//t:teiHeader//t:idno[@type='filename']/text()
          let $language :=  'GRC'
          let $origPlace := if(not(contains(lower-case(string-join($root//t:teiHeader//t:origPlace[1]/text(), ' ')), 'findspot'))) then ($root//t:teiHeader//t:origPlace/text()) else ($root//t:provenance[@type='found']//t:placeName[1]/text())
          let $licence :=  'https://creativecommons.org/licenses/by-nc-sa/4.0/'
          let $newuri :=  concat('https://igcyr2.unibo.it/en/', lower-case($root//t:teiHeader//t:idno[@type='filename'][1]/text()), '.html')
          let $uri :=  $root//t:teiHeader//t:idno[@type='URI']/text()
          let $tm :=  concat('https://www.trismegistos.org/text/', $root//t:teiHeader//t:idno[@type='TM'][1]/text())
          let $title :=  normalize-space(string-join($root//t:teiHeader//t:titleStmt//t:title//text(), ' '))
          let $date-when :=  $root//t:teiHeader//t:origDate/@when/string()
          let $date-notBefore :=  $root//t:teiHeader//t:origDate/@notBefore/string()
          let $date-notAfter :=  $root//t:teiHeader//t:origDate/@notAfter/string()
          let $support :=  normalize-space(string-join($root//t:teiHeader//t:support//text(), ' '))
          let $layout :=  normalize-space(string-join($root//t:teiHeader//t:layout//text(), ' '))
          let $material :=  normalize-space(string-join($root//t:teiHeader//t:material//text(), ' '))
          let $objectType :=  normalize-space(string-join($root//t:teiHeader//t:objectType//text(), ' '))
          let $execution :=  normalize-space(string-join($root//t:teiHeader//t:rs[@type='execution']//text(), ' '))
          let $unpublished := contains($root//t:div[@type='bibliography'], 'ot previously published')
          let $repository := normalize-space(string-join($root//t:teiHeader//t:msIdentifier//text(), ' '))
          let $divine := normalize-space(string-join($root//t:text//t:div[@type='edition']//t:persName[@type='divine']/@key/string(), '; '))
          let $ruler := normalize-space(string-join($root//t:text//t:div[@type='edition']//t:persName[@type='ruler']/@key/string(), '; '))
          
          (:let $equivalent := $list//graphic[descendant::ref=$amshistorica]:)
          (:let $author := $equivalent/author/text()
          let $when := $equivalent/when/text()
          let $date-range := $equivalent/date/text()
          let $data-provider := $equivalent/repository/text():)
          let $author := $image/t:desc/@resp/string()
          let $when := $image/t:desc/@n/string()
          let $date-range := $image/@n/string()
          let $data-provider := $image/t:desc/@source/string()
          
           return
           (:<item>{($idno, ' - ', $title, '$ ', $date-when, ' ',$date-notBefore, ' - ', $date-notAfter, '$ ', $language, '$ ', $origPlace, '$ ', $licence, '$ ', $newuri, '$ ', $uri, '$ ', $tm, '$ ', $material, '$ ', $objectType, '$ ', $execution, '$ ', $support, '$ ', $layout, '$ ', $divine, '$ ', $ruler)}
           </item>:)
           ('', $amshistorica, ' ', $caption, '$ ', $idno, ' - ', $title, '$ ', $author, '$ ', $when, '$ ', $date-when, ' ', $date-range, ' ', $date-notBefore, ' - ', $date-notAfter, '$ ', $language, '$ ', $origPlace, '$ ', $data-provider, '$ ', $licence, '$ ', $data-provider, '$ ', $newuri, '$ ', $uri, '$ ', $tm, '$ ', $material, '$ ', $objectType, '$ ', $execution, '$ ', $support, '$ ', $layout, '$ ', $divine, '$ ', $ruler, '
           ')
           (:('', $amshistorica, '$ ', $support, '$ ', $layout, '$ ', $divine, '$ ', $ruler, '
           '):)