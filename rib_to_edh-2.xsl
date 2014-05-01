<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"  
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs tei skos rdf xs" version="2.0">

<!-- 
     IRT - generate table for EDH
     RV 07-07-2009 ; GB 2009-12-08
     latest revision: 2012-06-21 GB

     RIB xml to EDH flat file (one xsl transformation)
     updates: 2014-03-10 PML
     updates: 2014-03-18 SV, PML
     updates: 2014-04-02 PML
     updates 2014-04-04 GB and PML
    updates 2014-04-09 JC, FG, PML 
    updates 2014-04-25 SV, PML
    
    
     to be run on RIB files list
    
     
-->
 
    
    <xsl:import href="../../EPIDOC-XSLT/start-txt.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:strip-space elements="w name"/>
   
    <xsl:template match="/">
        <EDH>
            <xsl:for-each select="//td[position()=3]">
                <xsl:if test="not(contains(preceding-sibling::td[2],'HD'))">
                <xsl:variable name="currentinscription">
                    <!--  path to be modified according to XML files directory -->
                    <xsl:sequence select="document(concat('rib',format-number(.,'00000'),'.xml'))"/>
                </xsl:variable>
                    <record><xsl:attribute name="ref"><xsl:value-of select=" concat('http://romaninscriptionsofbritain.org/rib/inscriptions/', $currentinscription//tei:idno[@type='rib'])"/></xsl:attribute>
                        <tmid><xsl:value-of select="concat('www.trismegistos.org/text/',preceding-sibling::td[1])"/></tmid>
                    <provinz><xsl:value-of select="$currentinscription//tei:geogName[@type='ancientRegion']"/></provinz>
                            <land>
                                <xsl:value-of select="$currentinscription//tei:geogName[@type='modernCountry']"/>
                            </land>
                            <fo_antik 
                                pleiades="{$currentinscription//tei:provenance[@type='found']/tei:placeName[@subtype='pleiades']/@ref[not(contains(.,'XXXXX'))]}">
                                <xsl:value-of select="$currentinscription//tei:provenance[@type='found']/tei:placeName[@subtype='pleiades'][not(contains(.,'XXXXX'))]"/>
                            </fo_antik>
                    <fo_modern>
                        <xsl:value-of select="$currentinscription//tei:origin/tei:placeName[1]"/>
                            </fo_modern>
                            <fundjahr>
                                <!-- Some RIB documents have more than one provenance, and thus more than one date, which made the original code fail -->
                                <xsl:value-of select="$currentinscription//tei:provenance/tei:date[1][@type='foundDate']/@when"/>
                            </fundjahr>
                        <fundstelle
                            geonames="{$currentinscription//tei:provenance[@type='found']/tei:placeName[@subtype='geonames']/@ref}">
                            <xsl:value-of select="$currentinscription//tei:provenance[@type='found']/tei:placeName[@subtype='geonames']"/>
                               </fundstelle>
                    <aufbewahrung><xsl:choose>
                        <!-- Some RIB documents have more than one msIdentifier/settlement, which made the original code fail -->
                        <xsl:when test="$currentinscription//tei:provenance[@type='lastLocation']//tei:orgName">
                            <xsl:value-of select="$currentinscription//tei:provenance[@type='lastLocation']//tei:orgName"/>
                        </xsl:when>
                        <xsl:otherwise><xsl:text>Findspot</xsl:text></xsl:otherwise>
                    </xsl:choose></aufbewahrung>
                            <dekor>
                                <xsl:if test="$currentinscription//tei:rs[@type='decoration']">
                                    
                                <xsl:attribute name="ref">
                                    <xsl:variable name="noquestion">
                                        <xsl:analyze-string select="$currentinscription//tei:rs[@type='decoration']" regex="(\w+)\?">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:matching-substring>            
                                            <xsl:non-matching-substring>
                                                <xsl:analyze-string select="." regex="(\w+),\s(\w*)">
                                                    <xsl:matching-substring> 
                                                        <xsl:value-of select="regex-group(1)"/>                     
                                                    </xsl:matching-substring>            
                                                    <xsl:non-matching-substring>
                                                        <xsl:value-of select="."/>
                                                    </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:variable>    
                                    <xsl:copy>
                                        <xsl:copy-of select="@*[not(local-name()='ref')]"/>
                                        <xsl:if test="text()">
                                            <xsl:variable name="voc_term">         
                                                <xsl:value-of select="document('https://raw.github.com/PietroLiuzzo/epidocupconversion/master/allinone/eagle-vocabulary-decoration.rdf')//skos:prefLabel[lower-case(.)=lower-case($noquestion)]/parent::skos:Concept/@rdf:about"/>
                                                <xsl:value-of select="document('https://raw.github.com/PietroLiuzzo/epidocupconversion/master/allinone/eagle-vocabulary-decoration.rdf')//skos:altLabel[lower-case(.)=lower-case($noquestion)]/parent::skos:Concept/@rdf:about"/>
                                            </xsl:variable>
                                            <xsl:if test="$voc_term!=''">
                                                <xsl:value-of select="$voc_term"/>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:attribute>
                                              <xsl:text>J</xsl:text>
                                </xsl:if>
                            </dekor>
                            <i_gattung>
                             <!--   <xsl:if test="$currentinscription//tei:term[1]">
                                <xsl:attribute name="ref">
                                    <xsl:variable name="noquestion">
                                        <xsl:analyze-string select="$currentinscription//tei:term[1]" regex="(\w+)\?">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:matching-substring>            
                                            <xsl:non-matching-substring>
                                                <xsl:analyze-string select="." regex="(\w+),\s(\w*)">
                                                    <xsl:matching-substring> 
                                                        <xsl:value-of select="regex-group(1)"/>                     
                                                    </xsl:matching-substring>            
                                                    <xsl:non-matching-substring>
                                                        <xsl:value-of select="."/>
                                                    </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:variable>
                                    
                                    <xsl:copy>
                                        <xsl:copy-of select="@*[not(local-name()='ref')]"/>
                                        <xsl:if test="text()">
                                            <xsl:variable name="voc_term">         
                                                <xsl:value-of select="document('https://raw.github.com/PietroLiuzzo/epidocupconversion/master/allinone/eagle-vocabulary-type-of-inscription.rdf')//skos:prefLabel[lower-case(.)=lower-case($noquestion)]/parent::skos:Concept/@rdf:about"/>
                                                <xsl:value-of select="document('https://raw.github.com/PietroLiuzzo/epidocupconversion/master/allinone/eagle-vocabulary-type-of-inscription.rdf')//skos:altLabel[lower-case(.)=lower-case($noquestion)]/parent::skos:Concept/@rdf:about"/>
                                            </xsl:variable>
                                            <xsl:if test="$voc_term!=''">
                                                <xsl:value-of select="$voc_term"/>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:attribute>
                                <xsl:value-of select="//tei:term[1]"/>
