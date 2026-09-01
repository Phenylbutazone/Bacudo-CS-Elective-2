import 'package:cs_elective_2/models/product.dart';

const products = <Product>[
  Product(
    id: 'wooting-60he',
    name: 'Wooting 60HE+ Lekker Linear 60 RGB Gaming Keyboard (Black)',
    price: 174.99,
    imageUrl: 'assets/wooting_60he_keyboard.png',
    description:
        '60% hall-effect gaming keyboard with Lekker Linear60 switches, '
        'per-key RGB lighting, and rapid trigger support.',
    category: 'Gaming Keyboards',
  ),
  Product(
    id: 'Corsair K60 Pro',
    name: 'Corsair K60 Pro TKL RGB Tenkeyless Optical-Mechanical Gaming Keyboard (White) (Corsair OPX Switch)',
    price: 92.07,
    imageUrl:
        'assets/CH-911D11A-NA-Gallery-K60-PRO-TKL-WHITE-01.png',
    description:
        'Weight 0.73kg Lighting RGB Keyboard Layout NA USB Polling Rate Up to 8,000Hz',
    category: 'Gaming Keyboards',
  ),
  Product(
    id: 'Redragon K572R',
    name: 'Redragon APA Mechanical Gaming Keyboard (K572R)',
    price: 31.95,
    imageUrl:
        'assets/fnjdtum.png',
    description:
        'The Redragon K572R APA Mechanical Gaming Keyboard is a multimedia function keyboard that has an anti-ghosting feature allows simultaneous typing of all keys, ensuring the keyboard is always receiving full signal',
    category: 'Gaming Keyboards',
  ),
  Product(
    id: 'Royal Kludge RK-M75',
    name: 'Royal Kludge RK-M75 HE Single-Mode RGB 81 Keys Hot-Swappable Mechanical Keyboard Hephaestus (Mint Switch)',
    price: 52.78,
    imageUrl:
        'assets/Royal Kludge RK-M75 HE.png',
    description:
        'Introducing the RK M75HE Magnetic Axis Keyboard – Engineered for the Ultimate Performance!TOP Structure DesignRobust and integrated construction ensures a consistent and stable typing feel',
    category: 'Gaming Keyboards',
  ),
  Product(
    id: 'Logitech G512 X 75',
    name: 'Logitech G512 X 75 Dual Swap TMR Analog/Mechanical 8k Gaming Keyboard (White) (920-013962)',
    price: 192.14,
    imageUrl:
        'assets/0097855208989.png',
    description:
        'G512 X 75 changes the game by offering legendary flexibility and power right at your fingertips.',
    category: 'Gaming Keyboards',
  ),
  Product(
    id: 'Akko TAC75',
    name: 'Akko TAC75 HE Wired RGB Magnetic Keyboard (Black) (Akko Glare Magnetic Switch)',
    price: 35.16,
    imageUrl:
        'assets/Layer20_4c251906-b007-4c7d-97dc-53456aa99b63.png',
    description:
        '8K Hz Polling Rate Wired USB-C Solution; 16K Hz Universal Scan Rate; 128K Hz Sampling Rate; Rapid Trigger: 0.005mm~2mm; Customizable Actuation Distance: 0.1mm~3.3mm; RT Stabilizer; Snap Key: Akkos Implementation of SOCD ; Cherry profile PBT Side-Printed Keycaps.',
    category: 'Gaming Keyboards',
  ),
  Product(
    id: 'Razer Huntsman V3',
    name: 'Razer Huntsman V3 HE Magnetic Mini 65% 8KHz - Hall Effect Magnetic Esports Keyboard',
    price: 128.07,
    imageUrl:
        'assets/drymsryms.png',
    description:
        'Razer Huntsman V3 HE Magnetic Mini 65% 8KHz Wired Gaming Keyboard | Hall Effect Magnetic Switches, 8000 Hz Polling, Razer Snap Flex,Razer Snap Tap, Rapid Trigger, Adjustable Actuation.',
    category: 'Tropical',
  ),
  Product(
    id: 'Pulsar eS HE 70',
    name: 'Pulsar eS HE 70 Ultrafast Hall Effect Gaming Keyboard (Black) (ES70HE01B)',
    price: 191.42,
    imageUrl:
        'assets/Layer10_4fe7e824-1c54-4745-8402-1b894dc583bf.png',
    description:
        'GAMING KEYBOARD WITH LCD DISPLAY The compact 70% layout PULSAR ES HE 70 keyboard features a built-in LCD display and an adjustable knob, allowing users to customize functions directly on the keyboard without installing any software.',
    category: 'Gaming Keyboards',
  ),
];

Product? productById(String id) {
  for (final product in products) {
    if (product.id == id) {
      return product;
    }
  }
  return null;
}
