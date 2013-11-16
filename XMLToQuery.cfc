<cfcomponent displayname="XMLToQuery" namespace="XMLToQuery" output="false">

		
	<cffunction name="init" access="public" output="false" returntype="any">												
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setXMLToAnything" access="public" returntype="boolean">
		<cfargument name="XMLToAnything" type="any" required="yes">
		<cfset variables.XMLToAnything = arguments.XMLToAnything />
		<cfreturn true />
	</cffunction>

	<!--- query --->
	<cffunction name="query_Update" output="false" access="public"  returntype="any">
		<cfargument name="thisXMLNode" type="any" required="yes">
		<cfargument name="thisElement" type="query" required="yes">	
		
			<cfoutput>update QUERY</cfoutput> <br>			
			<!------>
			<!--- Add Children to QUERY --->
			<cfif arraylen(thisXMLNode.XmlChildren) gt 0 >	
				<cfset thisElement = query_AddChildren(thisXMLNode,thisElement) />	
			<cfelseif StructCount(thisXMLNode.XmlAttributes) >
			<!--- Add Attributes To QUERY --->	
				<cfset thisElement = query_AddAttributes(thisXMLNode,thisElement) />
			</cfif>				
			<!--- if key is not in struct by now add as plain text. --->
			<cfif not structkeyexists(thisElement, thisXMLNode.XmlName)>
				<cfif trim(thisXMLNode.XmlText) neq "">  <!--- get rid of empty Nodes and create better grouping --->
						<cfset QueryAddColumn(thisElement,thisXMLNode.XmlName,arrayNew(1)) />
						<cfset QueryAddRow(thisElement) />	
						<cfset QuerySetCell(thisElement,thisXMLNode.XmlName,thisXMLNode.XmlText) />
						<cfoutput>#thisXMLNode.XmlName# = #thisXMLNode.XmlText#</cfoutput>
				</cfif>
			</cfif>	
			
			<!---<cfoutput>Ending update QUERY Element:</cfoutput>
			<cfdump var="#thisElement#"> <br> <br>--->
			
		<cfreturn thisElement />
	</cffunction>
	
	<cffunction name="query_AddChildren" output="false" access="public"  returntype="any">
		<cfargument name="thisXMLNode" type="any" required="yes">
		<cfargument name="thisElement" type="query" required="yes">	
		<cfset var j = "" />
		<cfset var k = "" />
		<cfset var temp = "" />
		<cfset var aXmlChildrenKeys = "" />
		
			<cfoutput>Add Children To QUERY</cfoutput> <br>
					<!---		--->		
			<!--- Check if there are any children and Call ToStruct 
						If there are Attributes, pass them to use as the starting struct --->
			<cfif arraylen(thisXMLNode.XmlChildren) gt 0 >	
				<cfset QueryAddRow(thisElement) />	
						
				<cfloop from="1" to="#arraylen(thisXMLNode.XmlChildren)#" index="j">
					<cfset temp = thisXMLNode.XmlChildren[j] />	
					
					<cfif temp.xmlText neq "" >
						<cfif listfindnocase(thisElement.columnlist, temp.xmlName) gt 0 >
							<!--- Using column guessing Method 1 --->
							<cfset QuerySetCell(thisElement, temp.xmlName,temp.xmlText ) />
						<cfelse>						
							<!--- Using column guessing Method 2 --->
							<cfif structcount(temp) gt 0>
								<cfset aXmlChildrenKeys = structKeyarray(temp.xmlAttributes) />	
								<cfloop from="1" to="#arraylen(aXmlChildrenKeys)#" index="k">
									<cfif not structkeyexists(thisElement,temp.xmlAttributes[aXMLChildrenKeys[1]] ) >																		
										<cfset QueryAddColumn(thisElement,temp.xmlAttributes[aXMLChildrenKeys[1]],arrayNew(1)) />
									</cfif>											
									<cfset QuerySetCell(thisElement,temp.xmlAttributes[aXMLChildrenKeys[1]],temp.xmlChildren[1].xmlText ) />
								</cfloop>
							</cfif>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
					
			<cfoutput>Ending Add Children to QUERY Element:</cfoutput>
			<!---<cfdump var="#thisElement#"> <br> <br>--->
					
		<cfreturn thisElement />
	</cffunction>
	
	<cffunction name="query_AddAttributes" access="public" output="false" returntype="any">
		<cfargument name="thisXMLNode" type="any" required="yes">
		<cfargument name="thisElement" type="any" required="no" default="#structNew()#">
		<cfset var j = "" />
		<cfset var temp = "" />
		<cfset var aXmlAttributesKeys = "" />			
		
			<cfoutput>Add Attributes To QUERY</cfoutput> <br>	
			<!---<cfdump var="#thisElement#"	/>
			<cfdump var="#thisXMLNode#"	/>--->
		
			<!--- Loop and Add the XML Attributes to Struct --->
			<cfif StructCount(thisXMLNode.XmlAttributes)>
				<cfset aXmlAttributesKeys = structKeyarray(thisXMLNode.XmlAttributes) />
				<cfloop from="1" to="#StructCount(thisXMLNode.XmlAttributes)#" index="j">
					<cfif not isQuery(thisElement) and structkeyexists(thisElement, aXmlAttributesKeys[j]) >
					
						<!--- if the structkey already exists convert to array --->
						<cfif not isQuery(thisElement[aXmlAttributesKeys[j]]) >
							<cfset temp = duplicate(thisElement[aXmlAttributesKeys[j]]) />
							<cfset thisElement = queryNew('') />																
							<cfset QueryAddColumn(thisElement,aXmlAttributesKeys[j],arrayNew(1)) />	
							<cfset QueryAddColumn(thisElement,thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]],arrayNew(1)) />							
							<cfset QueryAddRow(thisElement) />								
							<cfset QuerySetCell(thisElement,aXmlAttributesKeys[j],temp,1) />												
						</cfif>						
											
						<cfset QueryAddRow(thisElement) />
						<cfset QuerySetCell(thisElement,aXmlAttributesKeys[j],thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]]) />
						<cfset QuerySetCell(thisElement,thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]], thisXMLNode.XMLText ) />
						
					<cfelseif isQuery(thisElement) >
						<!--- if its already a Query, update it --->
						
						<!--- Add the attributeKey as a column and put the value into it--->
						<cfif not structkeyexists(thisElement,aXmlAttributesKeys[j])>
							<cfset QueryAddColumn(thisElement,aXmlAttributesKeys[j],arrayNew(1)) />
						</cfif>																			
						<!--- Also add the attribute Key value as a column and put the xmltext into it for good measure --->
						<cfif not structkeyexists(thisElement,thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]])>
							<cfset QueryAddColumn(thisElement,thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]],arrayNew(1)) />
						</cfif>														
																					
						<cfset QueryAddRow(thisElement) />
						<cfset QuerySetCell(thisElement,aXmlAttributesKeys[j],thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]]) />
						<cfset QuerySetCell(thisElement,thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]], thisXMLNode.XMLText ) />
						
						<!--- for debugging --->
						<cfoutput>#aXmlAttributesKeys[j]# = #thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]]# </cfoutput><br />
						<cfoutput>#thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]]# = #thisXMLNode.XMLText# </cfoutput><br />
					<cfelse>													
						<cfset structInsert(thisElement, aXmlAttributesKeys[j], thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]] ) />
						<cfset structInsert(thisElement, thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]], thisXMLNode.XMLText) />
					</cfif>
				</cfloop>
			</cfif>
						
			<cfoutput>Ending add Atttributes to QUERY Element:</cfoutput>
			<!---<cfdump var="#thisElement#"> <br> <br>--->
			
		<cfreturn thisElement />
	</cffunction>
	
</cfcomponent>