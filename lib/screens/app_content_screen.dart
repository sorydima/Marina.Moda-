import 'dart:io';

import 'package:flutter/material.dart';
import '../widgets/load_web_view.dart';

class AppContentScreen extends StatefulWidget {
  final String title;
  final String content;
  final String url;
  const AppContentScreen(
      {Key? key, required this.title, required this.content, required this.url})
      : super(key: key);

  @override
  _AppContentScreenState createState() => _AppContentScreenState();
}

class _AppContentScreenState extends State<AppContentScreen> {
  @override
  Widget build(BuildContext context) {
    String message = widget.content;
    message = Theme.of(context).brightness == Brightness.dark
        ? "<font color='white'>" + widget.content + "</font>"
        : "<font color='black'>" + widget.content + "</font>";
    return SafeArea(
      top: Platform.isIOS ? false : true,
      child: Scaffold(
          // backgroundColor: Colors.red,
          appBar: AppBar(
            elevation: 0,
            title: Text(widget.title),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: widget.url == ''
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: LoadWebView(
                    url: message,
                    webUrl: false,
                  ))
              : LoadWebView(
                  url: widget.url,
                  webUrl: true,
                )),
    );
  }
}
