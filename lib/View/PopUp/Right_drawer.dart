import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/PushNotification_controller.dart';
import '../../Controller/right_drawer_controller.dart';
import '../../Controller/Get_all_item_controller.dart';
import '../../Model/list_model.dart';
import '../../Model/Item_Model.dart';
import '../../View_model/Listitem_details.dart';

enum DrawerSelection { list, link, event }

// New Enums for Recurrence
enum RecurrenceType { none, daily, weekly, monthly, yearly }

extension StringCasing on String {
  String capitalize() => length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : this;
}

extension DrawerSelectionExtension on DrawerSelection {
  bool get isList => this == DrawerSelection.list;
  bool get isLink => this == DrawerSelection.link;
  bool get isEvent => this == DrawerSelection.event;
}

class CustomRightDrawer extends StatefulWidget {
  final void Function(ItemModel newItem)? onAddItemToHome;
  final String? parentId;
  final ItemModel? rootItem;
  final bool isInSublist;

  const CustomRightDrawer({
    super.key,
    this.onAddItemToHome,
    this.parentId,
    this.rootItem,
    required this.isInSublist,
  });

  @override
  State<CustomRightDrawer> createState() => _CustomRightDrawerState();
}

class _CustomRightDrawerState extends State<CustomRightDrawer> with SingleTickerProviderStateMixin {
  DrawerSelection selected = DrawerSelection.list;
  List<ListModel> recentLists = [];
  bool showCreateForm = false;
  String newTitle = '';
  String newSubtitle = '';
  String newUrl = '';
  Uint8List? pickedImage;
  bool isLoading = false;
  bool isSaving = false;
  String searchQuery = '';
  bool animateButton = false;

  // ===== EVENT VARIABLES =====
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isAllDay = false;
  String selectedCalendar = 'Church Calendar';

  // ===== RECURRENCE VARIABLES =====
  RecurrenceType recurrence = RecurrenceType.none;
  List<int> selectedDaysOfWeek = []; // 1 = Mon, 7 = Sun
  List<int> selectedMonths = []; // 1 = Jan, 12 = Dec
  DateTime? recurrenceUntil;

  DateTime? get startDateTime {
    if (startDate == null) return null;
    return DateTime(startDate!.year, startDate!.month, startDate!.day, startTime?.hour ?? 0, startTime?.minute ?? 0);
  }

  DateTime? get endDateTime {
    if (endDate == null) return null;
    return DateTime(endDate!.year, endDate!.month, endDate!.day, endTime?.hour ?? 0, endTime?.minute ?? 0);
  }

