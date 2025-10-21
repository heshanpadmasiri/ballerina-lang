#!/usr/bin/env python3
import http.server
import socketserver
import os

os.chdir('/workspaces/ballerina-lang/web-client-deploy')
PORT = 8080
Handler = http.server.SimpleHTTPRequestHandler
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Server running at http://localhost:{PORT}")
    httpd.serve_forever()
