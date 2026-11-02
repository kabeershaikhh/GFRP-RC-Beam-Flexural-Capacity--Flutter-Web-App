import 'package:flutter/material.dart';
import '../models/beam_input.dart';
import '../models/prediction_response.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/footer_view.dart';
import '../widgets/header_banner.dart';
import '../widgets/input_console.dart';
import '../widgets/results_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _engineService = const ApiService();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _resultsKey = GlobalKey();

  BeamInput _currentInput = BeamInput.standardDefault();
  PredictionResponse? _predictionResponse;
  bool _isLoading = false;
  String? _validationError;

  Future<void> _handleCalculate(BeamInput input) async {
    setState(() {
      _isLoading = true;
      _validationError = null;
      _currentInput = input;
    });

    // Immediately scroll to results view
    _scrollToResults();

    try {
      final response = await _engineService.predictCapacity(input);
      if (mounted) {
        setState(() {
          _predictionResponse = response;
          _isLoading = false;
        });
        _scrollToResults();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _validationError = e.toString();
        });
        _scrollToTop();
      }
    }
  }

  /// Automatically scrolls to results:
  /// - On Desktop (>900px): Smoothly scrolls page back up to top (offset 0) so the
  ///   Hero Card, AI vs ACI values, and badges are in full view.
  /// - On Mobile/Tablet (<=900px): Smoothly scrolls down to the Results Dashboard.
  void _scrollToResults() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final isDesktop = MediaQuery.of(context).size.width > 900;
      if (isDesktop) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
          );
        }
      } else {
        final ctx = _resultsKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            alignment: 0.0,
          );
        }
      }
    });
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Context Banner
            const HeaderBanner(),

            // Main Body Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1320),
                        child: LayoutBuilder(
                          builder: (context, screenConstraints) {
                            final isMobile = screenConstraints.maxWidth < 600;

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 12 : 20,
                                vertical: isMobile ? 14 : 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Optional Validation Alert Banner
                                  if (_validationError != null) ...[
                                    _buildValidationBanner(),
                                    const SizedBox(height: 16),
                                  ],

                                  // Responsive Layout: 2-column on desktop (>900px), single on mobile
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final isDesktop = constraints.maxWidth > 900;

                                      if (isDesktop) {
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Left Column: Input Console (45% width)
                                        Expanded(
                                          flex: 45,
                                          child: InputConsole(
                                            initialInput: _currentInput,
                                            isLoading: _isLoading,
                                            onCalculate: _handleCalculate,
                                            onInputChange: (inp) {
                                              setState(() => _currentInput = inp);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 24),

                                        // Right Column: Engineering Results Dashboard (55% width)
                                        Expanded(
                                          flex: 55,
                                          child: KeyedSubtree(
                                            key: _resultsKey,
                                            child: ResultsDashboard(
                                              response: _predictionResponse,
                                              currentInput: _currentInput,
                                              isLoading: _isLoading,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    // Mobile / Tablet: Stacked layout
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        InputConsole(
                                          initialInput: _currentInput,
                                          isLoading: _isLoading,
                                          onCalculate: _handleCalculate,
                                          onInputChange: (inp) {
                                            setState(() => _currentInput = inp);
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        KeyedSubtree(
                                          key: _resultsKey,
                                          child: ResultsDashboard(
                                            response: _predictionResponse,
                                            currentInput: _currentInput,
                                            isLoading: _isLoading,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Academic Citation & Conference Footer
                    const FooterView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.hazardRoseBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.hazardRoseBorder, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.hazardRose, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Input Limit Alert',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF991B1B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _validationError!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7F1D1D),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: Color(0xFF991B1B)),
            onPressed: () => setState(() => _validationError = null),
          ),
        ],
      ),
    );
  }
}
