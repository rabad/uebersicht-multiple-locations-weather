###
  Forecast.io data widget for Übersicht.
###

apiKey: ""

# Choose the color theme to use. Available themes are 'white' and 'black'.
theme: 'white'

# Choose degree units; 'c' for celsius, 'f' for fahrenheit
unit: 'c'

###
  Object of locations to display. Maximum recommended 5, but changing the refresh frequency more can be added.
  Each location will have an ID, a name, a latitude and a longitude.
  Ex:
    lnd:
      name: "London"
      lat: 51.50722
      lng: -0.12750
  where "lnd" is the ID.
###
locations:
  mad:
    name: "Madrid, ESP"
    lat: 40.416691
    lng: -3.700345
  vlc:
    name: "València, ESP"
    country: "España"
    lat: 39.470239
    lng: -0.376805
  ham:
    name: "Hamburg, DEU"
    lat: 53.5538148
    lng: 9.9915752
  bcn:
    name: "Barcelona, ESP"
    lat: 41.387917
    lng: 2.169919
  gij:
    name: "Gijón, ESP"
    lat: 43.5452608
    lng: -5.6619264


exclude: "minutely,hourly,alerts,flags"


###
 Refresh every '(60 * 1000)  * x' minutes
 Forecast.io allows to make a maximum of 1000 free queries/day. Number of queries will depend on number of locations and
 refresh frequency.
###
refreshFrequency: (60 * 1000) * 10


widgetName: "multiple-locations-weather"

style: """
  top: 1%
  left: 1%
  span
    display: inline-block
    .temperature
      b
        font-weight: bold
	.icon
		img
      width: 40px
      position: relative
      top: 15px
      left: 5px
  @css {
    span, div {
      font: 100 11px/1 'Helvetica Neue', sans-serif;
    }
    #content {
      border-radius: 10px;
      padding-left: 10px;
      padding-top: 5px;
      padding-right: 10px;
      padding-bottom: 20px;
    }
    #content.white {
      color: #fff;
      background-color: rgba(255,255,255,0.025);
      border: 1px solid rgba(255,255,255,0.5);
    }
    #content.black {
      color: #000;
      background-color: rgba(0,0,0,0.025);
      border: 1px solid rgba(0,0,0,0.5);
    }
    div.location {
      margin-top: -5px;
      padding-bottom: 10px;
      border-bottom: 1px solid rgba(255,255,255, 0.5);
    }
    span.name {
      width: 130px;
      overflow: hidden;
      text-overflow: ellipsis;
      font-weight: 600;
      font-size: 14px;
    }
    span.rain {
      margin-left: 10px;
    }
    div.week-forecats {
      height: 30px;
    }
    span.day {
      width: 65px;
    }
    div.day-name,
    div.day-icon,
    div.max-min {
      display: inline-block;
    }
    div.max-min {
      width: 50%;
    }
    div.max-min div{
      font-size: 8px;
      line-height: 1.5;
    }
    .max-temp, .min-temp, .rain-prob {
      font-weight: 600;
      font-size: 8px;
      line-height: 1.1;
    }
    div.day-icon {
      width: 40%;
    }
    div.day-icon img {
      position: relative;
      top: -5px;
      left: -5px;
      width: 30px;
    }
    div.day-name {
      margin-top: 8px;
      margin-bottom: 5px;
      text-transform: uppercase;
      font-weight: 600;
      text-align: center;
    }
  }
"""

command: "echo {}"


render: (o) -> """
	<article id="content">
	</article>
"""


