class RequestSummary {
  final double amountRequested;
  final double maxPossible;

  RequestSummary({required this.amountRequested, required this.maxPossible});

  factory RequestSummary.fromJson(Map<String, dynamic> json) => RequestSummary(
    amountRequested: (json["amountRequested"] as num).toDouble(),
    maxPossible: (json["maxPossible"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "amountRequested": amountRequested,
    "maxPossible": maxPossible,
  };

  double get percentage =>
      maxPossible > 0 ? (amountRequested / maxPossible * 100) : 0.0;
}

