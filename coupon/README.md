# Coupon API

This documentation describes the Jetpack Partner Coupon API and how to get started using it. The API allows for the management of Jetpack.com discount coupons that can be provided to customers.

## Table of Contents

- [Specification](#specification)
- [Authentication](#authentication)
- [Step-by-step integration guide](#step-by-step-integration-guide)
- [Bulk operations](#bulk-operations)

## Specification

This API has a dedicated OpenAPI v3 specification file: [spec.yml](./spec.yml)

## Authentication

This API uses the default authentication method as described [here](../README.md#authentication).

## Step-by-step integration guide

To integrate with the Jetpack Partner Coupon API and manage coupon codes you can follow these steps:

### 1. Create a WordPress.com user

You will first need to create a [WordPress.com](https://wordpress.com/) user to represent your organization. Once you have your account please reach out to the Jetpack Infinity team with the registered user email and we will provide you with an access token which is required for all API endpoints.

If you already have a WordPress.com user representing your organization you can skip this step.

### 2. Issue a coupon

To issue a coupon you have to make a `POST` request to the `/wpcom/v2/jetpack-partner/coupon/v1/coupon` endpoint - you can find our [bash example here](./examples/issue-coupon.sh).

The response will be a JSON object of the newly issued coupon that looks something like this:
```json
{
  "coupon_code":"partner_0.TG9yZW0gaXBzd",
  "products":["jetpack-backup-daily"],
  "discount":100,
  "used_at":null,
  "expired":false
}
```

Once you've issued a coupon it can be immediately used for a Jetpack.com purchase by any customer that has the coupon code.

### 3. Get the status of a coupon

To get the status of a coupon you have to make a `GET` request to the `/wpcom/v2/jetpack-partner/coupon/v1/coupon` endpoint - you can find our [bash example here](./examples/get-coupon-status.sh).

The response will be a JSON object of the coupon that looks something like this:
```json
{
  "coupon_code":"partner_0.TG9yZW0gaXBzd",
  "products":["jetpack-backup-daily"],
  "discount":100,
  "used_at":null,
  "expired":false
}
```
The `used_at` value is either `null` signifying that the coupon us not used yet or a `date-time` value signifying when the coupon was used.

### 4. Revoke a coupon

To revoke a coupon you have to make a `DELETE` request to the `/wpcom/v2/jetpack-partner/coupon/v1/coupon` endpoint - you can find our [bash example here](./examples/revoke-coupon.sh).

The response will be a JSON object of the coupon that looks something like this:
```json
{
  "coupon_code":"partner_0.TG9yZW0gaXBzd",
  "products":["jetpack-backup-daily"],
  "discount":100,
  "used_at":null,
  "expired":true
}
```

After revoking a coupon, its `expired` value will be updated to `true`.

## Bulk operations

Some of the individual coupon operations also exists as bulk operations to reduce the amount of HTTP request required to manage coupons.

### 1. Issue coupons

To issue coupons in bulk you have to make a `POST` request to the `/wpcom/v2/jetpack-partner/coupon/v1/coupons` endpoint - you can find our [bash example here](./examples/issue-coupons.sh).

The response will be a JSON array of the newly issued coupon that looks something like this:
```json
[
  {
    "coupon_code":"partner_0.TG9yZW0gaXBzd",
    "products":["jetpack-backup-daily"],
    "discount":100,
    "used_at":null,
    "expired":false
  },
  {
    "coupon_code":"partner_0.Ac2kF3gV8oP2x",
    "products":["jetpack-backup-daily"],
    "discount":100,
    "used_at":null,
    "expired":false
  }
]
```

Once you've issued the coupons, they can be immediately used for a Jetpack.com purchase by any customer that has the coupon code.


## Redeem coupons

The coupon(s) can be redeemed in a few different ways.

### Query parameter in WP Admin

The [all in one Jetpack plugin](https://wordpress.org/plugins/jetpack/) actively looks for a `jetpack-partner-coupon` parameter on any WP Admin page (e.g. `/wp-admin/index.php?jetpack-partner-coupon=MY_COUPON_123`) which will:

1. Redirect the customer into a "Redeem coupon flow" that co-brands your company together with Jetpack and informs them which product they've been granted a coupon for and, if they choose to redeem the cupon, will be redirect to a checkout page on Jetpack.com where the product and the coupon will be automatically applied.
2. Store the coupon in database for the WordPress site for approximately a month, so we can help communicate to the end-customer that they have an unredeemed coupon.

Using this method will allow you to e.g. have a SSO link from your own customer dashboard where you log in the customer and then redirect them to the redeem flow co-branding your company with Jetpack - and we'll take care of the rest.

_Note: this requires the [Jetpack plugin](https://wordpress.org/plugins/jetpack/) to be installed and activated beforehand._

### Add coupon to the database with WP CLI

Even though we recommend that you use the query parameter method above to directly lead your customer into a customized redeem flow, then it will still work if you add the coupon directly to the WordPress database with the CLI commands below because we have fallback logic that promts the user to redeemed coupons if the stopped halfway through the originally intended redeem flow.

* `wp jetpack options update partner_coupon <COUPON>`
  * You will be prompted to confirm that you wish to update Jetpack options. Answer `yes` here.
* `wp jetpack options update partner_coupon_added <timestamp>`
  * You will be prompted to confirm that you wish to update Jetpack options. Answer `yes` here.

We use the `partner_coupon_added` option as a fallback check to purge the coupon after approximately a month to try and prevent continuesly prompting customers about coupons that might already have been claimed or doesn't work anymore because they have been revoked.

_Note: Jetpack CLI commands requires the [Jetpack plugin](https://wordpress.org/plugins/jetpack/) to be installed and activated._

### Link directly to Jetpack Checkout

You can also use the following link to send customers directly to the Jetpack checkout with the product and coupon applied:

* `https://jetpack.com/redirect/?source=jetpack-partner-coupon-checkout&path={product}&query=coupon%3D{coupon-code}`
  * Remember to update the `{product}` argument with the specific product: `{product}` => `jetpack-backup-t1`.
  * Remember to update the `{coupon-code}` argument with the coupon: `{coupon-code}` => `MY_COUPON_123`.

This can be useful in e.g. email campaigns or if your support team wants to help the customer redeem the product because the website fails for any reason.

### Manually applying the coupon on Jetpack.com

Partner coupons works like a coupon we would issue ourselves, so they can be applied directly in the checkout on Jetpack.com.

The main drawback about this solution is that the customer is left on their own to select the exact product on Jetpack.com that the coupon has been issued for.
