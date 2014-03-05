$(document).on('ajax:beforeSend', "#follow_form", function(){
	$(this).html("submitting..");
});