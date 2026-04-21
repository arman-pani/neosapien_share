// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_transfer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeTransferHash() => r'6401328d72eafb128f37d02cd1dd1199f4b30116';

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

/// A combined provider that attempts to find a transfer in the active
/// incoming transfers stream first, and falls back to a direct fetch
/// if not found (e.g. following a deep link or FCM while sync is pending).
///
/// Copied from [activeTransfer].
@ProviderFor(activeTransfer)
const activeTransferProvider = ActiveTransferFamily();

/// A combined provider that attempts to find a transfer in the active
/// incoming transfers stream first, and falls back to a direct fetch
/// if not found (e.g. following a deep link or FCM while sync is pending).
///
/// Copied from [activeTransfer].
class ActiveTransferFamily extends Family<AsyncValue<IncomingTransfer?>> {
  /// A combined provider that attempts to find a transfer in the active
  /// incoming transfers stream first, and falls back to a direct fetch
  /// if not found (e.g. following a deep link or FCM while sync is pending).
  ///
  /// Copied from [activeTransfer].
  const ActiveTransferFamily();

  /// A combined provider that attempts to find a transfer in the active
  /// incoming transfers stream first, and falls back to a direct fetch
  /// if not found (e.g. following a deep link or FCM while sync is pending).
  ///
  /// Copied from [activeTransfer].
  ActiveTransferProvider call(String transferId) {
    return ActiveTransferProvider(transferId);
  }

  @override
  ActiveTransferProvider getProviderOverride(
    covariant ActiveTransferProvider provider,
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
  String? get name => r'activeTransferProvider';
}

/// A combined provider that attempts to find a transfer in the active
/// incoming transfers stream first, and falls back to a direct fetch
/// if not found (e.g. following a deep link or FCM while sync is pending).
///
/// Copied from [activeTransfer].
class ActiveTransferProvider
    extends AutoDisposeFutureProvider<IncomingTransfer?> {
  /// A combined provider that attempts to find a transfer in the active
  /// incoming transfers stream first, and falls back to a direct fetch
  /// if not found (e.g. following a deep link or FCM while sync is pending).
  ///
  /// Copied from [activeTransfer].
  ActiveTransferProvider(String transferId)
    : this._internal(
        (ref) => activeTransfer(ref as ActiveTransferRef, transferId),
        from: activeTransferProvider,
        name: r'activeTransferProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activeTransferHash,
        dependencies: ActiveTransferFamily._dependencies,
        allTransitiveDependencies:
            ActiveTransferFamily._allTransitiveDependencies,
        transferId: transferId,
      );

  ActiveTransferProvider._internal(
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
  Override overrideWith(
    FutureOr<IncomingTransfer?> Function(ActiveTransferRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveTransferProvider._internal(
        (ref) => create(ref as ActiveTransferRef),
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
  AutoDisposeFutureProviderElement<IncomingTransfer?> createElement() {
    return _ActiveTransferProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveTransferProvider && other.transferId == transferId;
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
mixin ActiveTransferRef on AutoDisposeFutureProviderRef<IncomingTransfer?> {
  /// The parameter `transferId` of this provider.
  String get transferId;
}

class _ActiveTransferProviderElement
    extends AutoDisposeFutureProviderElement<IncomingTransfer?>
    with ActiveTransferRef {
  _ActiveTransferProviderElement(super.provider);

  @override
  String get transferId => (origin as ActiveTransferProvider).transferId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
