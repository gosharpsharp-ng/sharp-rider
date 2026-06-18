# FCM Push Notifications & Deep Linking - Backend Integration Guide

## 📋 Overview

This document explains how to send push notifications with deep linking for GoSharpSharp apps (Rider, Vendor, Customer).

---

## 🔑 Prerequisites

1. **FCM Device Tokens**: Apps automatically register device tokens with your backend at:
   - **Endpoint**: `POST /api/v1/me/device-token`
   - **Payload**: `{ "device_token": "FCM_TOKEN_HERE" }`
   - **When**: On login and app start

2. **FCM Server Key**: Get from Firebase Console → Project Settings → Cloud Messaging → Server Key

---

## 📤 FCM Notification Structure

### Base Payload Format

```json
{
  "to": "DEVICE_FCM_TOKEN",
  "notification": {
    "title": "Notification Title",
    "body": "Notification message"
  },
  "data": {
    "type": "notification_type",
    "screen": "target_screen",
    "...additional_data": "..."
  },
  "priority": "high",
  "content_available": true
}
```

### Key Fields

| Field | Required | Description |
|-------|----------|-------------|
| `to` | ✅ Yes | FCM device token |
| `notification.title` | ✅ Yes | Notification title (shown in tray) |
| `notification.body` | ✅ Yes | Notification message |
| `data.type` | ✅ Yes | Notification type for routing |
| `data.*` | ⚠️ Varies | Additional data based on type |
| `priority` | ⚠️ Optional | Set to "high" for important notifications |

---

## 🚴 RIDER APP Notifications

### 1. New Delivery Request

**When**: New delivery is assigned to rider

```json
{
  "to": "RIDER_FCM_TOKEN",
  "notification": {
    "title": "New Delivery Request",
    "body": "You have a new delivery for ₦1,000 - 8.5 km"
  },
  "data": {
    "type": "new_order",
    "tracking_id": "DLV-20260613-ABC123",
    "delivery_id": "123",
    "delivery_fee": "1000",
    "distance": "8.5"
  },
  "priority": "high"
}
```

**App Action**: Opens delivery details screen

---

### 2. Delivery Status Update

**When**: Delivery status changes (picked up, delivered, etc.)

```json
{
  "to": "RIDER_FCM_TOKEN",
  "notification": {
    "title": "Delivery Update",
    "body": "Delivery DLV-123 has been marked as delivered"
  },
  "data": {
    "type": "delivery_update",
    "tracking_id": "DLV-20260613-ABC123",
    "status": "delivered"
  }
}
```

**App Action**: Opens delivery tracking screen

---

### 3. Payment/Earnings

**When**: Payment received or wallet updated

```json
{
  "to": "RIDER_FCM_TOKEN",
  "notification": {
    "title": "Payment Received",
    "body": "₦1,000 has been credited to your wallet"
  },
  "data": {
    "type": "payment",
    "amount": "1000",
    "transaction_id": "TXN-123"
  }
}
```

**App Action**: Opens wallet screen

---

### 4. General Message

**When**: System messages, announcements, etc.

```json
{
  "to": "RIDER_FCM_TOKEN",
  "notification": {
    "title": "Important Notice",
    "body": "New app update available"
  },
  "data": {
    "type": "message",
    "message_id": "MSG-123"
  }
}
```

**App Action**: Opens notifications screen

---

## 🏪 VENDOR APP Notifications

### 1. New Order

**When**: Customer places an order with vendor

```json
{
  "to": "VENDOR_FCM_TOKEN",
  "notification": {
    "title": "New Order Received",
    "body": "Order #456 - ₦5,000 - 3 items"
  },
  "data": {
    "type": "new_order",
    "order_id": "456",
    "total_amount": "5000",
    "items_count": "3"
  },
  "priority": "high"
}
```

**App Action**: Opens order details screen

---

### 2. Order Status Update

**When**: Order status changes (confirmed, ready, completed)

