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




    


// Helper function to download files
const downloadFile = async (url, outputPath) => {
  const response = await axios.get(url, { responseType: 'stream' });
  const writer = fs.createWriteStream(outputPath);
  response.data.pipe(writer);
  return new Promise((resolve, reject) => {
    writer.on('finish', resolve);
    writer.on('error', reject);
  });
};

const extractDemoData = async (data) => {
  const demoData = {
    imagePath: "",
    videoPath: "",
    logoPaths: [],
    sdgImagePaths: [],
    research_head: data.attributes.research_head,
    research_lead: data.attributes.research_lead,
    translated_data: {}
  };

  // Localized fields (en, fr, nl)
  data.attributes.localizations.data.forEach((locale) => {
    demoData.translated_data[locale.attributes.locale] = {
      title: locale.attributes.title,
      description: locale.attributes.explanation_short,
      topic: locale.attributes.topic,
      app_url: locale.attributes.appURL
    };
  });
  if (demoData.translated_data['fr-FR']) {
    demoData.translated_data['fr'] = demoData.translated_data['fr-FR'];
    delete demoData.translated_data['fr-FR'];
  }

  // English data (default if locale doesn't exist)
  if (!demoData.translated_data['en']) {
    demoData.translated_data['en'] = {
      title: data.attributes.title,
      description: data.attributes.explanation_short,
      topic: data.attributes.topic,
      app_url: data.attributes.appURL
    };
  }

  // Download main image
  const imageUrl = data.attributes.image.data.attributes.url;
  const imageOutputPath = path.join('/home/mrcyme/Pictures/', data.attributes.image.data.attributes.name);
  await downloadFile(`http://46.226.110.124:1337${imageUrl}`, imageOutputPath);
  demoData.imagePath = imageOutputPath;

  // Download logos from the caroussel
  for (let logo of data.attributes.caroussel.data) {
    const logoUrl = logo.attributes.url;
    const logoOutputPath = path.join('/home/mrcyme/Pictures/', logo.attributes.name);
    await downloadFile(`http://46.226.110.124:1337${logoUrl}`, logoOutputPath);
    demoData.logoPaths.push(logoOutputPath);
  }

  // Download SDG images
  for (let sdg of data.attributes.images_sdg.data) {
    const sdgImageUrl = sdg.attributes.url;
    const sdgOutputPath = path.join('/home/mrcyme/Pictures/', sdg.attributes.name);
    await downloadFile(`http://46.226.110.124:1337${sdgImageUrl}`, sdgOutputPath);
    demoData.sdgImagePaths.push(sdgOutputPath);
  }

  // Download video if available
  if (data.attributes.video && data.attributes.video.data) {
    const videoUrl = data.attributes.video.data.attributes.url;
    const videoOutputPath = path.join('/home/mrcyme/Videos/', data.attributes.video.data.attributes.name);
    await downloadFile(`http://46.226.110.124:1337${videoUrl}`, videoOutputPath);
    demoData.videoPath = videoOutputPath;
  }

  return demoData;
};

async function migrateDemo() {
    const url = "http://46.226.110.124:1337/api/demos?locale=en&populate=*";
    
    try {
      const response = await axios.get(url);
      
      if (response.status === 200) {
        const demos = response.data.data; // Iterate through all demos
  
        for (const demo of demos) {
          const demoData = await extractDemoData(demo); // Process each demo
          await createCompleteDemoFromData(demoData); // Push to Directus
          console.log('Demo migrated:', demoData);
        }
      } else {
        console.error('Failed to fetch data', response.status);
      }
    } catch (error) {
      console.error('Error:', error);
    }
  }
  

migrateDemo()
.then(() => {
    console.log("Demo created successfully with translations and files!");
})
.catch(error => {
    console.error("Error creating demo:", error);
});
