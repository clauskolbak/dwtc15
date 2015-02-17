<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"  encoding="utf-8" />

  <xsl:template match="/NavigationTree">
    <xsl:if test="Page">
      <ul>
        <xsl:apply-templates select="Page"/>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Page">
    <li>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="@Href" disable-output-escaping="yes"/>
        </xsl:attribute>
        <xsl:value-of select="@MenuText" disable-output-escaping="yes"/>
      </a>
      <xsl:if test="Page">
        <ul>
          <xsl:apply-templates select="Page"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
</xsl:stylesheet>