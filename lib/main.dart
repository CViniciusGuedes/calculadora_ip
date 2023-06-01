import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String ipAddress = '';
  String ipClass = '';
  String subnetMask = '';
  String cidr = '';
  String broadcastAddress = '';

  void calculateIPInfo() {
    setState(() {
      ipClass = getIpClass(ipAddress);
      subnetMask = getSubnetMask(ipAddress, ipClass);
      cidr = getCIDR(subnetMask);
      broadcastAddress = getBroadcastAddress(ipAddress, subnetMask);
    });
  }

  String getIpClass(String ipAddress) {
    List<String> parts = ipAddress.split('.');
    int firstOctet = int.parse(parts[0]);

    if (firstOctet >= 1 && firstOctet <= 126) {
      return 'Classe A';
    } else if (firstOctet >= 128 && firstOctet <= 191) {
      return 'Classe B';
    } else if (firstOctet >= 192 && firstOctet <= 223) {
      return 'Classe C';
    } else {
      return 'Não determinada';
    }
  }

  String getSubnetMask(String ipAddress, String ipClass) {
    if (ipClass == 'Classe A') {
      return '255.0.0.0';
    } else if (ipClass == 'Classe B') {
      return '255.255.0.0';
    } else if (ipClass == 'Classe C') {
      return '255.255.255.0';
    } else {
      return 'Não determinada';
    }
  }

  String getCIDR(String subnetMask) {
    int cidr = 0;
    List<String> parts = subnetMask.split('.');
    for (String part in parts) {
      int value = int.parse(part);
      for (int i = 0; i < 8; i++) {
        if ((value & 0x80) == 0) {
          return cidr.toString();
        }
        cidr++;
        value <<= 1;
      }
    }
    return cidr.toString();
  }

  String getBroadcastAddress(String ipAddress, String subnetMask) {
    List<String> ipParts = ipAddress.split('.');
    List<String> maskParts = subnetMask.split('.');
    List<String> broadcastParts = [];

    for (int i = 0; i < 4; i++) {
      int ip = int.parse(ipParts[i]);
      int mask = int.parse(maskParts[i]);
      int broadcast = ip | (~mask & 0xFF);
      broadcastParts.add(broadcast.toString());
    }

    return broadcastParts.join('.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora IP', textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                ipAddress = value;
              },
              decoration: InputDecoration(
                labelText: 'Digite o endereço IP',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: calculateIPInfo,
              child: Text('Calcular'),
            ),
            SizedBox(height: 16.0),
            Text('Classe de IP: $ipClass'),
            Text('Máscara de rede: $subnetMask'),
            Text('CIDR: $cidr'),
            Text('Endereço de broadcast: $broadcastAddress'),
          ],
        ),
      ),
    );
  }
}
