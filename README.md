Epidoc2EDH
==========
Based on RIB to EDH crosswalk, this xsl takes a list of files in epidoc xml, matched with existing HD numbers and TM ids in an html table and converts structured information to a flat xml file with values with strict conventions (e.g. An.Ep.2009: 45 --> AE 2009, 0045.). To be reused this needs to be widely customized according to the input epidoc, as many of the transformation match string patterns and non structured data.
The results should validate to the EDH schema.
