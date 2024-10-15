const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');

// Directus API base URL and access token
const directusUrl = 'https://fari-cms.directus.app';
const accessToken = 'vgVJBSjtM1gueChZgpXV52IkryKFLM5A';  // Replace with your actual token

// Function to upload a file with metadata
async function uploadFile(filePath, title) {
    const form = new FormData();

    // Append metadata and file to the form-data
    form.append('title', title);
    form.append('file', fs.createReadStream(filePath));

    try {
        const response = await axios.post(`${directusUrl}/files`, form, {
            headers: {
                'Authorization': `Bearer ${accessToken}`,
                ...form.getHeaders()  // Get the correct headers for form-data
            }
        });

        if (response.status === 200) {
            console.log('File uploaded successfully:', response.data);
            return response.data.data.id;  // Return the uploaded file's ID
        }
    } catch (error) {
        console.error('Error uploading file:', error.response ? error.response.data : error.message);
    }
}

// Example usage: Upload image and video
(async () => {
    const imagePath = "/home/mrcyme/Pictures/tictactoe1.png";  // Replace with actual file path
    const videoPath = 'path_to_your_video.mp4';  // Replace with actual file path

    const imageId = await uploadFile(imagePath, 'Demo Image');
    const videoId = await uploadFile(videoPath, 'Demo Video');

    console.log('Uploaded Image ID:', imageId);
    console.log('Uploaded Video ID:', videoId);
})();
