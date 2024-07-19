import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum _Status {
  queue,
  process,
}

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  _Status _status = _Status.queue;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _status = _Status.process;
        Timer(const Duration(seconds: 3), () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(
            left: 12.0,
          ),
          child: SvgPicture.asset(
            'images/ic_brand.svg',
            width: 24.0,
            height: 24.0,
            semanticsLabel: 'brand logo',
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
          ),
        ),
        title: const Opacity(
          opacity: 0.7,
          child: Text(
            "Nacho Cafe",
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _status == _Status.queue
                ? const StatusWidget(
                    iconUrl: "images/ic_queue.svg",
                    label: "Dalam antrian",
                  )
                : const StatusWidget(
                    iconUrl: "images/ic_process.svg",
                    label: "Sedang diproses",
                  ),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    super.key,
    required this.iconUrl,
    required this.label,
  });

  final String iconUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SvgPicture.asset(
            iconUrl,
            width: 128.0,
            height: 128.0,
            colorFilter: const ColorFilter.mode(
              Colors.red,
              BlendMode.srcIn,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