</xsl:if>                           -->
                              
                            </i_gattung>
                            <denkmaltyp>
                                <xsl:attribute name="ref">
                                    <xsl:variable name="noquestion">
                                        <xsl:analyze-string select="$currentinscription//tei:objectType" regex="(\w+)\?">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:matching-substring>            
                                            <xsl:non-matching-substring>
                                                <xsl:analyze-string select="." regex="(\w+),\s(\w*)">
                                                    <xsl:matching-substring> 
                                                        <xsl:value-of select="regex-group(1)"/>                     
                                                    </xsl:matching-substring>            
                                                    <xsl:non-matching-substring>
                                                        <xsl:value-of select="."/>
                                                    </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:variable>
                                    
                                    <xsl:copy>
                                        <xsl:copy-of select="@*[not(local-name()='ref')]"/>
                                        <xsl:if test="text()">
                                            <xsl:variable name="voc_term">         
                                                <xsl:value-of select="document('https://raw.github.com/PietroLiuzzo/epidocupconversion/master/allinone/eagle-vocabulary-object-type.rdf')//skos:prefLabel[lower-case(.)=lower-case($noquestion)]/parent::skos:Concept/@rdf:about"/>
                                                <xsl:value-of select="document('https://raw.github.com/PietroLiuzzo/epidocupconversion/master/allinone/eagle-vocabulary-object-type.rdf')//skos:altLabel[lower-case(.)=lower-case($noquestion)]/parent::skos:Concept/@rdf:about"/>
                                            </xsl:variable>
                                            <xsl:if test="$voc_term!=''">
                                                <xsl:value-of select="$voc_term"/>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:attribute>
                                <xsl:value-of select="$currentinscription//tei:objectType"/>
