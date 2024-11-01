import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:court_reserve_app/extensions/time_extension.dart';
import 'package:court_reserve_app/models/court_rate.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/models/tennis_court_type.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/court_rates_repository.dart';
import 'package:court_reserve_app/repositories/tennis_court_repository.dart';
import 'package:court_reserve_app/screens/add_tennis_court/add_tennis_court_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class AddTennisCourtScreen extends StatefulWidget {
  final TennisCourt? tennisCourt;
  const AddTennisCourtScreen({
    this.tennisCourt,
    Key? key,
  }) : super(key: key);

  @override
  State<AddTennisCourtScreen> createState() => _AddTennisCourtScreenState();
}

class _AddTennisCourtScreenState extends State<AddTennisCourtScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _weekdayPriceController = TextEditingController();
  final TextEditingController _weekendPriceController = TextEditingController();
  final TextEditingController _nightTimePriceController =
      TextEditingController();
  late AddTennisCourtViewModel _viewModel;
  Uint8List imageBytes = Uint8List(0);
  TennisCourtType? _tennisCourtType;
  TimeOfDay _openingTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closingTime = const TimeOfDay(hour: 22, minute: 0);
  bool isLoading = false;
  bool get isEditing => widget.tennisCourt != null;
  int _courtRateId = 0;

  @override
  void initState() {
    if (isEditing) {
      _nameController.text = widget.tennisCourt!.title;
      _cityController.text = widget.tennisCourt!.city;
      _addressController.text = widget.tennisCourt!.address;
      _weekdayPriceController.text =
          widget.tennisCourt!.pricePerHour.toString();
      _openingTime = widget.tennisCourt!.openingTime;
      _closingTime = widget.tennisCourt!.closingTime;
      imageBytes = base64Decode(widget.tennisCourt!.imageBase46());
    }
    _viewModel = AddTennisCourtViewModel(
      Input(
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
      ),
      TennisCourtRepository(),
      CourtRatesRepository(),
    );
    _viewModel.output.onSave.listen((event) {
      switch (event.state) {
        case OperationState.success:
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop(true);
          break;
        case OperationState.loading:
          setState(() {
            isLoading = true;
          });
          break;
        case OperationState.error:
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${event.error}",
              ),
            ),
          );
          break;
      }
      debugPrint("$event");
    });
    _viewModel.output.onDelete.listen((event) {
      switch (event.state) {
        case OperationState.success:
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop(true);
          break;
        case OperationState.loading:
          setState(() {
            isLoading = true;
          });
          break;
        case OperationState.error:
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${event.error}",
              ),
            ),
          );
          break;
      }
      debugPrint("$event");
    });

    _viewModel.output.onInit.listen((event) {
      switch (event.state) {
        case OperationState.success:
          setState(() {
            isLoading = false;
            _weekdayPriceController.text =
                event.data!.workdayHourlyPrice.toString();
            _weekendPriceController.text =
                event.data!.weekendHourlyPrice.toString();
            _nightTimePriceController.text = event.data!.nightTariff.toString();
            _courtRateId = event.data!.id;
          });
          break;
        case OperationState.loading:
          setState(() {
            isLoading = true;
          });
          break;
        case OperationState.error:
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${event.error}",
              ),
            ),
          );
          break;
      }
      debugPrint("$event");
    });
    if (widget.tennisCourt != null) {
      _viewModel.input.init.add(widget.tennisCourt!.courtId!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${isEditing ? "Edit" : "Add"} tennis court"),
      ),
      body: Stack(children: [
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, _) => const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 100,
                            ),
                            Text("Choose image"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: "City"),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    hint: const Text("Surface type"),
                    value: _tennisCourtType,
                    items: const [
                      DropdownMenuItem(
                        value: TennisCourtType.clay,
                        child: Text("Clay"),
                      ),
                      DropdownMenuItem(
                        value: TennisCourtType.grass,
                        child: Text("Grass"),
                      ),
                      DropdownMenuItem(
                        value: TennisCourtType.hard,
                        child: Text("Hard"),
                      )
                    ],
                    onChanged: (selectedCourtType) {
                      setState(() {
                        _tennisCourtType = selectedCourtType;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _weekdayPriceController,
                  decoration: const InputDecoration(
                      labelText: "Weekday price per hour"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _weekendPriceController,
                  decoration: const InputDecoration(
                      labelText: "Weekend price per hour"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _nightTimePriceController,
                  decoration: const InputDecoration(
                      labelText: "Night time additional price per game"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: OutlinedButton(
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: _openingTime,
                          ).then((selectedOpeningTime) {
                            setState(() {
                              _openingTime =
                                  selectedOpeningTime ?? _openingTime;
                            });
                          });
                        },
                        child: Text(
                            "Opening: ${_openingTime.toFormattedString()}"),
                      ),
                    ),
                    Flexible(
                      child: OutlinedButton(
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: _closingTime,
                          ).then((selectedOpeningTime) {
                            setState(() {
                              _closingTime =
                                  selectedOpeningTime ?? _closingTime;
                            });
                          });
                        },
                        child: Text(
                            "Closing: ${_closingTime.toFormattedString()}"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _onSave,
                      child: const Text("Save"),
                    ),
                    if (isEditing) ...[
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _onDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red.shade500,
                        ),
                        child: const Text("Delete"),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.white54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ]),
    );
  }

  void _pickImage() {
    FilePicker.platform.pickFiles().then((result) {
      if (result != null && result.files.single.path != null) {
        setState(() {
          imageBytes = File(result.files.single.path!).readAsBytesSync();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Something went wrong.",
            ),
          ),
        );
      }
    });
  }

  CourtRate _courtRate() {
    return CourtRate(
      int.tryParse(_weekdayPriceController.text) ?? 20,
      int.tryParse(_weekendPriceController.text) ?? 20,
      int.tryParse(_nightTimePriceController.text) ?? 0,
      id: _courtRateId,
    );
  }

  void _onSave() {
    _viewModel.input.save.add(
      TennisCourt(
        courtId: widget.tennisCourt?.courtId,
        title: _nameController.text,
        city: _cityController.text,
        address: _addressController.text,
        surfaceType: _tennisCourtType ?? TennisCourtType.hard,
        pricePerHour: double.tryParse(_weekdayPriceController.text) ?? 20.0,
        openingTime: _openingTime,
        closingTime: _closingTime,
        imagesData: [imageBytes],
        courtRate: _courtRate(),
      ),
    );
  }

  void _onDelete() {
    _viewModel.input.delete.add(widget.tennisCourt!.courtId!);
  }
}
