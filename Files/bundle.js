(function (React,ReactDOM,d3) {
  'use strict';

  React = React && React.hasOwnProperty('default') ? React['default'] : React;
  ReactDOM = ReactDOM && ReactDOM.hasOwnProperty('default') ? ReactDOM['default'] : ReactDOM;

  //console.log (arc);

  const width=960; 
  const height=500;
  const cx = width/2;
  const cy = height/2;
  const strokewidth = 10;
  const eyeOffsetX = 100;
  const eyeoffsety1 =120;
  const eyeoffsety2 =120;
  const eyeradius =40;
  const mouthwidth =20;
  const mouthradius =100;
  const noseoffset =20;
  const noseradius =60;
  const moutharc = d3.arc()
      .innerRadius(mouthradius)
      .outerRadius(mouthradius+mouthwidth)
      .startAngle(Math.PI*0.5)
      .endAngle(Math.PI*1.25 );


  const App =() => (
      React.createElement( 'svg', { width: width, height: height },
      React.createElement( 'g', { transform: `translate(${cx},${cy})` },
              React.createElement( 'circle', {
                //cx={cx}
                //cy={cy}
                r: cy -strokewidth/2, fill: "yellow", stroke: "black", 'stroke-width': strokewidth }
              ),

              React.createElement( 'circle', {
                cx: -eyeOffsetX, cy: -eyeoffsety1, r: eyeradius }
              ),
              React.createElement( 'circle', { cy: -noseoffset, r: noseradius, stroke: "black", 'stroke-width': "3", fill: "red" }),
             
        			React.createElement( 'circle', {
                cx: + eyeOffsetX, cy: -eyeoffsety2, r: eyeradius }
              ),
           
            React.createElement( 'path', { d: moutharc() })
        )
      )
    );
  const rootElement = document.getElementById("root");
  ReactDOM.render(React.createElement( App, null ), rootElement);
  //console.log(moutharc());

}(React,ReactDOM,d3));