<!--                                here something more should be done to insert values compatible with EDH. Using the SKOS and matching the value of lang="de" ?-->
                            </denkmaltyp>
                            <material>
                                <xsl:attribute name="ref">
                                    <xsl:variable name="noquestion">
                                        <xsl:analyze-string select="$currentinscription//tei:material" regex="(\w+)\?">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:matching-substring>            
                                            <xsl:non-matching-substring>
                                                <xsl:analyze-string select="." regex="(\w+),\s(\w*)">
                                                    <xsl:matching-substring> 
                                                        <xsl:value-of select="regex-group(1)"/>                     
                                                    </xsl:matching-substring>            
                                                    <xsl:non-matching-substring>
                                                        <xsl:value-of select="."/>
                                                    </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:variable>
                                   
                                    <xsl:copy>
                                        <xsl:copy-of select="@*[not(local-name()='ref')]"/>
                                        <xsl:if test="text()">
                                            <xsl:variable name="voc_term">         
                                                <xsl:value-of select="document('https://raw.github.com/PietroLiuzzo/epidocupconversion/master/allinone/eagle-vocabulary-material.rdf')//skos:prefLabel[lower-case(.)=lower-case($noquestion)]/parent::skos:Concept/@rdf:about"/>
                                                <xsl:value-of select="document('https://raw.github.com/PietroLiuzzo/epidocupconversion/master/allinone/eagle-vocabulary-material.rdf')//skos:altLabel[lower-case(.)=lower-case($noquestion)]/parent::skos:Concept/@rdf:about"/>
                                            </xsl:variable>
                                            <xsl:if test="$voc_term!=''">
                                                    <xsl:value-of select="$voc_term"/>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:copy>
                                </xsl:attribute>
                                <xsl:value-of select="$currentinscription//tei:material"/>
                            </material>
 <xsl:choose>                      
     <xsl:when test="$currentinscription//tei:msPart">
         <xsl:for-each select="$currentinscription//tei:msPart">
<!--             needs to choose the higher area and insert those in cm with one decimal only for values up to 99cm-->
                                <frg n="{position()}">
                                    <hoehe>
                                <xsl:value-of select="current()//tei:height"/>
                            </hoehe>
                            <breite>
                                <xsl:value-of select="current()//tei:width"/>
                            </breite>
                            <tiefe>
                                <xsl:value-of select="current()//tei:depth"/>
                            </tiefe>
                                </frg>
                            </xsl:for-each>
