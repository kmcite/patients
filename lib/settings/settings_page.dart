import '../main.dart';

class SettingsPage extends UI {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius())),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Theme Mode', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DropdownButtonFormField(
                    value: themeMode(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: ThemeMode.values.map(
                      (eachThemeMode) {
                        return DropdownMenuItem(
                          value: eachThemeMode,
                          child: Text(eachThemeMode.name.toUpperCase()),
                        );
                      },
                    ).toList(),
                    onChanged: themeMode,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius())),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Primary Color',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DropdownButtonFormField(
                    value: materialColor(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: Colors.primaries
                        .map(
                          (eachMaterialColor) => DropdownMenuItem(
                            value: eachMaterialColor,
                            child: Text(eachMaterialColor.colorName.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: materialColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius())),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: BorderRadiusModifier(),
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius())),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: UserUI(),
            ),
          ),
        ],
      ),
    );
  }
}
