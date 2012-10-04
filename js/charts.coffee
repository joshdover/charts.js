$ = jQuery

exampleChartData = 0

methods = 
  init: (allOptions) ->
    data = this.data('chart')
    
    if !data
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

    methods.update.apply(this, arguments)
      
  update: ->
    objectData = this.data('chart')
    
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
    if !(objectData.columnTitles is undefined) and (!(objectData.url is undefined) or ((objectData.url is undefined) and !objectData.chartDrawn))
      objectData.jsonData.splice(0,0,objectData.columnTitles)
  
    # add data to DataTable
    objectData.chartData = google.visualization.arrayToDataTable(objectData.jsonData)
       
    methods.draw.apply(this, arguments)    
      
  draw: ->
    objectData = this.data('chart')
    
    # universal defaults
    allDefaults = 
      width:500
      height:300
      animation:
        duration:2000
        easing:'inAndOut'
        
        
    # chart specifics
    if objectData.chartType == 'bar'
    
      # define default options
      barDefaults =
        legend:'none'
        hAxis:
          minValue:0
          
      barDefaults = $.extend(allDefaults, barDefaults)
      objectData.options = $.extend(barDefaults, objectData.options)
    
      # create bar chart object
      # this[0] accesses the first DOM element of the jQuery selector used eg. - $("#myChart")[0] would return the first DOM element with the id 'myChart'
      objectData.chart = new google.visualization.BarChart( objectData.target.get(0) );
    
    else if objectData.chartType == 'line'
          
      lineDefaults = 

      lineDefaults = $.extend(allDefaults, lineDefaults)
      objectData.options = $.extend(lineDefaults, objectData.options)
        
      # create bar chart object
      # this[0] accesses the first DOM element of the jQuery selector used eg. - $("#myChart")[0] would return the first DOM element with the id 'myChart'
      objectData.chart = new google.visualization.LineChart( objectData.target.get(0) )
      
    else if objectData.chartType == 'pie'
      
      pieDefaults = {}
      
      pieDefaults = $.extend(allDefaults, pieDefaults)
      objectData.options = $.extend(pieDefaults, objectData.options)
      
      objectData.chart = new google.visualization.PieChart( objectData.target.get(0) )
      
    
    # draw the chart
    objectData.chart.draw(objectData.chartData, objectData.options)
    objectData.chartDrawn = true

$.fn.chart = (method) ->
  if methods[method]
    return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1))
  else if typeof method == 'object' or !method
    return methods.init.apply(this, arguments)
  else
    $.error('Method ' + method + ' does not exist on jQuery.chart' )
