import 'dart:math' as math;
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
    final focusVM = context.watch<FocusViewModel>();

    return PopScope(
      canPop: !focusVM.isCountdownRunning,
      onPopInvoked: (didPop) {
        if (!didPop) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bạn đang tập trung, không thể quay lại! 🎋'),
              backgroundColor: Color(0xFF52B794),
            ),
          );
        }
      },
      child: DefaultTabController(
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
            child: IgnorePointer(
              ignoring: focusVM.isCountdownRunning,
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
                tabs: const [Tab(text: 'Timer'), Tab(text: 'Stopwatch')],
              ),
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
          child: TabBarView(
            physics: focusVM.isCountdownRunning ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
            children: const [_CountdownTab(), _StopwatchTab()],
          ),
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

class _CountdownTabState extends State<_CountdownTab> with SingleTickerProviderStateMixin {
  late AnimationController _swayController;

  @override
  void initState() {
    super.initState();
    _swayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _swayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusVM = context.watch<FocusViewModel>();
    final todoVM = context.read<TodoViewModel>();
    final profileVM = context.read<ProfileViewModel>();

    // Tính toán tiến trình đếm ngược để trồng cây lớn lên (từ 0.0 hạt mầm đến 1.0 cây ra hoa)
    final totalSeconds = focusVM.countdownDuration.inSeconds;
    final remainingSeconds = focusVM.countdownRemaining.inSeconds;
    double elapsedProgress = totalSeconds > 0 ? (totalSeconds - remainingSeconds) / totalSeconds : 0.0;
    final isTreeDead = focusVM.isTreeDead;

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
              color: focusVM.isCountdownRunning 
                  ? const Color(0xFF52B794).withOpacity(0.4) 
                  : (isTreeDead ? Colors.grey.withOpacity(0.4) : Colors.orange.withOpacity(0.4)),
              width: 8,
            ),
            boxShadow: [
              BoxShadow(
                color: (focusVM.isCountdownRunning 
                    ? const Color(0xFF52B794) 
                    : (isTreeDead ? Colors.grey : Colors.orange)).withOpacity(0.08),
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
                child: AnimatedBuilder(
                  animation: _swayController,
                  builder: (context, child) {
                    double swayVal = (_swayController.value * 2) - 1.0;
                    return _StudyTreeWidget(
                      progress: isTreeDead ? focusVM.deadProgress : elapsedProgress,
                      sway: swayVal,
                      isRunning: focusVM.isCountdownRunning,
                      isDead: isTreeDead,
                    );
                  },
                ),
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
                    isTreeDead ? "Aborted" : _formatDuration(focusVM.countdownRemaining),
                    style: TextStyle(
                      fontSize: isTreeDead ? 20 : 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: isTreeDead ? Colors.red[800] : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        GestureDetector(
          onTap: (focusVM.isCountdownRunning || isTreeDead) ? null : () => _showTimePicker(context, focusVM),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: (focusVM.isCountdownRunning || isTreeDead) ? Colors.grey[100] : Colors.white,
              borderRadius: BorderRadius.circular(30), 
              border: Border.all(color: Colors.red[100]!)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimePickerItem('hours'), const SizedBox(width: 24),
                _buildTimePickerItem('mins'), const SizedBox(width: 24),
                _buildTimePickerItem('secs'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (focusVM.isCountdownRunning)
              _buildCircleButton(
                label: 'Cancel\n(Bamboo dies)', 
                color: const Color(0xFFFFC6C6), 
                textColor: Colors.red[900]!, 
                onTap: () => focusVM.cancelCountdown()
              )
            else if (isTreeDead)
              _buildCircleButton(
                label: 'Replant', 
                color: const Color(0xFFE2E8F0), 
                textColor: Colors.grey[800]!, 
                onTap: () => focusVM.resetTree()
              )
            else
              _buildCircleButton(
                label: 'Start', 
                color: const Color(0xFFD4FFC6), 
                textColor: Colors.green[900]!, 
                onTap: () => focusVM.toggleCountdown()
              ),
          ],
        ),
        const SizedBox(height: 30),

        GestureDetector(
          onTap: (focusVM.isCountdownRunning || isTreeDead) ? null : () => _showLabelPicker(context, focusVM, todoVM),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: (focusVM.isCountdownRunning || isTreeDead) ? Colors.grey[50] : Colors.white,
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
                  'Label',
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
    final txtController = TextEditingController(text: (focusVM.countdownLabel == 'Hẹn giờ' || focusVM.countdownLabel == 'Focus') ? '' : focusVM.countdownLabel);
    
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
              const Text('Select or enter label', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: txtController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter custom label...',
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
              const Text('Or select a task from To-do:', style: TextStyle(color: Colors.grey)),
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
                        ? Text('Ends at: ${DateFormat('HH:mm').format(task.endTime!)}', style: const TextStyle(fontSize: 12))
                        : const Text('No end time', style: TextStyle(fontSize: 12)),
                      onTap: () {
                        focusVM.setCountdownLabel(task.title, taskId: task.id);
                        
                        // Chỉnh đúng bằng thời gian cần làm công việc (endTime - startTime)
                        if (task.endTime != null) {
                          final duration = task.endTime!.difference(task.startTime);
                          
                          if (!duration.isNegative && duration.inSeconds > 0) {
                            focusVM.setCountdownDuration(duration);
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
                    'Bamboo Grown Successfully! 🎉',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You have successfully completed the focus session "${focusVM.countdownLabel}" and nurtured a strong bamboo stalk!',
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
                      '+$xpEarned XP Earned',
                      style: const TextStyle(
                        color: Color(0xFF52B794),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (focusVM.selectedTaskId != null) ...[
                    const Divider(height: 32),
                    const Text(
                      'Complete Task?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Do you want to mark the task "${focusVM.countdownLabel}" as completed in your To-do list?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (focusVM.selectedTaskId != null) ...[
                    // Nút 1: Có, hoàn thành công việc
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
                          Navigator.pop(dialogContext);
                          final navigator = Navigator.of(context);
                          
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (loadingContext) => const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF52B794)),
                              ),
                            ),
                          );

                          // Đánh dấu hoàn thành trong To-do
                          try {
                            final todoVM = context.read<TodoViewModel>();
                            await todoVM.toggleTaskStatus(focusVM.selectedTaskId!);
                          } catch (e) {
                            debugPrint('Failed to auto-complete todo: $e');
                          }

                          final updatedUser = await focusVM.saveStudyLog();
                          navigator.pop();

                          if (updatedUser != null && context.mounted) {
                            await profileVM.checkAuthStatus();
                            await context.read<FeedViewModel>().fetchLeaderboard();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Virtual bamboo planted, XP claimed, and task completed! 🎋✅'),
                                backgroundColor: Color(0xFF52B794),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Yes, task completed! ✅',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Nút 2: Chưa hoàn thành
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF52B794)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          final navigator = Navigator.of(context);
                          
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (loadingContext) => const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF52B794)),
                              ),
                            ),
                          );

                          final updatedUser = await focusVM.saveStudyLog();
                          navigator.pop();

                          if (updatedUser != null && context.mounted) {
                            await profileVM.checkAuthStatus();
                            await context.read<FeedViewModel>().fetchLeaderboard();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Virtual bamboo planted and XP accumulated! 🎋'),
                                backgroundColor: Color(0xFF52B794),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Not completed, claim XP only',
                          style: TextStyle(
                            color: Color(0xFF52B794),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Không chọn task To-do, hiện nút mặc định
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
                          Navigator.pop(dialogContext);
                          final navigator = Navigator.of(context);
                          
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (loadingContext) => const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF52B794)),
                              ),
                            ),
                          );

                          final updatedUser = await focusVM.saveStudyLog();
                          navigator.pop();

                          if (updatedUser != null && context.mounted) {
                            await profileVM.checkAuthStatus();
                            await context.read<FeedViewModel>().fetchLeaderboard();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Virtual bamboo planted and XP accumulated! 🎋'),
                                backgroundColor: Color(0xFF52B794),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Great!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
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
  final double sway;
  final bool isRunning;
  final bool isDead;

  const _StudyTreeWidget({
    Key? key,
    required this.progress,
    required this.sway,
    required this.isRunning,
    required this.isDead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String stageName = 'Sprouting bamboo shoot...';
    if (isDead) {
      stageName = 'Withered bamboo 🍂';
    } else {
      if (progress >= 0.8) {
        stageName = 'Sturdy bamboo forest 🎋';
      } else if (progress >= 0.6) {
        stageName = 'Tall bamboo stalk 🎋';
      } else if (progress >= 0.4) {
        stageName = 'Branching bamboo 🌿';
      } else if (progress >= 0.2) {
        stageName = 'Sprouting baby shoot 🌱';
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: BambooPainter(
              progress: progress,
              sway: sway,
              isRunning: isRunning,
              isDead: isDead,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          stageName,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDead ? Colors.red[800] : Colors.green[800],
          ),
        ),
      ],
    );
  }
}

