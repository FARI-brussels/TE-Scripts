
import requests
# URL for the Directus "demos" collection

access_token = "vgVJBSjtM1gueChZgpXV52IkryKFLM5A"
url = "https://fari-cms.directus.app/items/demos"

# Headers with the Bearer token
headers = {
    "Authorization": f"Bearer {access_token}"
}

# Make the GET request with authentication
response = requests.get(url, headers=headers)

# Check if the request was successful
if response.status_code == 200:
    # Parse the JSON response
    data = response.json()
    print(data)
else:
    print(f"Failed to retrieve data. Status code: {response.json()}")
