{literal}

<script>

//var DEL_OM="#custom_32"
//var SEN_OM="#custom_31"

var DEL_OM="#custom_1"
var SEN_OM="#custom_2"
var STREET_FLD="street_address-1"
var ADD2_FLD="supplemental_address_1-Primary"
var CITY_FLD="city-1"
var STATE_OM="#state_province-1"
var ZIP_OM="postal_code-1"

// entire Legislative District field set
var LD_FS=".crm-profile-id-14"

function buildAddressParam($, address){
    //var address=getAddress($);

    // build address string to send to Google
    return address.street1 + " " + address.street2 + " " + 
      address.city + " " + address.state + " " + address.zip
}

function getAddress($){
   // Gather and returns parts of address from form

   console.log("getAddress called");

   //var sad2=$("input[name='"+ADD2_FLD+"']").val()

   return {
    "street1":$("input[name='"+STREET_FLD+"']").val(),
    "street2":"",
    "city":$("input[name='"+CITY_FLD+"']").val(),
    "state":$(STATE_OM+" option:selected").text(),
    "zip":$("input[name='"+ZIP_OM+"']").val()
    }
}

function toggleDistricts($, val){

    console.log("toggle districts with: " + JSON.stringify(val, null, 4));

    if(val != 'Maryland'){
        // Hide entire Legislative District field set
        $(LD_FS).hide();

	resetDistricts($);

        $("a[href='http://mdelect.net']").hide()
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

   if(!isEmpty(address.street1) && 
      !isEmpty(address.state) &&
      (address.state == "Maryland")){

      var address=buildAddressParam($, address);

      console.log(address);

      $.ajax({
            type: "GET",
            url: "https://www.googleapis.com/civicinfo/v2/representatives/?address=" +
		encodeURIComponent(address) +
		"&fields=divisions&key=",
            dataType: "json",
            contentType: "application/json; charset=utf-8",

	    beforeSend:function(){
	       $("a[href='http://mdelect.net']").text("calculating...");
	       // Clear values
	       resetDistricts($);

            },
            complete:function(){
	       $("a[href='http://mdelect.net']").text("lookup");
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
    $("input[name='"+STREET_FLD+"']").blur(function(){
	doSearch($);
    });

    $("input[name='"+CITY_FLD+"']").blur(function(){
	doSearch($);
    });

    $("input[name='"+ZIP_OM+"']").blur(function(){
	doSearch($);
    });

    // register handler to both toggle districts on/off when state changes
    // and execute search if conditions are right
    $(STATE_OM).change(function(){
	toggleDistricts($, $(this).find("option:selected").text());
	doSearch($);
    });

    $("a[href='http://mdelect.net']").text("lookup");

    $("a[href='http://mdelect.net']").click(function( event ) {
        doSearch($);

	event.preventDefault();
    });
});

</script>
{/literal}
