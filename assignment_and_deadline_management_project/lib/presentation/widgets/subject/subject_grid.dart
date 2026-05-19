import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/subject_entity.dart';
import 'package:fe_admin_web/presentation/widgets/subject/subject_card.dart';

class SubjectGrid extends StatelessWidget {
  final List<AdminSubjectModel> filteredSubjects;
  final Function(AdminSubjectModel) onEdit;
  final Function(String) onDelete;

  const SubjectGrid({
    super.key,
    required this.filteredSubjects,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredSubjects.isEmpty) {
      return const Center(
        child: Text('Không có môn học nào.'),
      );
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        childAspectRatio: 1.4,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: filteredSubjects.length,
      itemBuilder: (context, index) {
        final subject = filteredSubjects[index];

        return SubjectCard(
          subject: subject,
          onEdit: () => onEdit(subject),
          onDelete: () => onDelete(subject.id),
        );
      },
    );
  }
}
