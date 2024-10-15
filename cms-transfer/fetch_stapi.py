import requests

# URL to fetch demos with full content
url = "http://46.226.110.124:1337/api/whichcontentisreal-mediacontents?populate=*"

# Make the GET request
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    # Parse the JSON response
    data = response.json()["data"][0]
    print(data)
else:
    print(f"Failed to retrieve data. Status code: {response.status_code}")
