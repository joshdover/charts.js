# Charts.js

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

On the Google Charts callback, make our charts using Charts.js

```html
<script type="text/javascript">
google.setOnLoadCallback(makeCharts);
function makeCharts() {
  $("#chart-bar").chart({
    chartType:'bar',
    columnTitles:['Answer', 'Frequency'],
    jsonData: [
                ["1",1],
                ["2",4],
                ["3",1],
                ["4",3]
              ]
  });
}
</script>
```

## Specifying Data

You may either pass json directly upon creating the chart, or give the chart a url to make an AJAX request for the data. Currently, all data injected into the chart using the `google.visualization.arrayToDataTable()` method which you can read about [here](https://google-developers.appspot.com/chart/interactive/docs/datatables_dataviews#arraytodatatable).

### Passing JSON on creation
```javascript
$("#chart-bar").chart({
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

### Pass a URL
```javascript
$("#chart-bar").chart({
  chartType:'bar',
  columnTitles:['Answer', 'Frequency'],
  url: 'demo.json'
});
```

If you have used a URL for data, you can ask the chart to refresh its data by calling

```javascript
$("#chart").chart("update");
```

## Customizing

Google Charts allows for tons of customization, you and Charts.js supports all of these customization options. 

### Chart Types

Currently Charts.js only supports Bar, Pie, and Line graphs, but much more support is on its way. Simply specify the type of graph you want on initialization, or change it later.

```javascript
// Specify at creation

$("#chart").chart({
  chartType:'bar', // valid values: 'bar', 'pie', or 'line'
  columnTitles:['Answer', 'Frequency'],
  url: 'demo.json'
});

// or later on...

$("#chart").data("chart").chartType = 'bar';

// ...but don't forget to refresh the chart
$("#chart").chart("update");
```

### Google Charts Options

You may specify any options from the [Google Charts API](https://google-developers.appspot.com/chart/interactive/docs/customizing_charts) by passing them to the `options` item.

```javascript
$("#chart").chart({
  chartType:'bar',
  url: 'demo.json',
  options: {
    height: 600,
    width: 1200
  }
});