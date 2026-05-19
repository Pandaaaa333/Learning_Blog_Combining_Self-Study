import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/subject_entity.dart';
import 'package:fe_admin_web/presentation/widgets/subject/add_edit_subject_modal.dart';
import 'package:fe_admin_web/presentation/widgets/subject/subject_grid.dart';
import 'package:fe_admin_web/presentation/widgets/subject/subject_management_header.dart';
import 'package:provider/provider.dart';
import 'package:fe_admin_web/data/providers/subject_provider.dart';

class SubjectManagementScreen extends StatefulWidget {
  const SubjectManagementScreen({super.key});

  @override
  State<SubjectManagementScreen> createState() =>
      _SubjectManagementScreenState();
}

class _SubjectManagementScreenState extends State<SubjectManagementScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectProvider>().fetchSubjects();
    });
  }

  void _saveSubject(String? id, String name, String code) async {
    final subject = AdminSubjectModel(
      id: id ?? '',
      name: name,
      code: code,
      themeColor: '0xFF4A7DFF',
      enrolledStudents: 0,
    );

    final success = await context.read<SubjectProvider>().addOrUpdateSubject(subject);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu môn học thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể lưu môn học.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteSubject(String id) async {
    final success = await context.read<SubjectProvider>().deleteSubject(id);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Đã xóa môn học!'), backgroundColor: Colors.red));
    }
  }

  void _showAddEditSubjectModal([AdminSubjectModel? subject]) {
    showDialog(
      context: context,
      builder: (ctx) => AddEditSubjectModal(
        subject: subject,
        onSave: _saveSubject,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectProvider>(
      builder: (context, subjectProvider, child) {
        final filteredSubjects = subjectProvider.subjects.where((sub) {
          return sub.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              sub.code.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubjectManagementHeader(
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              onAddSubject: () => _showAddEditSubjectModal(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: subjectProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : subjectProvider.error != null
                      ? Center(child: Text(subjectProvider.error!, style: const TextStyle(color: Colors.red)))
                      : SubjectGrid(
                          filteredSubjects: filteredSubjects,
                          onEdit: (subject) => _showAddEditSubjectModal(subject),
                          onDelete: (id) => _deleteSubject(id),
                        ),
            ),
          ],
        );
      },
    );
  }
}