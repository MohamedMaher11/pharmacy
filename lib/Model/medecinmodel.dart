import 'package:hamo_pharmacy/gen/assets.gen.dart';

class Medicine {
  final String name;
  final String imageUrl;
  final double price;
  final String description;

  Medicine({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });
}

class Category {
  final String name;
  final List<Medicine> medicines;

  Category({
    required this.name,
    required this.medicines,
  });
}

// Example categories with real medicines
final categories = [
  Category(
    name: 'Cough',
    medicines: [
      Medicine(
        name: 'Benylin',
        imageUrl: Assets
            .kisspngBenylinCoughMedicinePurpleDrankCodeineCoughSyrup5b271c0b3fd4095717226415292897392615
            .path,
        price: 5.99,
        description:
            'Benylin cough syrup is designed to provide effective relief from coughs and throat irritation. '
            'It helps in soothing your throat and reducing the urge to cough. The syrup contains ingredients that '
            'work to reduce coughing and provide comfort. Ideal for both day and night use, it helps you breathe easier '
            'and get a restful night of sleep.',
      ),
      Medicine(
        name: 'Robitussin',
        imageUrl: Assets
            .kisspngBenylinCoughMedicineCommonColdPharmacyWarehouseChemist5b2690885d3bf58909526915292540243819
            .path,
        price: 6.49,
        description:
            'Robitussin is a trusted remedy for relieving cough and chest congestion. It features a soothing formula '
            'that helps to loosen and thin mucus, making it easier to expel. Perfect for individuals struggling with a '
            'persistent cough or congestion, Robitussin provides quick and effective relief, allowing you to get back to '
            'your daily activities with ease.',
      ),
      Medicine(
        name: 'Mucinex',
        imageUrl: Assets
            .ibuprofenPharmaceuticalDrugPharmacyGrindeksTabletE8095e83b787a99df9a632dcf76c715a
            .path,
        price: 7.29,
        description:
            'Mucinex offers relief from mucus and cough with its extended-release formula. It works to break up mucus, '
            'making it easier to expel and alleviating the discomfort of a productive cough. The extended-release formula '
            'ensures long-lasting relief, so you can breathe easier and enjoy a more comfortable day. Ideal for persistent '
            'coughs, Mucinex helps you manage your symptoms effectively.',
      ),
    ],
  ),
  Category(
    name: 'Pain Relief',
    medicines: [
      Medicine(
        name: 'Ibuprofen',
        imageUrl: Assets
            .acetaminophenFeverCommonColdBackPainSymptomTablet5b958624313e3bc7921e803a47d99846
            .path,
        price: 4.99,
        description:
            'Ibuprofen is a widely used medication that effectively reduces fever, pain, and inflammation. Whether you '
            'are dealing with a headache, back pain, or muscle aches, Ibuprofen provides quick and reliable relief. '
            'Its anti-inflammatory properties help reduce swelling and pain, making it a versatile choice for various '
            'pain-related conditions.',
      ),
      Medicine(
        name: 'Acetaminophen',
        imageUrl: Assets.a5bbc5580520350c0f2113eafead789c5d25e16f666161.path,
        price: 3.99,
        description:
            'Acetaminophen is a popular pain reliever and fever reducer, commonly used for managing minor aches and pains. '
            'It works by blocking the production of certain chemicals in the brain that cause pain and fever. Ideal for '
            'relieving headaches, toothaches, and muscle pain, Acetaminophen is gentle on the stomach and suitable for '
            'regular use.',
      ),
      Medicine(
        name: 'Aspirin',
        imageUrl: Assets
            .neutrogenaMaskCosmeticsFaceExfoliationMask36e23ebcb3b491345f7acf13cf007979
            .path,
        price: 5.49,
        description:
            'Aspirin is a time-tested medication for relieving pain, reducing inflammation, and lowering fever. It is effective '
            'for a range of conditions, including headaches, arthritis, and muscle pain. Aspirin also has blood-thinning properties '
            'that can help prevent heart attacks and strokes when used under medical supervision.',
      ),
    ],
  ),
  Category(
    name: 'Skin Care',
    medicines: [
      Medicine(
        name: 'Neutrogena',
        imageUrl: Assets
            .neutrogenaMaskCosmeticsFaceExfoliationMask36e23ebcb3b491345f7acf13cf007979
            .path,
        price: 10.99,
        description:
            'Neutrogena offers a range of skin care products designed to promote a healthy and radiant complexion. '
            'From cleansers to masks, Neutrogena products help to cleanse, exfoliate, and nourish your skin. They are formulated '
            'to address various skin concerns and provide effective results, leaving your skin feeling refreshed and rejuvenated.',
      ),
      Medicine(
        name: 'Cetaphil',
        imageUrl: Assets.cetaphil.path,
        price: 9.99,
        description:
            'Cetaphil is a gentle skin cleanser that is suitable for all skin types. Its mild formula cleanses the skin without '
            'irritation, making it perfect for sensitive skin. It helps remove dirt and oil while maintaining the skin’s natural moisture, '
            'leaving it soft and clean. Ideal for daily use, Cetaphil is a trusted choice for maintaining healthy skin.',
      ),
      Medicine(
        name: 'CeraVe',
        imageUrl: Assets
            .ceraveHydratingCleanserCeraveFoamingFacialCleanserCeraveMoisturizingLotionCeravePmFacialMoisturizingLotionFoamCleanser76aa845dd1f0ded0da97c85422aa652f
            .path,
        price: 12.99,
        description:
            'CeraVe offers a range of moisturizing and hydrating products designed to balance and restore the skin. With ingredients '
            'like ceramides and hyaluronic acid, CeraVe products help to strengthen the skin’s natural barrier and retain moisture. '
            'Ideal for all skin types, these products provide long-lasting hydration and improve the overall texture of your skin.',
      ),
    ],
  ),
  Category(
    name: 'Headache',
    medicines: [
      Medicine(
        name: 'Advil',
        imageUrl: Assets
            .advilColdSinusNonDrowsyAdvilMultiSymptomColdCoatedCaplets10CapletsIbuprofenBrandSinusInfectionRunnyNose3bd66c6197744153bc0d33083fd747d1
            .path,
        price: 6.99,
        description:
            'Advil provides fast and effective relief from headaches, cold, and sinus symptoms. Its non-drowsy formula helps to '
            'alleviate pain and reduce inflammation, making it a reliable choice for managing headache and sinus discomfort. '
            'Advil’s pain-relieving properties ensure you can stay active and focused without the interruption of pain.',
      ),
      Medicine(
        name: 'Tylenol',
        imageUrl: Assets.a5bbf0b5a82ee32b15395ebb4a71a1090864b76d9ed717.path,
        price: 5.49,
        description:
            'Tylenol is a trusted pain reliever that helps ease headaches, muscle aches, and other types of pain. Its effective formula '
            'reduces pain and fever, providing relief from various discomforts. Ideal for use throughout the day, Tylenol is gentle on '
            'the stomach and suitable for regular use.',
      ),
      Medicine(
        name: 'Excedrin',
        imageUrl: Assets.p2nbubc1eui1nlvr722p289i1l.path,
        price: 7.99,
        description:
            'Excedrin is specially formulated to provide relief from severe headaches and migraines. Its powerful combination of pain '
            'relievers works to target pain at its source, providing fast and effective relief. Excedrin’s targeted approach makes it an '
            'ideal choice for those experiencing intense headache symptoms.',
      ),
    ],
  ),
  Category(
    name: 'Fever',
    medicines: [
      Medicine(
        name: 'Panadol',
        imageUrl: Assets.pngegg.path,
        price: 4.49,
        description:
            'Panadol is a widely used medication for reducing fever and relieving mild to moderate pain. Its formula effectively targets '
            'pain and helps to lower body temperature. Ideal for managing symptoms of fever and discomfort, Panadol provides quick and '
            'reliable relief to help you feel better.',
      ),
      Medicine(
        name: 'Paracetamol',
        imageUrl: Assets.pngegg2.path,
        price: 3.99,
        description:
            'Paracetamol is a common pain and fever reducer that helps alleviate a range of symptoms from minor aches to moderate pain. '
            'Its gentle formula is suitable for all ages and provides effective relief without causing stomach irritation. Ideal for everyday '
            'use, Paracetamol helps manage pain and fever efficiently.',
      ),
    ],
  ),
  Category(
    name: 'Weakness',
    medicines: [
      Medicine(
        name: 'Ensure',
        imageUrl: Assets.pngegg3.path,
        price: 11.99,
        description:
            'Ensure is a nutritional drink designed to maintain strength and energy. It provides essential vitamins and minerals needed '
            'for overall health and vitality. Ideal for individuals experiencing weakness or needing extra nutritional support, Ensure helps '
            'boost your energy levels and support daily health needs.',
      ),
      Medicine(
        name: 'Protinex',
        imageUrl: Assets.protinexVanilla500x500.path,
        price: 12.49,
        description:
            'Protinex is a protein supplement that supports overall health and vitality. Enriched with high-quality protein, it helps in '
            'maintaining muscle mass and boosting energy levels. Ideal for those needing additional protein intake, Protinex is a great choice '
            'for enhancing physical strength and well-being.',
      ),
    ],
  ),
  // Add more categories as needed
];
