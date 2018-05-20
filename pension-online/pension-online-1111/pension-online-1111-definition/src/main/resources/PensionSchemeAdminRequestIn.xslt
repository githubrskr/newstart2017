<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:SOAP="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:subm="http://hmrc.gov.uk/etmp/digitalgateway/PODS"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions" version="2.0" exclude-result-prefixes="#all">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="UTF-8" />
    <xsl:param name="transmittingSystem" />
    <xsl:param name="originatingSystem" />
    <xsl:param name="receiptDate"/>  
    <xsl:param name="acknowledgementRefValue"></xsl:param>
    <xsl:template match="/">
       <xsl:variable name="current" select="current-dateTime()"/>
        <subm:ETMP_Transaction>
            <subm:ETMP_Transaction_Header>
                <subm:TransmittingSystem>
                    <xsl:value-of select="$transmittingSystem" />
                </subm:TransmittingSystem>
                <subm:OriginatingSystem>
                    <xsl:value-of select="$originatingSystem" />
                </subm:OriginatingSystem>
                <subm:ReceiptDate>
                    <xsl:choose>
                        <xsl:when test="$receiptDate">
                            <xsl:value-of select="$receiptDate"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$current"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </subm:ReceiptDate>
                <subm:AcknowledgementReference>
                   <xsl:value-of select="$acknowledgementRefValue"/>    
                </subm:AcknowledgementReference>
                <subm:MessageTypes>
                    <subm:MessageType>SubscriptionCreate</subm:MessageType>
                </subm:MessageTypes>
                <subm:RequestParameters>
                    <subm:ParamName>REGIME</subm:ParamName>
                    <subm:ParamValue>PODA</subm:ParamValue>
                </subm:RequestParameters>
                <subm:RequestParameters>
                    <subm:ParamName>SAP_NUMBER</subm:ParamName>
                    <subm:ParamValue>
                        <xsl:value-of select="/jsonObject/sapNumber" />
                    </subm:ParamValue>
                </subm:RequestParameters>
            </subm:ETMP_Transaction_Header>
            <xsl:call-template name="PSASubscriptionRequestType" />
        </subm:ETMP_Transaction>
    </xsl:template>
    <xsl:template name="PSASubscriptionRequestType">
        <subm:PSA_SubscriptionReq>
            <xsl:call-template name="SubscriptionType" />
            <xsl:call-template name="LegalStatusAndIdType" />
            <xsl:call-template name="OrganisationDetails" />
            <xsl:call-template name="IndividualDetails" />
            <xsl:call-template name="PSAIDFlag" />
            <xsl:call-template name="CorrespondenceAddressDetails" /> 
            <xsl:call-template name="CorrespondenceContactDetails" />
            <xsl:call-template name="PreviousAddressDetails" /> 
            <xsl:call-template name="DirOrPartnersDetails" />
            <xsl:call-template name="EntityAndDirOrPartnrDetails" />
            <xsl:call-template name="DeclarationDetails" />
       </subm:PSA_SubscriptionReq>
    </xsl:template>
    <!-- Template for SubscriptionType -->
    <xsl:template name="SubscriptionType">
        <xsl:if test="/jsonObject/customerType">
            <subm:SubscriptionGeneric>
              <xsl:choose>
                <xsl:when test="/jsonObject/customerType = 'UK'">
                     <subm:NonUKCustomer>false</subm:NonUKCustomer>
                </xsl:when>
                <xsl:when test="/jsonObject/customerType = 'NON-UK'">
                     <subm:NonUKCustomer>true</subm:NonUKCustomer>
                </xsl:when> 
             </xsl:choose>  
             </subm:SubscriptionGeneric>
        </xsl:if>
    </xsl:template>
    <!-- Template for LegalStatusAndIdType -->
    <xsl:template name="LegalStatusAndIdType">
            <subm:LegalEntityAndCustID>
              <xsl:choose>
                <xsl:when test="/jsonObject/legalStatus = 'Individual'">
                     <subm:LegalStatus>1</subm:LegalStatus>
                </xsl:when>
                <xsl:when test="/jsonObject/legalStatus = 'Partnership'">
                     <subm:LegalStatus>3</subm:LegalStatus>
                </xsl:when> 
                <xsl:when test="/jsonObject/legalStatus = 'Limited Company'">
                     <subm:LegalStatus>7</subm:LegalStatus>
                </xsl:when> 
             </xsl:choose>   

            <xsl:if test="/jsonObject/idType">
                <subm:IDType><xsl:value-of select="/jsonObject/idType"/></subm:IDType>
            </xsl:if>

            <xsl:if test="/jsonObject/idNumber">
                <subm:IDNumber><xsl:value-of select="/jsonObject/idNumber"/></subm:IDNumber>
            </xsl:if>
            
            <xsl:if test="/jsonObject/noIdentifier">
                <subm:NoIdentifier><xsl:value-of select="/jsonObject/noIdentifier"/></subm:NoIdentifier>
            </xsl:if>
            
           </subm:LegalEntityAndCustID>
    </xsl:template>
    <!-- Template for OrganisationDetails -->
    <xsl:template name="OrganisationDetails">
        <xsl:if test="/jsonObject/organisationDetail">
            <subm:OrganisationDetails>

                <xsl:if test="/jsonObject/name">
                    <subm:OrganisationName>
                        <xsl:value-of select="/jsonObject/name" />
                    </subm:OrganisationName>                
                </xsl:if>

                <xsl:if test="/jsonObject/crnNumber">
                    <subm:CRNNumber>
                        <xsl:value-of select="/jsonObject/crnNumber" />
                    </subm:CRNNumber>
                </xsl:if>
                <xsl:if test="/jsonObject/crnNumber">
                    <subm:VATRegNumber>
                        <xsl:value-of select="/jsonObject/vatRegistrationNumber" />
                    </subm:VATRegNumber>
                </xsl:if> 
                <xsl:if test="/jsonObject/payeReference">
                    <subm:PAYEReference>
                        <xsl:value-of select="/jsonObject/payeReference" />
                    </subm:PAYEReference>
                </xsl:if>
            </subm:OrganisationDetails>
        </xsl:if>
    </xsl:template>
    <!-- Template for IndividualDetails -->
    <xsl:template name="IndividualDetails">
        <xsl:if test="/jsonObject/individualDetail">
            <subm:IndividualDetails>
                <xsl:if test="/jsonObject/title">
                  <xsl:choose>
                    <xsl:when test="/jsonObject/legalStatus = 'Mr'">
                         <subm:Title>0001</subm:Title>
                    </xsl:when>
                    <xsl:when test="/jsonObject/legalStatus = 'Mrs'">
                         <subm:Title>0002</subm:Title>
                    </xsl:when> 
                    <xsl:when test="/jsonObject/legalStatus = 'Miss'">
                         <subm:Title>0003</subm:Title>
                    </xsl:when> 
                    <xsl:when test="/jsonObject/legalStatus = 'Ms'">
                         <subm:Title>0004</subm:Title>
                    </xsl:when> 
                    <xsl:when test="/jsonObject/legalStatus = 'Dr'">
                         <subm:Title>0005</subm:Title>
                    </xsl:when> 
                    <xsl:when test="/jsonObject/legalStatus = 'Sir'">
                         <subm:Title>0006</subm:Title>
                    </xsl:when> 
                    <xsl:when test="/jsonObject/legalStatus = 'Professor'">
                         <subm:Title>0009</subm:Title>
                    </xsl:when> 
                    <xsl:when test="/jsonObject/legalStatus = 'Lord'">
                         <subm:Title>0010</subm:Title>
                    </xsl:when>  
                 </xsl:choose>  
                </xsl:if> 
                <subm:FirstName><xsl:value-of select="/jsonObject/individualDetail/firstName" /></subm:FirstName>
                <xsl:if test="/jsonObject/individualDetail/middleName">
                    <subm:MiddleName>
                        <xsl:value-of select="/jsonObject/individualDetail/middleName" />
                    </subm:MiddleName>
                </xsl:if>
                <xsl:if test="/jsonObject/individualDetail/lastName">
                    <subm:LastName>
                        <xsl:value-of select="/jsonObject/individualDetail/lastName" />
                    </subm:LastName>
                </xsl:if>
                <subm:DateofBirth><xsl:value-of select="/jsonObject/individualDetail/dateOfBirth" /></subm:DateofBirth>  
             </subm:IndividualDetails>
        </xsl:if>
    </xsl:template>
    <!-- Template for PSAIDFlag -->
    <xsl:template name="PSAIDFlag">
        <xsl:if test="/jsonObject/pensionSchemeAdministratoridentifierStatus">
            <subm:ExistingPSAID>
                <xsl:if test="/jsonObject/pensionSchemeAdministratoridentifierStatus/isExistingPensionSchemaAdministrator">
                    <subm:ExistingPSAID>
                        <xsl:value-of select="/jsonObject/pensionSchemeAdministratoridentifierStatus/isExistingPensionSchemaAdministrator" />
                    </subm:ExistingPSAID>
                </xsl:if>
    
                <xsl:if test="/jsonObject/pensionSchemeAdministratoridentifierStatus/existingPensionSchemaAdministratorReference">
                    <subm:ExistingPSAIDReference>
                        <xsl:value-of select="/jsonObject/pensionSchemeAdministratoridentifierStatus/existingPensionSchemaAdministratorReference" />
                    </subm:ExistingPSAIDReference>
                </xsl:if>
            </subm:ExistingPSAID>
        </xsl:if>
    </xsl:template> 
    
    
    <!-- Template for CorrespondenceAddressDetails -->
    <xsl:template name="CorrespondenceAddressDetails">
        <xsl:if test="/jsonObject/correspondenceAddressDetail">
            <subm:CorrespondenceAddressDetails>
				  <xsl:choose>
					<xsl:when test="/jsonObject/correspondenceAddressDetail/addressType = 'UK'">
						 <subm:NonUKAddress>false</subm:NonUKAddress>
					</xsl:when>
					<xsl:when test="/jsonObject/correspondenceAddressDetail/addressType = 'NON-UK'">
						 <subm:NonUKAddress>true</subm:NonUKAddress>
					</xsl:when> 
				 </xsl:choose> 
                
                <subm:AddressLine1><xsl:value-of select="/jsonObject/correspondenceAddressDetail/line1" /></subm:AddressLine1>
                <subm:AddressLine2><xsl:value-of select="/jsonObject/correspondenceAddressDetail/line2" /></subm:AddressLine2>
                
                 <xsl:if test="/jsonObject/correspondenceAddressDetail/line3"> 
                      <subm:AddressLine3><xsl:value-of select="/jsonObject/correspondenceAddressDetail/line3" /></subm:AddressLine3>
                 </xsl:if>
 
                 <xsl:if test="/jsonObject/correspondenceAddressDetail/line4"> 
                      <subm:AddressLine4><xsl:value-of select="/jsonObject/correspondenceAddressDetail/line4" /></subm:AddressLine4>
                 </xsl:if>
                 <xsl:if test="/jsonObject/correspondenceAddressDetail/postalCode"> 
                      <subm:PostCode><xsl:value-of select="/jsonObject/correspondenceAddressDetail/postalCode" /></subm:PostCode>
                 </xsl:if>
                 <xsl:if test="/jsonObject/correspondenceAddressDetail/countryCode">  
                       <subm:CountryCode><xsl:value-of select="/jsonObject/correspondenceAddressDetail/countryCode" /></subm:CountryCode>
                 </xsl:if>  
            </subm:CorrespondenceAddressDetails>
        </xsl:if>
    </xsl:template>
    
    
    <!-- Template for CorrespondenceContactDetails -->
    <xsl:template name="CorrespondenceContactDetails">
        <xsl:if test="/jsonObject/correspondenceContactDetail">
            <subm:CorrespondenceContactDetails>
                 <xsl:if test="/jsonObject/correspondenceContactDetail/telephone">  
                       <subm:Telephone><xsl:value-of select="/jsonObject/correspondenceContactDetail/telephone" /></subm:Telephone>
                 </xsl:if>  
                 <xsl:if test="/jsonObject/correspondenceContactDetail/mobileNumber">  
                       <subm:Mobile><xsl:value-of select="/jsonObject/correspondenceContactDetail/mobileNumber" /></subm:Mobile>
                 </xsl:if>  
                 <xsl:if test="/jsonObject/correspondenceContactDetail/fax">  
                       <subm:Fax><xsl:value-of select="/jsonObject/correspondenceContactDetail/fax" /></subm:Fax>
                 </xsl:if>  
                 <xsl:if test="/jsonObject/correspondenceContactDetail/email">  
                       <subm:Email><xsl:value-of select="/jsonObject/correspondenceContactDetail/email" /></subm:Email>
                 </xsl:if>  
            </subm:CorrespondenceContactDetails>
        </xsl:if>
    </xsl:template>
    
        <!-- Template for PreviousAddressDetails -->
    <xsl:template name="PreviousAddressDetails">
        <xsl:if test="/jsonObject/previousAddressDetail">
            <subm:PreviousAddressDetails>
                 <xsl:if test="/jsonObject/previousAddressDetail/isPreviousAddressLast12Month">  
                       <subm:PrevAddLast12mon><xsl:value-of select="/jsonObject/previousAddressDetail/isPreviousAddressLast12Month" /></subm:PrevAddLast12mon>
                 </xsl:if>  
                 <xsl:if test="/jsonObject/previousAddressDetail/previousAddressDetail">  
                   <subm:PrevAddressDetails> 
                        <xsl:choose>
	
							<xsl:when test="/jsonObject/previousAddressDetail/previousAddressDetail/addressType = 'UK'">
								 <subm:NonUKAddress>false</subm:NonUKAddress>
							</xsl:when>
							<xsl:when test="/jsonObject/previousAddressDetail/previousAddressDetail/addressType = 'NON-UK'">
								 <subm:NonUKAddress>true</subm:NonUKAddress>
							</xsl:when> 
						</xsl:choose>
   
                        <subm:AddressLine1><xsl:value-of select="/jsonObject/previousAddressDetail/previousAddressDetail/line1" /></subm:AddressLine1>
                        <subm:AddressLine2><xsl:value-of select="/jsonObject/previousAddressDetail/previousAddressDetail/line2" /></subm:AddressLine2>
                        
                         <xsl:if test="/jsonObject/previousAddressDetail/previousAddressDetail/line3"> 
                              <subm:AddressLine3><xsl:value-of select="/jsonObject/previousAddressDetail/previousAddressDetail/line3" /></subm:AddressLine3>
                         </xsl:if>
         
                         <xsl:if test="/jsonObject/previousAddressDetail/previousAddressDetail/line4"> 
                              <subm:AddressLine4><xsl:value-of select="/jsonObject/previousAddressDetail/previousAddressDetail/line4" /></subm:AddressLine4>
                         </xsl:if>
                         
                         <xsl:if test="/jsonObject/previousAddressDetail/previousAddressDetail/postalCode"> 
                              <subm:PostCode><xsl:value-of select="/jsonObject/previousAddressDetail/previousAddressDetail/postalCode" /></subm:PostCode>
                         </xsl:if>
                         
                         <xsl:if test="/jsonObject/previousAddressDetail/previousAddressDetail/countryCode">  
                               <subm:CountryCode><xsl:value-of select="/jsonObject/previousAddressDetail/previousAddressDetail/countryCode" /></subm:CountryCode>
                         </xsl:if>   
                   </subm:PrevAddressDetails>  
                 </xsl:if>  
             </subm:PreviousAddressDetails>
        </xsl:if>
    </xsl:template>

    
    
    <!-- Template for DirOrPartnersDetails -->
    <xsl:template name="DirOrPartnersDetails">
        <xsl:if test="/jsonObject/numberOfDirectorOrPartners">
            <subm:NumOfDirOrPartnrsDetails>
                <xsl:if test="/jsonObject/numberOfDirectorOrPartners/isMorethanTenDirectors">
                  <xsl:choose>

                    <xsl:when test="/jsonObject/numberOfDirectorOrPartners/isMorethanTenDirectors = 'true'">
                         <subm:DirectorsMorethan10>Yes</subm:DirectorsMorethan10>
                    </xsl:when>
                    <xsl:when test="/jsonObject/numberOfDirectorOrPartners/isMorethanTenDirectors = 'false'">
                         <subm:DirectorsMorethan10>No</subm:DirectorsMorethan10>
                    </xsl:when> 
                 </xsl:choose>   
                </xsl:if>
             </subm:NumOfDirOrPartnrsDetails>
        </xsl:if>
    </xsl:template>
    
    
    <!-- Template for EntityAndDirOrPartnrDetails -->
    <xsl:template name="EntityAndDirOrPartnrDetails">
       <xsl:if test="/jsonObject/directorOrPartnerDetail">
       
         <xsl:for-each select="/jsonObject/directorOrPartnerDetail">

            <subm:EntityAndDirOrPartnrDetails>  

                <xsl:if test="./sequenceId">
                    <subm:SeqID><xsl:value-of select="sequenceId" /></subm:SeqID>
                </xsl:if>

                <xsl:choose>
                
                     <xsl:when test="./entityType = 'Director'">
                             <subm:EntityType>D</subm:EntityType>
                     </xsl:when>
                     
                     <xsl:when test="./entityType = 'Partner'">
                             <subm:EntityType>P</subm:EntityType>
                     </xsl:when> 
                 
                 </xsl:choose>


                <xsl:if test="./title">
                  <xsl:choose>
                    <xsl:when test="./title = 'Mr'">
                         <subm:Title>0001</subm:Title>
                    </xsl:when>
                    <xsl:when test="./title = 'Mrs'">
                         <subm:Title>0002</subm:Title>
                    </xsl:when> 
                    <xsl:when test="./title = 'Miss'">
                         <subm:Title>0003</subm:Title>
                    </xsl:when> 
                    <xsl:when test="./title = 'Ms'">
                         <subm:Title>0004</subm:Title>
                    </xsl:when> 
                    <xsl:when test="./title = 'Dr'">
                         <subm:Title>0005</subm:Title>
                    </xsl:when> 
                    <xsl:when test="./title = 'Sir'">
                         <subm:Title>0006</subm:Title>
                    </xsl:when> 
                    <xsl:when test="./title = 'Professor'">
                         <subm:Title>0009</subm:Title>
                    </xsl:when> 
                    <xsl:when test="./title = 'Lord'">
                         <subm:Title>0010</subm:Title>
                    </xsl:when>  
                 </xsl:choose>  
                </xsl:if>

                <xsl:if test="./firstName">
                   <subm:FirstName><xsl:value-of select="firstName" /></subm:FirstName>
                </xsl:if>

                <xsl:if test="./middleName">
                   <subm:MiddleName><xsl:value-of select="middleName" /></subm:MiddleName>
                </xsl:if>

                <xsl:if test="./lastName">
                    <subm:LastName><xsl:value-of select="lastName" /></subm:LastName>
                </xsl:if>

                <xsl:if test="./dateOfBirth">
                   <subm:DateofBirth><xsl:value-of select="dateOfBirth" /></subm:DateofBirth>
                </xsl:if>

                <xsl:if test="./referenceOrNino">
                   <subm:NINORef><xsl:value-of select="referenceOrNino" /></subm:NINORef>
                </xsl:if>

                <xsl:if test="./noNinoReason">
                   <subm:IfnoNINOreason><xsl:value-of select="noNinoReason" /></subm:IfnoNINOreason>
               </xsl:if>

                <xsl:if test="./utr">
                   <subm:UTRRef><xsl:value-of select="utr" /></subm:UTRRef>
               </xsl:if>

                <xsl:if test="./noUtrReason">
                   <subm:IfnoUTRreason><xsl:value-of select="noUtrReason" /></subm:IfnoUTRreason>
               </xsl:if>   
                <xsl:if test="/jsonObject/directorOrPartnerDetail/correspondenceCommonDetail">
                   <subm:CorrespCommDeails> 
                            <xsl:if test="/jsonObject/directorOrPartnerDetail/correspondenceCommonDetail/addressDetail">
                                <subm:AddressDetails>         
                                    <xsl:choose>                    
										<xsl:when test="/jsonObject/directorOrPartnerDetail/correspondenceCommonDetail/addressDetail/addressType = 'UK'">
										   <subm:NonUKAddress>false</subm:NonUKAddress>
										</xsl:when>
										
										<xsl:when test="/jsonObject/directorOrPartnerDetail/correspondenceCommonDetail/addressDetail/addressType = 'NON-UK'">
											 <subm:NonUKAddress>true</subm:NonUKAddress>
										</xsl:when> 
  								    </xsl:choose>
   
                                    
                                    <subm:AddressLine1><xsl:value-of select="correspondenceCommonDetail/addressDetail/line1" /></subm:AddressLine1>
                                    <subm:AddressLine2><xsl:value-of select="correspondenceCommonDetail/addressDetail/line2" /></subm:AddressLine2>
                                    
                                     <xsl:if test="correspondenceCommonDetail/addressDetail/line3"> 
                                          <subm:AddressLine3><xsl:value-of select="correspondenceCommonDetail/addressDetail/line3" /></subm:AddressLine3>
                                     </xsl:if>
                     
                                     <xsl:if test="correspondenceCommonDetail/addressDetail/line4"> 
                                          <subm:AddressLine4><xsl:value-of select="correspondenceCommonDetail/addressDetail/line4" /></subm:AddressLine4>
                                     </xsl:if>
                                     
                                     <xsl:if test="correspondenceCommonDetail/addressDetail/postalCode"> 
                                          <subm:PostCode><xsl:value-of select="correspondenceCommonDetail/addressDetail/postalCode" /></subm:PostCode>
                                     </xsl:if>
                                     
                                     <xsl:if test="correspondenceCommonDetail/addressDetail/countryCode">  
                                           <subm:CountryCode><xsl:value-of select="correspondenceCommonDetail/addressDetail/countryCode" /></subm:CountryCode>
                                     </xsl:if>   
                                 </subm:AddressDetails> 
                              </xsl:if>    
                              
                              <xsl:if test="correspondenceCommonDetail/contactDetail">
                                    <subm:ContactDetails>
                                         <xsl:if test="correspondenceCommonDetail/contactDetail/telephone">  
                                               <subm:Telephone><xsl:value-of select="correspondenceCommonDetail/contactDetail/telephone" /></subm:Telephone>
                                         </xsl:if>  
                                         <xsl:if test="correspondenceCommonDetail/contactDetail/mobileNumber">  
                                               <subm:Mobile><xsl:value-of select="correspondenceCommonDetail/contactDetail/mobileNumber" /></subm:Mobile>
                                         </xsl:if>  
                                         <xsl:if test="correspondenceCommonDetail/contactDetail/fax">  
                                               <subm:Fax><xsl:value-of select="correspondenceCommonDetail/contactDetail/fax" /></subm:Fax>
                                         </xsl:if>  
                                         <xsl:if test="correspondenceCommonDetail/contactDetail/email">  
                                               <subm:Email><xsl:value-of select="correspondenceCommonDetail/contactDetail/email" /></subm:Email>
                                         </xsl:if>  
                                    </subm:ContactDetails>
                            </xsl:if> 
                   </subm:CorrespCommDeails>
                 </xsl:if> 
                 <xsl:if test="/jsonObject/directorOrPartnerDetail/previousAddressDetail">  
                         <subm:PrevAddressDetails>
                             <xsl:if test="previousAddressDetail/isPreviousAddressLast12Month">  
                                   <subm:PrevAddLast12mon><xsl:value-of select="previousAddressDetail/isPreviousAddressLast12Month" /></subm:PrevAddLast12mon>
                             </xsl:if>  
                             <xsl:if test="previousAddressDetail/previousAddressDetail">  
                               <subm:PrevAddressDetails> 
                                     <xsl:choose>
										<xsl:when test="previousAddressDetail/previousAddressDetail/addressType = 'UK'">
											 <subm:NonUKAddress>false</subm:NonUKAddress>
										</xsl:when>
										<xsl:when test="previousAddressDetail/previousAddressDetail/addressType = 'NON-UK'">
											 <subm:NonUKAddress>true</subm:NonUKAddress>
										</xsl:when> 
                                    </xsl:choose>

                                    <subm:AddressLine1><xsl:value-of select="previousAddressDetail/previousAddressDetail/line1" /></subm:AddressLine1>
                                    <subm:AddressLine2><xsl:value-of select="previousAddressDetail/previousAddressDetail/line2" /></subm:AddressLine2>
                                    
                                     <xsl:if test="previousAddressDetail/previousAddressDetail/line3"> 
                                          <subm:AddressLine3><xsl:value-of select="previousAddressDetail/previousAddressDetail/line3" /></subm:AddressLine3>
                                     </xsl:if>
                     
                                     <xsl:if test="previousAddressDetail/previousAddressDetail/line4"> 
                                          <subm:AddressLine4><xsl:value-of select="previousAddressDetail/previousAddressDetail/line4" /></subm:AddressLine4>
                                     </xsl:if>
                                     
                                     <xsl:if test="previousAddressDetail/previousAddressDetail/postalCode"> 
                                          <subm:PostCode><xsl:value-of select="previousAddressDetail/previousAddressDetail/postalCode" /></subm:PostCode>
                                     </xsl:if>
                                     
                                     <xsl:if test="previousAddressDetail/previousAddressDetail/countryCode">  
                                           <subm:CountryCode><xsl:value-of select="previousAddressDetail/previousAddressDetail/countryCode" /></subm:CountryCode>
                                     </xsl:if>   
                               </subm:PrevAddressDetails>  
                             </xsl:if>  
                      </subm:PrevAddressDetails>
                </xsl:if>    
            </subm:EntityAndDirOrPartnrDetails>
          </xsl:for-each>    
  
        </xsl:if>
    </xsl:template>
    
    
    <!-- Template for DeclarationDetails -->
    <xsl:template name="DeclarationDetails">
        <xsl:if test="/jsonObject/declaration">
            <subm:Declaration>
                <subm:PSADeclarationBox1><xsl:value-of select="/jsonObject/declaration/box1" /></subm:PSADeclarationBox1>
                <subm:PSADeclarationBox2><xsl:value-of select="/jsonObject/declaration/box2" /></subm:PSADeclarationBox2>
                <subm:PSADeclarationBox3><xsl:value-of select="/jsonObject/declaration/box3" /></subm:PSADeclarationBox3>
                <subm:PSADeclarationBox4><xsl:value-of select="/jsonObject/declaration/box4" /></subm:PSADeclarationBox4>
                <xsl:if test="/jsonObject/declaration/box5">  
                   <subm:PSADeclarationBox5><xsl:value-of select="/jsonObject/declaration/box5" /></subm:PSADeclarationBox5>
                </xsl:if>    
                <xsl:if test="/jsonObject/declaration/box6">  
                   <subm:PSADeclarationBox6><xsl:value-of select="/jsonObject/declaration/box6" /></subm:PSADeclarationBox6> 
                </xsl:if>       
                
                <xsl:if test="/jsonObject/declaration/pensionAdvisorDetail">
           			<subm:PensionAdviDeails>
                    
    						  <subm:PensionAdviserName><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/name" /></subm:PensionAdviserName>
	    					   <subm:AddressDetails> 
									<xsl:choose>
										<xsl:when test="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/addressType = 'UK'">
											 <subm:NonUKAddress>false</subm:NonUKAddress>
										</xsl:when>
	
										<xsl:when test="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/addressType = 'NON-UK'">
											 <subm:NonUKAddress>true</subm:NonUKAddress>
										</xsl:when>
									</xsl:choose>
									
									 
									<subm:AddressLine1><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/line1" /></subm:AddressLine1>
									<subm:AddressLine2><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/line2" /></subm:AddressLine2>
									
									 <xsl:if test="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/line3"> 
										  <subm:AddressLine3><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/line3" /></subm:AddressLine3>
									 </xsl:if>
					 
									 <xsl:if test="/jsonObject/directorOrPartnerDetail/pensionAdvisorDetail/addressDetail/line4"> 
										  <subm:AddressLine4><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/line4" /></subm:AddressLine4>
									 </xsl:if>
									 
									 <xsl:if test="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/postalCode"> 
										  <subm:PostCode><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/postalCode" /></subm:PostCode>
									 </xsl:if>
									 
									 <xsl:if test="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/countryCode">  
										   <subm:CountryCode><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/addressDetail/countryCode" /></subm:CountryCode>
									 </xsl:if>   
                               </subm:AddressDetails>  
                               
                               <subm:ContactDetails>
                                         <xsl:if test="/jsonObject/declaration/pensionAdvisorDetail/contactDetail/telephone">  
                                               <subm:Telephone><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/contactDetail/telephone" /></subm:Telephone>
                                         </xsl:if>  
                                         <xsl:if test="/jsonObject/declaration/pensionAdvisorDetail/contactDetail/mobileNumber">  
                                               <subm:Mobile><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/contactDetail/mobileNumber" /></subm:Mobile>
                                         </xsl:if>  
                                         <xsl:if test="/jsonObject/declaration/pensionAdvisorDetail/contactDetail/fax">  
                                               <subm:Fax><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/contactDetail/fax" /></subm:Fax>
                                         </xsl:if>  
                                         <xsl:if test="/jsonObject/declaration/pensionAdvisorDetail/contactDetail/email">  
                                               <subm:Email><xsl:value-of select="/jsonObject/declaration/pensionAdvisorDetail/contactDetail/email" /></subm:Email>
                                         </xsl:if>  
                               </subm:ContactDetails>                               
			        </subm:PensionAdviDeails>
                </xsl:if>       
                     <subm:PSADeclarationBox7><xsl:value-of select="/jsonObject/declaration/box7" /></subm:PSADeclarationBox7>                                
            </subm:Declaration>
        </xsl:if>
    </xsl:template>
 </xsl:stylesheet>
