// models.dart
import 'package:hamo_pharmacy/gen/assets.gen.dart';

class Medicine {
  final String name;
  final String imageUrl;

  Medicine({required this.name, required this.imageUrl});
}

class Category {
  final String name;
  final List<Medicine> medicines;

  Category({required this.name, required this.medicines});
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
              .path),
      Medicine(
          name: 'Robitussin',
          imageUrl: Assets
              .kisspngBenylinCoughMedicineCommonColdPharmacyWarehouseChemist5b2690885d3bf58909526915292540243819
              .path),
      Medicine(
          name: 'Mucinex',
          imageUrl: Assets
              .ibuprofenPharmaceuticalDrugPharmacyGrindeksTabletE8095e83b787a99df9a632dcf76c715a
              .path),
    ],
  ),
  Category(
    name: 'Pain Relief',
    medicines: [
      Medicine(
          name: 'Ibuprofen',
          imageUrl: Assets
              .acetaminophenFeverCommonColdBackPainSymptomTablet5b958624313e3bc7921e803a47d99846
              .path),
      Medicine(
          name: 'Acetaminophen',
          imageUrl: Assets.a5bbc5580520350c0f2113eafead789c5d25e16f666161.path),
      Medicine(
          name: 'Aspirin',
          imageUrl: Assets
              .neutrogenaMaskCosmeticsFaceExfoliationMask36e23ebcb3b491345f7acf13cf007979
              .path),
    ],
  ),
  Category(
    name: 'Skin Care',
    medicines: [
      Medicine(
          name: 'Neutrogena',
          imageUrl: Assets
              .neutrogenaMaskCosmeticsFaceExfoliationMask36e23ebcb3b491345f7acf13cf007979
              .path),
      Medicine(name: 'Cetaphil', imageUrl: Assets.cetaphil.path),
      Medicine(
          name: 'CeraVe',
          imageUrl: Assets
              .ceraveHydratingCleanserCeraveFoamingFacialCleanserCeraveMoisturizingLotionCeravePmFacialMoisturizingLotionFoamCleanser76aa845dd1f0ded0da97c85422aa652f
              .path),
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
      ),
      Medicine(
          name: 'Tylenol',
          imageUrl: Assets.a5bbf0b5a82ee32b15395ebb4a71a1090864b76d9ed717.path),
      Medicine(
          name: 'Excedrin', imageUrl: Assets.p2nbubc1eui1nlvr722p289i1l.path),
    ],
  ),
  Category(
    name: 'Fever',
    medicines: [
      Medicine(name: 'Panadol', imageUrl: Assets.pngegg.path),
      Medicine(name: 'Paracetamol', imageUrl: Assets.pngegg2.path),
    ],
  ),
  Category(
    name: 'Weakness',
    medicines: [
      Medicine(name: 'Ensure', imageUrl: Assets.pngegg3.path),
      Medicine(name: 'Protinex', imageUrl: Assets.protinexVanilla500x500.path),
    ],
  ),
  // Add more categories as needed
];
