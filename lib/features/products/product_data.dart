class StoreProduct {
  final String id;
  final String name;
  final String shortDescription;
  final String fullDescription;
  final String price;
  final List<String> features;
  final List<String> applications;
  final List<String> imagePaths;
  final List<String> bannerImages;
  final String shopeeUrl;

  const StoreProduct({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    required this.price,
    required this.features,
    required this.applications,
    this.imagePaths = const [],
    this.bannerImages = const [],
    required this.shopeeUrl,
  });
}

const List<StoreProduct> kStoreProducts = [
  StoreProduct(
    id: 'byou',
    name: 'BYOU (Build Your Own UNO)',
    shortDescription:
        'DIY Arduino-Uno-class board with ATMEGA328P, CH9340G USB-TTL, and LM7805 regulation for hands-on embedded learning.',
    fullDescription:
        'BYOU (Build Your Own UNO) is a DIY Arduino-Uno-class microcontroller board built around the ATMEGA328P. It includes a CH9340G USB-TTL converter and an LM7805 voltage regulator, and is designed for Arduino IDE compatibility. The platform is intended for practical learning in embedded systems, soldering, and robotics fundamentals.',
    price: '₱1,500',
    features: [
      'ATMEGA328P-based Arduino-Uno-class design',
      'CH9340G USB-TTL converter',
      'LM7805 voltage regulator',
      'Arduino IDE compatibility',
    ],
    applications: [
      'Embedded systems learning',
      'Soldering practice and instruction',
      'Robotics learning projects',
      'Educational electronics demonstrations',
    ],
    imagePaths: [
      'assets/images/BYOU/BLK.JPG',
      'assets/images/BYOU/BLK_BACK.jpg',
      'assets/images/BYOU/GRN.jpg',
      'assets/images/BYOU/WHT.jpg',
    ],
    bannerImages: [
      'assets/images/Others/1.png',
      'assets/images/Others/2.png',
    ],
    shopeeUrl: 'https://shopee.ph/search?keyword=BYOU%20Build%20Your%20Own%20UNO',
  ),
  StoreProduct(
    id: 'nano-expansion-board',
    name: 'Nano Expansion Board',
    shortDescription:
        'Arduino Nano-compatible expansion module with TB6612FNG motor driver support and organized robotics wiring.',
    fullDescription:
        'Nano Expansion Board is an Arduino Nano-compatible expansion module designed to simplify robotics and automation wiring. It supports TB6612FNG motor driver integration and provides multiple servo headers, I2C headers, and buzzer support for cleaner prototyping layouts.',
    price: '₱500',
    features: [
      'Arduino Nano-compatible expansion module',
      'TB6612FNG motor driver support',
      'Multiple servo headers',
      'I2C headers',
      'Buzzer support',
    ],
    applications: [
      'Robotics wiring organization',
      'Automation prototyping',
      'Nano-based rapid hardware iteration',
    ],
    imagePaths: [
      'assets/images/Nano Expansion/2.jpg',
      'assets/images/Nano Expansion/4.jpg',
    ],
    shopeeUrl: 'https://shopee.ph/search?keyword=Nano%20Expansion%20Board',
  ),
  StoreProduct(
    id: 'rover-robotics-module',
    name: 'Rover Robotics Module',
    shortDescription:
        'Arduino Nano-compatible robotics control module with ultrasonic/IR sensor ports and TB6612FNG motor driver mount support.',
    fullDescription:
        'Rover Robotics Module is an Arduino Nano-compatible robotics control module intended for rover-class projects. The board provides ultrasonic sensor ports, IR sensor ports, Bluetooth/wireless module support, DIP switches, a tactile switch, buzzer support, and a TB6612FNG motor driver mount for robotics-focused builds.',
    price: '₱1,200',
    features: [
      'Arduino Nano-compatible robotics control module',
      'Ultrasonic sensor ports',
      'IR sensor ports',
      'Bluetooth / wireless module support',
      'DIP switches and tactile switch',
      'Buzzer support',
      'TB6612FNG motor driver mount',
    ],
    applications: [
      'Robotics control projects',
      'Rover platform development',
      'Sensor-integrated embedded experiments',
    ],
    imagePaths: [
      'assets/images/Rover/1.jpg',
      'assets/images/Rover/2.jpg',
      'assets/images/Rover/3.jpg',
    ],
    shopeeUrl: 'https://shopee.ph/search?keyword=Rover%20Robotics%20Module',
  ),
];
