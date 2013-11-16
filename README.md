XMLToAnything
=============

Use XMLToAnything to generate Coldfusion data types from XML docs. This can be useful if you want to work with structures, arrays, and queries instead of parsing the XML doc. 

Works best with XML that has been created with AnythingToXML, but will work with any XML. 

XMLToAnything will create a structure, or an array of structures from the XML. It will also attempt to determine possible queries and give a best guess at column names. Obviously this process is not 100% accurate. 

This can also be used if you have a XML template and need to figure out how to structure the data so that it can be generated with AnythingToXML.

Please see the example.cfm file for basic usage. 

I hope you find XMLToAnything useful!  
\- Dan   
http://danielgaspar.com


##Updates
<ul>
<li>2010/01/21 Uses type hinting from AnythingToXML for improved results</li>
<li>2008/06/26 Updated ADD Query Attributes function</li>
<li>2008/06/11 initial release</li>
</ul>

## License (Simplified BSD)

Copyright (c) Daniel Gaspar  
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
