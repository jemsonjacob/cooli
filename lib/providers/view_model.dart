import 'package:flutter/material.dart';

import '/providers/_base.dart';
import '/providers/_mixins.dart';

abstract class ViewModel extends BaseProvider
    with MixinProgressProvider, MixinAPIProvider {
  int _page = 1;
  bool _isAllCompleted = false;

  int get page => _page;

  bool get canLoadMore => (!_isAllCompleted) && (!super.isLoading);

  /// If you want to execute an [apiService] which has a pagination use
  /// [fetchListData]
  ///
  /// [_isAllCompleted]
  /// will be marked as ```true``` when [limit] does not matches with list
  /// returned by API
  ///
  /// By default [limit] is ```6```
  void fetchListData<IM>({
    required final Future<List<IM>> Function() apiService,
    required OnShowError onShowError,
    required ValueChanged<List<IM>> onSuccess,
    final int limit = 6,
  }) async {
    if (super.isLoading) return;
    super.isLoading = true;

    apiService().then((models) {
      if (models.length == limit) {
        _page++;
      } else {
        _isAllCompleted = true;
      }
      onSuccess(models);
    }).whenComplete(() => super.isLoading = false);
  }

  void reset() {
    _page = 1;
    _isAllCompleted = false;
  }
}