class BambooPainter extends CustomPainter {
  final double progress; // 0.0 -> 1.0
  final double sway; // -1.0 -> 1.0
  final bool isRunning;
  final bool isDead;

  BambooPainter({
    required this.progress,
    required this.sway,
    required this.isRunning,
    required this.isDead,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Vẽ chậu sứ đựng tre ở dưới cùng
    final paintPot = Paint()
      ..color = isDead ? Colors.grey[400]! : Colors.brown[300]!
      ..style = PaintingStyle.fill;
    
    final potPath = Path()
      ..moveTo(size.width / 2 - 30, size.height)
      ..lineTo(size.width / 2 - 20, size.height - 18)
      ..lineTo(size.width / 2 + 20, size.height - 18)
      ..lineTo(size.width / 2 + 30, size.height)
      ..close();
    canvas.drawPath(potPath, paintPot);

    final paintPotRim = Paint()
      ..color = isDead ? Colors.grey[500]! : Colors.brown[500]!
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(size.width / 2 - 25, size.height - 21, size.width / 2 + 25, size.height - 17),
        const Radius.circular(1.5),
      ),
      paintPotRim,
    );

    // Vẽ đất màu nâu đậm
    final paintSoil = Paint()..color = isDead ? Colors.grey[600]! : Colors.brown[700]!;
    canvas.drawOval(
      Rect.fromLTRB(size.width / 2 - 22, size.height - 20, size.width / 2 + 22, size.height - 17),
      paintSoil,
    );

