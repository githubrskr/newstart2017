<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" 
                xmlns:SOAP="http://schemas.xmlsoap.org/soap/envelope/"  version="2.0" exclude-result-prefixes="#all">
                
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>

    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>


    <xsl:param name="receiptDate"/>
    <xsl:param name="correlationId"/>
    
    <xsl:variable name="gtsrc">&gt;</xsl:variable>
    <xsl:variable name="ltsrc">&lt;</xsl:variable>

 
    <xsl:template match="/"> 
    
      	<xsl:param name="DateTime" select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01].[f01]')"/>

        <WorkItemRequest>
            <Message>            
               <MessageID><xsl:value-of select="$correlationId"/></MessageID>               
               
               <xsl:if test="/jsonObject/messageDetails">
                  <MessageSource><xsl:value-of select="/jsonObject/messageDetails/source"/></MessageSource>
               </xsl:if>   
              
                <MessageDateTime>
					<xsl:choose>
						<xsl:when test="$receiptDate">
							<xsl:value-of select="translate(translate(translate($receiptDate, '-', ''), ':', ''),'Z','')" />
							<xsl:text> GMT</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="translate(translate(translate($DateTime, '-', ''), ':', ''),'Z','')" />
							<xsl:text>.000 GMT</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</MessageDateTime>
                
                <MessageVersion>1.0</MessageVersion>
                
                <MessageType>Create</MessageType>
                
            </Message>
        
       	<WorkItem>        
        
             <xsl:if test="/jsonObject/workItemDetails">
                  <WorkItemType><xsl:value-of select="/jsonObject/workItemDetails/type"/></WorkItemType>
             </xsl:if>   
             
             <xsl:if test="/jsonObject/workItemDetails">
                  <WorkItemDateTime><xsl:value-of select="translate(translate(translate(/jsonObject/workItemDetails/dateTime, '-', ''), ':', ''),'Z','')" />
                  <xsl:text>.000 GMT</xsl:text>
                  </WorkItemDateTime>
             </xsl:if>   

             <xsl:if test="/jsonObject/workItemDetails">
                  <BFDate><xsl:value-of select="replace(/jsonObject/workItemDetails/bfDate,'-','')"/></BFDate>
             </xsl:if>              
             
        </WorkItem>

       	<ProcessingData>        
             <xsl:if test="/jsonObject/workItemDetails">
                <xsl:value-of select="$ltsrc" disable-output-escaping="yes"/>
                  <xsl:text>ProcessingProperty name=&quot;NINO&quot; type=&quot;String&quot; value=&quot;</xsl:text>
                  <xsl:value-of select="/jsonObject/workItemDetails/nino" disable-output-escaping="yes"/>
                 <xsl:text>&quot;/</xsl:text>
                <xsl:value-of select="$gtsrc" disable-output-escaping="yes"/>
             </xsl:if>   
             
             <xsl:if test="/jsonObject/workItemDetails">
             
                <xsl:value-of select="$ltsrc" disable-output-escaping="yes"/>
                  <xsl:text>ProcessingProperty name=&quot;TRN&quot; type=&quot;String&quot; value=&quot;</xsl:text>
                  <xsl:value-of select="/jsonObject/workItemDetails/temporaryReference" disable-output-escaping="yes"/>
                 <xsl:text>&quot;/</xsl:text>
                <xsl:value-of select="$gtsrc" disable-output-escaping="yes"/>
             </xsl:if>   

             <xsl:if test="/jsonObject/workItemDetails">
                <xsl:value-of select="$ltsrc" disable-output-escaping="yes"/>
                  <xsl:text>ProcessingProperty name=&quot;TAXYEAR&quot; type=&quot;String&quot; value=&quot;</xsl:text>
                  <xsl:value-of select="/jsonObject/workItemDetails/taxYear" disable-output-escaping="yes"/>
                 <xsl:text>&quot;/</xsl:text>
                <xsl:value-of select="$gtsrc" disable-output-escaping="yes"/>
             </xsl:if>   
      	</ProcessingData>


        <xsl:if test="/jsonObject/exceptions">     
        	<ExceptionData>
  		     <Exception>
			   <ExceptionDataTable> 
                 <xsl:if test=" (/jsonObject/workItemDetails/type = 502 or /jsonObject/workItemDetails/type = 503
			                         or /jsonObject/workItemDetails/type = 504 )" >  
                                     
				   <xsl:for-each select="/jsonObject/exceptions/exceptionRecord">
   		             <xsl:if test="./exceptionDataTypeName = 'NINO'
							  or  ./exceptionDataTypeName = 'Name' 
							  or  ./exceptionDataTypeName = 'TRN' 
							  or  ./exceptionDataTypeName = 'UTR' 
							  or  ./exceptionDataTypeName = 'Tax Year' 
							  or  ./exceptionDataTypeName = 'Date' " > 

						<Row>
		                   <xsl:value-of select="$ltsrc" disable-output-escaping="yes"/>
							<xsl:text>Col label=&quot;</xsl:text>
							   <xsl:value-of select="exceptionDataTypeName"/>
   							   <xsl:text>&quot; value=&quot;</xsl:text>
                               <xsl:value-of select="exceptionDataTypeValue"/>
							 <xsl:text>&quot;/</xsl:text>
                           <xsl:value-of select="$gtsrc" disable-output-escaping="yes"/> 
						</Row>
                     </xsl:if>  
				   </xsl:for-each> 
				 </xsl:if>
				 
				 
                 <xsl:if test=" (/jsonObject/workItemDetails/type = 500 or 
                                 /jsonObject/workItemDetails/type = 501 or
			                     /jsonObject/workItemDetails/type = 505 or
			                     /jsonObject/workItemDetails/type = 506 or
			                     /jsonObject/workItemDetails/type = 507 )" >  
			                         

				   <xsl:for-each select="/jsonObject/exceptions/exceptionRecord">
   		             <xsl:if test="./exceptionDataTypeName = 'NINO'
							  or  ./exceptionDataTypeName = 'Name' 
							  or  ./exceptionDataTypeName = 'TRN' 
							  or  ./exceptionDataTypeName = 'Emp Ref' 
							  or  ./exceptionDataTypeName = 'Payroll ID / Works Number' 
							  or  ./exceptionDataTypeName = 'Tax Year' 
							  or  ./exceptionDataTypeName = 'Date' " > 

						<Row>
		                   <xsl:value-of select="$ltsrc" disable-output-escaping="yes"/>
							<xsl:text>Col label=&quot;</xsl:text>
							   <xsl:value-of select="exceptionDataTypeName"/>
   							   <xsl:text>&quot; value=&quot;</xsl:text>
                               <xsl:value-of select="exceptionDataTypeValue"/>
							 <xsl:text>&quot;/</xsl:text>
                           <xsl:value-of select="$gtsrc" disable-output-escaping="yes"/> 
						</Row>
                     </xsl:if>  
				   </xsl:for-each> 
				 </xsl:if>			 
				 
            	</ExceptionDataTable>
  		     </Exception>
			</ExceptionData> 
        </xsl:if> 
        
        <xsl:if test="/jsonObject/urlValue">         
        	<ExternalLinks>  
               <xsl:value-of select="$ltsrc" disable-output-escaping="yes"/>
                 <xsl:text>URL name=&quot;url&quot; value=&quot;</xsl:text>
                  <xsl:value-of select="/jsonObject/urlValue"/>
                 <xsl:text>&quot;/</xsl:text>
               <xsl:value-of select="$gtsrc" disable-output-escaping="yes"/> 
 			</ExternalLinks> 
        </xsl:if>  
      </WorkItemRequest>

    </xsl:template>
    
    </xsl:stylesheet>