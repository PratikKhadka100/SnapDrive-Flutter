import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import './home_screen.dart';
import '../models/vehicle.dart';
import '../api/api_services.dart';

class AddVehicleScreen extends StatefulWidget {
  static const routeName = '/add-vehicle';

  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final dropDownItems = ['Gasoline', 'Bio', 'Electric', 'CNG'];
  String fuelTypeValue = '';

  final requiredValidate = ValidationBuilder().required().build();

  final vehicleNameController = TextEditingController();
  final vinController = TextEditingController();
  final kilometersController = TextEditingController();
  final yearController = TextEditingController();
  final engineSizeController = TextEditingController();
  final colorController = TextEditingController();
  final doorsController = TextEditingController();
  final driveTrainController = TextEditingController();
  final enginePowerController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final cylindersController = TextEditingController();
  final manufacturerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final base64ImgList =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    void addVehicleHandler() {
      var vehicleObject = Vehicle(
        name: vehicleNameController.text.trim(),
        vin: vinController.text.trim(),
        kilometers: double.parse(kilometersController.text.trim()),
        year: int.parse(yearController.text.trim()),
        engineSize: double.parse(engineSizeController.text.trim()),
        color: colorController.text.trim(),
        doors: int.parse(doorsController.text.trim()),
        fuelType: fuelTypeValue.trim(),
        driveTrain: driveTrainController.text.trim(),
        enginePower: int.parse(enginePowerController.text.trim()),
        length: int.parse(lengthController.text.trim()),
        width: int.parse(widthController.text.trim()),
        height: int.parse(heightController.text.trim()),
        manufacturer: manufacturerController.text.trim(),
        cylinders: int.parse(cylindersController.text.trim()),
        images: base64ImgList,
      );

      Map<String, dynamic> vehicleMap = vehicleObject.toMap();

      APIServices.addVehicle(vehicleMap);
    }

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );

    final fillColor = Theme.of(context).colorScheme.secondary.withOpacity(0.7);

    const textFieldPadding = EdgeInsets.symmetric(horizontal: 26.0);

    Widget buildTextField(
      TextInputType textInputType,
      String text,
      Widget? icon,
      String? Function(String?)? validator,
      TextEditingController controller,
    ) {
      return TextFormField(
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: outlineInputBorder,
          fillColor: fillColor,
          filled: true,
          prefixIcon: icon,
          prefixIconColor: Colors.black,
          hintText: text,
        ),
        validator: validator,
        controller: controller,
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: textFieldPadding,
              child: Column(
                children: <Widget>[
                  const Text(
                    'Add Vehicle Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    TextInputType.name,
                    'Vehicle Name',
                    const Icon(Icons.drive_eta_rounded),
                    requiredValidate,
                    vehicleNameController,
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    TextInputType.text,
                    'VIN',
                    const Icon(Icons.password_rounded),
                    requiredValidate,
                    vinController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          TextInputType.number,
                          'Kilometers',
                          const Icon(Icons.speed_rounded),
                          requiredValidate,
                          kilometersController,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: buildTextField(
                          TextInputType.number,
                          'Year',
                          const Icon(Icons.date_range_rounded),
                          requiredValidate,
                          yearController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    TextInputType.number,
                    'Engine Size (litres)',
                    const Icon(Icons.candlestick_chart_rounded),
                    requiredValidate,
                    engineSizeController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          TextInputType.text,
                          'Color',
                          const Icon(Icons.format_paint_rounded),
                          requiredValidate,
                          colorController,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: buildTextField(
                          TextInputType.number,
                          'Doors',
                          const Icon(Icons.door_front_door_rounded),
                          requiredValidate,
                          doorsController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: outlineInputBorder,
                      fillColor: fillColor,
                      filled: true,
                      prefixIcon: const Icon(Icons.propane_tank_rounded),
                      prefixIconColor: Colors.black,
                      hintText: 'Select Fuel Type',
                    ),
                    items: dropDownItems.map((String fuelType) {
                      return DropdownMenuItem(
                        value: fuelType,
                        child: Text(fuelType),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        fuelTypeValue = value!;
                      });
                    },
                    validator: requiredValidate,
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    TextInputType.text,
                    'Drive Train',
                    const Icon(Icons.car_repair_rounded),
                    requiredValidate,
                    driveTrainController,
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    TextInputType.number,
                    'Engine Power (bhp)',
                    const Icon(Icons.power_rounded),
                    requiredValidate,
                    enginePowerController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          TextInputType.number,
                          'Length (mm)',
                          null,
                          requiredValidate,
                          lengthController,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: buildTextField(
                          TextInputType.number,
                          'Width (mm)',
                          null,
                          requiredValidate,
                          widthController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          TextInputType.number,
                          'Height (mm)',
                          null,
                          requiredValidate,
                          heightController,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: buildTextField(
                          TextInputType.number,
                          'No. of Cylinders',
                          null,
                          requiredValidate,
                          cylindersController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    TextInputType.text,
                    'Manufacturer',
                    const Icon(Icons.precision_manufacturing_rounded),
                    requiredValidate,
                    manufacturerController,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          addVehicleHandler();
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      overlayColor: MaterialStateProperty.all(Colors.blue),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withAlpha(240),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
