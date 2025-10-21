#!/usr/bin/env python3
"""
Simple Python web server to serve the Ballerina web client files.
This server serves the generated JavaScript files and HTML from the bazel build output.
"""

import http.server
import socketserver
import os
import sys
import webbrowser
from pathlib import Path

# Configuration
PORT = 8080
HOST = 'localhost'

class CustomHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """Custom request handler with CORS headers and proper MIME types."""

    def end_headers(self):
        # Add CORS headers to allow cross-origin requests
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        super().end_headers()

    def guess_type(self, path):
        """Override to set correct MIME types for JavaScript files."""
        mimetype, encoding = super().guess_type(path)

        if path.endswith('.js'):
            return 'application/javascript'
        elif path.endswith('.js.map'):
            return 'application/json'
        elif path.endswith('.html'):
            return 'text/html'

        return mimetype

def find_bazel_output():
    """Find the bazel output directory containing the built files."""
    # Look for bazel-bin directory
    possible_paths = [
        '/workspaces/ballerina-lang/bazel-bin/web-client',
        './bazel-bin/web-client',
        '../bazel-bin/web-client',
        '../../bazel-bin/web-client'
    ]

    for path in possible_paths:
        if os.path.exists(path):
            return path

    return None

def main():
    """Main function to start the web server."""
    print("Ballerina Web Client Server")
    print("=" * 40)

    # Find the bazel output directory
    bazel_output = find_bazel_output()

    if not bazel_output:
        print("❌ Error: Could not find bazel output directory")
        print("Please make sure you have built the web-client first:")
        print("  bazel build //web-client:web-client")
        sys.exit(1)

    print(f"📁 Serving files from: {bazel_output}")

    # Change to the bazel output directory
    os.chdir(bazel_output)

    # Copy the HTML file to the output directory if it doesn't exist
    html_source = '/workspaces/ballerina-lang/web-client/index.html'
    html_dest = os.path.join(bazel_output, 'index.html')

    if os.path.exists(html_source) and not os.path.exists(html_dest):
        import shutil
        shutil.copy2(html_source, html_dest)
        print(f"📄 Copied HTML file to output directory")

    # List available files
    print("\n📋 Available files:")
    for file in sorted(os.listdir('.')):
        if os.path.isfile(file):
            size = os.path.getsize(file)
            print(f"  - {file} ({size:,} bytes)")

    # Start the server
    try:
        with socketserver.TCPServer((HOST, PORT), CustomHTTPRequestHandler) as httpd:
            print(f"\n🚀 Server starting on http://{HOST}:{PORT}")
            print(f"📱 Open your browser and go to: http://{HOST}:{PORT}")
            print("\nPress Ctrl+C to stop the server")
            print("-" * 40)

            # Try to open the browser automatically
            try:
                webbrowser.open(f'http://{HOST}:{PORT}')
                print("🌐 Browser opened automatically")
            except Exception as e:
                print(f"⚠️  Could not open browser automatically: {e}")

            httpd.serve_forever()

    except KeyboardInterrupt:
        print("\n\n🛑 Server stopped by user")
    except OSError as e:
        if e.errno == 98:  # Address already in use
            print(f"❌ Error: Port {PORT} is already in use")
            print(f"Try using a different port or stop the existing server")
        else:
            print(f"❌ Error starting server: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
