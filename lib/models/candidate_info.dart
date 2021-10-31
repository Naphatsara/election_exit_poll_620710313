class CandidateInfo {
  final int candidateNumber;
  final String candidateTitle;
  final String candidateName;

  CandidateInfo({
    required this.candidateNumber,
    required this.candidateTitle,
    required this.candidateName,
  });

  factory CandidateInfo.fromJson(Map<String, dynamic> json) {
    return CandidateInfo(
      candidateNumber: json['candidateNumber'],
      candidateTitle: json['candidateTitle'],
      candidateName: json['candidateName'],
    );
  }
  @override
  String toString() {
    return 'หมายเลย: $candidateNumber, ชื่อ: $candidateTitle $candidateName ';
  }
}
