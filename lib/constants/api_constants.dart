class ApiConstants {
  static const String baseUrl = 'https://gearpizza.revod.services';

  static const String googlePlacesApiKey =
      'AIzaSyBoxQBCZhDowlQVBdAX8_LYlgkug3Rruz8';

  // API Endpoints for Directus (not used for now - using mock data)
  static const String authLogin = '/auth/login';
  static const String restaurants = '/items/restaurants';
  static const String pizzas = '/items/pizzas';
  static const String allergens = '/items/allergens';
  static const String customers = '/items/customers';
  static const String orders = '/items/orders';
  static const String files = '/files';

  // Assignment credentials
  static const String ownerEmail = 'sarib@gearpizza.it';
  static const String ownerPassword = 'i3|h;A03=B&\\';

  // File upload configuration
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];

  // Order status values 
  static const String statusPending = 'pending';
  static const String statusPreparing = 'preparing';
  static const String statusShipped = 'shipped';
  static const String statusDelivered = 'delivered';
  static const String statusCancelled = 'cancelled';

  // Delivery fee
  static const double deliveryFee = 2.50;
}
