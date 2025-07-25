import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../Controller/App_controller.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  final AppService _appService = AppService();
  List<dynamic> _apps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load apps")),
      );
    }
  }

  Future<void> _deleteApp(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this app?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _appService.deleteApp(id);
      if (success) {
        _fetchApps();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('App deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete app')),
        );
      }
    }
  }

  String _getOrgNames(dynamic app) {
    final orgs = app['organizations'];
    if (orgs is List && orgs.isNotEmpty) {
      return orgs.map((org) => org['name'] ?? 'Unnamed').join(', ');
    }
    return 'Unassigned';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Implement Add App logic
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Iconsax.add, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "Add New",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text("Name",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white)),
                ),
                Expanded(
                  flex: 3,
                  child: Text("Organizations",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white)),
                ),
                Expanded(
                  flex: 2,
                  child: Text("Created At",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white)),
                ),
                Expanded(
                  flex: 2,
                  child: Text("Actions",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _apps.length,
              itemBuilder: (context, index) {
                final app = _apps[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              app['appName'] ?? 'Unnamed',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              _getOrgNames(app),
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              app['createdAt']?.substring(0, 10) ?? '',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // TODO: Implement edit logic
                                  },
                                  child: Container(
                                    margin:
                                    const EdgeInsets.only(right: 10),
                                    height: MediaQuery.of(context)
                                        .size
                                        .height *
                                        .04,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        .06,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      color: Colors.orangeAccent,
                                    ),
                                    child: const Icon(Iconsax.edit,
                                        size: 20, color: Colors.white),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _deleteApp(app['_id']),
                                  child: Container(
                                    height: MediaQuery.of(context)
                                        .size
                                        .height *
                                        .04,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        .06,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      color: Colors.redAccent,
                                    ),
                                    child: const Icon(Iconsax.trash,
                                        size: 20, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.2,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
