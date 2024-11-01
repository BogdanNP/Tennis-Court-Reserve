class UIModel<T> {
  final OperationState state;
  final T? data;
  final Object? error;

  UIModel(this.state, this.data, this.error);

  factory UIModel.success(T data) {
    return UIModel(OperationState.success, data, null);
  }
  factory UIModel.loading() {
    return UIModel(OperationState.loading, null, null);
  }
  factory UIModel.error(Object? error) {
    return UIModel(OperationState.error, null, error);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UIModel &&
            runtimeType == other.runtimeType &&
            state == other.state &&
            data == other.data &&
            error == other.error;
  }

  @override
  int get hashCode => state.hashCode ^ data.hashCode ^ error.hashCode;

  UIModel<V?> transform<V>([V? Function(T? _)? mappingFunction]) {
    switch (state) {
      case OperationState.success:
        return UIModel.success(mappingFunction?.call(data));
      case OperationState.loading:
        return UIModel.loading();
      case OperationState.error:
        return UIModel.error(error);
    }
  }

  @override
  String toString() {
    return "UIModel(state: $state, data: $data, error: $error)";
  }
}

enum OperationState {
  success,
  loading,
  error,
}
