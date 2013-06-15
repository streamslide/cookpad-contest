class TimeLine
  constructor: (@imgObjs, @options) ->
    #all objects offset to top 
  
  displayYearRange: ()->
    $("#rightBar").empty()

    @yearList = [2011, 2012, 2013, 2014]
    len = @yearList.length
    @currentYear ||= @yearList[len-1]

    #add to right bar
    for year in @yearList
      elem = $("<div class='year'>" + year + "</div>")
      if year is @currentYear
        elem.attr("id", "current_year")
      elem.appendTo("#rightBar")
      
  fetch: ()->

  animate: (year) ->
    $.each @imgObjs, (obj) ->
      obj = this
      tag = $('<img class="animated_photo">')
      tag.css({
        top: 'auto',
        bottom: "-"+obj.bottom+"px",
        position: 'absolute',
        'margin-left': obj.margin_left+"px",
        width: obj.width,
        height: obj.height
      })
      tag.appendTo("#leftBar")
      tag.attr('src', obj.src).load ->
        console.log('loaded')
        tag
          .delay(100)
          .animate(
            {bottom: "400px"},
            {queue: true, duration: 3000},
            ()->
              alert("done")
          )

  nextYear: () ->
    
  shuffleImage: () ->
    @imgObjs = [
      {src: "https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-prn1/p206x206/563683_10151426769389139_1989896978_n.jpg", year: 2015, width: 100, height: 100},
      {src: "https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-prn1/521782_10151426767634139_1414193279_n.jpg", year: 2014, width: 100, height: 100},
      {src: "https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-frc1/382304_10200603400510071_702291003_n.jpg", year: 2014, width: 100, height: 100}]
    
    maxWidth = $("#leftBar").width()
    len = @imgObjs.length
    bottom = null

    console.log(maxWidth)
    $.each @imgObjs, (obj) ->
      obj = this
      left = Math.floor((Math.random()*maxWidth)+1)
      if left > maxWidth - obj.width
        left = maxWidth - obj.width
      this["margin_left"] = left

      if bottom?
        bottom += 100
      else
        bottom = 0

      this["bottom"] = bottom

    return true

$(document).ready ->
  app = new TimeLine({a:1, b:2},{a:1,b:2})
  app.displayYearRange()
  app.shuffleImage()
  app.animate()

  window.changeyear = () ->
    app.currentYear = 2013
    app.displayYearRange()
