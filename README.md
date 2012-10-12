# Charts.js 0.3

A jQuery plugin to make using Google Charts super simple, without losing customizability.

## Basic Setup

Include the appropriate libraries in your `<head>` tag
  
```html
<!-- jQuery -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
    
<!-- Google JS-API -->
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    
<!-- Charts.js -->
<script type="text/javascript" src="js/charts.js"></script>
```

Load the Google Charts Library

```html
<script type="text/javascript">
// Load the visualization library
google.load('visualization', '1.0', {'packages':['corechart']});
</script>
```

On the Google Charts callback, draw your charts using Charts.js

```html
<script type="text/javascript">
google.setOnLoadCallback(makeCharts);
function makeCharts() {
  $("#chart-bar").chart({
    chartType:'bar',
    columnTitles:['Answer', 'Frequency'],
    jsonData: [["1",1],
              ["2",4],
              ["3",1],
              ["4",3]]
  });
}
</script>
```

## Specifying Data

You may either pass json directly upon creating the chart, or give the chart a url to make an AJAX request for the data. Currently, all data injected into the chart using the `google.visualization.arrayToDataTable()` method which you can read about [here](https://google-developers.appspot.com/chart/interactive/docs/datatables_dataviews#arraytodatatable).

### Passing JSON

JSON needs to be in a format where each row represents a data point, and each column represents a series. Column titles may be included in either the JSON or the `columnTitles` attribute. Column data types are implicit.

```javascript
$('#chart').chart({
  chartType:'bar',
  columnTitles:['Answer', 'Frequency'],
  jsonData: [
              ["1",1],
              ["2",4],
              ["3",1],
              ["4",3]
            ]
});
```

### Passing a URL

Make sure the JSON returned by the server matches the format above.

```javascript
$('#chart').chart({
  chartType:'bar',
  columnTitles:['Answer', 'Frequency'],
  url: 'demo.json'
});
```

If you have used a URL for data, you can ask the chart to refresh its data by calling `update`.

```javascript
$('#chart').chart('update');
```

### Column Titles

You may either specify the column titles of each series in your array using the `columnTitles` item, or they may be included in the JSON you pass in, or by the data returned by the server at the URL. 

## Customizing

Google Charts allows for tons of customization, you and Charts.js supports all of these customization options. 

### Chart Types

Charts.js supports `'bar'`, `'column'`, `'line'`, `'pie'`, `'combo'`, `'area'`, `'bubble'`, `'candlestick'`, and `'scatter'` graphs. Simply specify the type of graph you want on creation. You can also change it later and redraw the chart to see the changes.

```javascript
// specify at creation
$('#chart').chart({
  chartType:'bar',
  columnTitles:['Answer', 'Frequency'],
  url: 'demo.json'
});

// or change it later
$('#chart').data('chart').chartType = 'bar';

// but don't forget to redraw the chart
$('#chart').chart('draw');
```

### Google Charts Options

You may specify any options from the [Google Charts API](https://google-developers.appspot.com/chart/interactive/docs/customizing_charts) by passing them to the `options` item.

```javascript
$('#chart').chart({
  chartType:'bar',
  url: 'demo.json',
  options: {
    height: 600,
    width: 1200
  }
});
```

Options can also be changed after creation by updating the `options` object and redrawing the chart

```javascript
$('#chart').data('chart').options.height = 1000;
$('#chart').chart('draw');
```

# Changelog

## 0.3
* Fixed animating of charts when data is changed. Animations will work on `$('#chart').chart('update')`. Animations can be customized by changing `options.animation` item.
* Fixed chainability issues with jQuery

## 0.2
* Added all chart types included in the Google Charts `corechart` library
* Added ability to call `draw` to update chart to reflect changed options rather than using `update` for less data polling.