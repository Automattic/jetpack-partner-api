ACCESS_TOKEN= your access token
PRESET= unique preset slug
QUANTITY= the quantity of coupons

COUPONS_JSON=$(curl "https://public-api.wordpress.com/wpcom/v2/jetpack-partner/coupon/v1/coupons" \
  --silent \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data "{\"preset\":\"$PRESET\",\"quantity\":$QUANTITY}" \
  -X POST)
echo $COUPONS_JSON