afterRender: (dom) ->
  # Create the HTML structure for each defined location.
  $(dom).find('#content').attr('class', @theme)
  for id, _ of @locations
    locationDiv = document.createElement('div')
    locationDiv.setAttribute('id', id)
    locationDiv.setAttribute('class', 'location')
    $(dom).find('#content').append(locationDiv)
    nameSpan = document.createElement('span')
    nameSpan.setAttribute('class', 'name')
    temperatureSpan = document.createElement('span')
    temperatureSpan.setAttribute('class', 'temperature')
    rainSpan = document.createElement('span')
    rainSpan.setAttribute('class', 'rain')
    iconSpan = document.createElement('span')
    iconSpan.setAttribute('class', 'icon')
    $(dom).find('#content #' + id).append(nameSpan)
    $(dom).find('#content #' + id).append(temperatureSpan)
    $(dom).find('#content #' + id + ' .temperature').append(document.createElement('b'))
    $(dom).find('#content #' + id).append(rainSpan)
    $(dom).find('#content #' + id + ' .rain').text('Rain chance: ')
    $(dom).find('#content #' + id + ' .rain').append(document.createElement('b'))
    $(dom).find('#content #' + id).append(iconSpan)
    weekForecastDiv = document.createElement('div')
    weekForecastDiv.setAttribute('id', id + '-week')
    weekForecastDiv.setAttribute('class', 'week-forecast')
    $(dom).find('#content').append(weekForecastDiv)
    for idx in [1..7]
      daySpan = document.createElement('span')
      daySpan.setAttribute('class', 'day')
      daySpan.setAttribute('id', id + '-plus-' + idx)
      $(dom).find('#content #' + id + '-week').append(daySpan)
      maxMinDiv = document.createElement('div')
      maxMinDiv.setAttribute('class', 'max-min')
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx).append(maxMinDiv)
      dayNameDiv = document.createElement('div')
      dayNameDiv.setAttribute('class', 'day-name')
      maxTempDiv = document.createElement('div')
      minTempDiv = document.createElement('div')
      rainProbDiv = document.createElement('div')
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx + ' .max-min').append(dayNameDiv)
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx + ' .max-min').append(maxTempDiv)
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx + ' .max-min').append(minTempDiv)
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx + ' .max-min').append(rainProbDiv)
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx + ' .max-min div:nth-child(2)').text('M: ')
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx + ' .max-min div:nth-child(3)').text('m: ')
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx + ' .max-min div:nth-child(4)').text('R: ')
      maxTempSpan = document.createElement('span')
      maxTempSpan.setAttribute('class', 'max-temp')
      minTempSpan = document.createElement('span')
      minTempSpan.setAttribute('class', 'min-temp')
      rainProbSpan = document.createElement('span')
      rainProbSpan.setAttribute('class', 'rain-prob')
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx + ' .max-min div:nth-child(2)').append(maxTempSpan)
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx + ' .max-min div:nth-child(3)').append(minTempSpan)
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx + ' .max-min div:nth-child(4)').append(rainProbSpan)
      dayIconDiv = document.createElement('div')
      dayIconDiv.setAttribute('class', 'day-icon')
      $(dom).find('#content #' + id + '-week #' + id + '-plus-' + idx).append(dayIconDiv)
  @refresh()


update: (o, dom) ->
  apiKey = @apiKey
  exclude = @exclude
  theme = @theme
  unit = @unit
  widgetName = @widgetName
  days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
  $.each @locations, (id, location) ->
    url = "https://api.forecast.io/forecast/" + apiKey + "/" + location.lat + ","+ location.lng + "?units=si&exclude=" + exclude
    $.ajax({
      url: url
      type: 'GET',
      crossDomain: true,
      dataType: 'jsonp',
      success: (obj) ->
        data = obj
        return unless data.currently? || data.daily?
        # get current temp from json
        t = data.currently.apparentTemperature
        s1 = data.currently.icon
        s1 = s1.replace(/-/g, "_")
        r = data.currently.precipProbability
        $(dom).find('#' + id + ' .name').text(location.name)
        $(dom).find('#' + id + ' .icon').html('<img src="' + widgetName + '.widget/icon/' + theme + '/' + s1 + '.png"></img>')

        $(dom).find('#' + id + ' .temperature b').text(Math.round(t) + ' °C')
        if unit == 'f'
          $(dom).find('#' + id + ' .temperature b').text(Math.round(t * 9 / 5 + 32) + ' °F')

        $(dom).find('#' + id + ' .rain b').text(Math.round(r * 100) + '%')
        $.each data.daily.data, (idx, day) ->
          xx = new Date()
          xx.setTime(day.time*1000)
          $(dom).find('#' + id + '-plus-' + (idx + 1) + ' .day-name').text(days[xx.getDay()])
          $(dom).find('#' + id + '-plus-' + (idx + 1) + ' .rain-prob').text(Math.round(day.precipProbability * 100) + '%')

          $(dom).find('#' + id + '-plus-' + (idx + 1) + ' .max-temp').text(Math.round(day.apparentTemperatureMax))
          $(dom).find('#' + id + '-plus-' + (idx + 1) + ' .min-temp').text(Math.round(day.apparentTemperatureMin))
          if unit == 'f'
            $(dom).find('#' + id + '-plus-' + (idx + 1) + ' .max-temp').text(Math.round(day.apparentTemperatureMax * 9 / 5 + 32))
            $(dom).find('#' + id + '-plus-' + (idx + 1) + ' .min-temp').text(Math.round(day.apparentTemperatureMin * 9 / 5 + 32))

          s2 = day.icon
          s2 = s2.replace(/-/g, "_")
          $(dom).find('#' + id + '-plus-' + (idx + 1) + ' .day-icon').html('<img src="' + widgetName + '.widget/icon/' + theme + '/' + s2 + '.png"></img>')
    })
