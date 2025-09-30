---
title: 'Introduction - The domain'
---

The example we are going to use is rooted in the e-commerce domain. We will focus on the following arrangement:

A catalog that contains products, primarily consisting of a description and a price.

An order management module that contains orders consisting of line items referring to the products contained in the catalog.

An inventory management that keeps track of the stock for each product.

![img](https://raw.githubusercontent.com/spring-academy/spring-academy-assets/main/guides/spring-modulith-deep-dive/images/domain.png)

The primary use case we will investigate in its implications on both the structural, consistency and interaction arrangement is the following: when an order is completed (i.e., flips a certain state), a variety of functionality will have to be triggered:

The inventory needs to update its stock to reflect the products referred to by the items contained in the order leaving the warehouse.

An email notification needs to be sent out to the customer.

A customer loyalty program needs to record bonus points reflecting the total value of the order.

## Setup

```terminal:execute
command: cd ~/exercises && ./mvnw clean verify
```

TODO: ABOVE IS GIVING AN ERROR IN EDUCATES ENV. USE BELOW TO DOWLOAD LIBS.
```terminal:execute
command: cd ~/exercises && ./mvnw clean verify -DskipTests
```