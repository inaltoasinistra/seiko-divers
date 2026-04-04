#!/usr/bin/env python3
"""
Watch Catalog local server — port 8080.

Static file serving + one write endpoint:
  POST /api/starred   body: JSON array of ref strings
                      saves to user/starred.json
"""

import http.server
import json
import os
import sys
from pathlib import Path

PORT = 8080
STARRED_PATH = Path("user/starred.json")


class Handler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        if self.path == "/api/starred":
            try:
                length = int(self.headers.get("Content-Length", 0))
                body = self.rfile.read(length)
                refs = json.loads(body)
                STARRED_PATH.parent.mkdir(exist_ok=True)
                STARRED_PATH.write_text(json.dumps(refs, indent=2))
                self._respond(200, b"ok")
            except Exception as e:
                self._respond(400, str(e).encode())
        else:
            self._respond(404, b"not found")

    def _respond(self, code, body):
        self.send_response(code)
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def end_headers(self):
        if self.path.endswith(".json"):
            self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def log_message(self, fmt, *args):
        pass  # silence request noise


class SilentHTTPServer(http.server.HTTPServer):
    def handle_error(self, request, client_address):
        if sys.exc_info()[0] is BrokenPipeError:
            return
        super().handle_error(request, client_address)


os.chdir(Path(__file__).parent)
with SilentHTTPServer(("", PORT), Handler) as httpd:
    print(f"Serving on http://localhost:{PORT}  (Ctrl+C to stop)")
    httpd.serve_forever()
