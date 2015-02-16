Installing #dwtc15 items example data
====================================

**Warning: Following the steps below will destroy all existing data in your database!**

1. Install a clean version of the latest [Dynamicweb 8.6.0 release](http://developer.dynamicweb.com/downloads/dynamicweb-8.aspx) using the Dynamicweb installer
2. Copy item types from [Wrap for Dynamicweb](http://developer.dynamicweb.com/downloads.aspx) to the solution
3. Copy everything from the *[Files](../Files/)* folder to the solution's *Files* folder
4. Apply the sql script [dwtc15.local.dynamicweb.dk.sql](dwtc15.local.dynamicweb.dk.sql) to the database. **Warning**: this will delete all content in the database!
5. Restart your webserver, e.g. by running `iisreset`

That's it!
