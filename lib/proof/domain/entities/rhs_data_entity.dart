class RhsDataEntity {
  final String ethereumUrl;
  final String stateContractAddr;
  final String reverseHashServiceUrl;

  RhsDataEntity(
      {required this.ethereumUrl,
      required this.stateContractAddr,
      required this.reverseHashServiceUrl});

  @override
  String toString() =>
      "[RhsDataEntity] {ethereumUrl: $ethereumUrl, stateContractAddr: $stateContractAddr, reverseHashServiceUrl: $reverseHashServiceUrl}";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RhsDataEntity &&
          runtimeType == other.runtimeType &&
          ethereumUrl.toString() == other.ethereumUrl.toString() &&
          stateContractAddr.toString() == other.stateContractAddr.toString() &&
          reverseHashServiceUrl.toString() ==
              other.reverseHashServiceUrl.toString();

  @override
  int get hashCode => runtimeType.hashCode;
}
