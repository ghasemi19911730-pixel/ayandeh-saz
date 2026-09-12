import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AyandehSazApp());
}

class AyandehSazApp extends StatelessWidget {
  const AyandehSazApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'آینده‌ساز',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7)),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox(),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _i = 0;
  final _tabs = const [HomeTab(), CustomersTab(), PropertiesTab(), AiTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_i],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _i,
        onTap: (v) => setState(() => _i = v),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6C5CE7),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'خانه'),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'مشتریان'),
          BottomNavigationBarItem(icon: Icon(Icons.home_work_rounded), label: 'فایل‌ها'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_rounded), label: 'دستیار'),
        ],
      ),
    );
  }
}

// ───── تب خانه ─────
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _customers = 0, _properties = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _customers = (jsonDecode(p.getString('customers') ?? '[]') as List).length;
      _properties = (jsonDecode(p.getString('properties') ?? '[]') as List).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('صبح بخیر مشاور 👋',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('امروز فرصت‌های خوبی در انتظارته',
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF4A3FB8)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80, height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80, height: 80,
                          child: CircularProgressIndicator(
                            value: 0.78, strokeWidth: 8,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation(Color(0xFFFFC107)),
                          ),
                        ),
                        Text('۷۸', style: TextStyle(color: Colors.white,
                            fontSize: 26, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('هدف این ماه: ۱۰ قرارداد',
                            style: TextStyle(color: Colors.white,
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text('قراردادهای شما: ۳',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _stat(Icons.people_alt_rounded, const Color(0xFF6C5CE7),
                  'مشتریان', '$_customers')),
              const SizedBox(width: 12),
              Expanded(child: _stat(Icons.home_work_rounded, const Color(0xFF00B894),
                  'فایل‌ها', '$_properties')),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _stat(Icons.checklist_rounded, const Color(0xFFFFC107),
                  'پیگیری‌ها', '۰')),
              const SizedBox(width: 12),
              Expanded(child: _stat(Icons.smart_toy_rounded, const Color(0xFF0984E3),
                  'دستیار', 'آماده')),
            ]),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF6C5CE7).withOpacity(0.2)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.lightbulb_rounded, color: Color(0xFF6C5CE7)),
                    SizedBox(width: 10),
                    Text('پیشنهاد هوشمند',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ]),
                  SizedBox(height: 12),
                  Text('۳ مشتری امروز آماده بازدید هستند!'),
                  SizedBox(height: 6),
                  Text('اگر امروز پیگیری کنی، احتمال معامله بالا می‌رود.',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, Color color, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ───── تب مشتریان ─────
class CustomersTab extends StatefulWidget {
  const CustomersTab({super.key});
  @override
  State<CustomersTab> createState() => _CustomersTabState();
}

class _CustomersTabState extends State<CustomersTab> {
  List<Map<String, dynamic>> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _list = (jsonDecode(p.getString('customers') ?? '[]') as List)
          .map((e) => Map<String, dynamic>.from(e)).toList();
    });
  }

  Future<void> _add() async {
    final n = TextEditingController(), ph = TextEditingController(),
        r = TextEditingController();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (c) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom,
            left: 16, right: 16, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('مشتری جدید', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: n, decoration: const InputDecoration(
                labelText: 'نام', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: ph, keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'شماره تماس', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: r, maxLines: 2,
                decoration: const InputDecoration(
                    labelText: 'درخواست', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () async {
                if (n.text.isEmpty) return;
                final p = await SharedPreferences.getInstance();
                final l = (jsonDecode(p.getString('customers') ?? '[]') as List).toList();
                l.add({'name': n.text, 'phone': ph.text, 'request': r.text});
                await p.setString('customers', jsonEncode(l));
                if (c.mounted) Navigator.pop(c, true);
              },
              child: const Text('ذخیره'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
    if (ok == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text('مشتریان'), automaticallyImplyLeading: false),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('مشتری جدید'),
      ),
      body: _list.isEmpty
          ? const Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey),
                SizedBox(height: 12),
                Text('هنوز مشتری‌ای ثبت نشده', style: TextStyle(color: Colors.grey)),
              ]))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _list.length,
              itemBuilder: (_, i) {
                final c = _list[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF6C5CE7).withOpacity(0.15),
                      child: Text((c['name'] ?? '?').toString().substring(0, 1),
                          style: const TextStyle(color: Color(0xFF6C5CE7),
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(c['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${c['phone'] ?? ''}\n${c['request'] ?? ''}'),
                  ),
                );
              }),
    );
  }
}

