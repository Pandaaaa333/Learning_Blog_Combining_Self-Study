import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Đảm bảo bạn đã chạy: flutter pub add intl
import 'package:table_calendar/table_calendar.dart';
import '../viewmodels/todo_viewmodel.dart';
import 'todo_components.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);

  Widget _buildDayNumber(DateTime day, {required bool isSelected, required bool isToday, required bool isOutside}) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isSelected 
            ? const Color(0xFF53B8B7).withOpacity(0.05) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isOutside 
            ? null 
            : Border.all(
                color: isSelected ? const Color(0xFF53B8B7) : Colors.grey.shade200, 
                width: isSelected ? 1.5 : 1
              ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 4, top: 4),
          child: Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF53B8B7) 
                  : (isToday ? const Color(0xFF53B872).withOpacity(0.2) : Colors.transparent),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 12,
                color: isOutside 
                    ? Colors.grey[400] 
                    : isSelected 
                        ? Colors.white 
                        : (isToday ? const Color(0xFF53B872) : Colors.black87),
                fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF52B794);
    // Lắng nghe sự thay đổi từ TodoViewModel
    final viewModel = context.watch<TodoViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFECF7F3),
              Color(0xFFF8FAFC),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
              // 1. NÚT CHỨC NĂNG (TÌM KIẾM, THÊM MỚI)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF52B794).withOpacity(0.18), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF52B794).withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.format_list_bulleted_rounded, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.search, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              showSearch(context: context, delegate: TaskSearchDelegate(viewModel));
                            },
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.add, size: 22),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              showAddTaskBottomSheet(context, viewModel);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. LỊCH THÁNG (TableCalendar)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF52B794).withOpacity(0.12), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF52B794).withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TableCalendar<TaskModel>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: viewModel.focusedDate,
              rowHeight: 90,
              eventLoader: (day) => viewModel.getTasksForDay(day),
              selectedDayPredicate: (day) {
                return isSameDay(viewModel.selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(viewModel.selectedDate, selectedDay)) {
                  viewModel.changeDate(selectedDay);
                }
              },
              onPageChanged: (focusedDay) {
                viewModel.changeFocusedDate(focusedDay);
              },
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black54),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black54),
              ),
              calendarStyle: const CalendarStyle(
                cellMargin: EdgeInsets.all(2),
                // Xóa default marker
                markersMaxCount: 0, 
              ),
              calendarBuilders: CalendarBuilders<TaskModel>(
                defaultBuilder: (context, day, focusedDay) => _buildDayNumber(day, isSelected: false, isToday: false, isOutside: false),
                todayBuilder: (context, day, focusedDay) => _buildDayNumber(day, isSelected: false, isToday: true, isOutside: false),
                selectedBuilder: (context, day, focusedDay) => _buildDayNumber(day, isSelected: true, isToday: false, isOutside: false),
                outsideBuilder: (context, day, focusedDay) => _buildDayNumber(day, isSelected: false, isToday: false, isOutside: true),
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2.0, left: 4.0, right: 4.0), // Tăng lề ngoài để giảm chiều rộng
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: events.take(3).map((task) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 0.8), // Giảm khoảng cách giữa các task
                            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0), // Giảm padding trong
                            decoration: BoxDecoration(
                              color: task.isCompleted ? const Color(0xFF56B853).withOpacity(0.1) : const Color(0xFF5399B8).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2), // Bo góc nhỏ hơn xíu
                              border: Border.all(
                                color: task.isCompleted ? const Color(0xFF56B853).withOpacity(0.5) : const Color(0xFF5399B8).withOpacity(0.5),
                                width: 0.5,
                              )
                            ),
                            child: Text(
                              task.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 7.5, // Chữ nhỏ hơn 10% (từ 8.5 xuống 7.5)
                                fontWeight: FontWeight.w500,
                                color: task.isCompleted ? const Color(0xFF56B853) : const Color(0xFF5399B8),
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (viewModel.error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Lỗi: ${viewModel.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          const SizedBox(height: 16),

          // 3. TIÊU ĐỀ & BỘ LỌC TRẠNG THÁI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lịch trình hôm nay', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _FilterChip(
                      label: 'Tất cả', 
                      index: 0, 
                      selectedIndex: viewModel.selectedFilterIndex, 
                      onTap: () => viewModel.changeFilter(0)
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Chưa xong', 
                      index: 1, 
                      selectedIndex: viewModel.selectedFilterIndex, 
                      onTap: () => viewModel.changeFilter(1)
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Đã hoàn thành', 
                      index: 2, 
                      selectedIndex: viewModel.selectedFilterIndex, 
                      onTap: () => viewModel.changeFilter(2)
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. DANH SÁCH CÔNG VIỆC ĐÃ LỌC
          viewModel.isLoading 
            ? const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator(color: Color(0xFF52B794))))
            : viewModel.filteredTasks.isEmpty 
              ? const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Không có việc cần làm!')))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: viewModel.filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = viewModel.filteredTasks[index];
                    return TaskCardWidget(
                      task: task, 
                      onToggle: () => viewModel.toggleTaskStatus(task.id)
                    );
                  },
                ),
        ],
      ),
    ),
  ),
),
);
  }
}

// ==========================================
// WIDGET HỖ TRỢ: Nút lọc (Filter Chip)
// ==========================================
class _FilterChip extends StatelessWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label, 
    required this.index, 
    required this.selectedIndex, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF52B794) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF52B794) : Colors.grey[300]!),
        ),
        child: Text(
          label, 
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87, 
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, 
            fontSize: 13
          )
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET HỖ TRỢ: Thẻ công việc (Task Card)
// ==========================================
class TaskCardWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;

  const TaskCardWidget({Key? key, required this.task, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: task.isCompleted ? const Color(0xFFF1F5F9).withOpacity(0.6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted ? Colors.grey[300]! : const Color(0xFF52B794).withOpacity(0.18),
          width: 1.2,
        ),
        boxShadow: task.isCompleted 
            ? null 
            : [
                BoxShadow(
                  color: const Color(0xFF52B794).withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nút Checkbox động
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted ? const Color(0xFF56B853) : Colors.grey[400]!, 
                  width: 1.5
                ),
                color: task.isCompleted ? const Color(0xFF56B853) : Colors.white,
              ),
              child: task.isCompleted 
                ? const Icon(Icons.check, size: 16, color: Colors.white) 
                : null,
            ),
          ),
          const SizedBox(width: 16),
          // Thông tin tên và giờ giấc
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: task.isCompleted ? Colors.grey : Colors.black87,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null, 
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(task.startTime), 
                  style: const TextStyle(fontSize: 13, color: Colors.black54)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}