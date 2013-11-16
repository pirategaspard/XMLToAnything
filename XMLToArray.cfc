<cfcomponent displayname="XMLToArray" namespace="XMLToArray" output="false">
		
	<!--- 
	
		Copyright 2008 Daniel Gaspar Licensed under the Apache License, Version 2.0 (the "License");
		you may not use this file except in compliance with the License. You may obtain a copy of the
		License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or
		agreed to in writing, software distributed under the License is distributed on an "AS IS"
		BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License
		for the specific language governing permissions and limitations under the License.
	
	
	--->
		
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