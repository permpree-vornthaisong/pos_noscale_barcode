import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:pos_noscale_barcode/A_PROVIDER/PRINTTER/external_printter/printter_provider.dart';
import 'package:provider/provider.dart';

class TEST_PRINTER extends StatelessWidget {
  const TEST_PRINTER({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinterManagerClass>(builder: (context, printerManager, child) {
      return Container(
        child: Center(
          child: Container(
            height: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Container(
                    height: 70,
                    child: Center(
                      child: Text("Printter Scan"),
                    ),
                  ),
                  _buildPrinterTypeDropdown(printerManager),
                  // _buildBleSwitch(printerManager),
                  // _buildReconnectSwitch(printerManager),
                  _buildPrinterList(printerManager, context),
                  _buildNetworkSettings(printerManager, context),
                  _buildActionButtons(printerManager, context),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPrinterTypeDropdown(PrinterManagerClass printerManager) {
    return DropdownButtonFormField<PrinterType>(
      value: PrinterType.usb, // Ensure this matches one of the items
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.print, size: 24),
        labelText: "Type Printer Device",
        labelStyle: TextStyle(fontSize: 18.0),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      items: const <DropdownMenuItem<PrinterType>>[
        DropdownMenuItem(
          value: PrinterType.usb,
          child: Text("USB"),
        ),
      ],
      onChanged: (PrinterType? value) {
        if (value != null) {
          printerManager.PrinterManager_start();
          printerManager.defaultPrinterType = value;
          printerManager.reset();
          printerManager.scanDevices();
        }
      },
    );
  }
  /* Widget _buildPrinterTypeDropdown(PrinterManagerClass printerManager) {
    return DropdownButtonFormField<PrinterType>(
      value: printerManager.defaultPrinterType,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.print, size: 24),
        labelText: "Type Printer Device",
        labelStyle: TextStyle(fontSize: 18.0),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      items: <DropdownMenuItem<PrinterType>>[
        // <DropdownMenuItem<PrinterType>>
        /* const DropdownMenuItem(    //PrinterType.usb
          value: PrinterType.bluetooth,
          child: Text("Bluetooth"),
        ),*/
        const DropdownMenuItem(
          value: PrinterType.usb,
          child: Text("USB"),
        ),
        /* const DropdownMenuItem(
          value: PrinterType.network,
          child: Text("Network"),
        ),*/
      ],
      onChanged: (PrinterType? value) {
        if (value != null) {
          printerManager.PrinterManager_start();
          printerManager.defaultPrinterType = value;
          printerManager.reset();
          printerManager.scanDevices();
        }
      },
    );
  }*/

  Widget _buildBleSwitch(PrinterManagerClass printerManager) {
    return Visibility(
      visible: printerManager.defaultPrinterType == PrinterType.bluetooth,
      child: SwitchListTile.adaptive(
        contentPadding: const EdgeInsets.only(bottom: 20.0, left: 20),
        title: const Text("This device supports BLE (low energy)", textAlign: TextAlign.start, style: TextStyle(fontSize: 19.0)),
        value: printerManager.isBle,
        onChanged: (bool? value) {
          printerManager.PrinterManager_start();

          printerManager.isBle = value ?? false;
          printerManager.reset();
          printerManager.scanDevices();
        },
      ),
    );
  }

  Widget _buildReconnectSwitch(PrinterManagerClass printerManager) {
    return Visibility(
      visible: printerManager.defaultPrinterType == PrinterType.bluetooth,
      child: SwitchListTile.adaptive(
        contentPadding: const EdgeInsets.only(bottom: 20.0, left: 20),
        title: const Text("Reconnect", textAlign: TextAlign.start, style: TextStyle(fontSize: 19.0)),
        value: printerManager.reconnect,
        onChanged: (bool? value) {
          printerManager.reconnect = value ?? false;
        },
      ),
    );
  }
//                        printerManager.printTestTicket(context);

  Widget _buildPrinterList(PrinterManagerClass printerManager, BuildContext context) {
    return Column(
      children: printerManager.devices.map(
        (device) {
          bool isSelected = printerManager.selectedPrinter?.deviceName == device.deviceName;

          return Container(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent, // Background color when selected
            child: ListTile(
              title: Text('${device.deviceName}'),
              subtitle: printerManager.defaultPrinterType == PrinterType.usb
                  ? null
                  : Visibility(
                      visible: true,
                      child: Text("${device.address}"),
                    ),
              onTap: () {
                printerManager.selectDevice(device);
              },
              /* leading: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
              trailing: OutlinedButton(
                onPressed: printerManager.selectedPrinter == null || device.deviceName != printerManager.selectedPrinter?.deviceName
                    ? null
                    : () async {
                        await printerManager.printTestTicket(context);
                      },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  child: Text("Print test ticket", textAlign: TextAlign.center),
                ),
              ),*/
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildNetworkSettings(PrinterManagerClass printerManager, context) {
    return Visibility(
      visible: printerManager.defaultPrinterType == PrinterType.network,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextFormField(
              controller: printerManager.ipController,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              decoration: const InputDecoration(
                label: Text("IP Address"),
                prefixIcon: Icon(Icons.wifi, size: 24),
              ),
              onChanged: (value) {
                printerManager.setIpAddress(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextFormField(
              controller: printerManager.portController,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              decoration: const InputDecoration(
                label: Text("Port"),
                prefixIcon: Icon(Icons.numbers_outlined, size: 24),
              ),
              onChanged: (value) {
                printerManager.setPort(value);
              },
            ),
          ),
          /* Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: OutlinedButton(
              onPressed: () async {
                if (printerManager.ipController.text.isNotEmpty) {
                  printerManager.setIpAddress(printerManager.ipController.text);
                }
                printerManager.printTestTicket(context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 50),
                child: Text("Print test ticket", textAlign: TextAlign.center),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildActionButtons(PrinterManagerClass printerManager, context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: printerManager.selectedPrinter == null || printerManager.isConnected
                  ? null
                  : () {
                      printerManager.connectDevice(context);
                    },
              child: Text("Connect", textAlign: TextAlign.center),
              style: ElevatedButton.styleFrom(
                // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
                elevation: 5, // Shadow
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: printerManager.selectedPrinter == null || !printerManager.isConnected
                  ? null
                  : () {
                      if (printerManager.selectedPrinter != null) {
                        printerManager.disconnectDevice();
                      }
                    },
              child: const Text("Disconnect", textAlign: TextAlign.center),
              style: ElevatedButton.styleFrom(
                // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
                elevation: 5, // Shadow
              ),
            ),
          ),
        ],
      ),
    );
  }
}