</xsl:when>
     <xsl:otherwise><hoehe>
         <xsl:value-of select="$currentinscription//tei:support//tei:dimensions/tei:height"/>
     </hoehe>
         <breite>
             <xsl:value-of select="$currentinscription//tei:support//tei:dimensions/tei:width"/>
         </breite>
         <tiefe>
             <xsl:value-of select="$currentinscription//tei:support//tei:dimensions/tei:depth"/>
         </tiefe>
     </xsl:otherwise></xsl:choose>
                               <bh>
                                   <xsl:value-of select="$currentinscription//tei:layout/tei:dimensions/tei:hight"/>
                            </bh>
                            <metrik>
                                <xsl:value-of select="$currentinscription//tei:rs[@type='metre']"/>
                            </metrik>
                            <nl_text><!--non latin text-->
                                <xsl:if
                                    test="$currentinscription//tei:div[@type='edition']/descendant-or-self::*[@xml:lang='grc']">
                                    <xsl:text>A</xsl:text>
                                </xsl:if>
                            </nl_text>

                            <xsl:variable name="dates">
                                <xsl:for-each select="$currentinscription//tei:origDate">
                                    <xsl:sequence select="."/>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <date_von>
                                <xsl:choose><xsl:when test="$currentinscription//tei:origDate/@notBefore-custom"><xsl:value-of
                                        select="$currentinscription//tei:origDate/@notBefore-custom"
                                    /></xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="$currentinscription//tei:origDate"
                                    /></xsl:otherwise></xsl:choose>
<!--  can use in both format-date() to decide the output of the date-->
                            </date_von>
                            <dat_bis>
                                <xsl:choose><xsl:when test="$currentinscription//tei:origDate/@notAfter-custom"><xsl:value-of
                                    select="$currentinscription//tei:origDate/@notAfter-custom"
                                /></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="$currentinscription//tei:origDate"
                                        /></xsl:otherwise></xsl:choose>
                            </dat_bis>
                            <soziales>
                                <xsl:if test="$currentinscription//tei:rs[@type='socecon']">
                                    <xsl:text>J</xsl:text>
                                </xsl:if>
                            </soziales>
                            <religion>
                                <xsl:if test="$currentinscription//tei:rs[@type='religion']=('Jewish', 'Christian')">
                                    <xsl:text>2</xsl:text>
                                </xsl:if>
                                <xsl:if test="$currentinscription//tei:rs[@type='religion'][@nymRef='priesthood']">
                                    <xsl:text>3</xsl:text>
                                </xsl:if>
                            </religion>
                            <geographie>
                                <xsl:if test="$currentinscription//tei:div[@type='edition']//tei:placeName">
                                    <xsl:text>J</xsl:text>
                                </xsl:if>
                            </geographie>
                            <militaer>
                                <xsl:if test="$currentinscription//tei:div[@type='edition']//tei:rs[@type='military']">
                                    <xsl:text>J</xsl:text>
                                </xsl:if>
                            </militaer>
                            <beleg/>
                            <bearbeiter>
                                <xsl:value-of select="$currentinscription//tei:change[1]/@who"/>
                            </bearbeiter>
                            <datum>
                                <xsl:value-of select="$currentinscription//tei:change[1]/@when"/>  
                            </datum>
                <lit> 
                    <xsl:for-each select="$currentinscription//tei:bibl">
                        <lit_line><xsl:value-of select="."/></lit_line>
