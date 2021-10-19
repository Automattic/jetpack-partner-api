ACCESS_TOKEN= your access token
COUPON_CODE= unique coupon code

COUPON_JSON=$(curl "https://public-api.wordpress.com/wpcom/v2/jetpack-partner/coupon/v1/coupon?coupon_code=${COUPON_CODE}" \
  --silent \
  --header "Authorization: Bearer $ACCESS_TOKEN")
echo $COUPON_JSON
