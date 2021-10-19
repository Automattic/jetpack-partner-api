ACCESS_TOKEN= your access token

PRESETS_JSON=$(curl "https://public-api.wordpress.com/wpcom/v2/jetpack-partner/coupon/v1/presets" \
  --silent \
  --header "Authorization: Bearer $ACCESS_TOKEN")
echo $PRESETS_JSON
