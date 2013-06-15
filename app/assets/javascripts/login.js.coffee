$(document).ready ()->
  $('.eff').hover \
    ->
      console.log("in")
      value = $(this).find('img').outerHeight() * -1
      $(this).find('img').stop().animate({bottom: value} ,{duration:500, easing: 'easeOutBounce'})
    ,
    ->
      console.log("out")
      $(this).find('img').stop().animate({bottom:0} ,{duration:500, easing: 'easeOutBounce'})
  
  
  $('.eff').click () ->
    window.location = $(this).find('a:first').attr('href')
