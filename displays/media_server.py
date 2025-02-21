import sys
import os
import requests
import shutil
from pathlib import Path
import mimetypes
import time
import json
from urllib.parse import urlencode
import magic
from http.server import HTTPServer, SimpleHTTPRequestHandler
import webbrowser
import threading
import subprocess

class MediaHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, media_dir=None, **kwargs):
        self.media_dir = media_dir
        super().__init__(*args, **kwargs)

    def do_GET(self):
        if self.path == '/media-list':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            
            mime = magic.Magic(mime=True)
            media_files = []
            
            # Get all files in the media directory sorted by modification time
            files = sorted(
                Path(self.media_dir).glob('*'),
                key=lambda x: x.stat().st_mtime
            )
            
            for file_path in files:
                try:
                    file_type = mime.from_file(str(file_path))
                    if file_type.startswith(('video/', 'image/')):
                        media_type = 'video' if file_type.startswith('video/') else 'image'
                        media_files.append({
                            'path': f'/{file_path.name}',
                            'type': media_type
                        })
                except Exception as e:
                    print(f"Error processing file {file_path}: {e}")
            
            self.wfile.write(json.dumps(media_files).encode())
            return
            
        return super().do_GET()

def get_content_ids(device_id):
    """Get content IDs from device ID using Directus API."""
    try:
        # Prepare the query parameters
        params = {
            'fields': '*.*'  # Fetch all fields including all media
        }
        
        # Make the API request with parameters
        url = f"https://fari-cms.directus.app/items/displays"
        response = requests.get(url, params=params)
        response.raise_for_status()
        data = response.json()["data"]
        print(data)
        display = next(display for display in data if display['connected_device']['device_id'] == device_id)
        # Extract all content IDs
        content_items = [c["directus_files_id"] for c in display["content"]]

        
        return content_items
    
    except requests.RequestException as e:
        print(f"Error fetching displays data: {str(e)}")
        sys.exit(1)
    except (json.JSONDecodeError, KeyError) as e:
        print(f"Error parsing displays data: {str(e)}")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {str(e)}")
        sys.exit(1)
        

def download_contents(content_ids):
    """Download all content from Directus to a fresh display_content folder."""
    base_dir = Path("/home/fari")
    content_dir = base_dir / "display_content"
    
    # Remove existing display_content folder if it exists
    if content_dir.exists():
        print("Removing existing display_content folder...")
        shutil.rmtree(content_dir)
    
    # Create fresh display_content directory
    print("Creating new display_content folder...")
    content_dir.mkdir(parents=True, exist_ok=True)
    
    content_paths = []
    for content_id in content_ids:
        content_path = content_dir / f"{content_id}"
        print(f"Downloading content {content_id}...")
        
        try:
            url = f"https://fari-cms.directus.app/assets/{content_id}"
            response = requests.get(url, stream=True)
            response.raise_for_status()
            
            # Save the content
            with open(content_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            
            print(f"Download completed successfully for {content_id}")
            content_paths.append(content_path)
            
        except Exception as e:
            print(f"Error downloading content {content_id}: {str(e)}")
            if content_path.exists():
                content_path.unlink()
            continue
    
    return content_dir, content_paths

def start_server(content_dir):
    """Start HTTP server to serve media files."""
    # Copy index.html to content directory
    script_dir = Path(__file__).parent
    index_path = script_dir / "index.html"
    shutil.copy(index_path, content_dir / "index.html")
    
    # Change to content directory
    os.chdir(content_dir)
    
    # Start server
    port = 8000
    handler = lambda *args: MediaHandler(*args, media_dir=content_dir)
    server = HTTPServer(('localhost', port), handler)
    print(f"Server started at http://localhost:{port}")
    
    # Run server in a separate thread
    server_thread = threading.Thread(target=server.serve_forever)
    server_thread.daemon = True
    server_thread.start()
    
    return f"http://localhost:{port}"

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 media_server.py <device_id>")
        sys.exit(1)
    
    device_id = sys.argv[1]
    print(f"Device ID: {device_id}")
    
    # Get all content IDs
    content_ids = get_content_ids(device_id)
    print(f"Found {len(content_ids)} content items")
    
    # Download all content to fresh display_content folder
    content_dir, content_paths = download_contents(content_ids)
    
    if not content_paths:
        print("No content was successfully downloaded")
        sys.exit(1)
    
    print(f"Successfully downloaded {len(content_paths)} out of {len(content_ids)} items")
    
    # Start server and open browser
    server_url = start_server(content_dir)
    
    # Keep script running
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nShutting down...")
        sys.exit(0)

if __name__ == "__main__":
    main()