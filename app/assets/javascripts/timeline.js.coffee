class TimeLine
  constructor: (@imgObjs, @options) ->
    #all objects offset to top 
  
  animate: (year) ->
    $.each @imgObjs, (obj) ->
      tag = $('<img class="animated_photo">')
      tag.css({
        top: 'auto',
        bottom: '0px',
        position: 'absolute',
        'margin-left': this.margin_left+"px",
        width: this.width,
        height: this.height
      })
      tag.appendTo("#leftBar")
      tag.attr('src', this.src).load ->
        console.log('loaded')
        tag
          .delay(100)
          .animate({bottom: "500px"}, {queue: true, duration: 4700})

  nextYear: () ->

  shuffleImage: () ->
    @imgObjs = [
      {src: "https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-prn1/p206x206/563683_10151426769389139_1989896978_n.jpg", year: 2015, width: 100, height: 100},
      {src: "https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-prn1/521782_10151426767634139_1414193279_n.jpg", year: 2014, width: 100, height: 100}]
    
    maxWidth = $("#leftBar").width()
    console.log(maxWidth)
    $.each @imgObjs, (obj) ->
      left = Math.floor((Math.random()*maxWidth)+1)
      if left > maxWidth - 2*obj.width
        left = maxWidth - 2*obj.width
      this["margin_left"] = left

    return true

$(document).ready ->
  app = new TimeLine({a:1, b:2},{a:1,b:2})
  app.shuffleImage()
  app.animate()
  #app.animate()
