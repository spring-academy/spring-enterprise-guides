---
title: 'Introduction'
---

Placeholder for content

```section:begin
title: Hint
```

This is what the code should look like:
```java
package com.example.app.inventory;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.modulith.ApplicationModuleListener;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.app.order.Order;
import com.example.app.order.OrderCompleted;
import com.example.app.order.OrderManagement;

/**
 * @author Oliver Drotbohm
 */
@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class Inventory {

	private final OrderManagement orders;

	@ApplicationModuleListener
	void on(OrderCompleted event) {
		updateStockFor(orders.findById(event.orderIdentifier()));
	}

	public void updateStockFor(Order order) {

		log.info("Updating stock for order {}.", order.getId());

		// throw new RuntimeException();
	}
}
```

```section:end
```


Placeholder for more content