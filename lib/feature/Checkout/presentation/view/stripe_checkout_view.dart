import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// What [StripeCheckoutView] hands back when it closes.
/// 
/// مجرد صندوق صغير يحمل جواب: هل دُفع أو أُلغي.
class StripeCheckoutResult {
    final String? sessionId;
  final bool cancelled;
  // كونستركتر 1
  const StripeCheckoutResult.paid(this.sessionId) : cancelled = false;
    //2 كونستركتر 
  const StripeCheckoutResult.cancelled()
      : sessionId = null,
        cancelled = true;



  bool get isPaid => !cancelled;
}

/// Opens the Stripe hosted checkout page in a WebView and watches for the
/// backend's success / cancel redirect, handing the result back via [pop].
class StripeCheckoutView extends StatefulWidget {
  const StripeCheckoutView({super.key, required this.checkoutUrl});

  final String checkoutUrl;

  @override
  State<StripeCheckoutView> createState() => _StripeCheckoutViewState();
}

class _StripeCheckoutViewState extends State<StripeCheckoutView> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onNavigationRequest: _onNavigation,
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  NavigationDecision _onNavigation(NavigationRequest request) {
    final url = request.url;

    // The backend's redirect targets return raw JSON — intercept them instead
    // of letting the WebView render that, and close with the outcome.
    if (url.contains('/api/Checkout/success')) {
      final sessionId = Uri.parse(url).queryParameters['sessionId'];
      _finish(StripeCheckoutResult.paid(sessionId ?? ''));
      return NavigationDecision.prevent;
    }
    if (url.contains('/api/Checkout/cancel')) {
      _finish(const StripeCheckoutResult.cancelled());
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  void _finish(StripeCheckoutResult result) {
    if (_closed) return;
    _closed = true;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        // System back = the user backing out of payment.
        if (!didPop) _finish(const StripeCheckoutResult.cancelled());
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Payment',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.deepTeal,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.deepTeal),
            onPressed: () => _finish(const StripeCheckoutResult.cancelled()),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
