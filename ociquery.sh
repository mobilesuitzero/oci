#!/bin/bash
#Example string: 'FortiGate Next-Gen Firewall (BYOL)'
# Needs to do the oci session authenticate first
# Once authenticate and has the token, can then the following to retrieve the image id
#"FortiGate Next-Gen Firewall (BYOL)"
#"FortiGate Next-Gen Firewall (2 cores)"
#"FortiGate Next-Gen Firewall (4 cores)"
#"FortiGate Next-Gen Firewall (8 cores)"
declare -a FOSAppName=("FortiGate Next-Gen Firewall (BYOL)" "FortiGate Next-Gen Firewall (2 cores)" "FortiGate Next-Gen Firewall (4 cores)" "FortiGate Next-Gen Firewall (8 cores)" "FortiGate Next-Gen Firewall (24 cores)")
export FOSVERSION="7.0.5"
export REGION="us-phoenix-1"

echo "Querying in REGION $region, with FOS version $FOSVERSION"
for APP in "${FOSAppName[@]}"; do
	echo "APP: $APP"
	LISTING=`oci raw-request --target-uri https://iaas.$REGION.oraclecloud.com/20160918/appCatalogListings --http-method GET | jq --arg APP "$APP" '.data[] | select ( .displayName | contains($APP))' | jq -r '.listingId'`
	echo "LISTING: $LISTING"
	oci raw-request --http-method GET --target-uri https://iaas.$REGION.oraclecloud.com/20160918/appCatalogListings/$LISTING/resourceVersions | jq --arg FOSVERSION "$FOSVERSION" '.data[] | select ( .listingResourceVersion | contains($FOSVERSION))'
	#oci raw-request --http-method GET --target-uri https://iaas.$REGION.oraclecloud.com/20160918/appCatalogListings/$LISTING/resourceVersions | jq --arg FOSVERSION "$FOSVERSION" '.data[] | select ( .listingResourceVersion | contains($FOSVERSION))' | jq -r '.listingResourceId'

done
