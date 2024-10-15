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
        //console.error("Error checking if file exists:", error);
        return null;
    }
}

// Step 2: Upload the file if it doesn't exist
async function uploadFile(filePath, title, description) {
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
        formData.append('description', description);
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
            //console.error(`Failed to upload file. Status code: ${response.status}`);
            return null;
        }
    } catch (error) {
        //console.error("Error uploading file:", error);
        return null;
    }
}


// Step 2: Create the demo without logos and sdg_images
async function createDemo(demoData) {
    const demoUrl = `${base_url}/items/whichContentIsRealMediaPairs`;
    try {
        const response = await axios.post(demoUrl, demoData, { headers });
        const createdDemo = response.data.data;
        return createdDemo.id;  // Return the newly created demo ID
    } catch (error) {
        //console.error("Error creating demo:", error);
        return null;
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

  

  async function createCompleteDemoFromData(realId, fakeId, type) {
    // Upload the image and video if available
    console.log(realId, fakeId, type);
    const demoBaseData = {
        status: "published",
        realContent: realId,
        fakeContent: fakeId,
        type: type,
    };

    const demoId = await createDemo(demoBaseData);  // Step 2

}
  


    async function migrateDemo() {
        const url = "http://46.226.110.124:1337/api/whichcontentisreal-mediacontents?populate=*"
        try {
          const response = await axios.get(url);
          
          if (response.status === 200) {
            const demos = response.data.data; // Iterate through all demos
            
            for (const demo of demos) {
              
              const realimageOutputPath = path.join('/home/mrcyme/Pictures/',  demo.attributes.realContent.data.attributes.name);
              await downloadFile(`http://46.226.110.124:1337${demo.attributes.realContent.data.attributes.url}`, realimageOutputPath);
              const fakeimageOutputPath = path.join('/home/mrcyme/Pictures/',  demo.attributes.fakeContent.data.attributes.name);
              await downloadFile(`http://46.226.110.124:1337${demo.attributes.fakeContent.data.attributes.url}`, fakeimageOutputPath);
              realId = await uploadFile(realimageOutputPath, demo.attributes.realContent.data.attributes.name, demo.attributes.realContent.data.attributes.caption);
              fakeId = await uploadFile(fakeimageOutputPath, demo.attributes.fakeContent.data.attributes.name, demo.attributes.fakeContent.data.attributes.caption);
              console.log(realId, fakeId, demo.attributes.type);
              await createCompleteDemoFromData(realId, fakeId, demo.attributes.type);
            }
          } else {
            //console.error('Failed to fetch data', response.status);
          }
        } catch (error) {
          //console.error('Error:', error.data);
        }
      }
      
    
      migrateDemo()
      .then(() => {
          console.log("Demo created successfully with translations and files!");
      })
      .catch(error => {
          //console.error("Error creating demo:", error);
      });
  