
/**
* This file content some common function that will be use in some where
**/

/**
* Include common functions for the application
**/
var Post = {
  /**
  * Init
  **/
  init: function(){
    this.init_events();
  },

  /**
  * Init Events
  **/
  init_events: function(){
    var self = this;
  	if($("input#search_posts").length > 0){
      $("input#search_posts").keydown(function(event){
        if(event.keyCode == 13){ //hit Enter
          self.search_posts($(this).val());
        }
      });
  	}
  },

  /**
  * Search posts
  **/
  search_posts: function(search){
    var self = this;
    
    $.ajax("/posts/search", {
      type: 'GET',
      data: {
        search: search
      }
    }).done(function(ev){
      $(".container > .row > .col-lg-8").html(ev);
    });
  }
  
}

$(function() {
  Post.init();
});