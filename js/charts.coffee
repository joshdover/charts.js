$ = jQuery

methods = 
  init: (allOptions) ->
    # load the existing data from the chart if there is any
    objectData = this.data('chart')
        
    # create new data based on passed object
    if !objectData
      this.data('chart', {
        url: allOptions.url
        chartType: allOptions.chartType
        options: allOptions.options
        columnTitles: allOptions.columnTitles
        target: this
        chartData: new google.visualization.DataTable()
        jsonData: allOptions.jsonData
        chartDrawn: false
      })
    
    # update our chart's data
    methods.update.apply(this, arguments)
      
  update: ->
    objectData = this.data('chart')
    
    # skip the ajax request if there was no URL passed AND we have jsonData loaded
    if (objectData.url is undefined && !(objectData.jsonData is undefined))
      methods.parse.apply(this, arguments)
    else if !(objectData.url is undefined)
      # get raw data
      target = this
      $.getJSON(objectData.url, (data) ->
        objectData.jsonData = data
        methods.parse.apply(target, arguments)
      )
    else
      $.error('No chart data supplied')
    
  parse: ->
    objectData = this.data('chart')
          
    # add columns to DataTable
    # only if there are columns specified AND we have loaded new data from a URL
    if !(objectData.columnTitles is undefined) and (!(objectData.url is undefined) or ((objectData.url is undefined) and !objectData.chartDrawn))
      objectData.jsonData.splice(0,0,objectData.columnTitles)
  
    # add data to DataTable
    objectData.chartData = google.visualization.arrayToDataTable(objectData.jsonData, (objectData.chartType == 'candlestick') ? true : false)
    
    # draw our chart, if chart already exists, just redraw the chart (allows for animations)
    if objectData.chartDrawn
      objectData.chart.draw(objectData.chartData, objectData.options)
    else
      methods.draw.apply(this, arguments)    
      
  draw: ->
    objectData = this.data('chart')
    
    # universal defaults
    allDefaults = 
      width:800
      height:500
      animation:
        duration:1000
        easing:'inAndOut'
    
    # overload allDefaults with user specified options    
    objectData.options = $.extend(allDefaults, objectData.options) 
    
    # chartType specifics
    if objectData.chartType == 'bar'
    
      # create bar chart at specified DOM element
      objectData.chart = new google.visualization.BarChart( objectData.target.get(0) );
    
    else if objectData.chartType == 'line'
    
      # create line chart at specified DOM element
      objectData.chart = new google.visualization.LineChart( objectData.target.get(0) )
      
    else if objectData.chartType == 'pie'
       
      # create pie chart at specified DOM element
      objectData.chart = new google.visualization.PieChart( objectData.target.get(0) )
    
    else if objectData.chartType == 'combo'
      
      # create combo chart at specified DOM element
      objectData.chart = new google.visualization.ComboChart( objectData.target.get(0) )
      
    else if objectData.chartType == 'column'
      
      # create column chart at specified DOM element
      objectData.chart = new google.visualization.ColumnChart( objectData.target.get(0) )
    
    else if objectData.chartType == 'area'
      
      # create area chart at specified DOM element
      objectData.chart = new google.visualization.AreaChart( objectData.target.get(0) )
      
    else if objectData.chartType == 'bubble'
      
      # create bubble chart at specified DOM element
      objectData.chart = new google.visualization.BubbleChart( objectData.target.get(0) )
      
    else if objectData.chartType == 'candlestick'
      
      # create candlestick chart at specified DOM element
      objectData.chart = new google.visualization.CandlestickChart( objectData.target.get(0) )
      
    else if objectData.chartType == 'scatter'
      
      # create scatter chart at specified DOM element
      objectData.chart = new google.visualization.ScatterChart( objectData.target.get(0) )

    # draw the chart
    objectData.chart.draw(objectData.chartData, objectData.options)
    objectData.chartDrawn = true

$.fn.chart = (method) ->
  
  return this.each( ->

    $this = $(this)
    
    # call method specified with all arguments
    if methods[method]
      methods[ method ].apply( $this, Array.prototype.slice.call( arguments, 1))
  
    # if passed an object, call init with object
    else if typeof method == 'object' or !method    
      methods.init.apply($this, [method])
    
    # error
    else
      $.error('Method ' + method + ' does not exist on jQuery.chart' )
  )
