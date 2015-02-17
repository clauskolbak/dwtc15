<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"  encoding="utf-8" />
<xsl:param name="html-content-type" />

<xsl:template match="/NavigationTree">
  <xsl:for-each select="Page">
    <xsl:if test="position() &gt; 1">
      <xsl:if test="position() &lt; 5">
	<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
	  <div class="row">
	    <h4>
	    <xsl:value-of select="@MenuText" disable-output-escaping="yes"/>
	    </h4>
	  </div>
	
	<xsl:for-each select="Page">
	  <xsl:if test="position() &lt; 8">
	    <div class="row">
	      <a>
	      <xsl:attribute name="href">
		<xsl:value-of select="@FriendlyHref" disable-output-escaping="yes"/>
	      </xsl:attribute>
	      <xsl:value-of select="@MenuText" disable-output-escaping="yes"/>
	      </a>
	    </div>
	  </xsl:if>
	</xsl:for-each>
	</div>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>