import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fe_mobile/main.dart'; 
import 'package:fe_mobile/core/models/subject_model.dart';
import 'package:fe_mobile/features/onboarding/presentation/viewmodels/subject_onboarding_viewmodel.dart';
import 'package:fe_mobile/features/community/presentation/viewmodels/feed_viewmodel.dart';

class SubjectOnboardingView extends StatelessWidget {
  const SubjectOnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SubjectOnboardingViewModel>();
    const primaryColor = Color(0xFF52B794);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thiết lập môn học', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: viewModel.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Chọn các môn học bạn quan tâm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text('Điều này giúp chúng tôi gợi ý nội dung phù hợp cho bạn.', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: viewModel.popularSubjects.map((s) {
                        final isSelected = viewModel.isSelected(s);
                        return FilterChip(
                          label: Text('${s.iconPath} ${s.name}'),
                          selected: isSelected,
                          onSelected: (_) => viewModel.toggleSubject(s),
                          selectedColor: primaryColor.withOpacity(0.2),
                          checkmarkColor: primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? primaryColor : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: isSelected ? primaryColor : Colors.grey.shade300),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: viewModel.hasAddedSubjects && !viewModel.isProcessing 
                      ? () async {
                          await viewModel.completeOnboarding();
                          if (context.mounted) {
                            context.read<FeedViewModel>().refreshAll();
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const MainLayoutScreen()),
                              );
                            }
                          }
                        } 
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: viewModel.isProcessing 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('Hoàn tất', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
