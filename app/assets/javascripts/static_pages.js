
/**
* StaticPage Module for the application
**/
var StaticPage = {
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
    if($("section#photostack-1").length > 0){
      new Photostack( $("section#photostack-1")[0], {
        callback : function( item ) {
          //console.log(item)
        }
      } );

      $("section#photostack-1 nav")
    }
  }
  
}

$(function() {
  StaticPage.init();
});