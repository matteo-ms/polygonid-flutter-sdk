///{
///	 "ethereumUrl": "http://localhost:8545",
///	 "stateContractAddr": "0xEA9aF2088B4a9770fC32A12fD42E61BDD317E655",
///	 "reverseHashServiceUrl": "http://localhost:8003"
///}

class RhsAtomicQueryInputsParam {
  final String ethereumUrl;
  final String stateContractAddr;
  final BigInt reverseHashServiceUrl;

  RhsAtomicQueryInputsParam({
    required this.ethereumUrl,
    required this.stateContractAddr,
    required this.reverseHashServiceUrl,
  });

  Map<String, dynamic> toJson() => {
        "ethereumUrl": ethereumUrl,
        "stateContractAddr": stateContractAddr,
        "reverseHashServiceUrl": reverseHashServiceUrl,
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}
