# WebSocket Delivery Notifications - Payload Structure

## 📡 WebSocket Event: `delivery:new`

This is what the **backend sends via WebSocket** to notify riders of new deliveries.

---

## 🍔 FOOD DELIVERY (From Restaurant/Vendor)

### Key Difference
- **Has `orderId`** - Links to a restaurant order
- Includes vendor/restaurant details
- May have multiple food items

### Complete Payload Structure

```json
{
  "orderId": 456,                    // ✅ HAS ORDER ID (from restaurant)
  "deliveryId": 789,
  "trackingId": "DLV-20260613-ABC123",
  "status": "confirmed",
  "paymentStatus": "paid",
  "distance": 8.5,
  "price": 5000,                     // Total order cost
  "deliveryFee": 1000,              // Rider's earning
  "userId": 123,                     // Customer ID
  "riderId": null,                   // Not assigned yet
  "courierTypeId": 11,
  "courierTypeName": "e-bike",
  
  "pickupLocation": {
    "name": "Mama Put Restaurant, 23 Allen Avenue",
    "latitude": "9.0820",
    "longitude": "8.6753"
  },
  
  "destinationLocation": {
    "name": "Customer Address, 45 Lekki Phase 1",
    "latitude": "9.0765",
    "longitude": "8.6820"
  },
  
  "sender": {                        // Restaurant/Vendor
    "id": 789,
    "name": "Mama Put Restaurant",
    "phone": "+2347012345678",
    "email": "mamaput@example.com"
  },
  
  "receiver": {                      // Customer
    "id": 101,
    "name": "John Doe",
    "phone": "+2347098765432",
    "email": "john@example.com",
    "address": "45 Lekki Phase 1, Lagos"
  },
  
  "user": {                          // Customer details
    "id": 123,
    "fname": "John",
    "lname": "Doe",
    "email": "john@example.com",
    "phone": "+2347098765432"
  },
  
  "currency": {
    "id": 1,
    "code": "NGN",
    "symbol": "₦",
    "name": "Nigerian Naira",
    "exchange_rate": "1"
  },
  
  "message": "New delivery available for pickup",
  "confirmedAt": "2026-06-13T21:06:18.000000Z"
}
```

---

## 📦 PARCEL DELIVERY (Standalone)

### Key Difference
- **No `orderId`** (null) - Standalone delivery
- Direct sender to receiver
- May include parcel items/description

### Complete Payload Structure

```json
{
  "orderId": null,                   // ❌ NO ORDER ID (standalone parcel)
  "deliveryId": 850,
  "trackingId": "DLV-20260613-XYZ789",
  "status": "confirmed",
  "paymentStatus": "paid",
  "distance": 10.6,
  "price": 1075,                     // Total delivery cost
  "deliveryFee": 1000,              // Rider's earning
  "userId": 456,                     // Sender/Customer ID
  "riderId": null,
  "courierTypeId": 11,
  "courierTypeName": "e-bike",
  
  "pickupLocation": {
    "name": "Shop 12 Lugard Rd, Jos 930105, Plateau, Nigeria",
    "latitude": "9.90690450",
    "longitude": "8.89150810"
  },
  
  "destinationLocation": {
    "name": "RVQQ+J8Q, Rayfield Rd, Jos 930103, Plateau, Nigeria",
    "latitude": "9.83908360",
    "longitude": "8.88837460"
  },
  
  "sender": {                        // Person sending parcel
    "id": 456,
    "name": "Adekunle Abdulsalam",
    "phone": "+2347044017726",
    "email": "adekunle@example.com"
  },
  
  "receiver": {                      // Person receiving parcel
    "id": 85,
    "name": "Ahmed Ibrahim",
    "phone": "+2347055512345",
    "email": null,
    "address": "RVQQ+J8Q, Rayfield Rd, Jos"
  },
  
  "user": {                          // Sender details
    "id": 456,
    "fname": "Adekunle",
    "lname": "Abdulsalam",
    "email": "adekunle@example.com",
    "phone": "+2347044017726"
  },
  
  "currency": {
    "id": 1,
    "code": "NGN",
    "symbol": "₦",
    "name": "Nigerian Naira",
    "exchange_rate": "1"
  },
  
  "message": "New delivery available for pickup",
  "confirmedAt": "2026-06-13T19:55:39+01:00",
  
  "items": [                         // Optional: Parcel items
    {
      "id": 44,
      "name": "Documents",
      "description": "Important business documents",
      "category": "fragile",
      "weight": "2.50",
      "quantity": 1,
      "files": []
    }
  ]
}
```

