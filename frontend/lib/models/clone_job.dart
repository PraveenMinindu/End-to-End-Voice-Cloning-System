enum JobStatus { idle, uploading, pending, processing, done, error }

class CloneJob {
  final String? jobId;
  final JobStatus status;
  final String statusLabel;
  final double progress;
  final String? outputUrl;
  final String? errorMessage;
  final DateTime? createdAt;

  const CloneJob({
    this.jobId,
    this.status = JobStatus.idle,
    this.statusLabel = '',
    this.progress = 0,
    this.outputUrl,
    this.errorMessage,
    this.createdAt,
  });

  CloneJob copyWith({
    String? jobId,
    JobStatus? status,
    String? statusLabel,
    double? progress,
    String? outputUrl,
    String? errorMessage,
    DateTime? createdAt,
  }) {
    return CloneJob(
      jobId: jobId ?? this.jobId,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      progress: progress ?? this.progress,
      outputUrl: outputUrl ?? this.outputUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isActive =>
      status == JobStatus.uploading ||
      status == JobStatus.pending ||
      status == JobStatus.processing;

  bool get isSuccess => status == JobStatus.done;
  bool get isError => status == JobStatus.error;
  bool get isIdle => status == JobStatus.idle;
}
