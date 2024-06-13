import os
import http.server
import socketserver

# Define the port on which you want to serve your files
PORT = 8001

# Define the directory to serve files from
directory_to_serve = "content"

# Change the current working directory to the specified directory
os.chdir(directory_to_serve)

# Define the handler to use the SimpleHTTPRequestHandler class
Handler = http.server.SimpleHTTPRequestHandler

# Create the socket server
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving at port {PORT}")
    # Serve the files indefinitely
    httpd.serve_forever()

