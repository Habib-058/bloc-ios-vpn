import 'subscription_status_entity.dart';

class SubscriptionStatusResult {
  final bool isSubscribed;
  final SubscriptionStatus? subscriptionStatus;
  final String source; // 'server' or 'local'

  const SubscriptionStatusResult({
    required this.isSubscribed,
    this.subscriptionStatus,
    required this.source,
  });
}