---

## 📋 Quick Comparison

| Field | Food Delivery | Parcel Delivery | Notes |
|-------|---------------|-----------------|-------|
| `orderId` | **456** | **null** | Key difference! |
| `deliveryId` | ✅ Present | ✅ Present | Always present |
| `trackingId` | ✅ Present | ✅ Present | Always present |
| `sender` | Restaurant/Vendor | Individual sender | Different entity |
| `receiver` | Customer | Individual receiver | Same concept |
| `items` | ❌ Not included | ✅ May be included | Parcel items |
| `price` | Order total | Delivery cost | Different meaning |
| `deliveryFee` | ✅ Rider earning | ✅ Rider earning | Same |

---

## 🔑 Key Fields Explained

### Common to Both

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `deliveryId` | `int` | Unique delivery ID | `789` |
| `trackingId` | `string` | Human-readable tracking | `"DLV-20260613-ABC123"` |
| `status` | `string` | Delivery status | `"confirmed"`, `"picked"`, `"delivered"` |
| `paymentStatus` | `string` | Payment status | `"paid"`, `"pending"` |
| `distance` | `number/string` | Distance in km | `8.5` or `"8.5"` |
| `deliveryFee` | `number/string` | **Rider's earning** | `1000` or `"1000"` |
| `price` | `number/string` | Total cost | `5000` or `"5000"` |
| `courierTypeId` | `int` | Courier type ID | `11` |
| `courierTypeName` | `string` | Courier type | `"e-bike"`, `"bike"`, `"van"` |

### Locations

```json
{
  "pickupLocation": {
    "name": "Address name/description",
    "latitude": "9.0820",      // String format
    "longitude": "8.6753"      // String format
  },
  "destinationLocation": {
    "name": "Address name/description",
    "latitude": "9.0765",
    "longitude": "8.6820"
  }
}
```

### Sender & Receiver

```json
{
  "sender": {
    "id": 789,
    "name": "Sender Name",
    "phone": "+2347012345678",
    "email": "sender@example.com"    // Optional
  },
  "receiver": {
    "id": 101,
    "name": "Receiver Name",
    "phone": "+2347098765432",
    "email": "receiver@example.com", // Optional
    "address": "Full address string"
  }
}
```

---

## ⚠️ Important Backend Notes

### 1. Data Types
All numeric values can be sent as **strings OR numbers**. The app handles both:
- ✅ `"distance": 8.5` 
- ✅ `"distance": "8.5"`
- ✅ `"deliveryFee": 1000`
- ✅ `"deliveryFee": "1000"`

### 2. Required vs Optional

