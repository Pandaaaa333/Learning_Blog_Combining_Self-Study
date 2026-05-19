import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Đảm bảo fe_mobile đúng với tên project của bạn nhé
import 'package:fe_mobile/features/focus/presentation/viewmodels/focus_viewmodel.dart';
import 'package:fe_mobile/features/task_management/presentation/viewmodels/todo_viewmodel.dart';
import 'package:fe_mobile/features/profile/presentation/viewmodels/profile_viewmodel.dart'; 
import 'package:fe_mobile/features/community/presentation/viewmodels/feed_viewmodel.dart'; 

class FocusScreen extends StatelessWidget {
  const FocusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 58,
          titleSpacing: 0,
          title: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[700],
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF52B794), Color(0xFF3EA380)],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF52B794).withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: const [Tab(text: 'Hẹn giờ'), Tab(text: 'Bấm giờ')],
            ),
          ),
        ),
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
          child: const TabBarView(
            children: [_CountdownTab(), _StopwatchTab()],
          ),
        ),
      ),
    );
  }
}

// Hàm hỗ trợ format thời gian thành 00 : 00 : 00
String _formatDuration(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String h = twoDigits(d.inHours);
  String m = twoDigits(d.inMinutes.remainder(60));
  String s = twoDigits(d.inSeconds.remainder(60));
  return "$h : $m : $s";
}

// ==========================================
// 1. TAB HẸN GIỜ (COUNTDOWN)
// ==========================================
class _CountdownTab extends StatefulWidget {
  const _CountdownTab({Key? key}) : super(key: key);

  @override
  State<_CountdownTab> createState() => _CountdownTabState();
}

