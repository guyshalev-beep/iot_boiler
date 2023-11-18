import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';

import '../notification/notification.dart';

Future<MqttClient> connect(_log(String txt)) async {

  MqttServerClient client =
  MqttServerClient.withPort('broker.emqx.io', 'flutter_client', 1883);
  //MqttServerClient.withPort('wed4ec84.us-east-1.emqx.cloud', 'flutter_client', 15858);
  client.logging(on: true);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;
  final connMess = MqttConnectMessage()
      .withClientIdentifier("flutter_client")
      .authenticateAs("emqx", "public")
      //.authenticateAs("guy", "guy")
      .keepAliveFor(60)
      .withWillTopic('willtopic')
      .withWillMessage('My Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  client.connectionMessage = connMess;
  try {
    print('Connecting');
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('EMQX client connected');
    client.subscribe("esp8266/test1", MqttQos.atLeastOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {

      print('----------------- Received ${c.length} <>');
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage; //!!
      final payload =
      MqttPublishPayload.bytesToStringAsString(message.payload.message);
      if (payload.startsWith("notify_")){
        String _msg = payload.substring(7);

        //NotificationManager.notify("Notification From Your Boiler", _msg);
      }
      print('Received message:<$payload> from topic: ${c[0].topic}>');

    });

    client.published!.listen((MqttPublishMessage message) {
      print('----------------- published');
      final payload =
      MqttPublishPayload.bytesToStringAsString(message.payload.message);
      if (payload.startsWith("notify_"))
        _log(payload.substring(7));
      else
        _log(payload);
      print(
          'Published message: $payload to topic: ${message.variableHeader!.topicName}');
    });
  } else {
    print(
        'EMQX client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  return client;
}

void onConnected() {
  print('Connected');
}

void onDisconnected() {
  print('Disconnected');
}

void onSubscribed(String topic) {
  print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>Subscribed topic: $topic');
}

void onSubscribeFail(String topic) {
  print('Failed to subscribe topic: $topic');
}

void onUnsubscribed(String? topic) {
  print('Unsubscribed topic: $topic');
}

void pong() {
  print('Ping response client callback invoked');
}