import 'package:flutter/material.dart';

// ==========================================
// MÀN HÌNH TO-DO (QUẢN LÝ LỊCH TRÌNH)
// ==========================================
class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  int _selectedDateIndex = 0; // Mặc định chọn ngày đầu tiên (13)
  int _selectedFilterIndex = 0; // 0: Tất cả, 1: Chưa xong, 2: Đã hoàn thành

  // Mock dữ liệu các ngày trong tuần
  final List<Map<String, String>> _weekDays = [
    {'day': 'T2', 'date': '13'},
    {'day': 'T3', 'date': '14'},
    {'day': 'T4', 'date': '15'},
    {'day': 'T5', 'date': '16'},
    {'day': 'T6', 'date': '17'},
    {'day': 'T7', 'date': '18'},
    {'day': 'CN', 'date': '19'},
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF52B794);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        // Nút Avatar
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Avata',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Nút Chuông thông báo
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: Color(0xFFEEEEEE)), // Dòng kẻ mờ dưới AppBar
          
          // 1. HEADER: Chọn tháng và các công cụ
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút chọn tháng
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Tháng 4',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ),
                // Cụm icon công cụ (List, Search, Add)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20),
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
                        onPressed: () {},
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.add, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. LỊCH NGANG (Calendar Strip)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_weekDays.length, (index) {
                bool isSelected = _selectedDateIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDateIndex = index;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        _weekDays[index]['day']!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? primaryBlue : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _weekDays[index]['date']!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? primaryBlue : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Chấm xanh mờ nếu được chọn (tạo hiệu ứng highlight)
                      if (isSelected)
                        Container(
                          width: 30,
                          height: 4,
                          decoration: BoxDecoration(
                            color: primaryBlue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )
                      else
                        const SizedBox(height: 4),
                    ],
                  ),
                );
              }),
            ),
          ),
          
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),

          // 3. TIÊU ĐỀ & BỘ LỌC
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lịch trình hôm nay',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildFilterChip('Tất cả', 0, primaryBlue),
                    const SizedBox(width: 8),
                    _buildFilterChip('Chưa xong', 1, primaryBlue),
                    const SizedBox(width: 8),
                    _buildFilterChip('Đã hoàn thành', 2, primaryBlue),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // 4. DANH SÁCH CÔNG VIỆC (TASK LIST)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 1, // Tạm thời để 1 item theo thiết kế
              itemBuilder: (context, index) {
                return const TaskCardWidget();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Hàm tạo Widget Filter Chip
  Widget _buildFilterChip(String label, int index, Color primaryColor) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET: THẺ CÔNG VIỆC (TASK CARD)
// ==========================================
class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Màu xám nhạt nền card
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nút Checkbox tròn
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[400]!, width: 1.5),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          // Thông tin công việc
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Nộp sơ đồ Usecase',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '8:00',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
