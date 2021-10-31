class CandidateResult {
  final int candidateNumber;
  final String candidateTitle;
  final String candidateName;
  final int score;

  CandidateResult({
    required this.candidateNumber,
    required this.candidateTitle,
    required this.candidateName,
    required this.score
  });

  factory CandidateResult.fromJson(Map<String, dynamic> json) {
    return CandidateResult(
      candidateNumber: json['candidateNumber'],
      candidateTitle: json['candidateTitle'],
      candidateName: json['candidateName'],
      score: json['score'],
    );
  }
  @override
  String toString() {
    return 'หมายเลย: $candidateNumber, ชื่อ: $candidateTitle $candidateName, คะแนน: $score ';
  }
}