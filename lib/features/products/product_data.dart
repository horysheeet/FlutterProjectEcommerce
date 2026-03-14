const String kDefaultProductDescription =
    'High-quality robotic product with advanced features and capabilities. Perfect for industrial automation and smart manufacturing solutions.';
const String kUnoProductDescription =
  'This UNO (Type-C and Micro port) compatible microcontroller board is a compatible variant of the Arduino UNO, utilizing the 8-bit ATmega328P microcontroller. Featuring a RISC architecture, it operates at a maximum clock speed of 16MHz. With 32KB of flash memory for code storage and 2KB of SRAM, supplemented by an additional 1KB of EEPROM, it offers ample memory resources. Boasting a total of 20 GPIOs along with 2 analog inputs, all accessible via standard 2.54mm-pitched female pin headers and tactile buttons, it ensures versatility in connectivity.\n\nWhile closely resembling the Arduino Uno R3 in design, it incorporates several enhancements. Fully compatible with the Arduino Software/IDE, it seamlessly integrates with various applications, hardware, and sketches designed for the Arduino Uno. Essentially, it embodies all the standard features of the Arduino Uno, with the added benefit of expanded functionality.';
const String kDefaultProductPrice = '₱9,999';

class StoreProduct {
  final String name;
  final String description;
  final String price;
  final String shopeeId;
  final List<String> imagePaths;

  const StoreProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.shopeeId,
    this.imagePaths = const [],
  });

  String get shopeeUrl => 'https://shopee.ph/product/$shopeeId';
}

const List<StoreProduct> kStoreProducts = [
  StoreProduct(
    name: 'Uno',
    description: kUnoProductDescription,
    price: kDefaultProductPrice,
    shopeeId: 'product-0',
    imagePaths: [
      'assets/product_images/product_1/W1.png',
      'assets/product_images/product_1/W2.png',
      'assets/product_images/product_1/B1.png',
      'assets/product_images/product_1/B2.png',
      'assets/product_images/product_1/G1.png',
      'assets/product_images/product_1/G2.png',
    ],
  ),
  StoreProduct(
    name: 'Coming Soon!',
    description: kDefaultProductDescription,
    price: kDefaultProductPrice,
    shopeeId: 'product-1',
  ),
  StoreProduct(
    name: 'Coming Soon!',
    description: kDefaultProductDescription,
    price: kDefaultProductPrice,
    shopeeId: 'product-2',
  ),
  StoreProduct(
    name: 'Coming Soon!',
    description: kDefaultProductDescription,
    price: kDefaultProductPrice,
    shopeeId: 'product-3',
  ),
  StoreProduct(
    name: 'Coming Soon!',
    description: kDefaultProductDescription,
    price: kDefaultProductPrice,
    shopeeId: 'product-4',
  ),
  StoreProduct(
    name: 'Coming Soon!',
    description: kDefaultProductDescription,
    price: kDefaultProductPrice,
    shopeeId: 'product-5',
  ),
];
