const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');
const md5 = require('md5');  // Use md5 library instead of Node's crypto
const { title } = require('process');
const path = require('path');

// Base URL for Directus and access token
const base_url = "https://fari-cms.directus.app";
const access_token = "vgVJBSjtM1gueChZgpXV52IkryKFLM5A";

// Headers with Bearer token
const headers = {
    "Authorization": `Bearer ${access_token}`
};

// Step 1: Check if the file already exists in Directus by filename
async function checkFileExists(filename) {
    const fileUrl = `${base_url}/files?filter[filename_download][_eq]=${filename}`;
    try {
        const response = await axios.get(fileUrl, { headers });
        if (response.data.data.length > 0) {
            // File already exists, return its ID
            return response.data.data[0].id;
        } else {
            // File doesn't exist
            return null;
        }
    } catch (error) {
        console.error("Error checking if file exists:", error);
        return null;
    }
}

// Step 2: Upload the file if it doesn't exist
async function uploadFile(filePath) {
    if (!filePath) {
        console.log("No file path provided, skipping upload.");
        return null;  // Return null if no filePath is provided
    }

    try {
        const filename = path.basename(filePath);  // Get the filename from the file path

        // Check if the file already exists by filename
        const existingFileId = await checkFileExists(filename);
        if (existingFileId) {
            console.log(`File already exists. ID: ${existingFileId}`);
            return existingFileId;  // Return existing file ID
        }

        // File doesn't exist, proceed to upload
        const formData = new FormData();
        formData.append('file', fs.createReadStream(filePath));

        const uploadUrl = `${base_url}/files`;
        const response = await axios.post(uploadUrl, formData, {
            headers: {
                ...headers,
                'Content-Type': 'multipart/form-data',
            },
        });

        if (response.status === 200) {
            const fileData = response.data.data;
            return fileData.id;  // Return the uploaded file ID
        } else {
            console.error(`Failed to upload file. Status code: ${response.status}`);
            return null;
        }
    } catch (error) {
        console.error("Error uploading file:", error);
        return null;
    }
}


// Step 2: Create the demo without logos and sdg_images
async function createDemo(demoData) {
    const demoUrl = `${base_url}/items/demos`;
    try {
        const response = await axios.post(demoUrl, demoData, { headers });
        const createdDemo = response.data.data;
        return createdDemo.id;  // Return the newly created demo ID
    } catch (error) {
        console.error("Error creating demo:", error);
        return null;
    }
}

// Step 3: Insert into the join table
async function addFilesToDemo(demoId, fileIds, joinTableName) {
    const joinUrl = `${base_url}/items/${joinTableName}`;
    try {
        for (let fileId of fileIds) {
            const joinData = {
                demos_id: demoId,
                directus_files_id: fileId
            };
            const response = await axios.post(joinUrl, joinData, { headers });
        }
        
        console.log(`Files added to demo ${demoId} in table ${joinTableName}`);
    } catch (error) {
        console.error(`Error adding files to demo: ${error}`);
    }
}

async function addTranslationToDemo(demoId, language_code, data) {
    try {
        // URL to the demos_translations table in Directus
        const translationUrl = `${base_url}/items/demos_translations`;

        // Prepare the translation data
        const translationData = {
            demos_id: demoId,  // Reference to the demo
            languages_code : language_code,  // Language code for the translation
            ...data  // Translated content
        };

        // Make the POST request to add the translation
        const response = await axios.post(translationUrl, translationData, { headers });

        if (response.status === 200) {
            console.log("Translation added successfully:", response.data);
            return response.data;
        } else {
            console.error(`Failed to add translation. Status code: ${response.status}`);
            return null;
        }
    } catch (error) {
        console.error("Error adding translation:", error);
        return null;
    }
}

// Function to iterate through translations and add them
async function addAllTranslations(demoId, translated_data) {
    for (const [language_code, translation] of Object.entries(translated_data)) {
        console.log(`Adding translation for language: ${language_code}`);
        await addTranslationToDemo(demoId, language_code, translation);
    }
}




const demoData = {
    imagePath: "/home/mrcyme/Pictures/tictactoe1.png",
    videoPath: "/home/mrcyme/Videos/Screencasts/shellyappA.mp4",
    logoPaths: ["/home/mrcyme/Pictures/tictactoe3.png", "/home/mrcyme/Pictures/tictactoe5.png"],
    sdgImagePaths: ["/home/mrcyme/Pictures/tictactoe4.png", "/home/mrcyme/Pictures/tictactoe9.png"],
    research_head : "Research Head",
    research_lead : "Research Lead",
    translated_data: {
        en: {
            title: "New Demo",
            description: "This is a new demo",
            topic : "topuc", 
            app_url : "http.dddd"
            
        },
        fr: {
            title: "Nouvelle démo",
            description: "C'est une nouvelle démo", 
            topic : "topuc", 
            app_url : "http.dddd"
        },
        nl: {
            title: "nieuw demo", 
            description : "blabla", 
            topic : "topuc", 
            app_url : "http.dddd"
        }
    }

};


async function createCompleteDemoFromData(demoData) {
    const { imagePath, videoPath, logoPaths, sdgImagePaths, research_head, research_lead, translated_data } = demoData;
    // Upload the image and video if available
    console.log(imagePath)
    const imageId = imagePath ? await uploadFile(imagePath) : null;
    const videoId = videoPath ? await uploadFile(videoPath) : null;

    // Upload logos and SDG images if the lists are not empty
    const logoIds = logoPaths.length > 0 ? await Promise.all(logoPaths.map(uploadFile)) : [];
    const sdgImageIds = sdgImagePaths.length > 0 ? await Promise.all(sdgImagePaths.map(uploadFile)) : [];

    // Remove None (null) values in case of failed uploads
    const validLogoIds = logoIds.filter(id => id !== null);
    const validSdgImageIds = sdgImageIds.filter(id => id !== null);
    console.log(imageId)
    const demoBaseData = {
        status: "draft",
        image: imageId || null,  // Upload result or null
        video: videoId || null,   // Upload result or null
        research_head : research_head,
        research_lead : research_lead,
    };

    const demoId = await createDemo(demoBaseData);  // Step 2

    if (demoId) {
        // Step 3: Insert into the join table
        await addFilesToDemo(demoId, validLogoIds, 'demos_files');   // For logos
        await addFilesToDemo(demoId, validSdgImageIds, 'demos_files_1'); // For SDG images
        await addAllTranslations(demoId, translated_data);
    }
}

createCompleteDemoFromData(demoData)
    .then(() => {
        console.log("Demo created successfully with translations and files!");
    })
    .catch(error => {
        console.error("Error creating demo:", error);
    });
