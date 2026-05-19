import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodels/todo_viewmodel.dart';

// =========================================
// 1. CHỨC NĂNG TÌM KIẾM TOÀN CỤC (SearchDelegate)
// =========================================
class TaskSearchDelegate extends SearchDelegate {
  final TodoViewModel viewModel;
  TaskSearchDelegate(this.viewModel);

  @override
  String get searchFieldLabel => 'Tìm kiếm công việc...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '', // Xóa text
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null), // Đóng tìm kiếm
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    // Lọc tất cả task có chứa từ khóa (không phân biệt hoa thường)
    final results = viewModel.allTasks.where(
      (task) => task.title.toLowerCase().contains(query.toLowerCase())
    ).toList();

    if (results.isEmpty) {
      return const Center(child: Text('Không tìm thấy công việc nào.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        final dateStr = DateFormat('dd/MM/yyyy').format(task.startTime);
        final timeStr = DateFormat('HH:mm').format(task.startTime);
        
        return ListTile(
          title: Text(task.title, style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
          subtitle: Text('$timeStr - $dateStr'),
          leading: Icon(task.isCompleted ? Icons.check_circle : Icons.circle_outlined, color: task.isCompleted ? const Color(0xFF52B794) : Colors.grey),
        );
      },
    );
  }
}

// =========================================
// 2. FORM THÊM CÔNG VIỆC (Style Apple Calendar)
// =========================================
void showAddTaskBottomSheet(BuildContext context, TodoViewModel viewModel) {
  final titleController = TextEditingController();
  
  // Khởi tạo các biến trạng thái
  bool isAllDay = false;
  DateTime startDate = viewModel.selectedDate;
  TimeOfDay startTime = TimeOfDay.now();
  
  // Mặc định kết thúc sau 1 tiếng
  DateTime endDate = startDate;
  TimeOfDay endTime = TimeOfDay(hour: (startTime.hour + 1) % 24, minute: startTime.minute);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    backgroundColor: const Color(0xFFF2F2F6), // Màu nền xám nhạt kiểu iOS
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.85, // Chiếm 85% màn hình
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  // --- HEADER ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nút Hủy
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                            child: const Icon(Icons.close, size: 20, color: Colors.black87),
                          ),
                        ),
                        const Text('Mới', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        // Nút Lưu
                        GestureDetector(
                          onTap: () {
                            if (titleController.text.trim().isNotEmpty) {
                              final finalStart = DateTime(startDate.year, startDate.month, startDate.day, startTime.hour, startTime.minute);
                              final finalEnd = DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute);
                              
                              viewModel.addTask(titleController.text.trim(), finalStart, finalEnd);
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Color(0xFF52B794), shape: BoxShape.circle),
                            child: const Icon(Icons.check, size: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // --- CARD 1: TIÊU ĐỀ ---
                        Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: TextField(
                            controller: titleController,
                            autofocus: true,
                            style: const TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              hintText: 'Tiêu đề',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- CARD 2: THỜI GIAN ---
                        Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              // Cả ngày (All-day)
                              ListTile(
                                title: const Text('Cả ngày', style: TextStyle(fontSize: 16)),
                                trailing: Switch(
                                  value: isAllDay,
                                  activeColor: const Color(0xFF52B794),
                                  onChanged: (value) => setModalState(() => isAllDay = value),
                                ),
                              ),
                              const Divider(height: 1, indent: 16),

                              // Bắt đầu
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    const Text('Bắt đầu', style: TextStyle(fontSize: 16)),
                                    const Spacer(),
                                    if (!isAllDay) ...[
                                      _TimeButton(
                                        time: startTime,
                                        onTap: () async {
                                          final picked = await showTimePicker(context: context, initialTime: startTime);
                                          if (picked != null) setModalState(() => startTime = picked);
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    _DateButton(
                                      date: startDate,
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context, initialDate: startDate,
                                          firstDate: DateTime(2020), lastDate: DateTime(2030),
                                        );
                                        if (picked != null) setModalState(() => startDate = picked);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, indent: 16),

                              // Kết thúc
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    const Text('Kết thúc', style: TextStyle(fontSize: 16)),
                                    const Spacer(),
                                    if (!isAllDay) ...[
                                      _TimeButton(
                                        time: endTime,
                                        onTap: () async {
                                          final picked = await showTimePicker(context: context, initialTime: endTime);
                                          if (picked != null) setModalState(() => endTime = picked);
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    _DateButton(
                                      date: endDate,
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context, initialDate: endDate,
                                          firstDate: DateTime(2020), lastDate: DateTime(2030),
                                        );
                                        if (picked != null) setModalState(() => endDate = picked);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      );
    },
  );
}

// Widget Nút bấm chọn Giờ (xám nhạt)
class _TimeButton extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onTap;
  const _TimeButton({required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
        child: Text(time.format(context), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// Widget Nút bấm chọn Ngày (xám nhạt)
class _DateButton extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  const _DateButton({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
        child: Text(DateFormat('dd thg MM, yyyy').format(date), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
