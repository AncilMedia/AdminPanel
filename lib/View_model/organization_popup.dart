import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../View/PopUp/Right_drawer.dart';
import '../controller/organization_controller.dart';
import '../controller/app_controller.dart';

class OrganizationRow extends StatefulWidget {
  final Map<String, dynamic> organization;
  final VoidCallback onDelete;
  final void Function(Map<String, dynamic> org) onEdit;

  const OrganizationRow({
    super.key,
    required this.organization,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<OrganizationRow> createState() => _OrganizationRowState();
}

class _OrganizationRowState extends State<OrganizationRow> {
  late Map<String, dynamic> org;
  final AppService _appService = AppService();

  List<dynamic> _apps = [];
  Set<String> assignedAppIds = {};
  bool _isLoading = true;
  bool _isAssigning = false;

  @override
  void initState() {
    super.initState();
    org = widget.organization;
    assignedAppIds = {
      if (org['apps'] != null)
        for (var app in org['apps']) if (app['appId'] != null) app['appId']
    };
    _fetchApps();
  }

  Future<void> _fetchApps() async {
    try {
      final apps = await _appService.getApps();
      setState(() {
        _apps = apps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showCustomSnackBar(context, "Failed to load apps", false);
    }
  }

  Text _poppinsText(String text,
      {Color? color, double fontSize = 14, FontWeight? fontWeight, TextAlign? align}) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.poppins(
        color: color ?? Colors.black87,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  Future<void> _showAppSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        Set<String> localAssigned = Set.from(assignedAppIds);

        return AlertDialog(
          title: _poppinsText("Assign/Unassign Apps", fontWeight: FontWeight.w600),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              return SizedBox(
                width: 250,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _apps.length,
                  itemBuilder: (context, index) {
                    final app = _apps[index];
                    final appId = app['appId'];
                    final isChecked = localAssigned.contains(appId);

                    return CheckboxListTile(
                      title: _poppinsText(app['appName'] ?? "Unnamed App"),
                      value: isChecked,
                      onChanged: _isAssigning
                          ? null
                          : (value) async {
                        setModalState(() => _isAssigning = true);

                        if (value == true) {
                          final success = await OrganizationController.assignAppToOrganization(org['_id'], appId);
                          if (success) {
                            setState(() => assignedAppIds.add(appId));
                            setModalState(() => localAssigned.add(appId));
                            showCustomSnackBar(context, "Assigned ${app['appName']}", true);
                          }
                        } else {
                          final success = await OrganizationController.unassignAppFromOrganization(org['_id'], appId);
                          if (success) {
                            setState(() => assignedAppIds.remove(appId));
                            setModalState(() => localAssigned.remove(appId));
                            showCustomSnackBar(context, "Unassigned ${app['appName']}", false);
                          }
                        }

                        setModalState(() => _isAssigning = false);
                        setState(() {
                          org['apps'] = _apps
                              .where((app) => assignedAppIds.contains(app['appId']))
                              .toList();
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: _poppinsText("Close", fontWeight: FontWeight.w500),
            ),
          ],
        );
      },
    );
  }

  Future<bool> showConfirmationDialog({
    required String title,
    required String message,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: _poppinsText(title, fontWeight: FontWeight.bold),
        content: _poppinsText(message),
        actions: [
          TextButton(
            child: _poppinsText("Cancel"),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: _poppinsText("Confirm", color: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    ) ?? false;
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yy/MM/dd').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final columnFlex = [3, 2, 2, 2, 2, 3];
    final name = org['name'] ?? "this organization";

    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(flex: columnFlex[0], child: _dataItem(name)),

          Expanded(
            flex: columnFlex[2],
            child: Center(
              child: org['approved'] == true
                  ? _poppinsText("Accepted", color: Colors.green, fontWeight: FontWeight.bold)
                  : org['approved'] == false
                  ? _poppinsText("Rejected", color: Colors.red, fontWeight: FontWeight.bold)
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Iconsax.tick_circle, color: Colors.green),
                    onPressed: () async {
                      final confirmed = await showConfirmationDialog(
                        title: "Approve Organization",
                        message: "Are you sure you want to approve '$name'?",
                      );
                      if (confirmed) {
                        final success = await OrganizationController.approveOrganization(org['_id'], true);
                        if (success) setState(() => org['approved'] = true);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.close_circle, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showConfirmationDialog(
                        title: "Reject Organization",
                        message: "Are you sure you want to reject '$name'?",
                      );
                      if (confirmed) {
                        final success = await OrganizationController.approveOrganization(org['_id'], false);
                        if (success) setState(() => org['approved'] = false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: columnFlex[3],
            child: Center(
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    widget.onEdit(org);
                  } else if (value == 'delete') {
                    final confirmed = await showConfirmationDialog(
                      title: "Delete Organization",
                      message: "Are you sure you want to delete '$name'?",
                    );
                    if (confirmed) widget.onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: _poppinsText("Edit")),
                  PopupMenuItem(value: 'delete', child: _poppinsText("Delete")),
                ],
                icon: const Icon(Iconsax.card_edit),
              ),
            ),
          ),

          Expanded(
            flex: columnFlex[1],
            child: Center(
              child: _isLoading
                  ? Lottie.asset('assets/smudging dots.json', height: 30)
                  : _isAssigning
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : TextButton.icon(
                onPressed: _showAppSelectionDialog,
                icon: const Icon(Iconsax.more, size: 16),
                label: _poppinsText("Apps", fontSize: 12),
              ),
            ),
          ),

          Expanded(
            flex: columnFlex[5],
            child: _dataItem(formatDate(org['createdAt'] ?? "")),
          ),
        ],
      ),
    );
  }

  Widget _dataItem(String value) => Center(child: _poppinsText(value));
}