    // 2. Vẽ các đốt tre (tối đa 10 đốt)
    const int maxSegments = 10;
    double growthFactor = progress * maxSegments;
    int fullSegments = growthFactor.floor();
    double lastSegmentGrowth = growthFactor - fullSegments;

    double currentX = size.width / 2;
    double currentY = size.height - 19;

    double currentAngle = 0.0;
    
    // Tính toán chiều cao mỗi đốt tre tự động tỉ lệ với chiều cao canvas thực tế (tránh vượt ra ngoài)
    // Chiều cao tối đa cây tre là size.height - 35
    double usableHeight = size.height - 35;
    if (usableHeight < 100) usableHeight = 100;
    final double baseSegmentHeight = usableHeight / maxSegments;

    for (int i = 0; i < maxSegments; i++) {
      double segmentHeight = 0.0;
      if (i < fullSegments) {
        segmentHeight = baseSegmentHeight;
      } else if (i == fullSegments) {
        segmentHeight = baseSegmentHeight * lastSegmentGrowth;
        if (i == 0 && segmentHeight < 8) {
          segmentHeight = 8.0; // Hiển thị mầm măng tối thiểu
        }
      } else {
        break; // Chưa mọc tới
      }

      if (segmentHeight <= 0) continue;

      // Độ nghiêng/đung đưa cộng dồn theo chiều cao của cây tre (các đốt trên cao sẽ lắc nhiều hơn)
      double segmentSway = isRunning ? (sway * 0.035) : (sway * 0.01);
      currentAngle += segmentSway;

      double nextX = currentX + segmentHeight * math.sin(currentAngle);
      double nextY = currentY - segmentHeight * math.cos(currentAngle);

      // Thân tre có màu gradient chuyển tiếp. Nếu chết sẽ chuyển sang sắc nâu/xám héo khô.
      final segmentPaint = Paint()
        ..shader = LinearGradient(
          colors: isDead
              ? [
                  const Color(0xFFD2B48C), // Light dry brown
                  const Color(0xFF8B5A2B), // Withered brown
                  const Color(0xFF5C4033), // Dark dead brown
                ]
              : [
                  const Color(0xFF98E29E),
                  const Color(0xFF52B794),
                  const Color(0xFF2E8668),
                ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(Rect.fromLTRB(currentX - 5.0, nextY, currentX + 5.0, currentY));

      // Tạo hình dạng thuôn ở giữa của đốt tre giúp đốt tre nhìn tự nhiên hơn
      final segmentPath = Path();
      double widthBottom = 4.8 - (i * 0.22);
      if (widthBottom < 2.8) widthBottom = 2.8;
      double widthTop = 4.4 - (i * 0.22);
      if (widthTop < 2.4) widthTop = 2.4;
      double midWidth = (widthBottom + widthTop) / 2 * 0.86;

      segmentPath.moveTo(currentX - widthBottom, currentY);
      segmentPath.cubicTo(
        currentX - midWidth, currentY - segmentHeight * 0.3,
        currentX - midWidth, currentY - segmentHeight * 0.7,
        nextX - widthTop, nextY,
      );
      segmentPath.lineTo(nextX + widthTop, nextY);
      segmentPath.cubicTo(
        nextX + midWidth, nextY + segmentHeight * 0.3,
        currentX + midWidth, currentY - segmentHeight * 0.3,
        currentX + widthBottom, currentY,
      );
      segmentPath.close();

      canvas.drawPath(segmentPath, segmentPaint);

      // Vẽ khớp nối giữa các đốt tre (vành đốt)
      final jointPaint = Paint()
        ..color = isDead ? const Color(0xFFE5D3B3) : const Color(0xFFE8FCD0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4;
      
      canvas.drawLine(
        Offset(nextX - widthTop - 0.6, nextY),
        Offset(nextX + widthTop + 0.6, nextY),
        jointPaint,
      );

      final jointLinePaint = Paint()
        ..color = (isDead ? const Color(0xFF5C4033) : const Color(0xFF2E8668)).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawLine(
        Offset(nextX - widthTop - 0.2, nextY),
        Offset(nextX + widthTop + 0.2, nextY),
        jointLinePaint,
      );

      // Vẽ cành lá mọc ra từ đốt tre (chỉ vẽ từ đốt thứ 2 trở lên khi đốt đã mọc tương đối lớn)
      if (segmentHeight > 8 && i > 0) {
        bool drawLeft = (i % 2 == 0);
        bool drawRight = (i % 2 != 0);

        if (drawLeft) {
          _drawBambooBranch(canvas, nextX, nextY, isDead ? currentAngle - 2.0 : currentAngle - 1.25, i, isDead);
        }
        if (drawRight) {
          _drawBambooBranch(canvas, nextX, nextY, isDead ? currentAngle + 2.0 : currentAngle + 1.25, i, isDead);
        }
      }

      currentX = nextX;
      currentY = nextY;
    }
  }

  void _drawBambooBranch(Canvas canvas, double px, double py, double angle, int index, bool isDead) {
    // Thu nhỏ cành tre lại một chút để không vượt quá ô tròn theo chiều ngang
    double branchLength = 9.0 - (index * 0.4);
    if (branchLength < 5.0) branchLength = 5.0;

    double bx = px + branchLength * math.sin(angle);
    double by = py - branchLength * math.cos(angle);

    final branchPaint = Paint()
      ..color = isDead ? const Color(0xFF8B5A2B) : const Color(0xFF3EA380)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(px, py), Offset(bx, by), branchPaint);

    // Vẽ cụm 2 lá tre nhọn mọc ở đầu nhánh
    _paintLeaf(canvas, bx, by, angle - 0.35, index, isDead);
    _paintLeaf(canvas, bx, by, angle + 0.35, index, isDead);
  }

  void _paintLeaf(Canvas canvas, double lx, double ly, double angle, int index, bool isDead) {
    // Thu nhỏ chiều dài lá tre để nằm trọn vẹn trong vòng tròn
    double leafLength = 13.0 - (index * 0.5);
    if (leafLength < 6.0) leafLength = 6.0;
    double leafWidth = 2.6 - (index * 0.1);
    if (leafWidth < 1.5) leafWidth = 1.5;

    double endX = lx + leafLength * math.sin(angle);
    double endY = ly - leafLength * math.cos(angle);

    double midX = (lx + endX) / 2;
    double midY = (ly + endY) / 2;

    double perpX = -math.cos(angle) * leafWidth;
    double perpY = -math.sin(angle) * leafWidth;

    final leafPath = Path()
      ..moveTo(lx, ly)
      ..quadraticBezierTo(midX + perpX, midY + perpY, endX, endY)
      ..quadraticBezierTo(midX - perpX, midY - perpY, lx, ly)
      ..close();

    final leafPaint = Paint()
      ..shader = LinearGradient(
        colors: isDead
            ? [
                const Color(0xFFCD853F), // Peru withered brown
                const Color(0xFF8B4513), // Saddle dead brown
              ]
            : [
                const Color(0xFF52B794),
                const Color(0xFF1B5E46),
              ],
      ).createShader(Rect.fromLTRB(lx - 3, ly - 3, endX + 3, endY + 3));

    canvas.drawPath(leafPath, leafPaint);
  }

  @override
  bool shouldRepaint(covariant BambooPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.sway != sway ||
        oldDelegate.isRunning != isRunning ||
        oldDelegate.isDead != isDead;
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
              label: 'Reset', 
              color: Colors.white, 
              textColor: Colors.black87, 
              borderColor: Colors.grey[400], 
              onTap: () => focusVM.resetStopwatch()
            ),
            _buildCircleButton(
              label: focusVM.isStopwatchRunning ? 'Stop' : 'Start', 
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
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    ),
  );
}
