# FCM Push Notification Scenarios - Complete Flows

## 🚴 RIDER APP SCENARIOS

---

### Scenario 1: New Delivery Assignment

**📌 Trigger**: Customer places order, system assigns to nearest rider

**👨‍💻 Backend Action**:
```php
// Backend code
$rider = Rider::find($delivery->rider_id);

Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => $rider->device_token,  // "ewP-wdgJSTmdzpt86Yzz..."
    'notification' => [
        'title' => 'New Delivery Request',
        'body' => "You'll earn ₦1,000 - 8.5 km",
    ],
    'data' => [
        'type' => 'new_order',
        'tracking_id' => 'DLV-20260613-ABC123',
        'delivery_id' => '789',
        'delivery_fee' => '1000',
        'distance' => '8.5',
    ],
    'priority' => 'high',
]);
```

**📱 App Receives**:
```json
{
  "notification": {
    "title": "New Delivery Request",
    "body": "You'll earn ₦1,000 - 8.5 km"
  },
  "data": {
    "type": "new_order",
    "tracking_id": "DLV-20260613-ABC123",
    "delivery_id": "789",
    "delivery_fee": "1000",
    "distance": "8.5"
  }
}
```

**✅ App Action**:
- **App Closed**: Opens app → Shows delivery details screen
- **App Background**: Shows notification → Tap → Opens delivery details
- **App Open**: Shows in-app notification dialog
- **Navigation**: `Get.toNamed('/delivery-details', arguments: {'trackingId': 'DLV-123'})`

**🎯 User Experience**:
```
[Notification appears]
"New Delivery Request"
"You'll earn ₦1,000 - 8.5 km"

[User taps notification]
  ↓
[App opens to Delivery Details Screen]
From: Restaurant XYZ
To: Customer Address
Distance: 8.5 km
You'll Earn: ₦1,000

[Accept] [Decline]
```

---

### Scenario 2: Delivery Picked Up Reminder

**📌 Trigger**: Rider marked order as "picked up" 30 minutes ago but hasn't moved

**👨‍💻 Backend Action**:
```php
Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => $rider->device_token,
    'notification' => [
        'title' => 'Delivery in Progress',
        'body' => 'Don\'t forget to deliver order DLV-123!',
    ],
    'data' => [
        'type' => 'delivery_update',
        'tracking_id' => 'DLV-20260613-ABC123',
        'message' => 'reminder',
    ],
]);
```

**📱 App Receives & Action**:
- Shows notification reminder
- Tap → Opens delivery tracking screen with active delivery
- Shows customer location and navigation

---

### Scenario 3: Payment Credited

**📌 Trigger**: Daily earnings are credited to rider's wallet

**👨‍💻 Backend Action**:
```php
Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => $rider->device_token,
    'notification' => [
        'title' => 'Payment Received!',
        'body' => '₦15,000 has been credited to your wallet',
    ],
    'data' => [
        'type' => 'payment',
        'amount' => '15000',
        'transaction_id' => 'TXN-20260613-XYZ',
        'balance' => '45000',
    ],
]);
```

**📱 App Action**:
- Tap notification → Opens wallet screen
- Shows transaction history with new credit highlighted
- Updated balance displayed

---

## 🏪 VENDOR APP SCENARIOS

---

### Scenario 4: New Order Received

**📌 Trigger**: Customer completes checkout with vendor's items

**👨‍💻 Backend Action**:
```php
$vendor = Vendor::find($order->vendor_id);

Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => $vendor->device_token,
    'notification' => [
        'title' => 'New Order #' . $order->order_number,
        'body' => '₦5,000 - 3 items - Customer: John Doe',
    ],
    'data' => [
        'type' => 'new_order',
        'order_id' => '456',
        'order_number' => 'ORD-789',
        'total_amount' => '5000',
        'items_count' => '3',
        'customer_name' => 'John Doe',
    ],
    'priority' => 'high',
]);
```

