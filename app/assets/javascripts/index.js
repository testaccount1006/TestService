$(document).ready(function(){
	
	

	/* Menu */

	// Handle menu
	$(".menu_item").click(function(){
		if($(this).attr('id') == 'btn_list'){
			$("#create_company").hide();
			$("#companies_list").fadeIn("slow");
		}else{
			$("#companies_list").hide();
			$("#create_company").fadeIn("slow");
		}
	});

	/* Handle the list of companies */

	// Method to fill the list
	function list_companies(){
		$.ajax({
	        url: "/api/companies",
	        type: "GET",
	        dataType: "json",
	        headers: {'Authorization': 'Token token="'+$("#api_token").val()+'"'},
	        success: function(data) { 
	        	$("#ul_companies").html('');
	        	data.forEach(function(entry){
	        		$("#ul_companies").append("<li><a href='#'>"+entry["name"]+"</a></li>");
	        	});
	        },
	        error: function() { set_api_error(); }
	    });
	}


	/* Handle creation of company */


	// Set errors
	function set_errors(errors){
		$("#errors").fadeIn("slow");
		$("#errors").html("<b>The following problems appeared</b><br>"+errors.replace(/\,/g, '<br>'));
	}	

	// Set success
	function set_success(){
		$("#errors").hide();
		clear_form();
		$("#create_company").hide();
		$("#companies_list").fadeIn("slow");
	}

	// Clear form
	function clear_form(){
		$("#creation_form").find("input[type=text]").val("");
	}

	// Trigger the button
	$("#create_submit_btn").click(function(e){
		e.preventDefault();
		create_company();
	});

	// Method to execute creation procedure
	function create_company(){
		var data = JSON.stringify({
			"company": {
						"name": 	 $("input[name=name]").val(), 
						"address": 	 $("input[name=address]").val(),
						"city": 	 $("input[name=city]").val(),
						"country": 	 $("input[name=country]").val(),
						"phone": 	 $("input[name=phone]").val(),
						"email": 	 $("input[name=email]").val()
					},
			"persons": [{"name": $("input[name=director_name]").val(), "title": "Director"}]	
		});

		$.ajax({
	         url: "/api/create_company",
	         type: "POST",
	         dataType: "json",
	         data: data,
	         contentType: "application/json; charset=utf-8",
	         headers: {'Authorization': 'Token token="'+$("#api_token").val()+'"'},
	         success: function(result) { 
	         	if(result["result"] == "OK"){
	         		list_companies();
	         		set_success();
	         	}else{
	         		set_errors(result["message"]);
	         	}
	         },
	        error: function(e) { set_api_error(); }
	    });


	}


	/* Handle API key part */

	// Trigger when entered API key
	$("#api_token").keyup(function(){check_connection();});

	// Check if the API key is valid
	function check_connection(){
		$.ajax({
	        url: "/api/check_connection",
	        type: "GET",
	        headers: {'Authorization': 'Token token="'+$("#api_token").val()+'"'},
	        success: function() { 
	        	set_api_success();
	        },
	        error: function() { 
	        	set_api_error();
			}
	    });
	}

	// Set api_token success
	function set_api_success(){
		$("#api_token").css("background-color","green"); 
		list_companies();
		$("#create_submit_btn").attr('value', 'Create company'); 
	    $("#create_submit_btn").removeAttr('disabled');
	}

	// Set api_token failure
	function set_api_error(){
		$("#api_token").css("background-color","red"); 
	    $("#create_submit_btn").attr('disabled', 'disabled');
		$("#create_submit_btn").attr('value', 'Please set api key'); 
	}	



});
