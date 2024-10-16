---
title: "MNIST Online"
author: "Niels"
date: "2024-06-11"
---

# MNist Online
Here is a small demo MNIST classifier built with WebAssembly using the Raylib and ONNXRuntime libraries.
On the canvas below, you can draw a number.
A neural net will then run in your browser to determine which number it is (0 through 9).
The red bars will indicate the likelyhood of each number as you draw on the canvas.

This demo is entirely created in C++ and served statically from github. The technolgies used here are essentially raylib (for drawing stuff) and ONNXRuntime (for running neural networks). These two technolgies are quite nice for this task as the authors have kindly provided easy ways to cross compile them.
In my view it nicely showcases what's possible with WASM! We live in exciting times. 

***Note that on slower network connections it may not load immediately!***

<canvas class="emscripten" id="canvas" oncontextmenu="event.preventDefault()" tabindex=-1></canvas>
<script type='text/javascript'>
  var Module = {
    print: (function() {
      var element = document.getElementById('output');
      if (element) element.value = ''; // clear browser cache
      return (...args) => {
        var text = args.join(' ');
        console.log(text);
        if (element) {
          element.value += text + "\n";
          element.scrollTop = element.scrollHeight; // focus on bottom
        }
      };
    })(),
    canvas: (() => {
      var canvas = document.getElementById('canvas');
      canvas.addEventListener("webglcontextlost", (e) => { 
        alert('WebGL context lost. You will need to reload the page.'); 
        e.preventDefault(); 
      }, false);
      return canvas;
    })(),
    setStatus: (text) => {
      if (!Module.setStatus.last) Module.setStatus.last = { time: Date.now(), text: '' };
      if (text === Module.setStatus.last.text) return;
      var m = text.match(/([^(]+)\((\d+(\.\d+)?)\/(\d+)\)/);
      var now = Date.now();
      if (m && now - Module.setStatus.last.time < 30) return; // if this is a progress update, skip it if too soon
      Module.setStatus.last.time = now;
      Module.setStatus.last.text = text;
      if (m) {
        text = m[1];
      }
    },
    totalDependencies: 0,
    monitorRunDependencies: (left) => {
      this.totalDependencies = Math.max(this.totalDependencies, left);
      Module.setStatus(left ? 'Preparing... (' + (this.totalDependencies-left) + '/' + this.totalDependencies + ')' : 'All downloads complete.');
    }
  };
  Module.setStatus('Downloading...');
  window.onerror = (event) => {
    Module.setStatus('Exception thrown, see JavaScript console');
    Module.setStatus = (text) => {
      if (text) console.error('[post-exception status] ' + text);
    };
  };

  function adjustCanvasScale() {
    var canvas = document.getElementById('canvas');
    var containerWidth = document.documentElement.clientWidth;
    var containerHeight =document.documentElement.clientHeight;
    
    // Calculate the scale based on desired maximum size
    var maxCanvasWidth = 760;
    var maxCanvasHeight = 560;
    
    var scaleWidth = containerWidth / maxCanvasWidth;
    var scaleHeight = containerHeight / maxCanvasHeight;
    
    // Use the smaller scale to ensure the canvas fits within the viewport
    var scale = Math.min(scaleWidth, scaleHeight);
    
    canvas.style.transform = `scale(${scale * 0.9})`;
    canvas.style.transformOrigin = 'top left';
  }
  
  // Adjust the canvas scale on load and on window resize
  window.addEventListener('load', adjustCanvasScale);
  window.addEventListener('resize', adjustCanvasScale);
</script>
<script async type="text/javascript" src="mnist-web.js"></script>

<style>
  #canvas {
    margin-left: 20;
  }
</style>