**📱 App Receives**:
```json
{
  "notification": {
    "title": "New Order #ORD-789",
    "body": "₦5,000 - 3 items - Customer: John Doe"
  },
  "data": {
    "type": "new_order",
    "order_id": "456",
    "order_number": "ORD-789",
    "total_amount": "5000",
    "items_count": "3",
    "customer_name": "John Doe"
  }
}
```

**✅ App Action**:
- Shows notification with sound/vibration
- Tap → Opens order details screen
- Shows Accept/Reject buttons
- Displays order items, customer info, delivery address

**🎯 User Experience**:
```
[Notification + Sound]
"New Order #ORD-789"
"₦5,000 - 3 items - Customer: John Doe"

[Vendor taps notification]
  ↓
[Order Details Screen]
Order #ORD-789
Customer: John Doe
Total: ₦5,000

Items:
• Jollof Rice x2
• Chicken x1

[Accept Order] [Reject]
```

---

### Scenario 5: Rider Assigned to Order

**📌 Trigger**: Rider accepts delivery for vendor's order

**👨‍💻 Backend Action**:
```php
Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => $vendor->device_token,
    'notification' => [
        'title' => 'Rider Assigned',
        'body' => 'Ahmed is coming to pick up Order #ORD-789',
    ],
    'data' => [
        'type' => 'order_update',
        'order_id' => '456',
        'order_number' => 'ORD-789',
        'status' => 'rider_assigned',
        'rider_name' => 'Ahmed',
        'rider_phone' => '+2347012345678',
        'eta' => '5',
    ],
]);
```

**📱 App Action**:
- Tap → Opens order tracking screen
- Shows rider info and ETA
- Updates order status to "Preparing for pickup"

---

### Scenario 6: Low Stock Alert

**📌 Trigger**: Item stock drops below threshold

**👨‍💻 Backend Action**:
```php
Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => $vendor->device_token,
    'notification' => [
        'title' => 'Low Stock Alert',
        'body' => 'Jollof Rice - Only 5 portions left',
    ],
    'data' => [
        'type' => 'inventory',
        'product_id' => '123',
        'product_name' => 'Jollof Rice',
        'stock_level' => '5',
        'threshold' => '10',
    ],
]);
```

**📱 App Action**:
- Tap → Opens inventory screen
- Highlights low-stock item
- Shows "Restock" button

---

## 👤 CUSTOMER APP SCENARIOS

---

### Scenario 7: Order Confirmed by Vendor

**📌 Trigger**: Vendor accepts customer's order

**👨‍💻 Backend Action**:
```php
$customer = User::find($order->user_id);

Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => $customer->device_token,
    'notification' => [
        'title' => 'Order Confirmed!',
        'body' => 'Vendor is preparing your order',
    ],
    'data' => [
        'type' => 'order_update',
        'order_id' => '456',
        'tracking_id' => 'DLV-20260613-ABC123',
        'status' => 'confirmed',
        'vendor_name' => 'Mama Put Restaurant',
        'estimated_time' => '30',
    ],
    'priority' => 'high',
]);
```

**📱 App Receives**:
```json
{
  "notification": {
    "title": "Order Confirmed!",
    "body": "Vendor is preparing your order"
  },
  "data": {
    "type": "order_update",
    "order_id": "456",
    "tracking_id": "DLV-20260613-ABC123",
    "status": "confirmed",
    "vendor_name": "Mama Put Restaurant",
    "estimated_time": "30"
  }
}
```

**✅ App Action**:
- Tap → Opens order tracking screen
- Shows order progress timeline
- Displays estimated preparation time (30 mins)

**🎯 User Experience**:
```
[Notification]
"Order Confirmed!"
"Vendor is preparing your order"

[Customer taps]
  ↓
[Order Tracking Screen]
Order #ORD-789

Status Timeline:
✅ Order Placed
✅ Confirmed by Vendor
⏳ Preparing (Est. 30 mins)
⬜ Rider Assigned
⬜ Out for Delivery
⬜ Delivered
```

