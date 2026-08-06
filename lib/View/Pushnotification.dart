import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../Controller/Organization_Controller.dart';
import '../Controller/PushNotification_controller.dart';
import '../Controller/User_controller.dart';
import '../Model/User_Model.dart';
import '../View_model/Authentication_state.dart';

class PushNotification extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const PushNotification({super.key, this.initialData});

  @override
  State<PushNotification> createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  late TextEditingController titleController;
  late TextEditingController bodyController;
  late TextEditingController eventController;
  late TextEditingController typeController;

  XFile? selectedImage;
  String? selectedOrganization;
  String? selectedIndividual;

  bool isSending = false;
  bool isLoading = true;
  bool isAdmin = false;
  String? myOrganizationId;

  bool isScheduled = false;
  DateTime? scheduledDateTime;

  List<Map<String, dynamic>> organizations = [];
  List<UserModel> users = [];

  final Color primaryTeal = Colors.teal;
  final Color darkTeal = const Color(0xFF00796B);
  final Color lightTealAccent = const Color(0xFFE0F2F1);

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialData?['title'] ?? 'New Update Available');
    bodyController = TextEditingController(text: widget.initialData?['body'] ?? 'Check out the latest features in the app!');
    eventController = TextEditingController(text: widget.initialData?['event'] ?? 'general_update');
    typeController = TextEditingController(text: widget.initialData?['type'] ?? 'info');

    if (widget.initialData?['scheduledAt'] != null) {
      isScheduled = true;
      try {
        DateTime utcTime = DateTime.parse(widget.initialData!['scheduledAt']);
        scheduledDateTime = utcTime.add(const Duration(hours: 5, minutes: 30));
      } catch (e) {
        debugPrint("Date Parse Error: $e");
      }
    }
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    await _loadUserRole();
    if (isAdmin) await _loadOrganizations();
    await _fetchUsers();
    setState(() => isLoading = false);
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = prefs.getString('userRole') == 'admin';
      myOrganizationId = prefs.getString('organizationId');
    });
  }

  Future<void> _fetchUsers() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    try {
      final fetchedUsers = await UsergetController.fetchUsers(authState: authState);
      setState(() => users = fetchedUsers);
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }
  }

  Future<void> _loadOrganizations() async {
    try {
      final orgs = await OrganizationController.fetchOrganizations();
      setState(() => organizations = orgs);
    } catch (e) {
      debugPrint("Error loading organizations: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => selectedImage = image);
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: scheduledDateTime ?? DateTime.now().add(const Duration(minutes: 10)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(scheduledDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          scheduledDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  String? _getSelectedOrgId() {
    if (!isAdmin || selectedOrganization == null) return null;
    final org = organizations.firstWhere((e) => e['name'] == selectedOrganization, orElse: () => {});
    return org['_id'] as String?;
  }

  String? _getSelectedUserId() {
    if (selectedIndividual == null || selectedIndividual == "All Users") return null;
    final user = users.firstWhere((e) => e.username == selectedIndividual, orElse: () => UserModel.empty());
    return user.userId.isNotEmpty ? user.userId : null;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Center(child: Lottie.network('https://res.cloudinary.com/dggylwwqk/raw/upload/v1756724306/New_Notification_Bell_krzyrx.json', height: 200)),
      );
    }

    List<String> orgNames = organizations.map((e) => e['name'] as String).where((n) => n.isNotEmpty).toSet().toList();
    List<String> userNames = ["All Users", ...users.map((u) => u.username).where((n) => n.isNotEmpty).toSet().toList()];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 1100;
        final bool isMobile = constraints.maxWidth < 600;

        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          appBar: widget.initialData != null ? AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text("Modify Campaign", style: GoogleFonts.poppins(color: const Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18)),
          ) : null,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFFF1F5F9), lightTealAccent.withOpacity(0.5)],
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.initialData == null) _buildHeader(isMobile).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                  const SizedBox(height: 24),
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildForm(orgNames, userNames, false).animate().fadeIn(delay: 200.ms).scale(curve: Curves.easeOut)),
                        const SizedBox(width: 32),
                        Expanded(flex: 2, child: _buildRightColumn(false).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1)),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildForm(orgNames, userNames, true),
                        const SizedBox(height: 32),
                        _buildRightColumn(true),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: lightTealAccent, borderRadius: BorderRadius.circular(20)),
          child: Text("Campaign Manager", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: darkTeal)),
        ),
        const SizedBox(height: 12),
        Text("Push Notifications", style: GoogleFonts.poppins(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.w800, color: const Color(0xFF1E293B))),
        Text("Design and schedule high-engagement alerts", style: GoogleFonts.poppins(fontSize: isMobile ? 14 : 16, color: Colors.blueGrey.shade400)),
      ],
    );
  }

  Widget _buildForm(List<String> orgNames, List<String> userNames, bool isMobileOrTablet) {
    return _glassCard(
      padding: isMobileOrTablet ? 20 : 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Iconsax.edit, "1. Content Details", "What will users see?"),
          const SizedBox(height: 24),
          _buildFieldRow("Title", titleController, "Message Body", bodyController, Iconsax.text, Iconsax.textalign_left, isMobileOrTablet),
          const SizedBox(height: 20),
          _buildFieldRow("Event Key", eventController, "Category", typeController, Iconsax.key, Iconsax.category, isMobileOrTablet),
          const SizedBox(height: 32),
          _sectionHeader(Iconsax.user_tag, "2. Target Audience", "Who receives this?"),
          const SizedBox(height: 24),
          if (isMobileOrTablet) ...[
            if (isAdmin) _modernDropdown("Organization", selectedOrganization, orgNames, (v) => setState(() => selectedOrganization = v), Iconsax.hierarchy),
            if (isAdmin) const SizedBox(height: 16),
            _modernDropdown("Individual User", selectedIndividual, userNames, (v) => setState(() => selectedIndividual = v), Iconsax.user),
          ] else
            Row(
              children: [
                if (isAdmin) Expanded(child: _modernDropdown("Organization", selectedOrganization, orgNames, (v) => setState(() => selectedOrganization = v), Iconsax.hierarchy)),
                if (isAdmin) const SizedBox(width: 16),
                Expanded(child: _modernDropdown("Individual User", selectedIndividual, userNames, (v) => setState(() => selectedIndividual = v), Iconsax.user)),
              ],
            ),
          const SizedBox(height: 32),
          _sectionHeader(Iconsax.timer_1, "3. Delivery Schedule", "When should it go live?"),
          const SizedBox(height: 20),
          _buildSchedulingSection(isMobileOrTablet),
          const SizedBox(height: 40),
          _buildSendButton(),
          const SizedBox(height: 12),
          _sendToMyOrgButton(),
        ],
      ),
    );
  }

  Widget _buildSchedulingSection(bool isMobile) {
    return AnimatedContainer(
      duration: 300.ms,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isScheduled ? primaryTeal.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isScheduled ? primaryTeal.withOpacity(0.3) : Colors.grey.shade200, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: isScheduled ? primaryTeal : Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                    child: Icon(Iconsax.clock, size: 20, color: isScheduled ? Colors.white : Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Text("Schedule for later", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                ],
              ),
              Switch.adaptive(
                activeColor: primaryTeal,
                value: isScheduled,
                onChanged: (val) => setState(() => isScheduled = val),
              ),
            ],
          ),
          if (isScheduled)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: InkWell(
                onTap: _selectDateTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: lightTealAccent)),
                  child: Row(
                    children: [
                      Icon(Iconsax.calendar_1, color: primaryTeal, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          scheduledDateTime == null ? "Set Date & Time" : DateFormat('EEE, MMM d • hh:mm a').format(scheduledDateTime!),
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: darkTeal, fontSize: 13),
                        ),
                      ),
                      const Icon(Iconsax.arrow_right_3, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 0.2),
            ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(bool isMobile) {
    return Column(
      children: [
        _glassCard(
          padding: isMobile ? 20 : 32,
          child: Column(
            children: [
              _sectionHeader(Iconsax.image, "Media Assets", "Notification banner"),
              const SizedBox(height: 20),
              _buildImageBox(isMobile),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildLivePreview(isMobile),
      ],
    );
  }

  Widget _buildLivePreview(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white24, width: 4),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40, offset: const Offset(0, 20))],
      ),
      child: Column(
        children: [
          Container(width: 60, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 20),
          Text("LIVE PREVIEW", style: GoogleFonts.poppins(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: primaryTeal, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Iconsax.notification_bing, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titleController.text.isEmpty ? "Notification Title" : titleController.text, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF1E293B))),
                      const SizedBox(height: 4),
                      Text(bodyController.text.isEmpty ? "The notification content will appear here..." : bodyController.text, style: GoogleFonts.poppins(fontSize: 13, color: Colors.blueGrey.shade700, height: 1.4)),
                      if (selectedImage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: kIsWeb
                                ? Image.network(selectedImage!.path, height: 120, width: double.infinity, fit: BoxFit.cover)
                                : Image.file(File(selectedImage!.path), height: 120, width: double.infinity, fit: BoxFit.cover),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImageBox(bool isMobile) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: isMobile ? 180 : 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: lightTealAccent),
        ),
        child: selectedImage != null
            ? Stack(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(24), child: kIsWeb ? Image.network(selectedImage!.path, width: double.infinity, fit: BoxFit.cover) : Image.file(File(selectedImage!.path), width: double.infinity, fit: BoxFit.cover)),
            Positioned(right: 10, top: 10, child: CircleAvatar(backgroundColor: Colors.white, radius: 18, child: IconButton(icon: const Icon(Iconsax.trash, color: Colors.red, size: 18), onPressed: () => setState(() => selectedImage = null)))),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.image, size: 40, color: primaryTeal),
            const SizedBox(height: 12),
            Text("Upload Image", style: GoogleFonts.poppins(color: darkTeal, fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    bool isValid = titleController.text.isNotEmpty && bodyController.text.isNotEmpty;
    String btnText = isScheduled ? (widget.initialData != null ? "Update Schedule" : "Confirm Schedule") : "Blast Notification";

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isValid ? LinearGradient(colors: [darkTeal, primaryTeal]) : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: isSending || !isValid ? null : _handleSend,
        child: isSending
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isScheduled ? Iconsax.calendar_tick : Iconsax.send_1, size: 22),
            const SizedBox(width: 12),
            Text(btnText, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _sendToMyOrgButton() {
    if (isAdmin && myOrganizationId == null) return const SizedBox();
    if (widget.initialData != null) return const SizedBox();

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryTeal.withOpacity(0.3), width: 1.5),
        color: primaryTeal.withOpacity(0.05),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: isSending ? null : _sendToMyOrgUsers,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.people, size: 18, color: darkTeal),
            const SizedBox(width: 12),
            Text("Send to My Organization Only", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: darkTeal)),
          ],
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child, required double padding}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.05), blurRadius: 40, offset: const Offset(0, 20))],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(IconData icon, String title, String sub) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: primaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 22, color: primaryTeal)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18, color: const Color(0xFF1E293B))),
              Text(sub, style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey.shade400)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFieldRow(String l1, TextEditingController c1, String l2, TextEditingController c2, IconData i1, IconData i2, bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _modernInput(l1, c1, i1),
          const SizedBox(height: 20),
          _modernInput(l2, c2, i2),
        ],
      );
    }
    return Row(children: [Expanded(child: _modernInput(l1, c1, i1)), const SizedBox(width: 20), Expanded(child: _modernInput(l2, c2, i2))]);
  }

  Widget _modernInput(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF475569)))),
        TextFormField(
          controller: controller,
          onChanged: (v) => setState(() {}),
          cursorColor: primaryTeal,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryTeal, width: 1.5)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.transparent)),
          ),
        ),
      ],
    );
  }

  Widget _modernDropdown(String label, String? value, List<String> items, Function(String?) onChanged, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF475569)))),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : null,
          isExpanded: true,
          iconEnabledColor: primaryTeal,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryTeal, width: 1.5)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.transparent)),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _handleSend() async {
    if (isScheduled && scheduledDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a schedule time")));
      return;
    }
    setState(() => isSending = true);
    try {
      String? utcTime = isScheduled ? scheduledDateTime?.toUtc().toIso8601String() : null;
      if (widget.initialData != null) {
        await PushNotificationController.updateNotification(
          id: widget.initialData!['_id'],
          title: titleController.text,
          body: bodyController.text,
          event: eventController.text,
          type: typeController.text,
          scheduledAt: utcTime,
        );
      } else {
        await PushNotificationController.sendNotification(
          title: titleController.text,
          body: bodyController.text,
          event: eventController.text,
          type: typeController.text,
          userId: _getSelectedUserId(),
          organizationId: _getSelectedOrgId(),
          scheduledAt: utcTime,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification processed successfully!'), backgroundColor: Colors.green));
      if (widget.initialData != null) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red));
    }
    setState(() => isSending = false);
  }

  Future<void> _sendToMyOrgUsers() async {
    if (myOrganizationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Organization context not found.")));
      return;
    }
    setState(() => isSending = true);
    try {
      String? utcTime = isScheduled ? scheduledDateTime?.toUtc().toIso8601String() : null;
      await PushNotificationController.sendNotification(
        title: titleController.text,
        body: bodyController.text,
        event: eventController.text,
        type: typeController.text,
        organizationId: myOrganizationId,
        scheduledAt: utcTime,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Notification handled successfully!"), backgroundColor: Colors.green));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    }
    setState(() => isSending = false);
  }
}