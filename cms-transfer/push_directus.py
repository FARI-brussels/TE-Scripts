import requests

# Base URL for Directus
base_url = "https://fari-cms.directus.app"
access_token = "vgVJBSjtM1gueChZgpXV52IkryKFLM5A"

# Headers with Bearer token
headers = {
    "Authorization": f"Bearer {access_token}"
}

def upload_file(file_path, title):
    upload_url = f"{base_url}/files"
    
    # Prepare the multipart/form-data with metadata and the file content
    files = {
        "title": (None, title),  # Metadata (title) must be included first
        "file": (file_path, open(file_path, "rb"), "multipart/form-data"),  # File upload
    }

    response = requests.post(upload_url, headers=headers, files=files)
    
    # Check if the file upload was successful
    if response.status_code == 200:
        file_data = response.json()
        print(f"File uploaded successfully: {file_data}")
        return file_data["data"]["id"]  # Return the uploaded file's ID
    else:
        print(f"Failed to upload file: {file_path}. Status code: {response.status_code}")
        print(response.json())
        return None

# Paths for image, video, logos, and SDG images
image_path = "/home/mrcyme/Pictures/tictactoe1.png"
video_path = "path_to_your_video.mp4"
logo_paths = ["path_to_logo1.png", "path_to_logo2.png"]
sdg_image_paths = [ "/home/mrcyme/Pictures/tictactoe2.png",  "/home/mrcyme/Pictures/tictactoe3.png"]

# Upload the image, video, logos, and SDG images
image_id = upload_file(image_path, "test.png")
#video_id = upload_file(video_path)
#logo_ids = [upload_file(path) for path in logo_paths]
sdg_image_ids = [upload_file(path, "swag.png") for path in sdg_image_paths]

# Remove None values from logos and SDG images in case of failed uploads
#logo_ids = [id for id in logo_ids if id is not None]
sdg_image_ids = [id for id in sdg_image_ids if id is not None]

# Create the demo item
demo_data = {
    "status": "draft",
    "title": "New Demo",
    "image": image_id,  # Image file ID
    #"video": video_id,  # Video file ID
    #"logos": logo_ids,  # List of logo file IDs
    "sdg_images": sdg_image_ids  # List of SDG image file IDs
}

# URL for creating a new demo in Directus
demo_url = f"{base_url}/items/demos"

# Make the POST request to create a new demo
response = requests.post(demo_url, headers=headers, json=demo_data)

# Check if the demo creation was successful
if response.status_code == 200:
    print("Demo created successfully.")
    created_demo = response.json()
    print(created_demo)
else:
    print(f"Failed to create demo. Status code: {response.status_code}")
    print(response.json())
