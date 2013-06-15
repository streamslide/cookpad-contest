class TimeLine
  constructor: (@share_key, @options) ->
    if @share_key == ''
      @year_range_url = '/home/year_range'
      @year_photos_url = '/home/photos/'
    else
      @year_range_url = '/share/year_range/' + @share_key
      @year_photos_url = '/share/photos/' + @share_key + '/'
    @animateList = []

  displayYearRange: ()->
    app = this
    $("#rightBar > #year").empty()

    if not @yearList?
      $.ajaxSetup({async: false})
      $.get(app.year_range_url,
        (data) ->
          app.yearList = data
      )
      $.ajaxSetup({async: true})

    len = @yearList.length
    @currentYear ||= @yearList[0]

    #add to right bar
    for year in @yearList
      elem = $("<div class='year'>" + year + "</div>")
      if year is @currentYear
        elem.attr("id", "current_year")
      else
        elem.attr("class", "year pointer")
        ((year) ->
          elem.click ->
            app.setYear year
        )(year)

      elem.appendTo("#rightBar > #year")

  animate: (year) ->
    comment_top = $("#caption").offset().top
    app = this

    list = @animateList
    $.each @imgObjs, (obj) ->
      obj = this
      tag = $('<img class="animated_photo">')
      tag.css({
        top: 'auto',
        bottom: "-"+(obj.height+30)+"px",
        position: 'absolute',
        'margin-left': obj.margin_left+"px",
        width: obj.width
      })
      tag.appendTo("#leftBar")
      tag.attr('src', obj.src).load ->
        list.push(tag)
        tag
          .delay(obj.delay)
          .animate(
            {
              opacity: 0.3,
              bottom: $(window).height() + 40 + "px"
            },
            {
              step: ()->
                if (tag.offset().top <= comment_top && !(tag['displayed_comment']?))
                  tag['displayed_comment'] = true
                  app.displayCaption(obj.caption)
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
          true

  displayCaption :(message)->
    $("p#caption").hide()
    $("p#caption").html(message)
    $("p#caption").fadeIn('slow')

  nextYear: () ->
    curIdx = @yearList.indexOf(@currentYear)
    curIdx += 1
    if (curIdx >= @yearList.length)
      curIdx = 0
    year = @yearList[curIdx]
    @setYear(year)

  setYear: (year) ->
    @currentYear = year
    $("#leftBar img").remove()
    this.displayYearRange()
    this.fetchNewImage(@currentYear, this.shuffleImage)


  fetchNewImage: (year, callback)->
    app = this
    $.get(
        app.year_photos_url + year,
        (data)->
          if data.length == 0
            app.fetchNewImage(year+1, callback)
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
    delay = null

    $.each @imgObjs, (obj) ->
      obj = this
      left = Math.floor((Math.random()*(maxWidth - obj.width))+1)
      this["margin_left"] = left

      if delay?
        delay += 7000
      else
        delay = 0

      this["delay"] = delay

startClock = ()->
  today = new Date()
  h = today.getHours()
  m = today.getMinutes()
  s = today.getSeconds()

  m = checkTime(m)
  s = checkTime(s)

  $("div#clock").html(h+":"+m+":"+s)
  t = setTimeout(startClock ,500)

checkTime = (i)->
  i = "0" + i if i < 10
  i

window.TimeLine = TimeLine