---

### Scenario 8: Rider on the Way

**📌 Trigger**: Rider picks up order from vendor

**👨‍💻 Backend Action**:
```php
Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => $customer->device_token,
    'notification' => [
        'title' => 'Rider on the Way!',
        'body' => 'Ahmed is bringing your order - ETA 15 mins',
    ],
    'data' => [
        'type' => 'delivery_update',
        'order_id' => '456',
        'tracking_id' => 'DLV-20260613-ABC123',
        'status' => 'in_transit',
        'rider_name' => 'Ahmed',
        'rider_phone' => '+2347012345678',
        'rider_location_lat' => '9.0820',
        'rider_location_lng' => '8.6753',
        'eta_minutes' => '15',
    ],
]);
```

**📱 App Action**:
- Tap → Opens live delivery tracking screen
- Shows rider's real-time location on map
- Shows rider photo, name, phone
- Displays ETA countdown
- "Call Rider" button visible

---

### Scenario 9: Order Delivered

**📌 Trigger**: Rider marks delivery as complete

**👨‍💻 Backend Action**:
```php
Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => $customer->device_token,
    'notification' => [
        'title' => 'Order Delivered!',
        'body' => 'Enjoy your meal! Rate your experience',
    ],
    'data' => [
        'type' => 'order_update',
        'order_id' => '456',
        'tracking_id' => 'DLV-20260613-ABC123',
        'status' => 'delivered',
        'show_rating' => 'true',
    ],
]);
```

**📱 App Action**:
- Tap → Opens order details screen
- Shows "Order Completed" status
- Displays rating dialog
- "Rate Vendor" and "Rate Rider" buttons

---

### Scenario 10: Special Promotion

**📌 Trigger**: Marketing campaign - lunch time promo

**👨‍💻 Backend Action**:
```php
// Send to all customers in Lagos
Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => '/topics/customers_lagos',
    'notification' => [
        'title' => '🎉 Lunch Special!',
        'body' => 'Get 25% off on all orders - Use code LUNCH25',
    ],
    'data' => [
        'type' => 'promo',
        'promo_code' => 'LUNCH25',
        'discount_percent' => '25',
        'valid_until' => '2026-06-13 15:00:00',
        'min_order' => '2000',
    ],
]);
```

**📱 App Action**:
- Tap → Opens deals/promotions screen
- Shows promo banner with countdown timer
- Promo code automatically applied at checkout
- "Order Now" button prominently displayed

---

### Scenario 11: Chat Message from Vendor

**📌 Trigger**: Vendor sends message about order (substitution, delay, etc.)

**👨‍💻 Backend Action**:
```php
Http::post('https://fcm.googleapis.com/fcm/send', [
    'to' => $customer->device_token,
    'notification' => [
        'title' => 'Message from Mama Put Restaurant',
        'body' => 'Coca Cola is out of stock. OK to replace with Pepsi?',
    ],
    'data' => [
        'type' => 'message',
        'order_id' => '456',
        'sender_type' => 'vendor',
        'sender_id' => '789',
        'sender_name' => 'Mama Put Restaurant',
        'message_id' => 'MSG-123',
    ],
]);
```

**📱 App Action**:
- Tap → Opens chat screen with vendor
- Shows conversation history
- Message input ready for quick reply
- Quick reply buttons: "Yes, OK" / "No, refund"

---

## 🔄 MULTI-APP SCENARIOS

---

### Scenario 12: Complete Order Flow (All Apps)

**Event**: Customer orders food → Vendor prepares → Rider delivers

#### Step 1: Customer Places Order

**Customer App**:
```
[Customer completes checkout]
Shows: "Order placed successfully!"
```

#### Step 2: Vendor Receives Notification

