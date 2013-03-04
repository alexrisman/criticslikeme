# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('.star').raty({ 
    scoreName: 'rating[stars]', 
    score: $("#oldrating").attr("data-rating"),
    click: (score, evt)->
       $("#rating").submit()
      
  });
  
  
    