import subprocess
import re
import json

# Define MAC addresses
mac_addresses={
	"configs/substation1.json" : "e0:e1:a9:33:ea:ab", 
	"configs/prosumer2.json" : "e0:e1:a9:33:d1:6f", 
	"configs/prosumer3.json": "e0:e1:a9:33:d1:6b", 
	"configs/prosumer4.json": "e0:e1:a9:33:eb:dd",
	"configs/prosumer5.json": "e0:e1:a9:33:ce:a1",
	"configs/prosumer6.json" : "e0:e1:a9:33:e5:83",
	"configs/consumer7.json" :"e0:e1:a9:33:db:87"
	}

# Run arp-scan and get output
arp_output = subprocess.check_output(['sudo', 'arp-scan', '-I', 'wlxe0e1a933e581', '10.40.18.244/16']).decode('utf-8')

# Split the output into lines
arp_lines = arp_output.split('\n')

# Prepare a dictionary for JSON data
json_data = {}

# Go through each line
for line in arp_lines:
    # Check if any of the MAC addresses are in this line
    for k, v in mac_addresses.items():
        if v in line:
            # Use regex to extract the IP address
            match = re.search(r'\b(?:\d{1,3}\.){3}\d{1,3}\b', line)
            if match:
                # If found, add to the JSON data
                json_data[k] = match.group()
print(json_data)
# Write the JSON data to a file
with open('ips.json', 'w') as json_file:
    json.dump(json_data, json_file, indent=4)
