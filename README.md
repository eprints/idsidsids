# IDs IDs IDs #

Allows a publication record to have multiple IDs.

By default, EPrints only allows one ID to be entered per publication under the id_number field.  Other types of ID fields such as issn and isbn have been included within EPrints core but often further bepsoke ID field are added for things like PubMed ID, PMCID, etc. if the id_number is already being used for DOIs.

This module provides a replacement for the default EPrints "ID" and "ID Type" fields which allows the entry of any combination of the following:

 * DOI
 * ISBN
 * ISSN (including print and online)
 * PubMed ID
 * PMCID


## Setup ##

After installation the following steps are required:

### Add new field to workflow ###

Edit workflow file (usually archives/repoid/cfg/workflows/eprint/default.xml) and:

 1. replace all occurences of "id_number" with "ids" (be sure to retain the 'required' setting)
 2. remove all occurences of "isbn", "issn", etc.

````
  <stage name="core">

    [...]

    <component><field ref="divisions"/></component>

    <component show_help="always"><field ref="dates" required="yes"/></component>

    <component type="Field::Multi">
      <title>Publication Details</title>
      [...]
````
\* to comment out all occcurances of id_number, isbn, issn, etc.
```` 
.,$s/\(<field ref="id_number"\/>\n\s*<field ref="isbn"\/>\)/<!-- \1 -->/gc
````
### Migrate existing records ###

To migrate all existing records to use the new ID field, run the following command:

````
bin/epadmin recommit <repoid> eprint --verbose
````
