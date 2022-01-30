import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum MenuItem { settings, about, signOut }

class SharedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar appBar;
  const SharedAppBar({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  @override
  State<SharedAppBar> createState() => _SharedAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class _SharedAppBarState extends State<SharedAppBar> {
  FirebaseAuth auth = FirebaseAuth.instance;
  PackageInfo _packageInfo = PackageInfo(
      appName: 'appName',
      packageName: 'packageName',
      version: 'version',
      buildNumber: 'buildNumber',
      buildSignature: 'buildSignature');

  List<PopupMenuItem> items = [
    const PopupMenuItem(
      value: MenuItem.settings,
      child: ListTile(
        title: Text("Settings"),
        leading: Icon(FontAwesomeIcons.cog),
      ),
    ),
    const PopupMenuItem(
      value: MenuItem.about,
      child: ListTile(
        title: Text("About"),
        leading: Icon(FontAwesomeIcons.infoCircle),
      ),
    ),
  ];

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;
  }

  @override
  Widget build(BuildContext context) {
    _initPackageInfo();
    return AppBar(
      title: const Text("My BMI"),
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (value) {
            if (value == MenuItem.about) {
              showAboutDialog(
                  context: context,
                  applicationIcon: Expanded(
                    flex: 1,
                    child: Image.asset('images/playstore.png'),
                  ),
                  applicationName: _packageInfo.appName,
                  applicationVersion: _packageInfo.version);
            } else if (value == MenuItem.signOut) {
              auth.signOut();
            }
          },
          itemBuilder: (context) {
            return items;
          },
        ),
      ],
      centerTitle: true,
    );
  }

  Size get preferredSize => Size.fromHeight(widget.appBar.preferredSize.height);

  @override
  void initState() {
    super.initState();
    auth.userChanges().listen((User? user) {
      if (user != null) {
        if (items.length == 2) {
          items.add(const PopupMenuItem(
            value: MenuItem.signOut,
            child: ListTile(
              title: Text("Sign Out"),
              leading: Icon(FontAwesomeIcons.signOutAlt),
            ),
          ));
        }
      } else {
        if (items.length == 3) {
          items.removeLast();
        }
      }
    });
  }
}
