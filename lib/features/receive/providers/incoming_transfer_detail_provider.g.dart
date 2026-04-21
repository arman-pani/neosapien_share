// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_transfer_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$incomingTransferDetailHash() =>
    r'00ce6c58c38d92590c97bdd2944992b497bcd0e4';

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

abstract class _$IncomingTransferDetail
    extends BuildlessAutoDisposeAsyncNotifier<IncomingTransfer?> {
  late final String transferId;

  FutureOr<IncomingTransfer?> build(String transferId);
}

/// Fetches a specific transfer by ID.
/// This is used as a fallback by the ReceiveScreen if the real-time listener
/// hasn't yet pushed the document to the client.
///
/// Copied from [IncomingTransferDetail].
@ProviderFor(IncomingTransferDetail)
const incomingTransferDetailProvider = IncomingTransferDetailFamily();

/// Fetches a specific transfer by ID.
/// This is used as a fallback by the ReceiveScreen if the real-time listener
/// hasn't yet pushed the document to the client.
///
/// Copied from [IncomingTransferDetail].
class IncomingTransferDetailFamily
    extends Family<AsyncValue<IncomingTransfer?>> {
  /// Fetches a specific transfer by ID.
  /// This is used as a fallback by the ReceiveScreen if the real-time listener
  /// hasn't yet pushed the document to the client.
  ///
  /// Copied from [IncomingTransferDetail].
  const IncomingTransferDetailFamily();

  /// Fetches a specific transfer by ID.
  /// This is used as a fallback by the ReceiveScreen if the real-time listener
  /// hasn't yet pushed the document to the client.
  ///
  /// Copied from [IncomingTransferDetail].
  IncomingTransferDetailProvider call(String transferId) {
    return IncomingTransferDetailProvider(transferId);
  }

  @override
  IncomingTransferDetailProvider getProviderOverride(
    covariant IncomingTransferDetailProvider provider,
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
  String? get name => r'incomingTransferDetailProvider';
}

/// Fetches a specific transfer by ID.
/// This is used as a fallback by the ReceiveScreen if the real-time listener
/// hasn't yet pushed the document to the client.
///
/// Copied from [IncomingTransferDetail].
class IncomingTransferDetailProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          IncomingTransferDetail,
          IncomingTransfer?
        > {
  /// Fetches a specific transfer by ID.
  /// This is used as a fallback by the ReceiveScreen if the real-time listener
  /// hasn't yet pushed the document to the client.
  ///
  /// Copied from [IncomingTransferDetail].
  IncomingTransferDetailProvider(String transferId)
    : this._internal(
        () => IncomingTransferDetail()..transferId = transferId,
        from: incomingTransferDetailProvider,
        name: r'incomingTransferDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$incomingTransferDetailHash,
        dependencies: IncomingTransferDetailFamily._dependencies,
        allTransitiveDependencies:
            IncomingTransferDetailFamily._allTransitiveDependencies,
        transferId: transferId,
      );

  IncomingTransferDetailProvider._internal(
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
  FutureOr<IncomingTransfer?> runNotifierBuild(
    covariant IncomingTransferDetail notifier,
  ) {
    return notifier.build(transferId);
  }

  @override
  Override overrideWith(IncomingTransferDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: IncomingTransferDetailProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<
    IncomingTransferDetail,
    IncomingTransfer?
  >
  createElement() {
    return _IncomingTransferDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IncomingTransferDetailProvider &&
        other.transferId == transferId;
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
mixin IncomingTransferDetailRef
    on AutoDisposeAsyncNotifierProviderRef<IncomingTransfer?> {
  /// The parameter `transferId` of this provider.
  String get transferId;
}

class _IncomingTransferDetailProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          IncomingTransferDetail,
          IncomingTransfer?
        >
    with IncomingTransferDetailRef {
  _IncomingTransferDetailProviderElement(super.provider);

  @override
  String get transferId =>
      (origin as IncomingTransferDetailProvider).transferId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