**Always Required:**
- `deliveryId` or `orderId` (at least one!)
- `trackingId`
- `deliveryFee` (rider's earning)
- `distance`
- `pickupLocation` { name, latitude, longitude }
- `destinationLocation` { name, latitude, longitude }
- `sender` { name, phone }
- `receiver` { name, phone }

**Optional:**
- `orderId` (null for parcel deliveries)
- `status` (defaults to "confirmed")
- `paymentStatus` (defaults to "pending")
- `riderId` (null until assigned)
- `email` fields
- `items` array
- `user` object
- `currency` object
- `message`

### 3. orderId Logic

```php
// Backend pseudo-code
if ($delivery->is_from_restaurant_order) {
    $payload['orderId'] = $order->id;  // Food delivery
} else {
    $payload['orderId'] = null;         // Parcel delivery
}
```

---

## 🔄 WebSocket Flow

### Backend Sends (Node.js/Socket.io Example)

```javascript
// When a new delivery is created
io.to(`courier-type:e-bike`).emit('delivery:new', {
  orderId: order?.id || null,    // null for parcel, ID for food
  deliveryId: delivery.id,
  trackingId: delivery.tracking_id,
  status: delivery.status,
  paymentStatus: delivery.payment_status,
  distance: delivery.distance,
  price: order?.total || delivery.price,
  deliveryFee: delivery.delivery_fee,  // Rider's earning!
  
  pickupLocation: {
    name: delivery.pickup_address,
    latitude: delivery.pickup_lat.toString(),
    longitude: delivery.pickup_lng.toString()
  },
  
  destinationLocation: {
    name: delivery.destination_address,
    latitude: delivery.destination_lat.toString(),
    longitude: delivery.destination_lng.toString()
  },
  
  sender: {
    id: delivery.sender_id,
    name: delivery.sender_name,
    phone: delivery.sender_phone,
    email: delivery.sender_email
  },
  
  receiver: {
    id: delivery.receiver_id,
    name: delivery.receiver_name,
    phone: delivery.receiver_phone,
    email: delivery.receiver_email,
    address: delivery.receiver_address
  },
  
  currency: {
    id: 1,
    code: "NGN",
    symbol: "₦",
    name: "Nigerian Naira"
  },
  
  message: "New delivery available for pickup"
});
```

### App Receives & Shows Dialog

```dart
socket.on('delivery:new', (data) {
  // Parse notification
  final delivery = DeliveryNotificationModel.fromJson(data);
  
  // Show notification dialog
  showDeliveryDialog(
    title: delivery.orderId != null 
        ? "New Food Delivery"      // Has orderId = Food
        : "New Parcel Delivery",   // No orderId = Parcel
    fee: delivery.deliveryFee,
    distance: delivery.distance,
    from: delivery.pickupLocation.name,
    to: delivery.destinationLocation.name,
  );
});
```

---

## 🎯 Real Examples

### Example 1: Food Delivery

```json
{
  "orderId": 66,
  "deliveryId": 51,
  "trackingId": "ORD-YYX8FITN",
  "deliveryFee": "1000",
  "distance": 7.91,
  "pickupLocation": {
    "name": "mess 22 restaurant and catering services",
    "latitude": "9.26309810",
    "longitude": "12.44577350"
  },
  "destinationLocation": {
    "name": "Customer Address",
    "latitude": "9.20702510",
    "longitude": "12.49018540"
  },
  "sender": {
    "name": "Mess 22 Restaurant",
    "phone": "+2347012345678"
  },
  "receiver": {
    "name": "Adekunle Abdulsalam",
    "phone": "+2347044017726"
  }
}
```

### Example 2: Parcel Delivery

```json
{
  "orderId": null,
  "deliveryId": 85,
  "trackingId": "DLV-20260613-TNAEGI",
  "deliveryFee": "1000",
  "distance": 10.6,
  "pickupLocation": {
    "name": "Shop 12 Lugard Rd, Jos",
    "latitude": "9.90690450",
    "longitude": "8.89150810"
  },
  "destinationLocation": {
    "name": "RVQQ+J8Q, Rayfield Rd, Jos",
    "latitude": "9.83908360",
    "longitude": "8.88837460"
  },
  "sender": {
    "name": "Adekunle Abdulsalam",
    "phone": "+2347044017726"
  },
  "receiver": {
    "name": "Ahmed Ibrahim",
    "phone": "+2347055512345"
  },
  "items": [
    {
      "name": "Documents",
      "category": "fragile",
      "quantity": 1
    }
  ]
}
```

---

## ✅ Summary

| Aspect | Food Delivery | Parcel Delivery |
|--------|---------------|-----------------|
| **orderId** | Has value (456) | `null` |
| **Structure** | Same base structure | Same base structure |
| **Sender** | Restaurant/Vendor | Individual |
| **Purpose** | Food order delivery | Standalone delivery |
| **Items** | Usually not sent | May include items array |
| **Detection** | `orderId != null` | `orderId == null` |

**Both use the SAME WebSocket event**: `delivery:new`  
**Both have the SAME required fields**  
**Key difference**: `orderId` field presence

---

**Document Version**: 1.0  
**Last Updated**: June 13, 2026  
**Event**: `delivery:new`
