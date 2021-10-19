# Coupon API

This documentation describes the Jetpack Partner Coupon API and how to get started using it. The API allows for the management of Jetpack.com discount coupons that can be provided to customers.

## Table of Contents

- [Specification](#specification)
- [Authentication](#authentication)
- [Step-by-step integration guide](#step-by-step-integration-guide)

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

To get the status of a coupon you have to maka a `GET` request to the `/wpcom/v2/jetpack-partner/coupon/v1/coupon` endpoint - you can find our [bash example here](./examples/get-coupon-status.sh).

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

To revoke a coupon you have to maka a `DELETE` request to the `/wpcom/v2/jetpack-partner/coupon/v1/coupon` endpoint - you can find our [bash example here](./examples/revoke-coupon.sh).

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
