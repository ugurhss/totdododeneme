import 'package:flutter/material.dart';

void main() => runApp(const Uygulama());

class Uygulama extends StatelessWidget {
  const Uygulama({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crud ögreniyorum',
      debugShowCheckedModeBanner: false,
      home: const Crudsayfasi(),
    );
  }
}

///burası Widget Kimliği – “Kabuk”
///Ben durum tutan (stateful) bir widget’ım
///ve benim durumumu yönetecek class şudur: _CrudsayfasiState
///buraya bir şey yazılmaz sabit kalır

class Crudsayfasi extends StatefulWidget {
  const Crudsayfasi({super.key});

  @override
  State<Crudsayfasi> createState() => _CrudsayfasiState();
}

///burada sayfa işlemleri
///Her şey burada olur
///Benim durumumu yöneten class burasıdır
///tasarım ve işlemler burada ornegin topla cıkar crud işlemleri
class _CrudsayfasiState extends State<Crudsayfasi> {
  //burada controllerlar tanımladık burada adController içerisine yazılan veriyi okumak için
  //kullanılır başka bir amacı yok şimdilik
  //adController içerisinde ne yapacagını sil vs
  final TextEditingController adController = TextEditingController();

  int Id = 1;
  //kayıtları tutmak için liste tanımladık
  final List<Map<String, dynamic>> kayitlar = [];

  //widget imiz kapatılırken controller ı da kapatıyoruz
  //bu işlem olmasada olur ama ileryen sürede problem yaratır
  //sebebi cache kalması
  @override
  void dispose() {
    adController.dispose();
    super.dispose();
  }

  void ekle() {
    //trim kullanıpboşlukları silebiliz
    //final kullanmaya özen göster nasıl başlarsa öyle devam eder
    final String ad = adController.text.trim();
    //alt kısım normal bizim backend işlemi gibi
    //sadece setState kullanmayı unutma
    //onun içerine yazılır
    //peki içine yazmasam ne olacak dene
    //ekrana basmıyormuş
    //stsate demek ekrana yansıt demek veya ekranı yenile demek
    if (ad.isNotEmpty) {
      setState(() {
        kayitlar.add({'id': Id, 'ad': ad});
        Id++;
        adController.clear();
      });
    } else {
      print("Boş kayıt eklenemez");
    }
  }

  void sil(int Id) {
    setState(() {
      // Map'e eklerken 'id' kullandık, silerken de 'id' ile karşılaştırıyoruz
      kayitlar.removeWhere((k) => k['id'] == Id);
    });
  }

  //backend mantıgı
  // void show(int Id) {
  //   setState(() {
  //     if (kayitlar.isNotEmpty) {
  //       final kayit = kayitlar.firstWhere(
  //         (kayit) => kayit['id'] == Id,
  //         orElse: () => {},
  //       );
  //       if (kayit.isNotEmpty) {
  //         print('Kayıt bulundu: $kayit');
  //       } else {
  //         print('Kayıt bulunamadı');
  //       }
  //     }
  //   });
  // }

  ///Map<String, dynamic> kayit veri modelleme yapısı
  ///string key dinamik value degeri alırım kayıt adı altındaki listeden
  void detaySayfasinaGit(Map<String, dynamic> kayitlar) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetaySayfasi(kayit: kayitlar)),
    );
  }

  ///guncelleme kısmı anlamadm
  Future<void> guncelleSayfasinaGit(Map<String, dynamic> kayit) async {
    final Map<String, dynamic>? guncelKayit =
        await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(builder: (_) => GuncelleSayfasi(kayit: kayit)),
        );

    // üncelleme sayfasından veri döndüyse listede güncelle
    if (guncelKayit != null) {
      setState(() {
        final index = kayitlar.indexWhere((k) => k['id'] == guncelKayit['id']);
        if (index != -1) {
          kayitlar[index] = guncelKayit;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD İşlemleri')),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            TextField(
              controller: adController,
              decoration: const InputDecoration(
                labelText: 'Kayıt Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ekle, //fonkisyonu onpressed e bağladık ve cagırdık
                child: const Text('Ekle'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Kayıt Listesi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: kayitlar.isEmpty
                  ? const Center(child: Text("veri yok"))
                  : ListView.separated(
                      itemCount: kayitlar.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final kayit = kayitlar[index];
                        final int id = kayit['id'] as int;
                        final String ad = (kayit['ad'] ?? '').toString();

                        return ListTile(
                          title: Text(ad),
                          subtitle: Text('ID: $id'),
                          onTap: () => detaySayfasinaGit(kayit),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Detay',
                                icon: const Icon(Icons.visibility),
                                onPressed: () => detaySayfasinaGit(kayit),
                              ),
                              IconButton(
                                tooltip: 'Düzenle',
                                icon: const Icon(Icons.edit),
                                onPressed: () => guncelleSayfasinaGit(kayit),
                              ),
                              IconButton(
                                tooltip: 'Sil',
                                icon: const Icon(Icons.delete),
                                onPressed: () => sil(id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// dty sayfası
/// / required diyerek bu sayfanın hangi kaydı geleceğini
// tıkladıgında almak zorunda olduğunu belirtik
//required laravelde de kullanıyorsun unutma
class DetaySayfasi extends StatelessWidget {
  final Map<String, dynamic> kayit;

  const DetaySayfasi({super.key, required this.kayit});

  @override
  Widget build(BuildContext context) {
    final int id = kayit['id'] as int;
    final String ad = (kayit['ad'] ?? '').toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Detay')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: $id', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Ad: $ad', style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// güncelle sayfası
class GuncelleSayfasi extends StatefulWidget {
  final Map<String, dynamic> kayit;

  // required diyerek bu sayfanın hangi kaydı güncelleyeceğini
  // dışarıdan almak zorunda olduğunu söylüyoruz required laravelde de kullanıyorsun unutma
  const GuncelleSayfasi({super.key, required this.kayit});

  @override
  State<GuncelleSayfasi> createState() => _GuncelleSayfasiState();
}

class _GuncelleSayfasiState extends State<GuncelleSayfasi> {
  late final TextEditingController adController;

  // initState metodu veriyi al ve controller ı başlat
  void initState() {
    super.initState();
    adController = TextEditingController(
      text: (widget.kayit['ad'] ?? '').toString(),
    );
  }

  @override
  void dispose() {
    adController.dispose();
    super.dispose();
  }

  void kaydet() {
    final yeniAd = adController.text.trim();
    if (yeniAd.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ad boş olamaz')));
      return;
    }

    Navigator.pop(context, {'id': widget.kayit['id'], 'ad': yeniAd});
  }

  @override
  Widget build(BuildContext context) {
    final int id = widget.kayit['id'] as int;

    return Scaffold(
      appBar: AppBar(title: const Text('Güncelle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('ID: $id'),
            const SizedBox(height: 12),
            TextField(
              controller: adController,
              decoration: const InputDecoration(
                labelText: 'Yeni Ad',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('İptal'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: kaydet,
                    child: const Text('Kaydet'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
