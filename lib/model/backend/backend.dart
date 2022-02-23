enum BackEndStatus { undoing, loading, success, error }

class BackEndResponse {
  const BackEndResponse(this.status);

  final BackEndStatus status;
}