```json
{
  "to": "VENDOR_FCM_TOKEN",
  "notification": {
    "title": "Order Update",
    "body": "Order #456 has been picked up by rider"
  },
  "data": {
    "type": "order_update",
    "order_id": "456",
    "status": "picked_up"
  }
}
```

**App Action**: Opens order tracking screen

---

### 3. Payment Received

**When**: Payment for order is received

```json
{
  "to": "VENDOR_FCM_TOKEN",
  "notification": {
    "title": "Payment Received",
    "body": "₦5,000 received for Order #456"
  },
  "data": {
    "type": "payment",
    "order_id": "456",
    "amount": "5000"
  }
}
```

**App Action**: Opens wallet/transactions screen

---

### 4. Inventory Alert

**When**: Low stock or inventory issues

```json
{
  "to": "VENDOR_FCM_TOKEN",
  "notification": {
    "title": "Low Stock Alert",
    "body": "Jollof Rice is running low (5 remaining)"
  },
  "data": {
    "type": "inventory",
    "product_id": "789",
    "stock_level": "5"
  }
}
```

**App Action**: Opens inventory/products screen

---

## 👤 CUSTOMER APP Notifications

### 1. Order Confirmation

**When**: Order is confirmed by vendor

```json
{
  "to": "CUSTOMER_FCM_TOKEN",
  "notification": {
    "title": "Order Confirmed",
    "body": "Your order #456 is being prepared"
  },
  "data": {
    "type": "order_update",
    "order_id": "456",
    "tracking_id": "DLV-123",
    "status": "confirmed"
  },
  "priority": "high"
}
```

**App Action**: Opens order tracking screen

---

### 2. Rider Assigned

**When**: Rider accepts the delivery

```json
{
  "to": "CUSTOMER_FCM_TOKEN",
  "notification": {
    "title": "Rider Assigned",
    "body": "John is on the way to pick up your order"
  },
  "data": {
    "type": "delivery_update",
    "order_id": "456",
    "tracking_id": "DLV-123",
    "rider_name": "John",
    "rider_phone": "+2347012345678"
  }
}
```

**App Action**: Opens delivery tracking screen

---

### 3. Order Delivered

**When**: Order is delivered to customer

```json
{
  "to": "CUSTOMER_FCM_TOKEN",
  "notification": {
    "title": "Order Delivered",
    "body": "Your order has been delivered. Enjoy!"
  },
  "data": {
    "type": "order_update",
    "order_id": "456",
    "tracking_id": "DLV-123",
    "status": "delivered"
  }
}
```

**App Action**: Opens order details/rating screen

---

### 4. Promo/Deals

**When**: New promotions or special offers

```json
{
  "to": "CUSTOMER_FCM_TOKEN",
  "notification": {
    "title": "Special Offer!",
    "body": "Get 20% off on your next order"
  },
  "data": {
    "type": "promo",
    "promo_code": "SAVE20",
    "discount": "20"
  }
}
```

**App Action**: Opens deals/offers screen

---

### 5. Chat Message

**When**: Vendor or rider sends a message

```json
{
  "to": "CUSTOMER_FCM_TOKEN",
  "notification": {
    "title": "New Message from Vendor",
    "body": "We're out of Coca Cola. Can we substitute?"
  },
  "data": {
    "type": "message",
    "order_id": "456",
    "sender_type": "vendor",
    "sender_id": "789"
  }
}
```

**App Action**: Opens chat/support screen

---

## 🔧 Backend Implementation (PHP/Laravel Example)

### Single Notification

```php
use Illuminate\Support\Facades\Http;

function sendFCMNotification($deviceToken, $title, $body, $data = []) {
    $fcmServerKey = config('services.fcm.server_key');
    
    $payload = [
        'to' => $deviceToken,
        'notification' => [
            'title' => $title,
            'body' => $body,
        ],
        'data' => $data,
        'priority' => 'high',
        'content_available' => true,
    ];
    
    $response = Http::withHeaders([
        'Authorization' => 'key=' . $fcmServerKey,
        'Content-Type' => 'application/json',
    ])->post('https://fcm.googleapis.com/fcm/send', $payload);
    
    return $response->json();
}

// Usage Example: New Delivery for Rider
sendFCMNotification(
    $rider->device_token,
    'New Delivery Request',
    'You have a new delivery for ₦' . $delivery->fee,
    [
        'type' => 'new_order',
        'tracking_id' => $delivery->tracking_id,
        'delivery_id' => $delivery->id,
        'delivery_fee' => $delivery->fee,
        'distance' => $delivery->distance,
    ]
);
```

