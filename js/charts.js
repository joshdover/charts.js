// Generated by CoffeeScript 1.3.3
(function() {
  var $, methods;

  $ = jQuery;

  methods = {
    init: function(allOptions) {
      var objectData;
      objectData = this.data('chart');
      if (!objectData) {
        this.data('chart', {
          url: allOptions.url,
          chartType: allOptions.chartType,
          options: allOptions.options,
          columnTitles: allOptions.columnTitles,
          target: this,
          chartData: new google.visualization.DataTable(),
          jsonData: allOptions.jsonData,
          chartDrawn: false
        });
      }
      return methods.update.apply(this, arguments);
    },
    update: function() {
      var objectData;
      objectData = this.data('chart');
      if (objectData.url === void 0) {
        return methods.parse.apply(this, arguments);
      } else {
        return $.getJSON(objectData.url, function(data) {
          objectData.jsonData = data;
          return methods.parse.apply(this, arguments);
        });
      }
    },
    parse: function() {
      var objectData, _ref;
      objectData = this.data('chart');
      if (!(objectData.columnTitles === void 0) && (!(objectData.url === void 0) || ((objectData.url === void 0) && !objectData.chartDrawn))) {
        objectData.jsonData.splice(0, 0, objectData.columnTitles);
      }
      objectData.chartData = google.visualization.arrayToDataTable(objectData.jsonData, (_ref = objectData.chartType === 'candlestick') != null ? _ref : {
        "true": false
      });
      return methods.draw.apply(this, arguments);
    },
    draw: function() {
      var allDefaults, objectData;
      objectData = this.data('chart');
      allDefaults = {
        width: 800,
        height: 500,
        animation: {
          duration: 1000,
          easing: 'inAndOut'
        }
      };
      objectData.options = $.extend(allDefaults, objectData.options);
      if (objectData.chartType === 'bar') {
        objectData.chart = new google.visualization.BarChart(objectData.target.get(0));
      } else if (objectData.chartType === 'line') {
        objectData.chart = new google.visualization.LineChart(objectData.target.get(0));
      } else if (objectData.chartType === 'pie') {
        objectData.chart = new google.visualization.PieChart(objectData.target.get(0));
      } else if (objectData.chartType === 'combo') {
        objectData.chart = new google.visualization.ComboChart(objectData.target.get(0));
      } else if (objectData.chartType === 'column') {
        objectData.chart = new google.visualization.ColumnChart(objectData.target.get(0));
      } else if (objectData.chartType === 'area') {
        objectData.chart = new google.visualization.AreaChart(objectData.target.get(0));
      } else if (objectData.chartType === 'bubble') {
        objectData.chart = new google.visualization.BubbleChart(objectData.target.get(0));
      } else if (objectData.chartType === 'candlestick') {
        objectData.chart = new google.visualization.CandlestickChart(objectData.target.get(0));
      } else if (objectData.chartType === 'scatter') {
        objectData.chart = new google.visualization.ScatterChart(objectData.target.get(0));
      }
      objectData.chart.draw(objectData.chartData, objectData.options);
      return objectData.chartDrawn = true;
    }
  };

  $.fn.chart = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      return $.error('Method ' + method + ' does not exist on jQuery.chart');
    }
  };

}).call(this);
