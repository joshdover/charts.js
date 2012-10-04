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
      methods.parse.apply(objectData, arguments)
    else
      # get raw data
      $.getJSON(objectData.url, (data) ->
        objectData.jsonData = data
        methods.parse.apply(objectData, arguments)
      )
    
  parse: ->             
    # add columns to DataTable
    if !(this.columnTitles is undefined)
      this.jsonData.splice(0,0,this.columnTitles)
  
    # add data to DataTable
    this.chartData = google.visualization.arrayToDataTable(this.jsonData)
       
    methods.draw.apply(this, arguments)    
      
  draw: ->
    # universal defaults
    allDefaults = 
      width:500
      height:300
      animation:
        duration:2000
        easing:'inAndOut'
        
        
    # chart specifics
    if this.chartType == 'bar'
    
      # define default options
      barDefaults =
        legend:'none'
        hAxis:
          minValue:0
          
      barDefaults = $.extend(allDefaults, barDefaults)
      this.options = $.extend(barDefaults, this.options)
    
      # create bar chart object
      # this[0] accesses the first DOM element of the jQuery selector used eg. - $("#myChart")[0] would return the first DOM element with the id 'myChart'
      this.chart = new google.visualization.BarChart( this.target.get(0) );
    
    else if this.chartType == 'line'
          
      comboDefaults = 
        curveType:'function'
        pointSize:4
        legend:'none'

      comboDefaults = $.extend(allDefaults, comboDefaults)
      this.options = $.extend(comboDefaults, this.options)
        
      # create bar chart object
      # this[0] accesses the first DOM element of the jQuery selector used eg. - $("#myChart")[0] would return the first DOM element with the id 'myChart'
      this.chart = new google.visualization.LineChart( this.target.get(0) )
      
    else if this.chartType == 'pie'
      
      pieDefaults = {}
      
      pieDefaults = $.extend(allDefaults, pieDefaults)
      this.options = $.extend(pieDefaults, this.options)
      
      this.chart = new google.visualization.PieChart( this.target.get(0) )
      
    
    # draw the chart
    this.chart.draw(this.chartData, this.options)
    this.chartDrawn = true

$.fn.chart = (method) ->
  if methods[method]
    return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1))
  else if typeof method == 'object' or !method
    return methods.init.apply(this, arguments)
  else
    $.error('Method ' + method + ' does not exist on jQuery.chart' )
