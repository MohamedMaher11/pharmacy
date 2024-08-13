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

// أمثلة على الفئات مع أدوية حقيقية
final categories = [
  Category(
    name: 'السعال',
    medicines: [
      Medicine(
        name: 'بنيلين',
        imageUrl: Assets
            .kisspngBenylinCoughMedicinePurpleDrankCodeineCoughSyrup5b271c0b3fd4095717226415292897392615
            .path,
        price: 5.99,
        description:
            'شراب السعال بنيلين مصمم لتوفير راحة فعالة من السعال وتهيج الحلق. يساعد في تهدئة حلقك وتقليل الرغبة في السعال. الشراب يحتوي على مكونات تعمل على تقليل السعال وتوفير الراحة. مثالي للاستخدام في النهار والليل، يساعدك على التنفس بسهولة والحصول على نوم مريح.',
      ),
      Medicine(
        name: 'روبيتوسين',
        imageUrl: Assets
            .kisspngBenylinCoughMedicineCommonColdPharmacyWarehouseChemist5b2690885d3bf58909526915292540243819
            .path,
        price: 6.49,
        description:
            'روبيتوسين هو علاج موثوق لتخفيف السعال واحتقان الصدر. يتميز بتركيبته المهدئة التي تساعد في تفتيت وتخفيف المخاط، مما يسهل طرده. مثالي للأفراد الذين يعانون من سعال مزمن أو احتقان، يوفر روبيتوسين راحة سريعة وفعالة، مما يتيح لك العودة إلى أنشطتك اليومية بسهولة.',
      ),
      Medicine(
        name: 'موسينكس',
        imageUrl: Assets
            .ibuprofenPharmaceuticalDrugPharmacyGrindeksTabletE8095e83b787a99df9a632dcf76c715a
            .path,
        price: 7.29,
        description:
            'موسينكس يوفر راحة من المخاط والسعال بفضل تركيبته الممتدة المفعول. يعمل على تفتيت المخاط، مما يسهل طرده ويخفف من عدم الراحة الناتجة عن السعال المنتج. التركيبة الممتدة المفعول تضمن راحة طويلة الأمد، مما يتيح لك التنفس بسهولة والاستمتاع بيوم أكثر راحة. مثالي للسعال المستمر، يساعد موسينكس في إدارة الأعراض بشكل فعال.',
      ),
    ],
  ),
  Category(
    name: 'تخفيف الألم',
    medicines: [
      Medicine(
        name: 'إيبوبروفين',
        imageUrl: Assets
            .acetaminophenFeverCommonColdBackPainSymptomTablet5b958624313e3bc7921e803a47d99846
            .path,
        price: 4.99,
        description:
            'إيبوبروفين هو دواء يستخدم على نطاق واسع لتقليل الحمى والألم والالتهاب. سواء كنت تعاني من صداع أو آلام الظهر أو آلام العضلات، يوفر إيبوبروفين راحة سريعة وموثوقة. خصائصه المضادة للالتهابات تساعد في تقليل التورم والألم، مما يجعله خيارًا متعدد الاستخدامات لحالات الألم المختلفة.',
      ),
      Medicine(
        name: 'أسيتامينوفين',
        imageUrl: Assets.a5bbc5580520350c0f2113eafead789c5d25e16f666161.path,
        price: 3.99,
        description:
            'أسيتامينوفين هو مسكن شائع ومخفض للحمى، يُستخدم عادةً لإدارة الألم الطفيف والأوجاع. يعمل عن طريق حظر إنتاج بعض المواد الكيميائية في الدماغ التي تسبب الألم والحمى. مثالي لتخفيف الصداع وآلام الأسنان وآلام العضلات، أسيتامينوفين لطيف على المعدة ومناسب للاستخدام المنتظم.',
      ),
      Medicine(
        name: 'أسبرين',
        imageUrl: Assets
            .neutrogenaMaskCosmeticsFaceExfoliationMask36e23ebcb3b491345f7acf13cf007979
            .path,
        price: 5.49,
        description:
            'أسبرين هو دواء موثوق لتخفيف الألم وتقليل الالتهاب وخفض الحمى. هو فعال لعدد من الحالات، بما في ذلك الصداع والتهاب المفاصل وآلام العضلات. كما أن له خصائص مميعة للدم التي يمكن أن تساعد في الوقاية من النوبات القلبية والسكتات الدماغية عند استخدامه تحت إشراف طبي.',
      ),
    ],
  ),
  Category(
    name: 'العناية بالبشرة',
    medicines: [
      Medicine(
        name: 'نيتروجينا',
        imageUrl: Assets
            .neutrogenaMaskCosmeticsFaceExfoliationMask36e23ebcb3b491345f7acf13cf007979
            .path,
        price: 10.99,
        description:
            'تقدم نيتروجينا مجموعة من منتجات العناية بالبشرة المصممة لتعزيز بشرة صحية ومتألقة. من المنظفات إلى الأقنعة، تساعد منتجات نيتروجينا في تنظيف وتقشير وتغذية بشرتك. تم تصميمها لمعالجة مختلف مشكلات البشرة وتوفير نتائج فعالة، مما يجعل بشرتك تشعر بالانتعاش والتجدد.',
      ),
      Medicine(
        name: 'سيتافيل',
        imageUrl: Assets.cetaphil.path,
        price: 9.99,
        description:
            'سيتافيل هو منظف لطيف للبشرة مناسب لجميع أنواع البشرة. تركيبته اللطيفة تنظف البشرة بدون تهيج، مما يجعله مثاليًا للبشرة الحساسة. يساعد في إزالة الأوساخ والزيوت بينما يحافظ على الترطيب الطبيعي للبشرة، مما يجعلها ناعمة ونظيفة. مثالي للاستخدام اليومي، سيتافيل هو خيار موثوق للحفاظ على صحة البشرة.',
      ),
      Medicine(
        name: 'سيرافي',
        imageUrl: Assets
            .ceraveHydratingCleanserCeraveFoamingFacialCleanserCeraveMoisturizingLotionCeravePmFacialMoisturizingLotionFoamCleanser76aa845dd1f0ded0da97c85422aa652f
            .path,
        price: 12.99,
        description:
            'تقدم سيرافي مجموعة من المنتجات المرطبة والمغذية المصممة لتحقيق التوازن واستعادة البشرة. مع مكونات مثل السيراميدات وحمض الهيالورونيك، تساعد منتجات سيرافي في تعزيز حاجز البشرة الطبيعي والحفاظ على الترطيب. مثالية لجميع أنواع البشرة، توفر هذه المنتجات ترطيبًا طويل الأمد وتحسن ملمس بشرتك بشكل عام.',
      ),
    ],
  ),
  Category(
    name: 'الصداع',
    medicines: [
      Medicine(
        name: 'أدفيل',
        imageUrl: Assets
            .advilColdSinusNonDrowsyAdvilMultiSymptomColdCoatedCaplets10CapletsIbuprofenBrandSinusInfectionRunnyNose3bd66c6197744153bc0d33083fd747d1
            .path,
        price: 6.99,
        description:
            'أدفيل يوفر راحة سريعة وفعالة من الصداع وأعراض البرد والجيوب الأنفية. تركيبته غير المسببة للنعاس تساعد في تخفيف الألم وتقليل الالتهاب، مما يجعله خيارًا موثوقًا لإدارة الصداع وعدم الراحة الناتجة عن الجيوب الأنفية. خصائص أدفيل المسكنة تضمن لك البقاء نشطًا ومركّزًا دون انقطاع الألم.',
      ),
      Medicine(
        name: 'تايلينول',
        imageUrl: Assets.a5bbf0b5a82ee32b15395ebb4a71a1090864b76d9ed717.path,
        price: 5.49,
        description:
            'تايلينول هو مسكن موثوق يساعد في تخفيف الصداع وآلام العضلات وأنواع أخرى من الألم. تركيبته الفعالة تقلل الألم والحمى، مما يوفر الراحة من الانزعاجات المختلفة. مثالي للاستخدام طوال اليوم، تايلينول لطيف على المعدة ومناسب للاستخدام المنتظم.',
      ),
      Medicine(
        name: 'إكسيدرين',
        imageUrl: Assets.p2nbubc1eui1nlvr722p289i1l.path,
        price: 7.99,
        description:
            'إكسيدرين مصمم خصيصًا لتوفير الراحة من الصداع الشديد والصداع النصفي. تركيبته القوية من مسكنات الألم تعمل على استهداف الألم من مصدره، مما يوفر راحة سريعة وفعالة. النهج المستهدف لإكسيدرين يجعله خيارًا مثاليًا لأولئك الذين يعانون من أعراض صداع حادة.',
      ),
    ],
  ),
  Category(
    name: 'الحمى',
    medicines: [
      Medicine(
        name: 'أستيلامينوفين',
        imageUrl: Assets.a5bbc5580520350c0f2113eafead789c5d25e16f666161.path,
        price: 3.99,
        description:
            'أستيلامينوفين هو علاج موثوق لتخفيف الحمى والألم. يعمل عن طريق خفض درجة حرارة الجسم وتخفيف الألم المرتبط بالحالات المختلفة. مثالي للأطفال والبالغين، أستيلامينوفين يساهم في الشعور بالتحسن وإدارة الأعراض بشكل فعال.',
      ),
      Medicine(
        name: 'إيبوبروفين',
        imageUrl: Assets
            .ibuprofenPharmaceuticalDrugPharmacyGrindeksTabletE8095e83b787a99df9a632dcf76c715a
            .path,
        price: 4.99,
        description:
            'إيبوبروفين هو دواء مضاد للالتهابات يخفف الحمى والألم. يعمل على خفض درجة حرارة الجسم وتخفيف الألم الناتج عن التهابات مختلفة. مثالي لإدارة الحمى والألم المترافق معها، يوفر إيبوبروفين راحة فعالة وسريعة.',
      ),
      Medicine(
        name: 'موتفين',
        imageUrl: Assets.protinexVanilla500x500.path,
        price: 6.49,
        description:
            'موتفين هو علاج فعّال للحمى والألم. تركيبته تعمل على تقليل الحرارة وتخفيف الألم الناتج عن حالات متعددة. يوفر موتفين راحة طويلة الأمد ويساعد على تحسين جودة الحياة عن طريق تخفيف الأعراض المزعجة.',
      ),
    ],
  ),
];
