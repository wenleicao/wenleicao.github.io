---
layout: post
title: Show D3 and React Visualization in Github Page
---

Let us say, you create some javascript data visualization somewhere and you would like it show in Github page site. Is it possible?
The following is Massachusetts county map, I created with D3 and react in javascript.  The legend is interactive if you hover mouse over it.

<html>
  <head>
    <title>Massachusetts Chrolopleth map with interactive legend and viewbox</title>
    <link
      href="https://fonts.googleapis.com/css?family=Poppins&display=swap"
      rel="stylesheet"
    />
    <link href="styles.css" rel="stylesheet" />
    <script src="https://unpkg.com/react@16.9.0/umd/react.production.min.js"></script>
    <script src="https://unpkg.com/react-dom@16.9.0/umd/react-dom.production.min.js"></script>
    <script src="https://unpkg.com/d3@5.11.0/dist/d3.min.js"></script>
  			<script src="https://unpkg.com/topojson@3.0.2/dist/topojson.min.js"></script>  
  </head>
  <body>
    <div id="root">
    <script src="/Files/MA_county_map.js">
    
    </script>
    </div>
    
    <div id="root1">
    <script src="/Files/MA_crime_rate.js">
    
    </script>
    </div>
    
     
  </body>
</html>


what about add another one? not sure if it works
