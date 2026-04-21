// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_upload_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sendUploadHash() => r'5b3151f4c920268675415f396477ab487a96cfc7';

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

abstract class _$SendUpload extends BuildlessAsyncNotifier<SendUploadState> {
  late final String transferId;

  FutureOr<SendUploadState> build(String transferId);
}

/// See also [SendUpload].
@ProviderFor(SendUpload)
const sendUploadProvider = SendUploadFamily();

/// See also [SendUpload].
class SendUploadFamily extends Family<AsyncValue<SendUploadState>> {
  /// See also [SendUpload].
  const SendUploadFamily();

  /// See also [SendUpload].
  SendUploadProvider call(String transferId) {
    return SendUploadProvider(transferId);
  }

  @override
  SendUploadProvider getProviderOverride(
    covariant SendUploadProvider provider,
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
  String? get name => r'sendUploadProvider';
}

/// See also [SendUpload].
class SendUploadProvider
    extends AsyncNotifierProviderImpl<SendUpload, SendUploadState> {
  /// See also [SendUpload].
  SendUploadProvider(String transferId)
    : this._internal(
        () => SendUpload()..transferId = transferId,
        from: sendUploadProvider,
        name: r'sendUploadProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sendUploadHash,
        dependencies: SendUploadFamily._dependencies,
        allTransitiveDependencies: SendUploadFamily._allTransitiveDependencies,
        transferId: transferId,
      );

  SendUploadProvider._internal(
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
  FutureOr<SendUploadState> runNotifierBuild(covariant SendUpload notifier) {
    return notifier.build(transferId);
  }

  @override
  Override overrideWith(SendUpload Function() create) {
    return ProviderOverride(
      origin: this,
      override: SendUploadProvider._internal(
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
  AsyncNotifierProviderElement<SendUpload, SendUploadState> createElement() {
    return _SendUploadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SendUploadProvider && other.transferId == transferId;
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
mixin SendUploadRef on AsyncNotifierProviderRef<SendUploadState> {
  /// The parameter `transferId` of this provider.
  String get transferId;
}

class _SendUploadProviderElement
    extends AsyncNotifierProviderElement<SendUpload, SendUploadState>
    with SendUploadRef {
  _SendUploadProviderElement(super.provider);

  @override
  String get transferId => (origin as SendUploadProvider).transferId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
