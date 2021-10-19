ACCESS_TOKEN= your access token
PRESET= unique preset slug

COUPON_JSON=$(curl "https://public-api.wordpress.com/wpcom/v2/jetpack-partner/coupon/v1/coupon" \
  --silent \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data "{\"preset\":\"$PRESET\"}" \
  -X POST)
echo $COUPON_JSON
