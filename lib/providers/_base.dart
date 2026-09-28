import 'dart:io';

import 'package:cooli/models/app_error_model.dart';

import '/utils/extensions.dart';
import 'package:flutter/material.dart';

import '_mixins.dart';

/// A callback for showing error messages
typedef OnShowError = void Function(AppError msg);

/// The base provider class
///
///
abstract class BaseProvider extends ChangeNotifier {
  final String? _providerName;

  String? get providerName => _providerName;

  int get deviceType {
    if (Platform.isAndroid) return 1;
    if (Platform.isIOS) return 2;
    return -1;
  }

  // Future<String?> get deviceToken async => FirebaseMessagingHelper().getToken();

  /// The default constructor
  BaseProvider({String? name})
      : _providerName = name,
        super();

  @override
  void notifyListeners() {
    try {
      super.notifyListeners();
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  // Future<UserResModel> getUserModel() => SharedPreferences.getInstance().then(
  //     (sp) => UserResModel.fromSharedPrefStr(sp.getString(spKeys.keyUserInfo)));
}

/// The basic provider to load the json data
///
/// [M] is the type of data represents the json
// abstract class AssetJsonLoaderBaseProvider<M> extends BaseProvider
//     with IProgressProvider {
//   late final String fileName;
//   M? dataModel;

//   AssetJsonLoaderBaseProvider({
//     required this.fileName,
//     String? name,
//   }) : super(name: name ?? "BaseAssetJsonLoaderProvider");

//   @protected
//   M convertFromJson(dynamic jsonData);

//   Future<M> _fetchJsonData() async {
//     final value = await AppAssetHelper.loadJson(fileName);
//     assert(value != null);
//     dataModel = convertFromJson(value);
//     return dataModel!;
//   }

//   Future<M> fetchJsonData() =>
//       _fetchJsonData().coverWithProgress<AssetJsonLoaderBaseProvider>(this);
// }

/// The base api provider which handle loading and errors
/// [M] is the interface model which returns the API result
///
abstract class _BaseSimpleAPIProvider<M> extends BaseProvider
    with MixinAPIProvider, MixinProgressProvider {
  // static String? _uniqueUUID;
  // String? _appVersion;
  _BaseSimpleAPIProvider({String? name})
      : super(name: name ?? "BaseSimpleAPIProvider");
  M? _iModel;
  M? get iModel => _iModel;
  set _setIModel(M? value) {
    _iModel = value;
    notifyListeners();
  }

  @protected
  bool get shouldResetParams => false;

  @protected
  void resetParams() {}

  void resetIModel() {
    _iModel = null;
    notifyListeners();
  }

  /// The API service to be called.
  /// This api service is defined in the subclasses
  /// The parameters are need to defined as subclass variables
  ///
  @protected
  Future<M?> apiService();

  Future<M?> fetchFromAPIService({
    required OnShowError onShowError,
    void Function(M? m)? onSuccess,
    VoidCallback? onInvalidSession,
  }) =>
      apiService()
          .then((value) {
            _setIModel = value;
            if (onSuccess != null) {
              onSuccess(value);
            }
            return value;
          })
          .handleAPIException(
            handleAPIException: handleAPIException,
            onShowError: onShowError,
            onInvalidToken: onInvalidSession,
          )
          .then((model) {
            if (shouldResetParams) {
              resetParams();
            }
            return model;
          })
          .coverWithProgress(this);
}

/// The base api for list pagination
/// The [IM] can be the interface model
abstract class _BaseListLoadMoreProvider<IM> extends BaseProvider
    with MixinAPIProvider, MixinProgressProvider {
  final _list = <IM>[];

  int? _pageCount;

  _BaseListLoadMoreProvider({String? name})
      : super(name: name ?? "BaseListLoadMoreProvider");
  int _page = 0;
  bool _isAllCompleted = false;

  List<IM> get list => _list;

  int get page => _page;

  int get nextPage => _page + 1;

  bool get canLoadMore => (!_isAllCompleted) && (!super.isLoading);

  set _addToList(List<IM>? value) {
    if (value?.isNotEmpty ?? false) {
      _list.addAll(value!);
    }
    notifyListeners();
  }

  Future<ListLoadOptionModel<IM>?> apiService();

  // Future<List<IM>> fetchAPIService();
  Future<ListLoadOptionModel<IM>?> fetchListData({
    required OnShowError onShowError,
    ValueChanged<List<IM>?>? onSuccess,
    VoidCallback? onInit,
  }) async {
    if (super.isLoading) return null;
    super.isLoading = true;

    // print("####### after onInit");
    // await Future.delayed(const Duration(seconds: 2));
    if (onInit != null) {
      onInit();
    }
    return apiService()
        .then((model) {
          _isAllCompleted = computeIsCompleted(model);
          _addToList = model?.iList;
          if (onSuccess != null) onSuccess(model?.iList);
          return model;
        })
        .handleAPIException(
          handleAPIException: handleAPIException,
          onShowError: onShowError,
        )
        .whenComplete(() => super.isLoading = false);
    // super.isLoading = false;
    // print("####### after future api");
  }

  void reset() {
    _pageCount = null;
    _page = 0;
    _isAllCompleted = false;
    _list.clear();
  }

  bool computeIsCompleted(ListLoadOptionModel<IM>? model) {
    _pageCount = model?.pageCount;
    _page = model?.currentPage ?? 1;

    return _page >= (_pageCount ?? 0);
  }
}

class ListLoadOptionModel<IM> {
  int? totalCount;
  int? pageCount;
  int? currentPage;
  int? perPage;

  List<IM>? iList;

  ListLoadOptionModel({
    required this.totalCount,
    required this.pageCount,
    required this.currentPage,
    required this.perPage,
    required this.iList,
  });

  // factory ListLoadOptionModel.fromMeta(
  //     {required List<IM>? iList, required MetaModel? meta}) {
  //   return ListLoadOptionModel(
  //     totalCount: meta?.totalCount,
  //     pageCount: meta?.pageCount,
  //     currentPage: meta?.currentPage,
  //     perPage: meta?.perPage,
  //     iList: iList,
  //   );
  // }
}

class SimpleValueProvider<T> extends BaseProvider {
  T? _value;

  T? get value => _value;

  set value(T? val) {
    if (_value == val) return;
    _value = val;
    notifyListeners();
  }

  SimpleValueProvider({T? initialVal})
      : _value = initialVal,
        super();
}

/// The base api for list pagination
/// The [IM] can be the interface model
abstract class BaseListLoadMoreProvider1<IM> extends BaseProvider
    with MixinAPIProvider, MixinProgressProvider {
  final int _limit;
  final _list = <IM>[];

  BaseListLoadMoreProvider1({int limit = 6, String? name})
      : _limit = limit,
        super(name: name ?? "BaseListLoadMoreProvider");
  int _offset = 0;
  int _page = 1;
  bool _isAllCompleted = false;

  List<IM> get list => _list;

  int get limit => _limit;

  int get offset => _offset;

  int get page => _page;

  bool get canLoadMore => (!_isAllCompleted) && (!super.isLoading);

  set _addToList(List<IM>? value) {
    if (value?.isNotEmpty ?? false) {
      _list.clear();
      _list.addAll(value!);
    }
    notifyListeners();
  }

  Future<List<IM>> fetchAPIService();

  // Future<List<IM>> fetchAPIService();
  Future<ListLoadOptionModel<IM>?> fetchListData({
    required OnShowError onShowError,
    ValueChanged<List<IM>?>? onSuccess,
    VoidCallback? onInit,
  }) async {
    if (super.isLoading) return null;
    super.isLoading = true;

    // print("####### after onInit");
    // await Future.delayed(const Duration(seconds: 2));
    if (onInit != null) {
      onInit();
    }
    fetchAPIService()
        .then((models) {
          _isAllCompleted = models.length < _limit;
          _offset += models.length;
          _addToList = models;
          _page++;
          if (onSuccess != null) onSuccess(models);
          return models;
        })
        .handleAPIException(
          handleAPIException: handleAPIException,
          onShowError: onShowError,
        )
        .whenComplete(() => super.isLoading = false);
    return null;

    // super.isLoading = false;
    // print("####### after future api");
  }

  // void fetchListData({@required OnShowError onShowError}) {
  //   if (super.isLoading) return;
  //   super.isLoading = true;
  //   fetchAPIService()
  //       .then((models) {
  //         this._isAllCompleted = models.length < _limit;
  //         this._offset += models.length;
  //         this._addToList = models;
  //         this._page++;
  //       })
  //       .handleAPIException(
  //         handleAPIException: handleAPIException,
  //         onShowError: onShowError,
  //       )
  //       .coverWithProgress(this);
  // }

  void reset() {
    _offset = 0;
    _page = 1;
    _isAllCompleted = false;
    _list.clear();
  }
}

///create [NetworkSimpleLoader] object
///instead of creating a new [Provider] class in[repo]
class NetworkSimpleLoader<P> extends _BaseSimpleAPIProvider {
  Future<P> futureTask;
  NetworkSimpleLoader(this.futureTask);
  @override
  Future<P> apiService() {
    return futureTask;
  }
}

///create [NetworkListMoreLoader] object
///instead of creating a new [networkProvider]
///The [P] can be the data model
class NetworkListMoreLoader<P> extends _BaseListLoadMoreProvider {
  late final Future<ListLoadOptionModel<P>?> futureTask;
  NetworkListMoreLoader(this.futureTask);

  @override
  Future<ListLoadOptionModel?> apiService() {
    return futureTask;
  }
}
