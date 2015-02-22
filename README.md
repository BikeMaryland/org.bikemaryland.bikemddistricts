# org.bikemaryland.bikemddistricts

This is a CiviCRM plugin that adds code to a profile to use the
[Google Civic API](https://developers.google.com/civic-information/)
to look up Maryland state legislative districts.

The plugin is meant to work with forms that include a mailing address
profile along with a profile that asks for Maryland state senate and
delegate districts.

The plugin looks for a specific field (see bikemddistricts.php) on
forms to determine whether or not the page contains fields for state
legislative districts.  If the field is present, it adds
JQuery/Javascript code to the page that:

1. Shows/hides the 'State Legislative Districts' profile based on
whether or not the mailing address has state set to Maryland
2. Attemps to executes a Google Civic API lookup when the user edits his mail address.



