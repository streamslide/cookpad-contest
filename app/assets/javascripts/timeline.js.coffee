class TimeLine
  constructor: (@options) ->
    #all objects offset to top 
    @animateList = []
  
  displayYearRange: ()->
    $("#rightBar").empty()

    @yearList = [2009, 2010, 2011, 2012]
    len = @yearList.length
    @currentYear ||= @yearList[0]

    #add to right bar
    for year in @yearList
      elem = $("<div class='year'>" + year + "</div>")
      if year is @currentYear
        elem.attr("id", "current_year")
      elem.appendTo("#rightBar")
      
  animate: (year) ->
    app = this
    list = @animateList
    $.each @imgObjs, (obj) ->
      obj = this
      tag = $('<img class="animated_photo">')
      tag.css({
        top: 'auto',
        bottom: "-"+obj.bottom+"px",
        position: 'absolute',
        'margin-left': obj.margin_left+"px",
        width: obj.width
      })
      tag.appendTo("#leftBar")
      tag.attr('src', obj.src).load ->
        list.push(tag)
        tag
          .delay(100)
          .animate(
            {bottom: "1000px"},
            {
              queue: true,
              duration: 15000,
              complete: ()->
                idx = list.indexOf(tag)
                list.splice(idx, 1)
                tag.remove() #delete from DOM

                if (list.length == 0)
                  app.nextYear()
            }
          )

  nextYear: () ->
    curIdx = @yearList.indexOf(@currentYear)
    curIdx += 1
    if (curIdx >= @yearList.length)
      curIdx = 0

    @currentYear = @yearList[curIdx]
    this.displayYearRange()
    this.fetchNewImage(@currentYear, this.shuffleImage)
  

  fetchNewImage: (year, callback)->
    app = this
    $.get(
        "/home/photos/"+year,
        (data)->
          console.log(data)
          app.imgObjs = data
      )
      .done(
        ()->
          callback.apply(app)
          app.animate()
      )

  shuffleImage: () ->
    maxWidth = $("#leftBar").width()
    len = @imgObjs.length
    bottom = null

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

$(document).ready ->
  app = new TimeLine({a:1, b:2},{a:1,b:2})
  app.displayYearRange()
  app.fetchNewImage(app.currentYear, app.shuffleImage)

  window.changeyear = () ->
    app.currentYear = 2013
    app.displayYearRange()
