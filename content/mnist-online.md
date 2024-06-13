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

***Note that on slower network connections it may not load immediately!***

<style>
  #canvas-container {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  #canvas {
    width: 100%;
    height: 100%;
    max-width: 100vw;
    max-height: 100vh;
    object-fit: contain; /* This ensures the content scales proportionally */
  }
</style>

<div id="canvas-container">
  <canvas class="emscripten" id="canvas" oncontextmenu="event.preventDefault()" tabindex=-1></canvas>
</div>

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
</script>
<script async type="text/javascript" src="mnist-web.js"></script>

This demo is entirely created in C++!
