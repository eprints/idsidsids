# IDs IDs IDs #

**IDs IDs IDs** allows a publication record to store multiple IDs.

By default, EPrints only allows one ID to be entered per publication under the *id_number* field.  Other types of ID fields such as *issn* and *isbn* have been included within EPrints core but often further bespoke ID fields need to be added for things like PubMed ID, PMCID, etc. if the *id_number* field is already being used for DOIs.

This plugin provides a replacement for the default EPrints *id_number* (labelled *Identification number*) field, which allows the entry of any combination of the following:

 * DOI
 * ISBN
 * ISSN
 * PubMed ID
 * PMCID

This plugin will backfill the old ID fields (*id_number*, *isbn* and *issn*) where IDs of the right type are set. Where multiple IDs of the right types are set, a priority list (as defined in *cfg/cfg.d/zz_idsidsids.pl*) is used to determine which value to use.  If multiple IDs have the same type, the first ID of the highest priority type will be used.

This plugin will autopopulate the *ids* field with IDs from the old ID fields when an item is recommitted (see **Migrate existing records**) but only prior to IDs being added to the *ids* field.

This plugin provides validators for each of its ID types to check that the IDs entered meet certain format requirements.  There is also a validator that can be enabled to ensure that only one ID of any type can be specified.

This plugin provides renderers for each of its ID types using third-party lookup services to provide additional information about the IDs.  It also provides a renderer for the whole *ids* field, so it can be rendered as a list (*ul* HTML element).

## Installing as an Ingredient ##

EPrints 3.4+ supports ingredients.  To install IDs IDs IDs as an ingredient:

 1. Copy the idsidsids directory inside the ingredients (e.g. */opt/eprints3/ingredients/*) directory.
 2. Run the *make_ingredient.sh* (e.g. *./make_ingredient.sh*).  This will make the appropriate symbolic links so IDs IDs IDs will work as an ingredient.
 3. Edit flavours/*FLAVOUR_NAME*/inc and add "ingredients/idsidsids" on its own line at the end of the file.
 4. Check EPrints configuration and reload the webserver (e.g. */opt/eprints3/epadmin test && apachectl graceful*).

## Setup ##

After installation the following steps are required:

### Add new field to workflow ###

Edit workflow file (usually archives/repoid/cfg/workflows/eprint/default.xml) and:

 1. replace all occurences of *id_number* with *ids* (be sure to retain the *required* setting if set).
 2. remove all occurences of *isbn* and *issn*.

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
