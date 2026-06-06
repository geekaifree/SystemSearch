import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const SystemSearchApp());

class SystemSearchApp extends StatelessWidget {
  const SystemSearchApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: '系统级极速搜索', debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true, brightness: Brightness.light),
    darkTheme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true, brightness: Brightness.dark),
    home: const SearchHomePage(),
  );
}

class SearchItem {
  final String title, subtitle, type, icon;
  SearchItem({required this.title, required this.subtitle, required this.type, required this.icon});
}

class SearchHomePage extends StatefulWidget {
  const SearchHomePage({super.key});
  @override
  State<SearchHomePage> createState() => _SearchHomePageState();
}

class _SearchHomePageState extends State<SearchHomePage> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  List<SearchItem> _results = [];
  List<String> _history = [];
  String _filter = '全部';

  final _apps = [
    SearchItem(title: '设置', subtitle: '系统设置', type: 'app', icon: '⚙️'),
    SearchItem(title: '浏览器', subtitle: '网页浏览', type: 'app', icon: '🌐'),
    SearchItem(title: '文件管理器', subtitle: '文件管理', type: 'app', icon: '📁'),
    SearchItem(title: '计算器', subtitle: '数学计算', type: 'app', icon: '🔢'),
    SearchItem(title: '日历', subtitle: '日程管理', type: 'app', icon: '📅'),
    SearchItem(title: '相机', subtitle: '拍照录像', type: 'app', icon: '📷'),
    SearchItem(title: '音乐', subtitle: '音乐播放', type: 'app', icon: '🎵'),
    SearchItem(title: '终端', subtitle: '命令行', type: 'app', icon: '💻'),
    SearchItem(title: '备忘录', subtitle: '记录笔记', type: 'app', icon: '📝'),
    SearchItem(title: '天气', subtitle: '天气预报', type: 'app', icon: '🌤️'),
  ];
  final _files = [
    SearchItem(title: '项目报告.docx', subtitle: '~/Documents/ • 2.5MB', type: 'file', icon: '📄'),
    SearchItem(title: '演示文稿.pptx', subtitle: '~/Documents/ • 5.1MB', type: 'file', icon: '📊'),
    SearchItem(title: '照片_2024.jpg', subtitle: '~/Pictures/ • 3.8MB', type: 'file', icon: '🖼️'),
    SearchItem(title: '下载文件.zip', subtitle: '~/Downloads/ • 45.2MB', type: 'file', icon: '📦'),
    SearchItem(title: '配置文件.json', subtitle: '~/.config/ • 4KB', type: 'file', icon: '⚙️'),
  ];
  final _settings = [
    SearchItem(title: 'Wi-Fi设置', subtitle: '管理无线网络', type: 'setting', icon: '📶'),
    SearchItem(title: '蓝牙设置', subtitle: '管理蓝牙设备', type: 'setting', icon: '🔵'),
    SearchItem(title: '显示设置', subtitle: '调整屏幕亮度', type: 'setting', icon: '🖥️'),
    SearchItem(title: '声音设置', subtitle: '调整音量', type: 'setting', icon: '🔊'),
    SearchItem(title: '存储管理', subtitle: '查看存储空间', type: 'setting', icon: '💾'),
    SearchItem(title: '隐私设置', subtitle: '隐私权限管理', type: 'setting', icon: '🔒'),
  ];

  @override
  void initState() { super.initState(); _loadHistory(); _ctrl.addListener(_search); }
  @override
  void dispose() { _ctrl.dispose(); _focus.dispose(); super.dispose(); }

  Future<void> _loadHistory() async {
    final p = await SharedPreferences.getInstance();
    final d = p.getString('search_history');
    if (d != null) setState(() => _history = List<String>.from(json.decode(d)));
  }
  Future<void> _saveHistory() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('search_history', json.encode(_history));
  }

  void _search() {
    final q = _ctrl.text.trim().toLowerCase();
    if (q.isEmpty) { setState(() => _results = []); return; }
    final r = <SearchItem>[];
    if (_filter == '全部' || _filter == '应用') r.addAll(_apps.where((a) => a.title.toLowerCase().contains(q) || a.subtitle.toLowerCase().contains(q)));
    if (_filter == '全部' || _filter == '文件') r.addAll(_files.where((a) => a.title.toLowerCase().contains(q)));
    if (_filter == '全部' || _filter == '设置') r.addAll(_settings.where((a) => a.title.toLowerCase().contains(q) || a.subtitle.toLowerCase().contains(q)));
    if (_filter == '全部' || _filter == '网页') r.add(SearchItem(title: '搜索 "$q"', subtitle: '使用搜索引擎', type: 'web', icon: '🌐'));
    setState(() => _results = r);
  }

  void _pick(SearchItem item) {
    final q = _ctrl.text.trim();
    if (q.isNotEmpty) { _history.remove(q); _history.insert(0, q); if (_history.length > 20) _history = _history.sublist(0, 20); _saveHistory(); }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('打开: ${item.title}'), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Column(children: [
      Container(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: Column(children: [
        Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(28)), child: TextField(controller: _ctrl, focusNode: _focus, autofocus: true, decoration: InputDecoration(hintText: '搜索应用、文件、设置...', prefixIcon: const Icon(Icons.search), suffixIcon: _ctrl.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _ctrl.clear(); _focus.requestFocus(); }) : null, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)))),
        const SizedBox(height: 10),
        SizedBox(height: 36, child: ListView(scrollDirection: Axis.horizontal, children: ['全部', '应用', '文件', '设置', '网页'].map((f) => Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(label: Text(f, style: const TextStyle(fontSize: 13)), selected: _filter == f, onSelected: (_) { setState(() => _filter = f); _search(); }, visualDensity: VisualDensity.compact))).toList())),
      ])),
      const Divider(height: 1),
      Expanded(child: _ctrl.text.isEmpty ? _buildHistory() : _buildResults()),
    ])));
  }

  Widget _buildHistory() {
    if (_history.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.search, size: 80, color: Colors.grey.shade300), const SizedBox(height: 16), Text('输入关键词开始搜索', style: TextStyle(color: Colors.grey.shade500, fontSize: 16))]));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 16, 16, 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('搜索历史', style: TextStyle(fontWeight: FontWeight.bold)), TextButton(onPressed: () { setState(() => _history.clear()); _saveHistory(); }, child: const Text('清除'))])),
      Expanded(child: ListView.builder(itemCount: _history.length, itemBuilder: (ctx, i) => ListTile(leading: const Icon(Icons.history), title: Text(_history[i]), onTap: () { _ctrl.text = _history[i]; _focus.requestFocus(); }))),
    ]);
  }

  Widget _buildResults() {
    if (_results.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.search_off, size: 64, color: Colors.grey.shade300), const SizedBox(height: 16), Text('没有找到匹配结果', style: TextStyle(color: Colors.grey.shade500))]));
    return ListView.builder(padding: const EdgeInsets.symmetric(vertical: 8), itemCount: _results.length, itemBuilder: (ctx, i) {
      final r = _results[i];
      final tc = r.type == 'app' ? Colors.blue : r.type == 'file' ? Colors.orange : r.type == 'setting' ? Colors.green : Colors.purple;
      final tl = r.type == 'app' ? '应用' : r.type == 'file' ? '文件' : r.type == 'setting' ? '设置' : '网页';
      return ListTile(leading: Container(width: 44, height: 44, decoration: BoxDecoration(color: tc.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(r.icon, style: const TextStyle(fontSize: 24)))), title: Text(r.title, maxLines: 1, overflow: TextOverflow.ellipsis), subtitle: Text(r.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)), trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: tc.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(tl, style: TextStyle(fontSize: 11, color: tc, fontWeight: FontWeight.bold))), onTap: () => _pick(r));
    });
  }
}