// ───── تب فایل‌ها ─────
class PropertiesTab extends StatefulWidget {
  const PropertiesTab({super.key});
  @override
  State<PropertiesTab> createState() => _PropertiesTabState();
}

class _PropertiesTabState extends State<PropertiesTab> {
  List<Map<String, dynamic>> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _list = (jsonDecode(p.getString('properties') ?? '[]') as List)
          .map((e) => Map<String, dynamic>.from(e)).toList();
    });
  }

  Future<void> _add() async {
    final t = TextEditingController(), l = TextEditingController(),
        pr = TextEditingController(), a = TextEditingController();
    String type = 'آپارتمان', deal = 'فروش';

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (c) => StatefulBuilder(
        builder: (c, setS) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom,
              left: 16, right: 16, top: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('فایل جدید', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(controller: t, decoration: const InputDecoration(
                    labelText: 'عنوان', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: l, decoration: const InputDecoration(
                    labelText: 'محدوده', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: DropdownButtonFormField<String>(
                    value: type,
                    decoration: const InputDecoration(labelText: 'نوع', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'آپارتمان', child: Text('آپارتمان')),
                      DropdownMenuItem(value: 'خانه', child: Text('خانه')),
                      DropdownMenuItem(value: 'زمین', child: Text('زمین')),
                      DropdownMenuItem(value: 'مغازه', child: Text('مغازه')),
                      DropdownMenuItem(value: 'ویلا', child: Text('ویلا')),
                    ],
                    onChanged: (v) => setS(() => type = v!),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: DropdownButtonFormField<String>(
                    value: deal,
                    decoration: const InputDecoration(labelText: 'معامله', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'فروش', child: Text('فروش')),
                      DropdownMenuItem(value: 'رهن', child: Text('رهن')),
                      DropdownMenuItem(value: 'اجاره', child: Text('اجاره')),
                    ],
                    onChanged: (v) => setS(() => deal = v!),
                  )),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextField(controller: a,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'متراژ', border: OutlineInputBorder()))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: pr,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'قیمت', border: OutlineInputBorder()))),
                ]),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () async {
                    if (t.text.isEmpty) return;
                    final p = await SharedPreferences.getInstance();
                    final li = (jsonDecode(p.getString('properties') ?? '[]') as List).toList();
                    li.add({
                      'title': t.text, 'location': l.text, 'price': pr.text,
                      'area': a.text, 'type': type, 'deal': deal,
                    });
                    await p.setString('properties', jsonEncode(li));
                    if (c.mounted) Navigator.pop(c, true);
                  },
                  child: const Text('ذخیره'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
    if (ok == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text('فایل‌ها'), automaticallyImplyLeading: false),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('فایل جدید'),
      ),
      body: _list.isEmpty
          ? const Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_work_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 12),
                Text('هنوز فایلی ثبت نشده', style: TextStyle(color: Colors.grey)),
              ]))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _list.length,
              itemBuilder: (_, i) {
                final p = _list[i];
                final color = p['deal'] == 'فروش' ? Colors.green
                    : p['deal'] == 'رهن' ? Colors.orange : Colors.blue;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(child: Text(p['title'] ?? '',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(p['deal'] ?? '',
                                style: TextStyle(color: color,
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ]),
                        const SizedBox(height: 6),
                        Row(children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(p['location'] ?? '', style: const TextStyle(color: Colors.grey)),
                        ]),
                        const SizedBox(height: 6),
                        Text('${p['area']} متر • ${p['type']}',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}

// ───── تب دستیار ─────
class AiTab extends StatelessWidget {
  const AiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text('دستیار هوشمند'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF4A3FB8)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(children: [
              Icon(Icons.smart_toy_rounded, color: Colors.white, size: 60),
              SizedBox(height: 12),
              Text('دستیار هوشمند آینده‌ساز',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('به‌زودی می‌تونی با دستیار حرف بزنی',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 20),
          _f(Icons.mic_rounded, 'ورودی صوتی', 'مشتری جدید رو با صدات ثبت کن'),
          _f(Icons.search_rounded, 'جستجوی هوشمند', 'سریع‌ترین فایل مناسب مشتری رو پیدا کن'),
          _f(Icons.trending_up_rounded, 'تحلیل درآمد', 'گزارش کامل از عملکرد ماهانه'),
          _f(Icons.lightbulb_rounded, 'فرصت‌های طلایی', 'مشتری‌های آماده معامله رو بشناس'),
        ],
      ),
    );
  }

  Widget _f(IconData i, String t, String s) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6C5CE7).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(i, color: const Color(0xFF6C5CE7)),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 2),
              Text(s, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )),
        ]),
      );
}
