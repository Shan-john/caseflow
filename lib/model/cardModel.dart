class CaseModel {
  final String id;
  final String caseName;
  final String caseDate;
  final String caseType;
  final String judgeNumber;

  CaseModel({
    required this.id,
    required this.caseName,
    required this.caseDate,
    required this.caseType,
    required this.judgeNumber,
  });

  // Factory constructor to create a CaseModel from Firestore document
  factory CaseModel.fromFirestore(String id, Map<String, dynamic> data) {
    return CaseModel(
      id: id,
      caseName: data["case_name"] ?? "Unknown",
      caseDate: data["case_date"] ?? "Unknown",
      caseType: data["case_type"] ?? "Unknown",
      judgeNumber: data["judge_number"] ?? "Unknown",
    );
  }
}