<!--                        CONCAT WITH VALUE of REFERENCE IN PTR -->
                    </xsl:for-each>
                </lit>
                
                        <kommentar>
                            <komm_line>
                                <xsl:value-of select="$currentinscription//tei:div[@type='commentary']/tei:p"/>
                            </komm_line>
                        </kommentar>
                            <xsl:variable name="names">
                                <xsl:for-each select="$currentinscription//tei:div[@type='edition']//tei:persName[not(@type='divine')]">
                                    <xsl:variable name="me" select="generate-id()"/>
                                    <xsl:if test="not(child::tei:w[@lemma='diuus'][generate-id(ancestor::tei:persName[1]) = $me]
                                        or descendant::tei:w[@lemma='diuus'][generate-id(ancestor::tei:persName[1]) = $me])">
                                        <xsl:if test="not(following-sibling::*[1][local-name()='w'][@lemma='filius' or @lemma='libertus' or @lemma='filia' or @lemma='liberta'] 
                                            and not(descendant::tei:name[@type='gentilicium' or @type='cognomen']))">
                                    <xsl:sequence select="."/>
                                        </xsl:if></xsl:if>
                                </xsl:for-each>
                            </xsl:variable>

                            <xsl:for-each select="$names/tei:persName[not(@type='divine')][descendant::tei:name]">
                                <xsl:variable name="namepos">
                                    <xsl:value-of select="position()"/>
                                </xsl:variable>
                                <Namen n="{position()}">
                                    <name>
                                        <xsl:variable name="namewithspaces"><xsl:apply-templates select=".">
                                            <xsl:with-param name="parm-leiden-style" tunnel="yes">edh-names</xsl:with-param>
                                            <xsl:with-param name="parm-line-inc" select="$line-inc" tunnel="yes" as="xs:double"/>
                                        </xsl:apply-templates></xsl:variable>
                                        <xsl:value-of select="normalize-space($namewithspaces)"/>
                                    </name>
                                    <praenomen>
                                        <xsl:variable name="praenomen">
                                            <xsl:if test=".//tei:name[@type='praenomen'][@nymRef]">
                                                
                                                  <xsl:variable name="me" select="generate-id()"/>
                                                  <xsl:for-each
                                                      select=".//tei:name[@type='praenomen'][@nymRef][generate-id(ancestor::tei:persName[1]) = $me]">
                                                      <xsl:sequence select="substring-after(./@nymRef,'#')"/>
                                                  </xsl:for-each>
                                                
                                                </xsl:if>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="$praenomen = 'Caius'">
                                                <xsl:text>C.</xsl:text>
                                            </xsl:when>
