
/**
* This file content some common function that will be use in some where
**/

/**
* Include common functions for the application
**/
var Post = {
  main_container: function(){
    return $(".container > .row > .col-lg-8");
  },
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

      $("input#search_posts").next('.input-group-btn').click(function(event){
        self.search_posts($("input#search_posts").val());
      });
  	}

    self.main_container().delegate('.new_comment', 'ajax:success',function(event, data, status, xhr){
      $(this).closest(".comments").html(data.html);
    });
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
      self.main_container().html(ev);
    });
  }
  
}

$(function() {
  Post.init();
});