---

### Multiple Notifications (Topic-based)

```php
function sendToTopic($topic, $title, $body, $data = []) {
    $fcmServerKey = config('services.fcm.server_key');
    
    $payload = [
        'to' => '/topics/' . $topic,
        'notification' => [
            'title' => $title,
            'body' => $body,
        ],
        'data' => $data,
        'priority' => 'high',
    ];
    
    $response = Http::withHeaders([
        'Authorization' => 'key=' . $fcmServerKey,
        'Content-Type' => 'application/json',
    ])->post('https://fcm.googleapis.com/fcm/send', $payload);
    
    return $response->json();
}

// Example: Send to all riders in a city
sendToTopic(
    'riders_lagos',
    'Peak Hour Bonus',
    'Earn 2x on all deliveries for the next 2 hours!',
    ['type' => 'message']
);
```

---

## 📊 Notification Type Reference

### All Supported Types

| Type | Rider | Vendor | Customer | Target Screen |
|------|-------|--------|----------|---------------|
| `new_order` | ✅ | ✅ | ❌ | Order/Delivery Details |
| `order_update` | ❌ | ✅ | ✅ | Order Tracking |
| `delivery_update` | ✅ | ❌ | ✅ | Delivery Tracking |
| `payment` | ✅ | ✅ | ❌ | Wallet |
| `message` | ✅ | ✅ | ✅ | Messages/Notifications |
| `promo` | ❌ | ❌ | ✅ | Deals/Offers |
| `inventory` | ❌ | ✅ | ❌ | Inventory |

---

## ✅ Testing Checklist

### 1. Test with Firebase Console

1. Go to Firebase Console → Cloud Messaging
2. Click "Send test message"
3. Add FCM token (from app logs: `🔑 FULL FCM TOKEN:`)
4. Test each notification type

### 2. Test from Backend

```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_FCM_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "Test Notification",
      "body": "This is a test"
    },
    "data": {
      "type": "message"
    }
  }'
```

### 3. Verify Deep Linking

For each notification type:
- [ ] Tap notification when app is **closed** → Opens correct screen
- [ ] Tap notification when app is **background** → Opens correct screen
- [ ] Tap notification when app is **foreground** → Opens correct screen

---

## 🚨 Important Notes

### 1. Data Format
- All `data` values must be **strings** (not numbers or booleans)
- Use `"123"` not `123`
- Use `"true"` not `true`

### 2. Priority
- Set `"priority": "high"` for time-sensitive notifications (new orders, urgent updates)
- Use `"content_available": true` for iOS background updates

### 3. Token Management
- Device tokens can change (app reinstall, token refresh)
- Always use the latest token from database
- Handle invalid token responses and remove from database

### 4. Rate Limiting
- Don't spam users with too many notifications
- Batch notifications when possible
- Use topics for broadcast messages

---

## 🔗 Additional Resources

- [FCM HTTP v1 API Docs](https://firebase.google.com/docs/cloud-messaging/http-server-ref)
- [FCM Admin SDK](https://firebase.google.com/docs/cloud-messaging/admin)
- [Testing FCM](https://firebase.google.com/docs/cloud-messaging/concept-options#testing)

---

## 📞 Support

If you encounter issues:
1. Check FCM server logs for delivery status
2. Verify device token is valid and up-to-date
3. Test with Firebase Console first
4. Check app logs for navigation errors

---

**Document Version**: 1.0  
**Last Updated**: June 13, 2026  
**Apps Covered**: Rider, Vendor, Customer