  @override
  void initState() {
    super.initState();
    _loadLists();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => animateButton = true);
    });
  }

  Future<void> _loadLists() async {
    setState(() => isLoading = true);
    try {
      if (widget.isInSublist) {
        final lists = await ListController.fetchLists(parentId: widget.parentId);
        setState(() => recentLists = lists.where((l) => l.type == selected.name).toList());
      } else {
        final items = await ItemService.fetchItems(parentId: null);
        setState(() {
          recentLists = items
              .where((i) => i.type == selected.name)
              .map((i) => ListModel(
            id: i.id,
            title: i.title,
            subtitle: i.subtitle,
            image: i.image ?? '',
            parentId: i.parentId,
            index: i.index ?? 0,
            type: i.type,
          ))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Failed to load items: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // RRULE Generator for the Backend
  String? _generateRRule() {
    if (recurrence == RecurrenceType.none) return null;
    String rule = "FREQ=${recurrence.name.toUpperCase()}";
    if (recurrence == RecurrenceType.weekly && selectedDaysOfWeek.isNotEmpty) {
      final days = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
      rule += ";BYDAY=${selectedDaysOfWeek.map((i) => days[i - 1]).join(',')}";
    }
    if (selectedMonths.isNotEmpty) {
      rule += ";BYMONTH=${selectedMonths.join(',')}";
    }
    if (recurrenceUntil != null) {
      rule += ";UNTIL=${recurrenceUntil!.toIso8601String().split('T')[0].replaceAll('-', '')}T235959Z";
    }
    return rule;
  }

  Future<void> _handleCreateNewList() async {
    if (newTitle.trim().isEmpty) {
      _snack("Title required", false);
      return;
    }
    setState(() => isSaving = true);
    try {
      ItemModel newItem;
      String? rRule = selected.isEvent ? _generateRRule() : null;

      if (widget.isInSublist) {
        final newList = await ListController.createList(
          newTitle.trim(), newSubtitle.trim(),
          imageBytes: pickedImage, parentId: widget.parentId,
          type: selected.name, url: selected.isLink ? newUrl.trim() : null,
        );
        newItem = ItemModel(id: newList.id, title: newList.title, subtitle: newList.subtitle, image: newList.image, type: newList.type ?? selected.name, parentId: newList.parentId, index: newList.index);
      } else {
        newItem = await ItemService.createItem(
          title: newTitle.trim(), subtitle: newSubtitle.trim(),
          imageBytes: pickedImage, type: selected.name,
          url: selected.isLink ? newUrl.trim() : null,
          startDateTime: selected.isEvent ? startDateTime?.toIso8601String() : null,
          endDateTime: selected.isEvent ? endDateTime?.toIso8601String() : null,
          isAllDay: selected.isEvent ? isAllDay : null,
          calendar: selected.isEvent ? selectedCalendar : null,
          recurrenceRule: rRule, // Add this to your API controller
        );
      }

      final prefs = await SharedPreferences.getInstance();
      final orgId = prefs.getString("organizationId");
      if (orgId != null) {
        await PushNotificationController.sendNotification(
          title: "New ${selected.name.capitalize()} Added",
          body: "$newTitle created",
          event: "create_${selected.name}",
          type: selected.name,
          organizationId: orgId,
        );
      }

      widget.onAddItemToHome?.call(newItem);
      _resetState();
      await _loadLists();
      _snack("Created Successfully", true);
    } catch (e) {
      _snack("Error: $e", false);
    }
    setState(() => isSaving = false);
  }

  void _resetState() {
    setState(() {
      showCreateForm = false;
      newTitle = ''; newSubtitle = ''; newUrl = ''; pickedImage = null;
      startDate = null; endDate = null; startTime = null; endTime = null;
      isAllDay = false; recurrence = RecurrenceType.none;
      selectedDaysOfWeek = []; selectedMonths = []; recurrenceUntil = null;
    });
  }

  void _snack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: success ? Colors.green : Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final filteredLists = recentLists.where((list) => list.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    return SizedBox(
      width: 420,
      child: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: showCreateForm ? _buildCreateForm() : _buildMainDrawer(filteredLists),
        ),
      ),
    );
  }

  // ================= MAIN DRAWER =================
  Widget _buildMainDrawer(List<ListModel> filteredLists) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Type", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DrawerSelection.values.map((option) {
              bool isSelected = selected == option;
              return GestureDetector(
                onTap: () { setState(() { selected = option; _loadLists(); }); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.purpleAccent.shade100.withOpacity(0.2) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? Colors.purpleAccent.shade200 : Colors.transparent),
                  ),
                  child: Text(option.name.capitalize(), style: GoogleFonts.poppins(color: isSelected ? Colors.purple.shade700 : Colors.grey.shade600, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _input("Search items...", (val) => setState(() => searchQuery = val), icon: Iconsax.search_normal),
          const SizedBox(height: 20),
          _buildAnimatedCreateButton(),
          const SizedBox(height: 24),
          Row(children: [Text("Existing Records", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)), const Spacer(), Container(height: 1, width: 40, color: Colors.grey.shade300)]),
          const SizedBox(height: 12),
          if (isLoading) Center(child: Lottie.asset('assets/Loading star.json', height: 100)) else _buildRecordList(filteredLists),
        ],
      ),
    );
  }

  Widget _buildAnimatedCreateButton() {
    return AnimatedScale(
      duration: const Duration(milliseconds: 600),
      scale: animateButton ? 1.0 : 0.9,
      curve: Curves.easeOutBack,
      child: InkWell(
        onTap: () => setState(() => showCreateForm = true),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purpleAccent.shade100, Colors.deepPurpleAccent.shade100]),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.purpleAccent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Iconsax.add_square, color: Colors.white, size: 20), const SizedBox(width: 10), Text("Create ${selected.name.capitalize()}", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold))]),
        ),
      ),
    );
  }

  Widget _buildRecordList(List<ListModel> lists) {
    if (lists.isEmpty) return _buildEmptyState();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lists.length,
      itemBuilder: (context, index) {
        final list = lists[index];
        return FallingListItem(
          delay: Duration(milliseconds: 80 * index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
            child: ListTile(
              leading: _buildListImage(list.image),
              title: Text(list.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
              subtitle: Text(list.subtitle ?? '', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
              trailing: const Icon(Iconsax.arrow_right_3, size: 16, color: Colors.grey),
              onTap: () => _handleNavigation(list),
            ),
          ),
        );
      },
    );
  }

  // ================= RECURRENCE UI =================
  Widget _buildRecurrenceSection() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Iconsax.refresh, "Repeat Configuration"),
          const SizedBox(height: 20),

          // --- FREQUENCY SEGMENTED SELECTOR ---
          Text("Frequency", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: RecurrenceType.values.map((type) {
                bool isSelected = recurrence == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => recurrence = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          type == RecurrenceType.none ? "Off" : type.name.capitalize(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? Colors.blueAccent : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // --- WEEKLY DAY PICKER ---
          if (recurrence == RecurrenceType.weekly) ...[
            const SizedBox(height: 24),
            _buildDaySelector(),
          ],

          // --- MONTH SELECTOR (Modern Grid) ---
          const SizedBox(height: 24),
          Row(
            children: [
              Text("Active Months", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
              const Spacer(),
              if(selectedMonths.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => selectedMonths.clear()),
                  child: Text("Reset", style: TextStyle(fontSize: 11, color: Colors.red.shade300)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMonthGrid(),

          // --- ENDS ON PICKER ---
          const SizedBox(height: 24),
          _modernPicker(
              "Recurrence Ends",
              recurrenceUntil == null ? "Repeat Forever" : "${recurrenceUntil!.day}/${recurrenceUntil!.month}/${recurrenceUntil!.year}",
              Iconsax.calendar_edit,
                  () async {
                final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100)
                );
                if (d != null) setState(() => recurrenceUntil = d);
              }
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Repeat on", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final dayNum = index + 1;
            final isSelected = selectedDaysOfWeek.contains(dayNum);
            return GestureDetector(
              onTap: () => setState(() => isSelected ? selectedDaysOfWeek.remove(dayNum) : selectedDaysOfWeek.add(dayNum)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? Colors.blueAccent : Colors.grey.shade200),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))] : [],
                ),
                child: Center(
                  child: Text(
                    days[index],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMonthGrid() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final monthNum = index + 1;
        final isSelected = selectedMonths.contains(monthNum);
        return GestureDetector(
          onTap: () => setState(() => isSelected ? selectedMonths.remove(monthNum) : selectedMonths.add(monthNum)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? Colors.blueAccent : Colors.transparent),
            ),
            child: Center(
              child: Text(
                months[index],
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.blueAccent : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _eventFormUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _glassCard(
            child: Column(
              children: [
                _sectionHeader(Iconsax.info_circle, "Basic Details"),
                const SizedBox(height: 16),
                _input("Event Title", (v) => setState(() => newTitle = v), icon: Iconsax.document_text),
                _input("Subtitle", (v) => setState(() => newSubtitle = v), icon: Iconsax.text),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _glassCard(
            child: Column(
              children: [
                _sectionHeader(Iconsax.calendar, "Date & Time"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _modernPicker("Starts", startDate == null ? "Set Date" : "${startDate!.day}/${startDate!.month}/${startDate!.year}", Iconsax.calendar, () => _pickDate(true))),
                    const SizedBox(width: 12),
                    Expanded(child: _modernPicker("At", startTime?.format(context) ?? "Set Time", Iconsax.clock, () => _pickTime(true))),
                  ],
                ),
                const Divider(height: 32, color: Colors.black12),
                Row(
                  children: [
                    Expanded(child: _modernPicker("Ends", endDate == null ? "Set Date" : "${endDate!.day}/${endDate!.month}/${endDate!.year}", Iconsax.calendar, () => _pickDate(false))),
                    const SizedBox(width: 12),
                    Expanded(child: _modernPicker("At", endTime?.format(context) ?? "Set Time", Iconsax.clock, () => _pickTime(false))),
                  ],
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text("All Day", style: GoogleFonts.poppins(fontSize: 14)),
                  value: isAllDay,
                  onChanged: (v) => setState(() => isAllDay = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildRecurrenceSection(),
          const SizedBox(height: 16),
          _glassCard(child: Column(children: [_sectionHeader(Iconsax.folder_2, "Calendar"), const SizedBox(height: 12), _modernCalendarPicker(value: selectedCalendar, items: ['Church Calendar', 'Personal', 'Work'], onChanged: (v) => setState(() => selectedCalendar = v!))])),
          const SizedBox(height: 32),
          _actionButtons(),
        ],
      ),
    );
  }

  // ================= HELPERS =================
  Widget _buildCreateForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Row(children: [
            Container(decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), shape: BoxShape.circle), child: IconButton(icon: const Icon(Iconsax.arrow_left_2, color: Colors.blueAccent, size: 20), onPressed: _resetState)),
            const SizedBox(width: 16),
            Text("New ${selected.name.capitalize()}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900)),
          ]),
        ),
        const Divider(height: 1, thickness: 1, color: Colors.black12),
        Expanded(child: selected.isEvent ? _eventFormUI() : _defaultFormUI()),
      ],
    );
  }

  Widget _defaultFormUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          _glassCard(child: Column(children: [_sectionHeader(Iconsax.document_text, "Content Info"), const SizedBox(height: 16), _input("Title", (v) => setState(() => newTitle = v), icon: Iconsax.edit), _input("Subtitle", (v) => setState(() => newSubtitle = v), icon: Iconsax.note), if (selected.isLink) _input("URL", (v) => setState(() => newUrl = v), icon: Iconsax.link)])),
          const SizedBox(height: 16),
          _glassCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionHeader(Iconsax.image, "Cover Image"),
              const SizedBox(height: 12),
              GestureDetector(
                // onTap: _pickImage,
                child: Container(
                  width: double.infinity, height: 180,
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blueAccent.withOpacity(0.2))),
                  child: pickedImage == null ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Iconsax.cloud_add, size: 40, color: Colors.blueAccent), Text("Upload Image", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.blueAccent))]) : ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.memory(pickedImage!, fit: BoxFit.cover)),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 32),
          _actionButtons(),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))]), child: child);
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(children: [Icon(icon, size: 20, color: Colors.blueAccent), const SizedBox(width: 8), Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.blueGrey.shade700))]);
  }

  Widget _input(String hint, Function(String) onChanged, {IconData? icon}) {
    return Container(margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)), child: TextField(onChanged: onChanged, decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, size: 20, color: Colors.grey), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12))));
  }

  Widget _modernPicker(String label, String value, IconData icon, VoidCallback onTap) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)), const SizedBox(height: 4), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blueAccent.withOpacity(0.1))), child: Row(children: [Icon(icon, size: 16, color: Colors.blueAccent), const SizedBox(width: 8), Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)))]))]));
  }

  Widget _modernCalendarPicker({required String value, required List<String> items, required Function(String?) onChanged}) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(isExpanded: true, value: value, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 14)))).toList(), onChanged: onChanged)));
  }

  Widget _actionButtons() {
    return Column(children: [
      SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0), onPressed: isSaving || newTitle.trim().isEmpty ? null : _handleCreateNewList, child: isSaving ? const CircularProgressIndicator(color: Colors.white) : Text("Create ${selected.name.capitalize()}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
      TextButton(onPressed: _resetState, child: Text("Discard", style: TextStyle(color: Colors.red.shade400))),
    ]);
  }

  Widget _buildListImage(String imageUrl) {
    return Container(width: 45, height: 45, decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)), child: imageUrl.isNotEmpty ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Iconsax.image))) : const Icon(Iconsax.image, color: Colors.grey));
  }

  Widget _buildEmptyState() {
    return Center(child: Column(children: [const SizedBox(height: 40), Icon(Iconsax.ghost, size: 40, color: Colors.grey.shade300), const SizedBox(height: 8), Text("No results found", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13))]));
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2024), lastDate: DateTime(2100));
    if (picked != null) setState(() => isStart ? startDate = picked : endDate = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => isStart ? startTime = picked : endTime = picked);
  }

  void _handleNavigation(ListModel list) {
    if ((list.type ?? 'list') == 'list') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ListItemDetailsPage(
        parentItem: ItemModel(id: list.id, title: list.title, subtitle: list.subtitle, image: list.image, type: 'list', parentId: list.parentId, index: list.index),
        rootItem: widget.rootItem ?? ItemModel(id: list.id, title: list.title, subtitle: list.subtitle, image: list.image, type: 'list', parentId: list.parentId, index: list.index),
      )));
    }
  }
}

class FallingListItem extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const FallingListItem({super.key, required this.child, required this.delay});
  @override
  State<FallingListItem> createState() => _FallingListItemState();
}

class _FallingListItemState extends State<FallingListItem> with SingleTickerProviderStateMixin {
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () { if (mounted) setState(() => _visible = true); });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(offset: _visible ? Offset.zero : const Offset(0, -0.3), duration: const Duration(milliseconds: 500), curve: Curves.easeOutBack, child: AnimatedOpacity(opacity: _visible ? 1.0 : 0.0, duration: const Duration(milliseconds: 500), child: widget.child));
  }
}