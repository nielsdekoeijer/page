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

<canvas class="emscripten" id="canvas" oncontextmenu="event.preventDefault()" tabindex=-1></canvas>
<script type='text/javascript'>
  var Module = {
    canvas: (() => {
      var canvas = document.getElementById('canvas');
      canvas.addEventListener("webglcontextlost", (e) => { 
              alert('WebGL context lost. You will need to reload the page.'); e.preventDefault(); }, false);

      return canvas;
    })(),

    // realistically I have no idea what this does, but removing it breaks things
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

  function resizeCanvas() {
    var canvas = document.getElementById('canvas');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    if (Module && Module.canvas) {
      Module.canvas = canvas;
      if (Module.resize) {
        Module.resize(canvas.width, canvas.height);
      }
    }
  }

  window.addEventListener('load', resizeCanvas);
  window.addEventListener('resize', resizeCanvas);

</script>
<script async type="text/javascript" src="mnist-web.js"></script>

This demo is entirely created in C++!
