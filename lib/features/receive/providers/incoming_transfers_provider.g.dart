// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_transfers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$incomingTransfersHash() => r'c71edd86d8f1242a64945c2158bd7d20656fb3c6';

/// Streams the live list of incoming "ready" transfers for the current user.
///
/// • Attaches a Firestore real-time listener on first build.
/// • Deduplicates across rebuilds: if a transferId has already been surfaced
///   this session, its notification is not re-fired.
/// • Automatically cancels the subscription when the provider is disposed.
///
/// Copied from [IncomingTransfers].
@ProviderFor(IncomingTransfers)
final incomingTransfersProvider =
    StreamNotifierProvider<IncomingTransfers, List<IncomingTransfer>>.internal(
      IncomingTransfers.new,
      name: r'incomingTransfersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$incomingTransfersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IncomingTransfers = StreamNotifier<List<IncomingTransfer>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
