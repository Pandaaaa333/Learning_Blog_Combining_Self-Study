import 'package:flutter/material.dart';
import 'package:fe_mobile/core/models/subject_model.dart';
import '../../data/services/subject_service.dart';

class SubjectOnboardingViewModel extends ChangeNotifier {
  final SubjectService _subjectService = SubjectService();
  
  List<SubjectModel> _allSubjects = [];
  List<SubjectModel> _addedSubjects = [];
  bool _isLoading = false;
  bool _isProcessing = false;

  List<SubjectModel> get popularSubjects => _allSubjects;
  List<SubjectModel> get addedSubjects => _addedSubjects;
  bool get isLoading => _isLoading;
  bool get isProcessing => _isProcessing;
  bool get hasAddedSubjects => _addedSubjects.isNotEmpty;

  SubjectOnboardingViewModel() {
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    _isLoading = true;
    notifyListeners();

    _allSubjects = await _subjectService.getAllSubjects();
    _addedSubjects = await _subjectService.getMySubjects();
    
    _isLoading = false;
    notifyListeners();
  }

  void toggleSubject(SubjectModel subject) {
    if (_addedSubjects.any((s) => s.id == subject.id)) {
      _addedSubjects.removeWhere((s) => s.id == subject.id);
    } else {
      _addedSubjects.add(subject);
    }
    notifyListeners();
  }

  bool isSelected(SubjectModel subject) {
    return _addedSubjects.any((s) => s.id == subject.id);
  }

  void addSubject(SubjectModel subject) {
    if (!_addedSubjects.any((s) => s.id == subject.id)) {
      _addedSubjects.add(subject);
      notifyListeners();
    }
  }

  void removeSubject(SubjectModel subject) {
    _addedSubjects.removeWhere((s) => s.id == subject.id);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isProcessing = true;
    notifyListeners();
    
    final subjectIds = _addedSubjects.map((s) => s.id).toList();
    final success = await _subjectService.updatePreferences(subjectIds);
    
    _isProcessing = false;
    notifyListeners();
  }
}