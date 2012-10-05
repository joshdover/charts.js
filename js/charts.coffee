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
    
    # only make ajax request if there was no URL passed
    if (objectData.url is undefined)
      methods.parse.apply(this, arguments)
    else
      # get raw data
      $.getJSON(objectData.url, (data) ->
        objectData.jsonData = data
        methods.parse.apply(this, arguments)
      )
    
  parse: ->
    objectData = this.data('chart')
          
    # add columns to DataTable
    # only if there are columns specified AND we have loaded new data from a URL
    if !(objectData.columnTitles is undefined) and (!(objectData.url is undefined) or ((objectData.url is undefined) and !objectData.chartDrawn))
      objectData.jsonData.splice(0,0,objectData.columnTitles)
  
    # add data to DataTable
    objectData.chartData = google.visualization.arrayToDataTable(objectData.jsonData)
    
    # draw our chart
    methods.draw.apply(this, arguments)    
      
  draw: ->
    objectData = this.data('chart')
    
    # universal defaults
    allDefaults = 
      width:500
      height:300
      animation:
        duration:1000
        easing:'inAndOut'
        
        
    # chartType specifics
    if objectData.chartType == 'bar'
    
      # default options for chartType = 'bar'
      barDefaults =
        legend:'none'
        hAxis:
          minValue:0
          
      # overload allDefaults with barDefaults, overload barDefaults with user specified options
      barDefaults = $.extend(allDefaults, barDefaults)
      objectData.options = $.extend(barDefaults, objectData.options)
    
      # create bar chart at specified DOM element
      objectData.chart = new google.visualization.BarChart( objectData.target.get(0) );
    
    else if objectData.chartType == 'line'
      
      # default options for chartType = 'line' 
      lineDefaults = {}
      
      # overload allDefaults with lineDefaults, overload lineDefaults with user specified options
      lineDefaults = $.extend(allDefaults, lineDefaults)
      objectData.options = $.extend(lineDefaults, objectData.options)
        
      # create line chart at specified DOM element
      objectData.chart = new google.visualization.LineChart( objectData.target.get(0) )
      
    else if objectData.chartType == 'pie'
      
      # default options for chartType = 'pie' 
      pieDefaults = {}
      
      # overload allDefaults with pieDefaults, overload pieDefaults with user specified options
      pieDefaults = $.extend(allDefaults, pieDefaults)
      objectData.options = $.extend(pieDefaults, objectData.options)
      
      # create pie chart at specified DOM element
      objectData.chart = new google.visualization.PieChart( objectData.target.get(0) )
      
    
    else if objectData.chartType == 'combo'
    
      # default options for chartType = 'combo' 
      comboDefaults = {}
      
      # overload allDefaults with pieDefaults, overload pieDefaults with user specified options
      comboDefaults = $.extend(allDefaults, comboDefaults)
      objectData.options = $.extend(comboDefaults, objectData.options)
      
      # create pie chart at specified DOM element
      objectData.chart = new google.visualization.ComboChart( objectData.target.get(0) )
    
    # draw the chart
    objectData.chart.draw(objectData.chartData, objectData.options)
    objectData.chartDrawn = true

$.fn.chart = (method) ->
  
  # call method specified with all arguments
  if methods[method]
    return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1))
  
  # if passed an object, call init with object
  else if typeof method == 'object' or !method
    return methods.init.apply(this, arguments)
    
  # error
  else
    $.error('Method ' + method + ' does not exist on jQuery.chart' )