<!--                                     tokenize() the sequence? sequence retains xml values   double praenomen  if it ever happens  -->
                                            <xsl:when test="$praenomen = 'Cnaeus'">
                                                <xsl:text>Cn.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$praenomen = 'Decimus'">
                                                <xsl:text>D.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$praenomen = 'Lucius'">
                                                <xsl:text>L.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$praenomen = 'Manius'">
                                                <xsl:text>M'.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$praenomen = 'Marcus'">
                                                <xsl:text>M.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$praenomen = 'Publius'">
                                                <xsl:text>P.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$praenomen = 'Quintus'">
                                                <xsl:text>Q.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$praenomen = 'Seruius'">
                                                <xsl:text>Ser.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$praenomen = 'Tiberius'">
                                                <xsl:text>Ti.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$praenomen = 'Titus'">
                                                <xsl:text>T.</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$praenomen"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                            <xsl:when test=".//tei:name[@type='praenomen'][1][child::tei:supplied[@reason='lost']] 
                                                or .//tei:name[@type='praenomen'][1][descendant::tei:supplied[@reason='lost']] 
                                                or .//tei:name[@type='praenomen'][1][parent::tei:supplied[@reason='lost']]
                                                or .//tei:name[@type='praenomen'][1][ancestor::tei:supplied[@reason='lost']]">
                                                <xsl:text>+</xsl:text>
                                            </xsl:when>
                                            <xsl:when test=".//tei:name[@type='praenomen'][1]/tei:del 
                                                or .//tei:name[@type='praenomen'][1]//tei:del 
                                                or .//tei:name[@type='praenomen'][1][parent::tei:del]
                                                or .//tei:name[@type='praenomen'][1][ancestor::tei:del]">
                                                <xsl:text>++</xsl:text>
                                            </xsl:when>
                                        </xsl:choose>
                                    </praenomen>
                                    <nomen>
                                        <xsl:if test=".//tei:name[@type='gentilicium'][@nymRef]">
                                            <!-- Some RIB documents have more than one persNames with more than one nomen, which made the original code fail -->
                                            <xsl:analyze-string select="(.//tei:name[@type='gentilicium'])[1]/@nymRef" regex="#"> 
                                                <xsl:non-matching-substring><xsl:value-of
                                                select="."/></xsl:non-matching-substring></xsl:analyze-string>
                                            <xsl:if test=".//tei:name[@type='gentilicium'][1]/tei:expan or .//tei:name[@type='gentilicium'][1]//tei:expan">
                                                <xsl:text>*</xsl:text>
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test=".//tei:name[@type='gentilicium'][1]/tei:supplied[@reason='lost'] 
                                                    or .//tei:name[@type='gentilicium'][1]//tei:supplied[@reason='lost'] 
                                                    or .//tei:name[@type='gentilicium'][1][parent::tei:supplied[@reason='lost']]
                                                    or .//tei:name[@type='gentilicium'][1][ancestor::tei:supplied[@reason='lost']]">
                                                    <xsl:text>+</xsl:text>
                                                </xsl:when>
                                                <xsl:when test=".//tei:name[@type='gentilicium'][1]/tei:del 
                                                    or .//tei:name[@type='gentilicium'][1]//tei:del 
                                                    or .//tei:name[@type='gentilicium'][1][parent::tei:del]
                                                    or .//tei:name[@type='gentilicium'][1][ancestor::tei:del]">
                                                    <xsl:text>++</xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:if>
                                    </nomen>
                                    <cognomen>
                                        <xsl:for-each select=".//tei:name[@type='cognomen'][@nymRef][not(@nymRef =
                                            ('Adiabenicus','Alamannicus','Alanicus','Anticus','Arabicus','Armeniacus','Britannicus',
                                            'Carpicus','Dacicus','Francicus','Gallicus','Germanicus','Gipidicus','Gothicus','Herullicus',
                                            'Medicus','Palmyrenicus','Parthicus','Persicus','Pius','Sarmaticus','Vandalicus'))]">
                                            <xsl:analyze-string regex="#" select="@nymRef"><xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring></xsl:analyze-string>
                                            <xsl:if test="child::tei:expan or descendant::tei:expan">
                                                <xsl:text>*</xsl:text>
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test="child::tei:supplied[@reason='lost'] 
                                                    or descendant::tei:supplied[@reason='lost'] 
                                                    or parent::tei:supplied[@reason='lost']
                                                    or ancestor::tei:supplied[@reason='lost']">
                                                    <xsl:text>+</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="child::tei:del 
                                                    or descendant::tei:del 
                                                    or parent::tei:del
                                                    or ancestor::tei:del">
                                                    <xsl:text>++</xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                            <xsl:if test="not(position()=last())">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </cognomen>
                                    <supernomen>
                                        <xsl:for-each select=".//tei:name[@type='supernomen'][@nymRef]">
                                            <xsl:value-of select="@nymRef"/>
                                            <xsl:if test="not(position()=last())">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </supernomen>
                                    <tribus>
                                        <xsl:for-each select=".//tei:name[@type='tribe'][@nymRef]">
                                            <xsl:value-of select="@nymRef"/>
                                            <xsl:if test="not(position()=last())">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </tribus>
                                </Namen>
                            </xsl:for-each>
                            <origo/>
                            <geschlecht/>
                            <status/>
                            <beruf/>
                            <l_jahre/>
                            <l_monate/>
                            <l_tage/>
                            <l_stunden/>
                            <textus>
                                <xsl:variable name="text"><xsl:for-each select="$currentinscription//tei:div[@type='edition'][not(@subtype)]/tei:ab[@type='markup']">      
                                    <xsl:apply-templates select=".">
                                        <xsl:with-param name="parm-leiden-style" tunnel="yes">edh-itx</xsl:with-param>
                                       <xsl:with-param name="parm-line-inc" select="$line-inc" tunnel="yes" as="xs:double"/>
                                    </xsl:apply-templates>
                                </xsl:for-each></xsl:variable>
                                <xsl:value-of select="normalize-space($text)"/>
                            </textus>
                        </record>
                </xsl:if>
            </xsl:for-each>
            
        </EDH>
    </xsl:template>

    <xsl:template match="tei:rs[@type='dimensions']">
        <xsl:for-each select="tei:measure">
            <xsl:if test="not(last())">
                <xsl:value-of select="."/>
                <xsl:text> x </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="tei:head"/>

</xsl:stylesheet>