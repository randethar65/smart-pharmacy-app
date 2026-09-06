import 'package:flutter/material.dart';

/// A single [NavigatorState] key shared with [MaterialApp]. It lets code that
/// has no [BuildContext] (interceptors, services) push routes — e.g. sending
/// the user back to Login when the session dies.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
