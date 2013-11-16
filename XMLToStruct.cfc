<cfcomponent displayname="XMLToStruct" namespace="XMLToStruct" output="false">

	<cffunction name="init" access="public" output="false" returntype="any">		
		<cfargument name="XMLToXutils" required="yes" >
		<cfargument name="XMLToQuery" required="yes" >
		<cfset variables.XMLToXutils = arguments.XMLToXutils />		
		<cfset variables.XMLToQuery = arguments.XMLToQuery />										
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setXMLToAnything" access="public" output="false" returntype="boolean">
		<cfargument name="XMLToAnything" type="any" required="yes">
		<cfset variables.XMLToAnything = arguments.XMLToAnything />
		<cfreturn true />
	</cffunction>

	<!--- Structure --->
	<cffunction name="struct_Update" access="public" output="false" returntype="any">
		<cfargument name="thisXMLNode" type="any" required="yes">
		<cfargument name="thisElement" type="struct" required="yes">			
		
			<cfoutput>update STRUCT</cfoutput> <br>
			<!------>
			<!--- Add Children to Struct --->
			<cfif arraylen(thisXMLNode.XmlChildren) gt 0 >	
				<cfset thisElement = struct_AddChildren(thisXMLNode,thisElement) />	
			<cfelseif StructCount(thisXMLNode.XmlAttributes) >
			<!--- Only if there are no children: Add Attributes AS A QUERY --->	
				<cfset thisElement = variables.XMLToQuery.query_AddAttributes(thisXMLNode,thisElement) />
			</cfif>														
			<!--- if key is not in struct by now add as plain text. --->
			<cfif not structkeyexists(thisElement, thisXMLNode.XmlName)>
				<cfif trim(thisXMLNode.XmlText) neq "">  <!--- get rid of empty Nodes and create better grouping --->
					<cfset structInsert(thisElement, thisXMLNode.XmlName, thisXMLNode.XmlText) />
				</cfif>
			</cfif>			
			
			<!---<cfoutput>Ending update STRUCT Element:</cfoutput>
			<cfdump var="#thisElement#"> <br> <br>--->
			
		<cfreturn thisElement />
	</cffunction>
		
	<cffunction name="struct_AddChildren" access="public" output="false" returntype="any">
		<cfargument name="thisXMLNode" type="any" required="yes">
		<cfargument name="thisElement" type="struct" required="yes">	
		<cfset var temp = structNew() />
		
			<cfoutput>Add Children To STRUCT</cfoutput> <br>
				<!------>
				<!--- Check if there are any children and Call XmlToStruct 
			If there are Attributes, pass them to use as the starting struct --->
			<cfset temp = struct_AddAttributes(thisXMLNode) />
			<cfif arraylen(thisXMLNode.XmlChildren) gt 0 >								
				<cfset structInsert(thisElement, thisXMLNode.XmlName, variables.XMLToAnything.ToStruct(thisXMLNode.XmlChildren, struct_AddAttributes(thisXMLNode))) />
			</cfif>			
			
			<!---<cfoutput>Ending Add Children to STRUCT Element:</cfoutput>
			<cfdump var="#thisElement#"> <br> <br>--->
				
		<cfreturn thisElement />
	</cffunction>
	
	
	<cffunction name="struct_AddAttributes" access="public" output="false" returntype="any">
		<cfargument name="thisXMLNode" type="any" required="yes">
		<cfargument name="thisElement" type="struct" required="no" default="#structNew()#">
		<cfset var j = "" />	
		<cfset var aXmlAttributesKeys = "" />
			
			<cfoutput>Add Attributes to STRUCT</cfoutput> <br>
			<!------>
			<!--- Loop and Add the XML Attributes to Struct --->
			<cfif StructCount(thisXMLNode.XmlAttributes)>				
				<cfset aXmlAttributesKeys = structKeyarray(thisXMLNode.XmlAttributes) />
				<cfloop from="1" to="#StructCount(thisXMLNode.XmlAttributes)#" index="j">
					<!--- if the structkey already exists convert to array --->
					<cfif not isArray(thisElement) and structkeyexists(thisElement, aXmlAttributesKeys[j]) >
						<cfif not isArray(thisElement[aXmlAttributesKeys[j]]) >
							<cfset thisElement[aXmlAttributesKeys[j]] = variables.XMLToXutils.structToArray(thisXMLNode, thisElement, thisElement[aXmlAttributesKeys[j]]) >
						</cfif>								
						<cfset arrayAppend(thisElement[aXmlAttributesKeys[j]], thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]] ) />
					<cfelse>													
						<cfset structInsert(thisElement, aXmlAttributesKeys[j], thisXMLNode.XmlAttributes[aXmlAttributesKeys[j]] ) />
					</cfif>
				</cfloop>
			</cfif>			
				
			<!---<cfoutput>Ending add Attributes to STRUCT Element:</cfoutput>
			<cfdump var="#thisElement#"> <br> <br>--->	
																
		<cfreturn thisElement />
	</cffunction>
	
</cfcomponent>