class _CountdownTabState extends State<_CountdownTab> {
  @override
  Widget build(BuildContext context) {
    final focusVM = context.watch<FocusViewModel>();
    final todoVM = context.read<TodoViewModel>();
    final profileVM = context.read<ProfileViewModel>();

    // Tính toán tiến trình đếm ngược để trồng cây lớn lên (từ 0.0 hạt mầm đến 1.0 cây ra hoa)
    final totalSeconds = focusVM.countdownDuration.inSeconds;
    final remainingSeconds = focusVM.countdownRemaining.inSeconds;
    double elapsedProgress = totalSeconds > 0 ? (totalSeconds - remainingSeconds) / totalSeconds : 0.0;

    // Trigger hiển thị Dialog Chúc mừng khi hoàn thành
    if (focusVM.hasCompletedSession) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSuccessDialog(context, focusVM, profileVM);
      });
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: focusVM.isCountdownRunning ? const Color(0xFF52B794).withOpacity(0.4) : Colors.orange.withOpacity(0.4),
              width: 8,
            ),
            boxShadow: [
              BoxShadow(
                color: (focusVM.isCountdownRunning ? const Color(0xFF52B794) : Colors.orange).withOpacity(0.08),
                blurRadius: 32,
                spreadRadius: 4,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Widget Cây Học Tập lớn dần hoạt họa cực đẹp
              Positioned(
                top: 30,
                bottom: 80,
                left: 20,
                right: 20,
                child: _StudyTreeWidget(progress: elapsedProgress),
              ),
              // 2. Đồng hồ đếm ngược thiết kế modern capsule
              Positioned(
                bottom: 35,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDuration(focusVM.countdownRemaining),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        GestureDetector(
          onTap: focusVM.isCountdownRunning ? null : () => _showTimePicker(context, focusVM),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: focusVM.isCountdownRunning ? Colors.grey[100] : Colors.white,
              borderRadius: BorderRadius.circular(30), 
              border: Border.all(color: Colors.red[100]!)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimePickerItem('giờ'), const SizedBox(width: 24),
                _buildTimePickerItem('phút'), const SizedBox(width: 24),
                _buildTimePickerItem('giây'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircleButton(
              label: 'Hủy', 
              color: const Color(0xFFFFC6C6), 
              textColor: Colors.red[900]!, 
              onTap: () => focusVM.cancelCountdown()
            ),
            _buildCircleButton(
              label: focusVM.isCountdownRunning ? 'Tạm dừng' : 'Bắt đầu', 
              color: focusVM.isCountdownRunning ? Colors.orange[100]! : const Color(0xFFD4FFC6), 
              textColor: focusVM.isCountdownRunning ? Colors.orange[900]! : Colors.green[900]!, 
              onTap: () => focusVM.toggleCountdown()
            ),
          ],
        ),
        const SizedBox(height: 30),

        GestureDetector(
          onTap: focusVM.isCountdownRunning ? null : () => _showLabelPicker(context, focusVM, todoVM),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: focusVM.isCountdownRunning ? Colors.grey[50] : Colors.white,
              borderRadius: BorderRadius.circular(24), 
              border: Border.all(color: const Color(0xFF52B794).withOpacity(0.18), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF52B794).withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nhãn',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                Expanded(
                  child: Text(
                    focusVM.countdownLabel, 
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerItem(String label) {
    return Row(
      children: [
        Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!, width: 1.5))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  void _showTimePicker(BuildContext context, FocusViewModel focusVM) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          color: Colors.white,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hms,
            initialTimerDuration: focusVM.countdownDuration,
            onTimerDurationChanged: (Duration newDuration) {
              focusVM.setCountdownDuration(newDuration);
            },
          ),
        );
      }
    );
  }

  void _showLabelPicker(BuildContext context, FocusViewModel focusVM, TodoViewModel todoVM) {
    final txtController = TextEditingController(text: focusVM.countdownLabel == 'Hẹn giờ' ? '' : focusVM.countdownLabel);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chọn hoặc nhập nhãn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: txtController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Nhập nhãn tùy chỉnh...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check, color: Color(0xFF52B794)),
                    onPressed: () {
                      focusVM.setCountdownLabel(txtController.text.trim());
                      Navigator.pop(context);
                    },
                  )
                ),
                onSubmitted: (val) {
                  focusVM.setCountdownLabel(val.trim());
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              const Text('Hoặc chọn công việc từ To-do:', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              SizedBox(
                height: 200, 
                child: ListView.builder(
                  itemCount: todoVM.allTasks.length,
                  itemBuilder: (context, index) {
                    final task = todoVM.allTasks[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.assignment_outlined, color: Colors.grey),
                      title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: task.endTime != null 
                        ? Text('Kết thúc: ${DateFormat('HH:mm').format(task.endTime!)}', style: const TextStyle(fontSize: 12))
                        : const Text('Không có giờ kết thúc', style: TextStyle(fontSize: 12)),
                      onTap: () {
                        focusVM.setCountdownLabel(task.title);
                        
                        // Nếu có giờ kết thúc, tính thời gian còn lại
                        if (task.endTime != null) {
                          final now = DateTime.now();
                          final remaining = task.endTime!.difference(now);
                          
                          if (!remaining.isNegative) {
                            focusVM.setCountdownDuration(remaining);
                          }
                        }
                        
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  void _showSuccessDialog(BuildContext context, FocusViewModel focusVM, ProfileViewModel profileVM) {
    // Reset completion state so it is only triggered once
    focusVM.resetCompletionState();

    final xpEarned = focusVM.lastXpEarned;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (dialogContext, anim1, anim2) => const SizedBox(),
      transitionBuilder: (dialogContext, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Celebration Icon / Visual Confetti
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      color: Color(0xFF52B794),
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Trồng Cây Thành Công! 🎉',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Bạn đã hoàn thành xuất sắc phiên tập trung "${focusVM.countdownLabel}" và nuôi dưỡng một cây xanh lớn mạnh!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  // XP Reward Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF52B794).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '+$xpEarned XP Tích Lũy',
                      style: const TextStyle(
                        color: Color(0xFF52B794),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF52B794),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        // Close success dialog using its dialogContext
                        Navigator.pop(dialogContext);
                        
                        // Keep a reference to the navigator of the parent context
                        final navigator = Navigator.of(context);
                        
                        // Show loading screen / overlay while submitting API
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (loadingContext) => const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF52B794)),
                            ),
                          ),
                        );

                        // Call backend API to record study log and retrieve updated profile
                        final updatedUser = await focusVM.saveStudyLog();
                        
                        // Close the loading dialog
                        navigator.pop();

                        if (updatedUser != null && context.mounted) {
                          // Reload profile stats and info
                          await profileVM.checkAuthStatus();
                          
                          // Reload leaderboard stats
                          await context.read<FeedViewModel>().fetchLeaderboard();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã gieo trồng cây ảo và tích lũy XP! 🌳'),
                              backgroundColor: Color(0xFF52B794),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Tuyệt vời!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// WIDGET DỰ TRỰC QUAN CÂY HỌC TẬP (VECTO ĐỒ HỌA MƯỢT MÀ)
// ==========================================
class _StudyTreeWidget extends StatelessWidget {
  final double progress; // 0.0 -> 1.0
  const _StudyTreeWidget({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int stage = 1;
    if (progress >= 0.8) {
      stage = 5;
    } else if (progress >= 0.6) {
      stage = 4;
    } else if (progress >= 0.4) {
      stage = 3;
    } else if (progress >= 0.2) {
      stage = 2;
    }

    String stageName = 'Hạt mầm';
    switch (stage) {
      case 1:
        stageName = 'Đang gieo hạt...';
        break;
      case 2:
        stageName = 'Cây nảy mầm 🌱';
        break;
      case 3:
        stageName = 'Cây non lớn dần 🌿';
        break;
      case 4:
        stageName = 'Cây trưởng thành 🌳';
        break;
      case 5:
        stageName = 'Cây cổ thụ nở hoa 🌸';
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Cây lớn dần theo Scale của Stage
              Positioned(
                bottom: 30,
                child: AnimatedScale(
                  scale: 0.8 + (stage * 0.12),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                  child: _buildTreeDrawing(stage),
                ),
              ),
              // Chậu cây hoạt hình
              Positioned(
                bottom: 0,
                child: Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.brown[400],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 72,
                      height: 4,
                      color: Colors.brown[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          stageName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
      ],
    );
  }

  Widget _buildTreeDrawing(int stage) {
    if (stage == 1) {
      // Giai đoạn 1: Hạt mầm trong đất
      return Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
      );
    }

    if (stage == 2) {
      // Giai đoạn 2: Nảy mầm (thân nhỏ + 2 lá non)
      return SizedBox(
        height: 40,
        width: 40,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(width: 4, height: 25, color: Colors.brown[600]),
            Positioned(
              top: 5,
              left: 2,
              child: Transform.rotate(
                angle: -0.5,
                child: Container(
                  width: 14,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 2,
              child: Transform.rotate(
                angle: 0.5,
                child: Container(
                  width: 14,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (stage == 3) {
      // Giai đoạn 3: Cây non (cây vừa, tản lá nhỏ)
      return SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(width: 6, height: 45, color: Colors.brown[600]),
            Positioned(
              top: 10,
              child: CircleAvatar(radius: 16, backgroundColor: Colors.green[400]),
            ),
            Positioned(
              top: 0,
              child: CircleAvatar(radius: 12, backgroundColor: Colors.green[500]),
            ),
          ],
        ),
      );
    }

    if (stage == 4) {
      // Giai đoạn 4: Cây trưởng thành (nhiều tản lá xanh)
      return SizedBox(
        height: 90,
        width: 90,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(width: 8, height: 55, color: Colors.brown[700]),
            Positioned(
              top: 20,
              left: 10,
              child: CircleAvatar(radius: 20, backgroundColor: Colors.green[500]),
            ),
            Positioned(
              top: 20,
              right: 10,
              child: CircleAvatar(radius: 20, backgroundColor: Colors.green[500]),
            ),
            Positioned(
              top: 0,
              child: CircleAvatar(radius: 24, backgroundColor: Colors.green[600]),
            ),
          ],
        ),
      );
    }

    // Giai đoạn 5: Cây cổ thụ nở hoa đào (Sakura hồng cực kỳ tuyệt hảo)
    return SizedBox(
      height: 110,
      width: 110,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(width: 10, height: 65, color: Colors.brown[700]),
          Positioned(
            top: 25,
            left: 10,
            child: CircleAvatar(radius: 24, backgroundColor: Colors.green[600]),
          ),
          Positioned(
            top: 25,
            right: 10,
            child: CircleAvatar(radius: 24, backgroundColor: Colors.green[600]),
          ),
          Positioned(
            top: 0,
            child: CircleAvatar(radius: 28, backgroundColor: Colors.green[700]),
          ),
          // Hoa đào điểm xuyết màu hồng đào
          Positioned(top: 15, left: 25, child: _buildFlowerPoint()),
          Positioned(top: 10, right: 20, child: _buildFlowerPoint()),
          Positioned(top: 35, left: 15, child: _buildFlowerPoint()),
          Positioned(top: 30, right: 15, child: _buildFlowerPoint()),
          Positioned(top: 45, left: 35, child: _buildFlowerPoint()),
          Positioned(top: 40, right: 35, child: _buildFlowerPoint()),
        ],
      ),
    );
  }

  Widget _buildFlowerPoint() {
    return Container(
      width: 9,
      height: 9,
      decoration: const BoxDecoration(
        color: Colors.pinkAccent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 2.5,
          height: 2.5,
          decoration: const BoxDecoration(
            color: Colors.yellow,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. TAB BẤM GIỜ (STOPWATCH)
// ==========================================
class _StopwatchTab extends StatelessWidget {
  const _StopwatchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusVM = context.watch<FocusViewModel>();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: focusVM.isStopwatchRunning ? const Color(0xFF52B794).withOpacity(0.4) : Colors.orange.withOpacity(0.4),
              width: 8,
            ),
            boxShadow: [
              BoxShadow(
                color: (focusVM.isStopwatchRunning ? const Color(0xFF52B794) : Colors.orange).withOpacity(0.08),
                blurRadius: 32,
                spreadRadius: 4,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _formatDuration(focusVM.stopwatchElapsed), 
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: focusVM.isStopwatchRunning ? const Color(0xFF2C7A60) : Colors.black87,
              ),
            )
          ),
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircleButton(
              label: 'Đặt lại', 
              color: Colors.white, 
              textColor: Colors.black87, 
              borderColor: Colors.grey[400], 
              onTap: () => focusVM.resetStopwatch()
            ),
            _buildCircleButton(
              label: focusVM.isStopwatchRunning ? 'Dừng' : 'Bắt đầu', 
              color: focusVM.isStopwatchRunning ? Colors.orange[100]! : const Color(0xFFD4FFC6), 
              textColor: focusVM.isStopwatchRunning ? Colors.orange[900]! : Colors.green[900]!, 
              onTap: () => focusVM.toggleStopwatch()
            ),
          ],
        ),
      ],
    );
  }
}

// ==========================================
// WIDGET DÙNG CHUNG
// ==========================================
Widget _buildCircleButton({required String label, required Color color, required Color textColor, Color? borderColor, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 90, height: 90,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: borderColor != null ? Border.all(color: borderColor) : null),
      child: Center(child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14))),
    ),
  );
}
