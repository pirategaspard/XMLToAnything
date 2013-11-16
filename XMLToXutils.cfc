<cfcomponent displayname="XMLToXutils" namespace="XMLToXutils" output="false">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="structToQuery" access="public" output="false" returntype="query">
		<cfargument name="thisXMLNode" type="any" required="yes" >
		<cfargument name="thisElement" type="any" required="yes" >
		<cfset var j = '' />
		<cfset var k = '' />
		<cfset var L = '' />
		<cfset var m = '' />
		<cfset var temp = '' />
		<cfset var aKeys = '' />		
		
			<cfoutput>convert STRUCT to QUERY</cfoutput> <br>
			
			<cfif isArray(thisElement[thisXMLNode.XmlName])>
				<cfset temp = duplicate(thisElement[thisXMLNode.XmlName]) />
			<cfelseif isStruct(thisElement[thisXMLNode.XmlName]) >
				<cfset temp = arrayNew(1) >
				<cfset arrayAppend(temp, duplicate(thisElement[thisXMLNode.XmlName])) />			
			</cfif>
			
			<cfset thisElement = queryNew('') />	
			<cfset QueryAddRow(thisElement) />								
			
			<cfif isArray(temp) >
					
					<!--- loop keys, attempt to Guess Column names  --->	
				<cfloop from="1" to="#arraylen(temp)#" index="j">
					<cfset aKeys = structKeyarray(temp[j]) />	
					
				
					<!--- METHOD 2:  assuming that structs have two keys: one is a column name the other is a value, 
						column names match the current XMLchildren attribute names 
						(this was a pain in the butt)
					--->	
					<cftry>			
						<cfloop from="1" to="#arraylen(aKeys)#" index="k">												
							<cfif listlen(temp[j][aKeys[k]], ' ') eq	1 > 
								<cfloop from="1" to="#arraylen(thisXMLNode.XMLChildren)#" index="L">
									<cfif structkeyexists(thisXMLNode.XMLChildren[L].XMLAttributes, aKeys[k])>
										<cfif thisXMLNode.XMLChildren[L].XMLAttributes[aKeys[k]] eq temp[j][aKeys[k]] >
											<!---<cfoutput>Create Column: #temp[j][aKeys[k]]#</cfoutput><br />--->
											<cfset QueryAddColumn(thisElement, temp[j][aKeys[k]], arrayNew(1)) />																																							
											<cfif k eq 2  >
												<cfset QuerySetCell(thisElement, temp[j][aKeys[k]], temp[j][aKeys[k-1]] ) />
												<!---<cfoutput>Set cell #temp[j][aKeys[k]]# to value #temp[j][aKeys[k-1]]# </cfoutput>--->
											<cfelseif k+1 eq arraylen(aKeys)>
												<cfset QuerySetCell(thisElement, temp[j][aKeys[k]], temp[j][aKeys[k+1]] ) />
												<!---<cfoutput>Set cell #temp[j][aKeys[k]]# to value #temp[j][aKeys[k+1]]# </cfoutput>--->
											</cfif>
										</cfif>
									</cfif>
								</cfloop>																
							</cfif>
						</cfloop>	
						<cfcatch>
						</cfcatch>			
					</cftry>
					<!--- METHOD 1: Just add the key names as columns --->		
					<cfif listlen(thisElement.columnList) eq 0 >
						<cfloop from="1" to="#arraylen(aKeys)#" index="m">
							<cfset QueryAddColumn(thisElement, aKeys[m], arrayNew(1)) />
							<cfset QuerySetCell(thisElement, aKeys[m], temp[j][aKeys[m]] ) />						
						</cfloop>
					</cfif>			
				</cfloop>
			<cfelse>
			</cfif>
				
	<!---<cfoutput>Ending Convert STRUCT to QUERY Element:</cfoutput>
		<cfdump var="#thisElement#"> <br> <br>--->
			
		<cfreturn thisElement />
	</cffunction>
	
	<cffunction name="structToArray" access="public" output="false" returntype="array">
		<cfargument name="thisXMLNode" type="any" required="yes" >
		<cfargument name="thisElement" type="any" required="yes" >
		<cfargument name="olddata" type="any" required="yes" >
		<cfset var temp = '' />							
			
				<cfoutput>convert STRUCT to ARRAY</cfoutput> <br>
			<!------>
			<!--- 
				Take the data that is currently in that struct, save it,
				change the struct to a new array,
				and add the old data back in as the first item in the array
			 --->					 
			
			<cfset temp = duplicate(arguments.olddata) />
			<cfset thisElement = arrayNew(1) />									
			<cfset arrayAppend(thisElement,temp) />
			
			<!---<cfoutput>Ending Convert STRUCT to ARRAY Element:</cfoutput>
			<cfdump var="#thisElement#"> <br> <br>--->
			
			<cfreturn thisElement />			
	</cffunction>		
	
	<cffunction name="HasChildren" access="public" output="false" returntype="boolean">
		<cfargument name="thisXMLChildren" type="array" required="yes">
		<cfset var j = "" />	
		<cfset var k = "" />		
		<cfset var aKeys = "" />
		
		<cfoutput>Does XML have Complex Children? </cfoutput>	<br />
		<!------>
		<!--- if the xml has xmlchildren that are not null or
				 xmlattributes that are complex or not null then 
				 the xml is deemed to "have children" --->						
		<cfloop from="1" to="#arrayLen(thisXMLChildren)#" index="j">		
			<cfif isSimpleValue(thisXMLChildren[j].xmlChildren) and trim(thisXMLChildren[j].xmlChildren) neq "" >
				<cfreturn true>
			<cfelseif not isSimpleValue(thisXMLChildren[j].xmlAttributes) >
				<cfreturn true>
			<!---<cfelse >
				<cfset aKeys = structkeyarray(thisXMLChildren[j].xmlAttributes) />	
				<cfloop from="1" to="#arraylen(aKeys)#" index="k"> 
					<cfif not isSimplevalue(thisXMLChildren[j].xmlAttributes[aKeys[k]]) >
						<cfreturn true>
					</cfif>
				</cfloop>--->
			</cfif>	
		</cfloop>
		
		<cfreturn false>
	</cffunction>
	
</cfcomponent>