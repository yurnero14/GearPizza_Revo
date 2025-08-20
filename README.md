# GearPizza - Flutter Pizza Ordering App

A complete Flutter mobile application for pizza ordering with restaurant management features, developed for Revo's hiring assignment.

## Features

### Core Features (Required)
- **Restaurant Selection** - Browse available restaurants
- **Pizza Menu** - View pizzas with descriptions, prices, and allergen information
- **Allergen Filtering** - Exclude pizzas containing specific allergens
- **Shopping Cart** - Add/remove pizzas with quantity controls
- **Google Places Autocomplete** - Italian address suggestions during checkout
- **Photo Upload** - Delivery support photos to help drivers
- **Order Checkout** - Complete order flow with customer information

### Advanced Features (Optional)
- **Owner Login** - Restaurant owner authentication
- **Pizza Management** - CRUD operations for menu items
- **Order Management** - Track and update order statuses
- **Status Workflow** - Pending → Preparing → Shipped → Delivered
- **Real-time Updates** - Order status monitoring

## Architecture

```
lib/
├── constants/          # API endpoints and configuration
├── models/            # Data models (Pizza, Order, User, etc.)
├── providers/         # State management (Provider pattern)
├── screens/           # UI screens and navigation
├── services/          # Business logic and API calls
└── widgets/           # Reusable UI components
```

## Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **HTTP Client**: Dio + HTTP
- **Image Handling**: Image Picker
- **Address Autocomplete**: Google Places API
- **JSON Serialization**: json_annotation + json_serializable
- **Local Storage**: SharedPreferences

## Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK
- Android Studio / VS Code
- Google Places API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yurnero14/GearPizza_Revo
   cd GearPizza_revo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```
   
3. **Run the app**
   ```bash
   flutter run
   ```

## Current Implementation

### Data Layer
- **Mock Services** - Complete business logic with realistic data
- **Ready for Backend** - Service layer designed for easy API integration
- **Directus Ready** - Structured for the provided backend endpoints

### Demo Credentials
- **Owner Login**: `owner@gearpizza.com` / `pizza123` (also the owner login: sarib@gearpizza.it works)
- **Restaurant**: The Sparrow Restaurant (ID: 5)
- **Sample Orders**: 6 orders with different statuses for testing

### Sample Data
- 5 pizzas with realistic descriptions and pricing
- 8 allergen types (Milk, Wheat, Egg, Tomato, etc.)
- Multiple order statuses for workflow demonstration

## Assignment Compliance

**Core Requirements**
- Flutter mobile app for pizza ordering
- Restaurant and pizza selection
- Shopping cart functionality
- Address autocomplete integration
- Photo upload for delivery
- Allergen management and filtering

**Optional Features**
- Owner back office functionality
- Pizza CRUD operations
- Order management system
- Status workflow implementation

**Technical Requirements**
- Clean architecture
- State management
- Error handling
- Professional UI/UX


## Development Notes

- **Mock Data**: All features work with realistic mock data
- **Google Places**: Configured for Italian addresses only
- **Image Assets**: Pizza images stored in `assets/images/pizzas/`
- **Error Handling**: Comprehensive error states and user feedback
- **Responsive Design**: Optimized for mobile devices

## Developer

Created by Muhammad Sarib Khan for Revo's Software Engineer's position.

---


