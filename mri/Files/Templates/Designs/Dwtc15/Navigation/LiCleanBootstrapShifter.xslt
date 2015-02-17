<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"  encoding="utf-8" />
<xsl:param name="html-content-type" />

<xsl:template match="/NavigationTree">
	<ul class="nav nav-pills nav-stacked">
  	<xsl:for-each select="Page">
  		<xsl:if test="position() &gt; 1">
  		<li class="nav-header">
		    <a>
		      	<xsl:attribute name="href">
				<xsl:value-of select="@FriendlyHref" disable-output-escaping="yes"/>
		     	</xsl:attribute>
		     	<xsl:value-of select="@MenuText" disable-output-escaping="yes"/>
		     </a>
		</li>
		<li class="nav-line">
			<hr class="nav-line-hr"></hr>
		</li>
	<xsl:for-each select="Page">
	  	<li>
		     <a>
		      	<xsl:attribute name="href">
				<xsl:value-of select="@FriendlyHref" disable-output-escaping="yes"/>
		      	</xsl:attribute>
		      	<xsl:value-of select="@MenuText" disable-output-escaping="yes"/>
		     </a>
	    </li>
	</xsl:for-each>
	</xsl:if>
  </xsl:for-each>
  </ul>
</xsl:template>

</xsl:stylesheet>