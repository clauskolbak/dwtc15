<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"  encoding="utf-8" />
<xsl:param name="html-content-type" />

<xsl:template match="/NavigationTree">
  <xsl:for-each select="Page">
    <xsl:if test="position() &gt; 1">
      <xsl:if test="position() &lt; 5">
	<a style="text-decoration: none; color: #959595;">
	<xsl:attribute name="href">
	  <xsl:value-of select="@FriendlyHref" disable-output-escaping="yes"/>
	</xsl:attribute>
	<xsl:value-of select="@MenuText" disable-output-escaping="yes"/>
	<span>&#160;&#160;&#160;</span>
	</a>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>