**Backend → Vendor**:
```json
{
  "to": "VENDOR_TOKEN",
  "notification": {
    "title": "New Order #ORD-789",
    "body": "₦5,000 - 3 items"
  },
  "data": {
    "type": "new_order",
    "order_id": "456"
  }
}
```

**Vendor App**: Opens order details → Vendor accepts

#### Step 3: Customer Gets Confirmation

**Backend → Customer**:
```json
{
  "to": "CUSTOMER_TOKEN",
  "notification": {
    "title": "Order Confirmed!",
    "body": "Being prepared - ETA 30 mins"
  },
  "data": {
    "type": "order_update",
    "order_id": "456",
    "status": "confirmed"
  }
}
```

**Customer App**: Opens tracking screen

#### Step 4: Rider Assigned

**Backend → Rider**:
```json
{
  "to": "RIDER_TOKEN",
  "notification": {
    "title": "New Delivery Request",
    "body": "₦1,000 - 5 km"
  },
  "data": {
    "type": "new_order",
    "tracking_id": "DLV-123"
  }
}
```

**Rider App**: Shows delivery dialog → Rider accepts

#### Step 5: Customer & Vendor Notified

**Backend → Customer**:
```json
{
  "notification": {
    "title": "Rider Assigned!",
    "body": "Ahmed will deliver your order"
  },
  "data": {
    "type": "delivery_update",
    "rider_name": "Ahmed"
  }
}
```

**Backend → Vendor**:
```json
{
  "notification": {
    "title": "Rider on the Way",
    "body": "Ahmed is coming to pick up - ETA 5 mins"
  },
  "data": {
    "type": "order_update",
    "status": "rider_assigned"
  }
}
```

#### Step 6: Delivery Complete

**Backend → Customer**:
```json
{
  "notification": {
    "title": "Delivered!",
    "body": "Enjoy your meal"
  },
  "data": {
    "type": "order_update",
    "status": "delivered"
  }
}
```

**Backend → Rider**:
```json
{
  "notification": {
    "title": "Payment Received",
    "body": "₦1,000 earned"
  },
  "data": {
    "type": "payment",
    "amount": "1000"
  }
}
```

**Backend → Vendor**:
```json
{
  "notification": {
    "title": "Order Completed",
    "body": "Order #ORD-789 delivered"
  },
  "data": {
    "type": "order_update",
    "status": "completed"
  }
}
```

---

## 📊 Summary Table

| Scenario | App | Type | Priority | Opens Screen |
|----------|-----|------|----------|--------------|
| New Delivery | Rider | `new_order` | High | Delivery Details |
| Delivery Reminder | Rider | `delivery_update` | Normal | Tracking |
| Payment Received | Rider | `payment` | Normal | Wallet |
| New Order | Vendor | `new_order` | High | Order Details |
| Rider Assigned | Vendor | `order_update` | Normal | Order Tracking |
| Low Stock | Vendor | `inventory` | Normal | Inventory |
| Order Confirmed | Customer | `order_update` | High | Order Tracking |
| Rider En Route | Customer | `delivery_update` | Normal | Live Tracking |
| Order Delivered | Customer | `order_update` | Normal | Rating Screen |
| Promo Alert | Customer | `promo` | Normal | Deals |
| Chat Message | Any | `message` | Normal | Chat |

---

## 🎯 Testing Scenarios

### Test Case 1: App Closed
1. Close app completely
2. Send notification from backend
3. Verify notification appears in tray
4. Tap notification
5. ✅ App opens to correct screen with data

### Test Case 2: App Background
1. Open app, then minimize
2. Send notification
3. Tap notification
4. ✅ App brings to foreground, navigates to screen

### Test Case 3: App Foreground
1. Keep app open
2. Send notification
3. ✅ In-app notification appears
4. Tap notification
5. ✅ Navigates to screen

---

**Document Version**: 1.0  
**Scenarios**: 12 complete flows  
**Apps Covered**: Rider, Vendor, Customer
