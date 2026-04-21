// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_download_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$receiveDownloadHash() => r'233223c2d77cdcefad548deec44da5de7d62aa01';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ReceiveDownload
    extends BuildlessAsyncNotifier<ReceiveDownloadState> {
  late final String transferId;

  FutureOr<ReceiveDownloadState> build(String transferId);
}

/// See also [ReceiveDownload].
@ProviderFor(ReceiveDownload)
const receiveDownloadProvider = ReceiveDownloadFamily();

/// See also [ReceiveDownload].
class ReceiveDownloadFamily extends Family<AsyncValue<ReceiveDownloadState>> {
  /// See also [ReceiveDownload].
  const ReceiveDownloadFamily();

  /// See also [ReceiveDownload].
  ReceiveDownloadProvider call(String transferId) {
    return ReceiveDownloadProvider(transferId);
  }

  @override
  ReceiveDownloadProvider getProviderOverride(
    covariant ReceiveDownloadProvider provider,
  ) {
    return call(provider.transferId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'receiveDownloadProvider';
}

/// See also [ReceiveDownload].
class ReceiveDownloadProvider
    extends AsyncNotifierProviderImpl<ReceiveDownload, ReceiveDownloadState> {
  /// See also [ReceiveDownload].
  ReceiveDownloadProvider(String transferId)
    : this._internal(
        () => ReceiveDownload()..transferId = transferId,
        from: receiveDownloadProvider,
        name: r'receiveDownloadProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$receiveDownloadHash,
        dependencies: ReceiveDownloadFamily._dependencies,
        allTransitiveDependencies:
            ReceiveDownloadFamily._allTransitiveDependencies,
        transferId: transferId,
      );

  ReceiveDownloadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.transferId,
  }) : super.internal();

  final String transferId;

  @override
  FutureOr<ReceiveDownloadState> runNotifierBuild(
    covariant ReceiveDownload notifier,
  ) {
    return notifier.build(transferId);
  }

  @override
  Override overrideWith(ReceiveDownload Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReceiveDownloadProvider._internal(
        () => create()..transferId = transferId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        transferId: transferId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<ReceiveDownload, ReceiveDownloadState>
  createElement() {
    return _ReceiveDownloadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReceiveDownloadProvider && other.transferId == transferId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, transferId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReceiveDownloadRef on AsyncNotifierProviderRef<ReceiveDownloadState> {
  /// The parameter `transferId` of this provider.
  String get transferId;
}

class _ReceiveDownloadProviderElement
    extends AsyncNotifierProviderElement<ReceiveDownload, ReceiveDownloadState>
    with ReceiveDownloadRef {
  _ReceiveDownloadProviderElement(super.provider);

  @override
  String get transferId => (origin as ReceiveDownloadProvider).transferId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
