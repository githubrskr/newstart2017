<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:SOAP="http://schemas.xmlsoap.org/soap/envelope/">
	<xsl:output method="text" omit-xml-declaration="yes" indent="no" encoding="UTF-8" media-type="application/json"/>
	<!-- utility templates -->
	<xsl:template name="trimCommasFromEndOfString">
		<xsl:param name="value"/>
		<xsl:variable name="temp" select="normalize-space($value)"/>
		<xsl:variable name="end">
			<xsl:value-of select="substring($temp, string-length($temp))"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$end = ','">
				<xsl:call-template name="trimCommasFromEndOfString">
					<xsl:with-param name="value" select="substring($temp,0,string-length($temp))"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$temp"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="writeBooleanValueIfPresent">
		<xsl:param name="key"/>
		<xsl:param name="value"/>
		<xsl:if test="string-length(normalize-space($value))&gt;0">
			<xsl:text>"</xsl:text>
			<xsl:value-of select="$key"/>
			<xsl:text>":</xsl:text>
			<xsl:choose>
				<xsl:when test="normalize-space($value)='true' or normalize-space($value)='1' or normalize-space($value)='Y'">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="writeStringValueIfPresent">
		<xsl:param name="key"/>
		<xsl:param name="value"/>
		<xsl:if test="string-length(normalize-space($value))&gt;0">
			<xsl:text>"</xsl:text>
			<xsl:value-of select="$key"/>
			<xsl:text>":"</xsl:text>
			<xsl:value-of select="$value"/>
			<xsl:text>",</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="writeNumberValueIfPresent">
		<xsl:param name="key"/>
		<xsl:param name="value"/>
		<xsl:if test="string-length(normalize-space($value))&gt;0">
			<xsl:text>"</xsl:text>
			<xsl:value-of select="$key"/>
			<xsl:text>":</xsl:text>
			<xsl:value-of select="$value"/>
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="writeDateTimeValueIfPresent">
		<xsl:param name="key"/>
		<xsl:param name="value"/>
		<xsl:if test="string-length(normalize-space($value))&gt;0">
			<xsl:text>"</xsl:text>
			<xsl:value-of select="$key"/>
			<xsl:text>" : "</xsl:text>
			<xsl:value-of select="translate(translate(translate($value, '-', ''), ':', ''),'Z','')"/>
			<xsl:text>",</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="writeDateValueIfPresent">
		<xsl:param name="key"/>
		<xsl:param name="value"/>
		<xsl:if test="string-length(normalize-space($value))&gt;0">
			<xsl:text>"</xsl:text>
			<xsl:value-of select="$key"/>
			<xsl:text>" : "</xsl:text>
			<xsl:value-of select="format-date($value, '[Y0001]-[M01]-[D01]')"/>
			<xsl:text>",</xsl:text>
		</xsl:if>
	</xsl:template>
	 <xsl:template name="buildStringValue">
        <xsl:param name="value" />
        <xsl:variable name="strValue" select="normalize-space($value)"/>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="$strValue" />
        <xsl:text>",</xsl:text>
    </xsl:template>
</xsl:stylesheet>