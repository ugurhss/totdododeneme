import 'package:flutter/material.dart';

void main() => runApp(Uygulama());

class Uygulama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crud ögreniyorum',
      home: Scaffold(
        appBar: AppBar(title: const Text('Crud ögreniyorum')),
        body: Crudsayfasi(),
      ),
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
  void dispose() {
    adController.dispose();
    super.dispose();
  }

  void ekle() {
    //trim kullanıpboşlukları silebiliz
    //final kullanmaya özen göster nasıl başlarsa öyle devam eder
    final String ad = adController.text;
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
      kayitlar.removeWhere((kayitlar) => kayitlar['Id'] == Id);
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
      appBar: AppBar(
        title: const Text('CRUD İşlemleri'),
      )
      body: Padding(padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          TextField(
            controller: adController,
            decoration: const InputDecoration(
              labelText: 'Kayıt Adı',
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ekle, //fonkisyonu onpressed e bağladık ve cagırdık
              child: const Text('Ekle'), 
            ),
          ),
        ],
      ),
      ),

    );
  }
}
