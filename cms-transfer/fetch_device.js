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

// Step 2: Create the demo without logos and sdg_images
async function createDemo(demoData) {
    const demoUrl = `${base_url}/items/devices`;
    try {
        const response = await axios.post(demoUrl, demoData, { headers });
        const createdDemo = response.data.data;
        return createdDemo.id;  // Return the newly created demo ID
    } catch (error) {
        //console.error("Error creating demo:", error);
        return null;
    }
}

async function migrateDemo() {
    const url = "http://46.226.110.124:1337/api/devices"
    try {
      const response = await axios.get(url);
      console.log(response)
      if (response.status === 200) {
        const demos = response.data.data; // Iterate through all demos
        console.log(demos);
        for (const demo of demos) {
            console.log(demo);
            demoData = {
                "device_id": demo.attributes.device_id,
                "ip": demo.attributes.ip,
                "mac": demo.attributes.mac,
            }
            await createDemo(demoData)

          
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
      //console.error("Error creating demo:", error);
  });
