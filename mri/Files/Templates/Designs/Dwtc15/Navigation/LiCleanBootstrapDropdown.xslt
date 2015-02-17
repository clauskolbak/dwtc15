<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<!--
	Description: ul/li based navigation. No features from admin implemented.
	Recommended settings:
	Fold out: True or False
	Upper menu: Dynamic or Static
	First level: > 0
	Last level: >= First level
	-->

	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"  encoding="utf-8" />
	<xsl:param name="html-content-type" />
	<xsl:template match="/NavigationTree">

		<xsl:if test="count(//Page) > 0">
			<ul>
				<xsl:if test="Settings/LayoutNavigationAttributes/@class!=''">
					<xsl:attribute name="class">
						<xsl:value-of select="Settings/LayoutNavigationAttributes/@class" disable-output-escaping="yes"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="Settings/LayoutNavigationAttributes/@id!=''">
					<xsl:attribute name="id">
						<xsl:value-of select="Settings/LayoutNavigationAttributes/@id" disable-output-escaping="yes"/>
					</xsl:attribute>
				</xsl:if>

				<xsl:apply-templates select="Page">
					<xsl:with-param name="depth" select="1"/>
				</xsl:apply-templates>
			</ul>
		</xsl:if>

	</xsl:template>

	<xsl:template match="//Page">
		<xsl:param name="depth"/>
		<xsl:if test="@Allowclick='True'">
		<li>
			<xsl:attribute name="class">

				<xsl:text disable-output-escaping="yes">dropdown</xsl:text>
				<xsl:if test="@RelativeLevel='1'">
					<xsl:text disable-output-escaping="yes"> dw-navbar-button</xsl:text>
				</xsl:if>
				<xsl:if test="@InPath='True' or @Active='True'"> active </xsl:if>
			</xsl:attribute>
			<a>
				<xsl:if test="@RelativeLevel='1'">
					<xsl:attribute name="class">dropdown-toggle</xsl:attribute>
					<xsl:attribute name="data-hover">dropdown</xsl:attribute>
					<xsl:attribute name="data-close-others">true</xsl:attribute>
				</xsl:if>
				<xsl:if test="@RelativeLevel='1' and @Sort='1'">
					<xsl:attribute name="id">homemenubtn</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="href">
					<xsl:value-of select="@FriendlyHref" disable-output-escaping="yes"/>
				</xsl:attribute>
				<xsl:value-of select="@MenuText" disable-output-escaping="yes"/>
				<span><xsl:comment/></span>
			</a>
			<xsl:if test="count(Page) and /NavigationTree/Settings/LayoutNavigationSettings/@endlevel > @RelativeLevel">
				<ul class="M{@AbsoluteLevel} dropdown-menu">
					<xsl:apply-templates select="Page">
						<xsl:with-param name="depth" select="$depth+1"/>
					</xsl:apply-templates>
				</ul>
			</xsl:if>
		</li>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>