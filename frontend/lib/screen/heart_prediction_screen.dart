import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/predict_model.dart';
import 'package:frontend/screen/team_member_screen.dart';
import 'package:frontend/widget/dropdown_input_widget.dart';
import 'package:frontend/widget/error_snackbar_widget.dart';
import 'package:frontend/widget/loading_widget.dart';
import 'package:frontend/widget/text_input_widget.dart';

class HeartPredictionScreen extends StatefulWidget {
  const HeartPredictionScreen({Key? key}) : super(key: key);

  @override
  State<HeartPredictionScreen> createState() => _HeartPredictionScreenState();
}

class _HeartPredictionScreenState extends State<HeartPredictionScreen> {
  TextEditingController priceController = TextEditingController();
  TextEditingController highController = TextEditingController();
  TextEditingController lowController = TextEditingController();
  TextEditingController openController = TextEditingController();

  late String? price = priceController.text;
  late String? high = highController.text;
  late String? low = lowController.text;
  late String? open = openController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bitcoin(USD) Prediction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              App.of(context)?.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildInputSymptom(context),
            buildPredictButton(context),
            TeamMemberScreen(),
          ],
        ),
      ),
    );
  }

  Widget buildInputSymptom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildPriceInputBox(context),
        buildOpenInputBox(context),
        buildHighInputBox(context),
        buildLowInputBox(context),
      ],
    );
  }

  Widget buildPriceInputBox(BuildContext context) {
    return TextInputWidget(
      title: 'Price',
      controller: priceController,
    );
  }

  Widget buildHighInputBox(BuildContext context) {
    return TextInputWidget(
      title: 'High Price',
      controller: highController,
    );
  }

  Widget buildLowInputBox(BuildContext context) {
    return TextInputWidget(
      title: 'Low Price',
      controller: lowController,
    );
  }

  Widget buildOpenInputBox(BuildContext context) {
    return TextInputWidget(
      title: 'Open Price',
      controller: openController,
    );
  }

  Widget buildPredictButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ElevatedButton(
          onPressed: () async {
            // await Api.get('severity');
            // showResult();

            if (price != "" && high != "" && low != "" && open != "") {
              showResult();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
            }
          },
          child: const Text('Predict'),
        ),
      ),
    );
  }

  Future<PredictModel> postRequest() async {
    var data = {
      "Price": price,
      "High": high,
      "Low": low,
      "Open": open,
    };

    return await Api.post('/api/predict', data);
  }

  void showResult() {
    Widget okButton = TextButton(
      child: const Text("CLOSE"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<PredictModel>(
          future: postRequest(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AlertDialog(
                title: Text(
                  "Bitcoin Price in the next 30 days",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'USD ${snapshot.data!.predict!}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                actions: [
                  okButton,
                ],
              );
            }
            return const LoadingWidget();
          },
        );
      },
    );
  }
}
