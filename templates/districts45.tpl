
{* keep api key in separate file *}
{config_load file='apikey.conf'}
{config_load file='fields.conf'}

<script>
// delegate option menu    
var DEL_OM="#{$smarty.config.del_om}"
// senate option menu
var SEN_OM="#{$smarty.config.sen_om}"
// street field
var STREET_FLD="#{$smarty.config.street_fld}"
// additional address field
var ADD2_FLD="#{$smarty.config.add2_fld}"
// city field
var CITY_FLD="#{$smarty.config.city_fld}"
// state option menu
var STATE_OM="#{$smarty.config.state_om}"
// postal/zip code option menu
var ZIP_OM="#{$smarty.config.zip_om}"
// entire Legislative District field set
var LD_FS=".{$smarty.config.ld_fs}"
// google civic api key
var KEY="{$smarty.config.apikey}"

{literal}

function buildAddressParam($, address){
    // build address string to send to Google
    return address.street1 + " " + address.street2 + " " + 
      address.city + " " + address.state + " " + address.zip
}

function getAddress($){
   // Gather and returns parts of address from form
   return {
    "street1":$(STREET_FLD).val(),
    "street2":"",
    "city":$(CITY_FLD).val(),
    "state":$(STATE_OM+" option:selected").text(),
    "zip":$(ZIP_OM).val()
    }
}

function toggleDistricts($, val){

    console.log("toggle districts with: " + JSON.stringify(val, null, 4));

    if(val != 'Maryland'){
        // Hide entire Legislative District field set
        $(LD_FS).hide();

	resetDistricts($);

        //$("a[href='http://mdelect.net']").hide()
    } else {
        // Show entire Legislative District field set
        $(LD_FS).show();
    }
}

function parseGoogleCivicOutput(data){
    // Open Civic Data identifiers
    var SENATE_OCD="ocd-division/country:us/state:md/sldu:"
    var DELEGATE_OCD="ocd-division/country:us/state:md/sldl:"

    var senate="";
    var delegate="";

    for(key in data.divisions){
	console.log(key);
	// search for senate district
	if(key.slice(0,SENATE_OCD.length) == SENATE_OCD) {
            senate=key
            if(data.divisions[key].hasOwnProperty("alsoKnownAs")){
		    <!-- also delegate district -->
		    delegate=data.divisions[key].alsoKnownAs[0]
            }
	}
	// search for delegate district 
	if(key.slice(0,DELEGATE_OCD.length) == DELEGATE_OCD) {
            delegate=key;
	}
    }
    // extract district numbers
    sen=senate.substring(SENATE_OCD.length, senate.length).toUpperCase()
    del=delegate.substring(DELEGATE_OCD.length, delegate.length).toUpperCase()

    return { "del":del, "sen":sen };
}

function resetDistricts($){
    $(DEL_OM).select2("val", "");
    $(SEN_OM).select2("val", "");
}

function doSearch($){
   console.log("dosearch called");
   var address=getAddress($);
   
      console.log(JSON.stringify(address));

   if(!isEmpty(address.street1) && 
      !isEmpty(address.state) &&
      (address.state == "Maryland")){

      var address=buildAddressParam($, address);

      console.log(address);

      $.ajax({
            type: "GET",
            url: "https://www.googleapis.com/civicinfo/v2/representatives/?address=" +
		encodeURIComponent(address) +
		"&fields=divisions&key="+KEY,
            dataType: "json",
            contentType: "application/json; charset=utf-8",

	    beforeSend:function(){
	       //$("a[href='http://mdelect.net']").text("checking you");
	       // Clear values
	       resetDistricts($);

            },
            complete:function(){
               //$("a[href='http://mdelect.net']").text("lookup");
            }
        }).done(function(data) {
	    var districts = parseGoogleCivicOutput(data);
	    console.log(JSON.stringify(districts));
 
            $(SEN_OM).select2("val", districts.sen);
            $(DEL_OM).select2("val", districts.del);
	});
   }
}

function isEmpty(str) {
    return (!str || 0 === str.length);
}

cj(document).ready(function($) {
    console.log( "ready!" );
    
    // set districts on/off based on initial state
    toggleDistricts($, $(STATE_OM).find("option:selected").text());

    // When focus leaves these fields, try to do a lookup
    $(STREET_FLD).blur(function(){
	doSearch($);
    });

    $(CITY_FLD).blur(function(){
	doSearch($);
    });

    $(ZIP_OM).blur(function(){
	doSearch($);
    });

    // register handler to both toggle districts on/off when state changes
    // and execute search if conditions are right
    $(STATE_OM).change(function(){
	toggleDistricts($, $(this).find("option:selected").text());
	doSearch($);
    });

    //$(LD_FS).find("div.messages").hide();
    
    //$("a[href='http://mdelect.net']").text("lookup");

    //$("a[href='http://mdelect.net']").click(function( event ) {
    //    doSearch($);

    //	event.preventDefault();
    //});
});

</script>
{/literal}
