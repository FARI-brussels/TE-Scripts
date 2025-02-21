import sys
import os
import requests
from pathlib import Path
import mimetypes
import vlc
import time
import json
from urllib.parse import urlencode
import shutil
import magic  # for better

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
    base_dir = Path("/home/mrcyme")
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
                content_path.unlink()  # Clean up failed download
            continue
    
    return content_paths

def classify_media(paths):
    """Classify media files into videos and images."""
    videos = []
    images = []
    
    mime = magic.Magic(mime=True)
    
    for path in paths:
        if path.exists():
            file_type = mime.from_file(str(path))
            if file_type.startswith('video/'):
                videos.append(path)
            elif file_type.startswith('image/'):
                images.append(path)
    
    return videos, images

def play_video_loop(video_paths):
    """Play videos in a continuous loop."""
    instance = vlc.Instance()
    media_list = instance.media_list_new()
    
    # Add all videos to the list
    for path in video_paths:
        media = instance.media_new(str(path))
        media_list.add_media(media)
    
    list_player = instance.media_list_player_new()
    player = instance.media_player_new()
    list_player.set_media_player(player)
    list_player.set_media_list(media_list)
    
    # Set fullscreen
    player.set_fullscreen(True)
    
    # Set playback mode to loop
    list_player.set_playback_mode(vlc.PlaybackMode.loop)
    
    # Start playing
    list_player.play()
    
    return list_player, player

def display_image_slideshow(image_paths, image_duration=8):
    """Display images in a slideshow with specified duration."""
    instance = vlc.Instance()
    player = instance.media_player_new()
    
    # Set fullscreen
    player.set_fullscreen(True)
    
    current_image = 0
    
    while True:
        # Get current image path
        image_path = image_paths[current_image]
        
        # Create and set media
        media = instance.media_new(str(image_path))
        player.set_media(media)
        
        # Play image
        player.play()
        
        # Wait for specified duration
        time.sleep(image_duration)
        
        # Move to next image
        current_image = (current_image + 1) % len(image_paths)

def play_media(content_paths):
    """Play media files based on their type."""
    try:
        # Classify media files
        videos, images = classify_media(content_paths)
        
        if videos and not images:
            # If we only have videos, play them in loop
            print("Playing videos in loop...")
            list_player, player = play_video_loop(videos)
            while True:
                time.sleep(1)
                
        elif images and not videos:
            # If we only have images, show slideshow
            print("Starting image slideshow...")
            display_image_slideshow(images)
            
        elif videos and images:
            print("Found both videos and images. Playing videos only...")
            list_player, player = play_video_loop(videos)
            while True:
                time.sleep(1)
        else:
            print("No playable media found")
            sys.exit(1)
    
    except KeyboardInterrupt:
        print("\nPlayback stopped by user")
        sys.exit(0)
    except Exception as e:
        print(f"Error playing media: {str(e)}")
        sys.exit(1)

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 video_handler.py <device_id>")
        sys.exit(1)
    
    device_id = sys.argv[1]
    print(f"Device ID: {device_id}")
    
    # Get all content IDs
    content_ids = get_content_ids(device_id)
    print(f"Found {len(content_ids)} content items")
    
    # Download all content to fresh display_content folder
    content_paths = download_contents(content_ids)
    
    if not content_paths:
        print("No content was successfully downloaded")
        sys.exit(1)
    
    print(f"Successfully downloaded {len(content_paths)} out of {len(content_ids)} items")
    
    # Play all media files
    play_media(content_paths)

if __name__ == "__main__":
    main()