<cfcomponent displayname="XMLToAnything" namespace="XMLToAnything" output="false">
	<!--- XMLToAnything by Daniel Gaspar http://danielgaspar.com 5/1/2008 --->
	<!--- With thanks to Anuj at http://www.anujgakhar.com and his xml2struct http://xml2struct.riaforge.org/ --->

	<cffunction name="init" access="public" output="false" returntype="any">	
		<cfset variables.XMLToXutils =	createObject('component', 'XMLToXutils').init() />		
		<cfset variables.XMLToQuery = createObject('component', 'XMLToQuery').init() />
		<cfset variables.XMLToStruct = createObject('component', 'XMLToStruct').init(variables.XMLToXutils,variables.XMLToQuery) />		
		<cfset variables.XMLToArray = createObject('component', 'XMLToArray').init(variables.XMLToXutils,variables.XMLToStruct) />			
		<cfset variables.XMLToArray.setXMLToAnything(this) />	
		<cfset variables.XMLToStruct.setXMLToAnything(this) />	
		<cfset variables.XMLToQuery.setXMLToAnything(this) />
		<cfreturn this>
	</cffunction>

	<cffunction name="ToStruct" access="public" returntype="any" output="false">
		<cfargument name="thisXML" type="any" required="true" />						
		<cfargument name="AttributesStruct" type="struct" required="false" default="#structNew()#" hint="This is used internally: not required to be passed by user" />
		<cfset var i = 1 />
		<cfset var thisElement = arguments.AttributesStruct />
		<cfset var thisXMLNode = "" />
		<!--- make sure we have an array --->
		<cftry>			
			<cfif isArray(arguments.thisXML) >
				<cfset thisXMLNode = arguments.thisXML />
			<cfelseif isSimpleValue(arguments.thisXML) >
				<!--- remove xml doc type from string if it exists --->
				<cfset arguments.thisXML = reReplaceNoCase(arguments.thisXML,'\<\?xml(.*)\?\>','') />
				<cfset thisXMLNode =  XmlSearch(XmlParse(arguments.thisXML),"/node()") />	
			<cfelseif isXML(arguments.thisXML) >
				<cfset thisXMLNode = XmlSearch(XmlParse(arguments.thisXML),"/node()")>
			</cfif>
			<cfcatch>
				<cfreturn "Unknown Type" />
			</cfcatch>
		</cftry>			
		<!--- loop through array --->
		<!---<cftry>--->
			<cfloop from="1" to="#arraylen(thisXMLNode)#" index="i"> 				
				<!--- Update thisElement with XMLNode Data --->
				<cfset thisElement = AddData(thisXMLNode[i],thisElement) />		
			</cfloop>	
			<!---<cfcatch>
				<cfoutput>There was an error while processing this XML file</cfoutput>
				<!---<cfdump var="#thisXMLNode#" >--->
				<cfreturn thisElement />
			</cfcatch>
		</cftry>--->
		<cfreturn thisElement />
	</cffunction>
	
	<cffunction name="AddData" access="private" output="false" returntype="any">
		<cfargument name="thisXMLNode" type="any" required="yes">
		<cfargument name="thisElement" type="any" required="yes">	
		<cfoutput>Add Data To Element:</cfoutput><br />
		<!---<cfdump var="#thisElement#"> <br>--->
		<cfif isArray(thisElement)>		
			<!--- update array with XMLNode Data --->								
			<cfset thisElement = variables.XMLToArray.array_Update(thisXMLNode,thisElement) />
		<cfelseif isQuery(thisElement) >
			<cfset thisElement = variables.XMLToQuery.query_Update(thisXMLNode,thisElement) />							
		<cfelse>				
			<!--- if the structkey already exists We are dealing with an Array or a Query --->
			<cfif structkeyexists(thisElement,thisXMLNode.XmlName) >																								
				<cfif not isArray(thisElement) and isArray(thisElement[thisXMLNode.XmlName])>	
					<!--- if we are creating an ARRAY of ARRAYS: create a query instead. --->		
					<cfset thisElement = variables.XMLToXutils.structToQuery(thisXMLNode, thisElement) />							 																	
				<cfelseif (not isArray(thisElement) and not variables.XMLToXutils.HasChildren(thisXMLNode.xmlChildren))>
					<!--- if we are creating an ARRAY of STRUCTS that DO NOT have children: create a query instead. --->				
						<cfset thisElement = variables.XMLToXutils.structToQuery(thisXMLNode, thisElement) />					
				<cfelseif not isArray(thisElement[thisXMLNode.XmlName]) >	
					<!--- convert this struct to an array --->								
					<cfset thisElement = variables.XMLToXutils.structToArray(thisXMLNode, thisElement, thisElement[thisXMLNode.XmlName]) />
				</cfif>		
				<cfif isQuery(thisElement)>
					<cfset thisElement = 	variables.XMLToQuery.query_Update(thisXMLNode,thisElement) />
				<cfelseif isArray(thisElement)>
					<cfset thisElement = 	variables.XMLToArray.array_Update(thisXMLNode,thisElement) />		
				</cfif>
			<cfelse>
				<!--- else just update struct with XMLNode Data --->				
				<cfset thisElement = variables.XMLToStruct.struct_Update(thisXMLNode,thisElement) />													
			</cfif>
		</cfif>		
		<!---<cfoutput>Ending Add Data Element:</cfoutput>
		<cfdump var="#thisElement#"> <br> <br>--->
		<cfreturn thisElement />
	</cffunction>
	
	
		
</cfcomponent>