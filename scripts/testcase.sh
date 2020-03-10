#! /bin/bash
#
# This script runs through a sample scenario of creating Launches, Payloads 
# It then takes a Payload and Launch through the process
#
echo "What is the IP address for the API server (default is localhost:3000)?"
read API_URL
API_URL=${API_URL:-http://localhost:3000}
echo ""
echo "********** Get all identities"
echo ""
curl -X GET "${API_URL}/api/login?userid=admin&password=admin"
echo ""
curl -X GET "${API_URL}/api/users/" 
echo ""
echo ""
echo "********* Get current user"
echo ""
curl -X GET "${API_URL}/api/current-user-id/" 
echo ""
echo ""
echo "********* Retailer Walmart logs in and create Order-001"
echo ""
curl -X GET "${API_URL}/api/login?userid=Walmart&password=Walmart"
echo ""
curl -X POST "${API_URL}/api/orders/" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"orderId\":\"Order-001\",\"productId\":\"tomato\",\"price\":3,\"quantity\":10,\"producerId\":\"Farm001\",\"retailerId\":\"Walmart\"}"
echo ""
echo "********* View orders for Walmart"
echo ""
curl -X GET "${API_URL}/api/orders/" 
echo ""
echo "********* Walmart views Order-001"
echo ""
curl -X GET "${API_URL}/api/orders/Order-001" 
echo ""
echo ""
echo "********** Retailer HEB logs in and create Order-002, Order-003"
echo ""
curl -X GET "${API_URL}/api/login?userid=HEB&password=HEB"
echo ""
curl -X POST "${API_URL}/api/orders/" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"orderId\":\"Order-002\",\"productId\":\"mango\",\"price\":5,\"quantity\":20,\"producerId\":\"ABFarm\",\"retailerId\":\"HEB\"}"
echo ""
curl -X POST "${API_URL}/api/orders/" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"orderId\":\"Order-003\",\"productId\":\"grapes\",\"price\":2,\"quantity\":30,\"producerId\":\"Farm001\",\"retailerId\":\"HEB\"}"
echo ""
echo ""
echo "********** HEB attempts to view orders associated with them"
echo ""
curl -X GET "${API_URL}/api/orders/" 
echo ""
echo ""
echo "********** HEB attempts to view Order-001. Should not be able to"
echo ""
curl -X GET "${API_URL}/api/orders/Order-001" 
echo ""
echo ""
echo "********** Producer logs in to view orders associated with them and receives Order-002"
echo ""
curl -X GET "${API_URL}/api/login?userid=ABFarm&password=ABFarm"
echo ""
echo "********** Get current user type"
echo ""
curl -X GET "${API_URL}/api/current-user-type/" 
echo ""
echo "********** Get all orders for ABFarm"
echo ""
curl -X GET "${API_URL}/api/orders/"
echo ""
echo ""
echo "********** Producer receives Order-002 which changes status to ORDER_RECEIVED"
echo ""
curl -X PUT "${API_URL}/api/receive-order/Order-002" 
echo ""
echo ""
echo "********** Producer assigns a shipper"
echo ""
curl -X PUT "${API_URL}/api/assign-shipper/Order-002?shipperid=Fedex" 
echo ""
echo ""
echo "********** Shipper logs in to view orders associated with them"
echo ""
curl -X GET "${API_URL}/api/login?userid=Fedex&password=Fedex"
echo ""
curl -X GET "${API_URL}/api/orders/" 
echo ""
echo ""
echo "********** Shipper creates a shipment for Order-002 by assigning a tracking number"
echo ""
curl -X PUT "${API_URL}/api/create-shipment-for-order/Order-002" 
echo ""
echo ""
echo "********** Shipper transports Order-001 by changing status to ORDER_IN_TRANSPORT"
echo ""
curl -X PUT "${API_URL}/api/transport-shipment/Order-002" 
echo ""
#curl -X GET "${API_URL}/api/orders/Order-002" 
echo ""
echo ""
echo "********** Retailer logs back in to see orders associated with them"
echo ""
curl -X GET "${API_URL}/api/login?userid=HEB&password=HEB"
echo ""
echo ""
echo "********** Retailer receives the shipment for Order-002 by moving status to SHIPMENT_RECEIVED"
echo ""
curl -X PUT "${API_URL}/api/receive-shipment/Order-002" 
echo ""
echo ""
echo "********** Customer can now view history for Order-002" 
echo ""
curl -X GET "${API_URL}/api/login?userid=ACustomer&password=ACustomer"
echo ""
curl -X GET "${API_URL}/api/order-history/Order-002" 
echo ""
echo "" 
echo "********** ACustomer attempts to view history for Order-001.  Can not because it is not in the correct state"
echo ""
curl -X GET "${API_URL}/api/order-history/Order-001" 
echo ""
echo ""
echo "********** Regulator can see all orders and their history"
echo ""
curl -X GET "${API_URL}/api/login?userid=FDA&password=FDA"
echo ""
curl -X GET "${API_URL}/api/orders/" 
echo ""
echo ""
curl -X GET "${API_URL}/api/order-history/Order-001" 
echo ""
echo ""
curl -X GET "${API_URL}/api/order-history/Order-002" 
echo ""
echo ""
echo "********** Log in as Retailer Walmart and delete Order-001"
echo ""
curl -X GET "${API_URL}/api/login?userid=Walmart&password=Walmart"
echo ""
#curl -X DELETE "${API_URL}/api/orders/Order-001" 
echo ""
echo ""
echo "********** Log in as Retailer HEB and delete Order-002"
echo ""
curl -X GET "${API_URL}/api/login?userid=HEB&password=HEB"
echo ""
#curl -X DELETE "${API_URL}/api/orders/Order-002" 

