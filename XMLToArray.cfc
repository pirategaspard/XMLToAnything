<cfcomponent displayname="XMLToArray" namespace="XMLToArray" output="false">

	<cffunction name="init" access="public" output="false" returntype="any">		
		<cfargument name="XMLToXutils" required="yes" >
		<cfargument name="XMLToStruct" required="yes" >
		<cfset variables.XMLToXutils = arguments.XMLToXutils />	
		<cfset variables.XMLToStruct = arguments.XMLToStruct />
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setXMLToAnything" access="public" returntype="void">
		<cfargument name="XMLToAnything" type="any" required="yes">
		<cfset variables.XMLToAnything = arguments.XMLToAnything />
	</cffunction>

	<!--- Array  --->	
	<cffunction name="array_Update" access="public" output="false" returntype="any">
		<cfargument name="thisXMLNode" type="any" required="yes">
		<cfargument name="thisElement" type="array" required="yes">		
		
			<cfoutput>Update ARRAY</cfoutput> <br>
				<!------>
			<!--- Add Children to array --->
			<cfset thisElement = array_AddChildren(thisXMLNode, thisElement) />
			<!--- Add text data to array --->
			<cfif trim(thisXMLNode.XmlText) neq "">
				<cfset arrayAppend(thisElement, thisXMLNode.XmlText) />	
			</cfif>
			
			<!---<cfoutput>Ending Update Array  Element:</cfoutput>
			<cfdump var="#thisElement#"> <br> <br>--->
			
		<cfreturn thisElement />
	</cffunction>
	
	<cffunction name="array_AddChildren" access="public" output="false" returntype="any">
		<cfargument name="thisXMLNode" type="any" required="yes">
		<cfargument name="thisElement" type="array" required="yes">	
		
			<cfoutput>ADD Children To ARRAY</cfoutput> <br>
			<!------>
			<!--- Check if there are any children and Call XmlToStruct 
						If there are Attributes, pass them to use as the starting struct --->
			<cfif arraylen(thisXMLNode.XmlChildren) gt 0 >								
				<cfset arrayAppend(thisElement, variables.XMLToAnything.ToStruct(thisXMLNode.XmlChildren, variables.XMLToStruct.struct_AddAttributes(thisXMLNode))) />
			</cfif>			
			
			<!---<cfoutput>Ending Add Children To ARRAY Element:</cfoutput>
			<cfdump var="#thisElement#"> <br> <br>--->
			
		<cfreturn thisElement />
	</cffunction>
	
</cfcomponent>