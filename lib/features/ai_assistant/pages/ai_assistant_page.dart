import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/widgets/custom_cached_network_image.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/ai_assistant/models/ai_assistant_models.dart';
import 'package:flutter_ecommerce/features/ai_assistant/repositories/ai_assistant_repository.dart';
import 'package:flutter_ecommerce/features/comparison/pages/comparison_page.dart';
import 'package:flutter_ecommerce/features/multi_retailer/models/retailer_product.dart';
import 'package:flutter_ecommerce/features/multi_retailer/widgets/product_redirect_button.dart';
import 'package:flutter_ecommerce/features/multi_retailer/widgets/retailer_badge.dart';
import 'package:gap/gap.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final _assistantRepo = sl<AIAssistantRepository>();
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  final List<String> _quickPrompts = [
    "iPhone under ₹70,000",
    "Sony noise cancelling headphones",
    "Best laptop for programming under 50k",
    "Fitness smartwatch with AMOLED",
  ];

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(
      ChatMessage(
        text: "👋 Hi! I'm your AI Shopping Assistant. Tell me what you're looking for, your budget, or specifications, and I'll find the best verified deals across Amazon India, Flipkart, Croma, and ShopWave!",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendPrompt([String? customText]) async {
    final text = (customText ?? _promptController.text).trim();
    if (text.isEmpty) return;

    _promptController.clear();
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });
    _scrollToBottom();

    final result = await _assistantRepo.sendPrompt(text);
    if (mounted) {
      setState(() {
        _isLoading = false;
        result.fold(
          (failure) => _messages.add(ChatMessage(
            text: "Sorry, I had trouble processing that request: ${failure.toString()}",
            isUser: false,
            timestamp: DateTime.now(),
          )),
          (aiResponse) => _messages.add(aiResponse),
        );
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 20),
            ),
            const Gap(10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ShopWave AI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Personal Shopping Assistant", style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick Prompt Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _quickPrompts.length,
              separatorBuilder: (_, __) => const Gap(8),
              itemBuilder: (context, i) {
                return ActionChip(
                  label: Text(_quickPrompts[i], style: const TextStyle(fontSize: 12)),
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  onPressed: () => _sendPrompt(_quickPrompts[i]),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg, theme);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  const Gap(10),
                  Text("Analyzing prices across retailer feeds...", style: TextStyle(color: theme.colorScheme.outline, fontSize: 12)),
                ],
              ),
            ),
          // Prompt Input Field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promptController,
                      onSubmitted: (_) => _sendPrompt(),
                      decoration: InputDecoration(
                        hintText: "E.g. Best ANC headphones under ₹30,000",
                        hintStyle: TextStyle(color: theme.colorScheme.outline, fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const Gap(8),
                  IconButton.filled(
                    onPressed: () => _sendPrompt(),
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, ThemeData theme) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16).copyWith(bottomRight: Radius.zero),
          ),
          child: Text(
            msg.text,
            style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 14),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16).copyWith(bottomLeft: Radius.zero),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Text(
                msg.text,
                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
              ),
            ),
            if (msg.recommendations.isNotEmpty) ...[
              const Gap(10),
              ...msg.recommendations.map((rec) => _buildRecommendationCard(rec, theme)),
            ],
            if (msg.explanation != null && msg.explanation!.isNotEmpty) ...[
              const Gap(6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: theme.colorScheme.outline),
                    const Gap(6),
                    Expanded(
                      child: Text(
                        msg.explanation!,
                        style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(RetailerProductModel rec, ThemeData theme) {
    final imgUrl = rec.imageUrls.isNotEmpty ? rec.imageUrls.first : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: AppCachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.cover),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RetailerBadge(retailerName: rec.retailer.name),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const Gap(2),
                              Text("${rec.rating}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const Gap(6),
                      Text(
                        rec.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const Gap(4),
                      Text(
                        "₹${rec.price.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (rec.recommendationReason != null) ...[
              const Gap(8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withAlpha(50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 14, color: theme.colorScheme.primary),
                    const Gap(6),
                    Expanded(
                      child: Text(
                        rec.recommendationReason!,
                        style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ComparisonPage(
                            productTitle: rec.title,
                            category: rec.category,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                    child: const Text("Compare Prices", style: TextStyle(fontSize: 12)),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: ProductRedirectButton(
                    url: rec.productUrl,
                    retailerName: rec.retailer.name,
                    isCompact: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
