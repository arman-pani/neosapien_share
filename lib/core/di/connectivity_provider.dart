import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

@riverpod
class ConnectivityResults extends _$ConnectivityResults {
  @override
  Stream<List<ConnectivityResult>> build() {
    return Connectivity().onConnectivityChanged;
  }
}
