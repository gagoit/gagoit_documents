/**
* This file content some common function that will be use in some where
**/
$(function(){
	$(".alert .close").click(function(){
    $(this).closest(".alert").remove();
  });
  
  $(".alert").delay(5000).fadeOut("slow", function () { $(this).remove();});
});