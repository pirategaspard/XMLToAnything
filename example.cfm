<cfsavecontent variable="myXML" >
	<?xml version="1.0" encoding="utf-8"?> 
	<ORDERS CF_TYPE='array'>  
		<ORDER ordernumber="D1D9BC68-A3A3-C3EF-400C2C8DC4D79D71" CF_TYPE='struct'>   
			<CUSTOMER customerid="D1D9BC6F-C228-AD7F-A2421136971CD7C6" CF_TYPE='object'>  
				<FIRSTNAME><![CDATA[Bob]]></FIRSTNAME> 
				<LASTNAME><![CDATA[Jones]]></LASTNAME> 
			</CUSTOMER> 
			<PRODUCTS>  
				<PRODUCT id="1" CF_TYPE='query'> 
					<NAME><![CDATA[GI Joe]]></NAME> 
					<PRICE><![CDATA[$10.00]]></PRICE> 
				</PRODUCT> 
				<PRODUCT id="2" CF_TYPE='query'> 
					<NAME><![CDATA[Transformer]]></NAME> 
					<PRICE><![CDATA[$16.00]]></PRICE> 
				</PRODUCT> 
			</PRODUCTS> 
		</ORDER> 
		<ORDER ordernumber="D1D9BC70-A28A-F0AA-926134E00040ECCB" CF_TYPE='struct'>  
			<CUSTOMER customerid="D1D9BC73-988C-65F6-AD816C46A69DB27D" CF_TYPE='object'> 
				<FIRSTNAME><![CDATA[Jill]]></FIRSTNAME> 
				<LASTNAME><![CDATA[Jones]]></LASTNAME> 
			</CUSTOMER> 
			<PRODUCTS>  
				<PRODUCT id="3" CF_TYPE='query'> 
					<NAME><![CDATA[My Little Pony]]></NAME> 
					<PRICE><![CDATA[$12.00]]></PRICE> 
				</PRODUCT> 
			</PRODUCTS> 
		</ORDER> 
	</ORDERS>
</cfsavecontent>
<cfset XMLToAnything = createObject('component', 'XMLToAnything').init() />
<cfset myData = XMLToAnything.toStruct(myXML) />
<cfdump var="#myData#" />
