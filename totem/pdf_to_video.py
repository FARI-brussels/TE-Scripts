import cv2
from pdf2image import convert_from_path
from PIL import Image
import numpy as np

def pdf_to_video(pdf_path, video_path, duration_per_slide=6):
    # Convert PDF to a list of images
    images = convert_from_path(pdf_path, dpi=200, fmt='jpeg')
    
    # Assuming a fixed frame rate
    fps = 1
    frame_duration = fps * duration_per_slide  # How many times to duplicate each frame

    # Find the max width and height
    max_width = max(image.width for image in images)
    max_height = max(image.height for image in images)
    resolution = (max_width, max_height)

    # Define the codec and create VideoWriter object
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # You can use 'XVID' if you prefer
    video = cv2.VideoWriter(video_path, fourcc, fps, resolution)

    for image in images:
        # Resize/canvas image
        new_image = Image.new("RGB", resolution, (255, 255, 255))
        new_image.paste(image, ((max_width - image.width) // 2,
                                (max_height - image.height) // 2))
        
        # Convert PIL image to OpenCV format
        open_cv_image = np.array(new_image) 
        open_cv_image = open_cv_image[:, :, ::-1].copy()  # Convert RGB to BGR 
        
        # Insert the same frame multiple times based on the desired duration
        for _ in range(frame_duration):
            video.write(open_cv_image)

    # Release everything when job is finished
    video.release()



# Example usage
pdf_path = 'conference.pdf'
video_path = 'conference.mp4'
pdf_to_video(pdf_path, video_path)
