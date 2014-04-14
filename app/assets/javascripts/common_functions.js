/**
* This file content some common function that will be use in some where
**/

/**
* Include common functions for the application
**/
var Gagoit = {
  /**
  * Show Alert Html
  **/
  showAlertHtml: function(field, type, html) {
    field.find(".gagoit-alert").remove();
    field.append($("<div class='gagoit-alert " + type + " fade in alert-msg-align'><a class='close' data-dismiss='gagoit-alert'>×</a>" + html + "</div>"));
    
    field.find(".gagoit-alert").delay(5000).fadeOut("slow", function () { $(this).remove();});

    field.find(".close").click(function(){
      field.find(".gagoit-alert").remove();
    });
  },

  /**
  * Show Alert message
  **/
  showAlertMessage: function(field, type, message) {
    field.find(".gagoit-alert").remove();
    field.append($("<div class='gagoit-alert " + type + " fade in alert-msg-align'><a class='close' data-dismiss='gagoit-alert'>×</a><p> " + message + " </p></div>"));
    
    field.find(".gagoit-alert").delay(5000).fadeOut("slow", function () { $(this).remove();});
    
    field.find(".close").click(function(){
      field.find(".gagoit-alert").remove();
    });
  },

  /**
  * Check Url is in Text or not
  **/
  checkUrlInText: function(text){
    if(new RegExp("([a-zA-Z0-9]+://)?([a-zA-Z0-9_]+:[a-zA-Z0-9_]+@)?([a-zA-Z0-9.-]+\\.[A-Za-z]{2,4})(:[0-9]+)?(/.*)?").test(text)) {
            return true;
    }
    return false;
  }
}