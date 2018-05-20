<?xml version="1.0" encoding="UTF-8"?>
<!-- MTDfB API #1358 - Pension Scheme Administrator Subscription response transformation -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tns="http://hmrc.gov.uk/etmp/digitalgateway/PODS">
	<xsl:import href="UtilityTemplates.xslt"/>
	<xsl:output method="text" omit-xml-declaration="yes" indent="no" encoding="UTF-8"/>
	<xsl:template match="/">
		<xsl:variable name="temp">
			<xsl:call-template name="trimCommasFromEndOfString">
				<xsl:with-param name="value">
					<!-- processingDate -->
					<xsl:call-template name="writeStringValueIfPresent">
						<xsl:with-param name="key">processingDate</xsl:with-param>
						<xsl:with-param name="value" select="//tns:ETMP_TransactionResponse/tns:ETMP_Transaction_Header/tns:ProcessingDate"/>
					</xsl:call-template>
					<xsl:if test="//tns:ETMP_TransactionResponse/tns:PODSSubscriptionCreate_Response">
						<!-- formBundle -->
						<xsl:call-template name="writeStringValueIfPresent">
							<xsl:with-param name="key">formBundle</xsl:with-param>
							<xsl:with-param name="value" select="//tns:ETMP_TransactionResponse/tns:PODSSubscriptionCreate_Response/tns:FormBundleNumber"/>
						</xsl:call-template>
						<!-- psaId -->
						<xsl:call-template name="writeStringValueIfPresent">
							<xsl:with-param name="key">psaId</xsl:with-param>
							<xsl:with-param name="value" select="//tns:ETMP_TransactionResponse/tns:PODSSubscriptionCreate_Response/tns:PSAID"/>
						</xsl:call-template>
						<!-- utr -->
						<xsl:call-template name="writeStringValueIfPresent">
							<xsl:with-param name="key">utr</xsl:with-param>
							<xsl:with-param name="value" select="//tns:ETMP_TransactionResponse/tns:PODSSubscriptionCreate_Response/tns:UTR"/>
						</xsl:call-template>
						<!-- nino -->
						<xsl:call-template name="writeStringValueIfPresent">
							<xsl:with-param name="key">nino</xsl:with-param>
							<xsl:with-param name="value" select="//tns:ETMP_TransactionResponse/tns:PODSSubscriptionCreate_Response/tns:NINO"/>
						</xsl:call-template>
						<!-- countryCode -->
						<xsl:call-template name="writeStringValueIfPresent">
							<xsl:with-param name="key">countryCode</xsl:with-param>
							<xsl:with-param name="value" select="//tns:ETMP_TransactionResponse/tns:PODSSubscriptionCreate_Response/tns:Countrycode"/>
						</xsl:call-template>
						<!-- postalCode -->
						<xsl:call-template name="writeStringValueIfPresent">
							<xsl:with-param name="key">postalCode</xsl:with-param>
							<xsl:with-param name="value" select="//tns:ETMP_TransactionResponse/tns:PODSSubscriptionCreate_Response/tns:PostCode"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat('{ ',$temp,' }')"/>
	</xsl:template>
</xsl:stylesheet>
