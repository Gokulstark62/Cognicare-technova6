import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../nlp/tamil_ner.dart';
import '../nlp/ner_entity.dart';

class NlpTestScreen extends StatefulWidget {
  const NlpTestScreen({super.key});

  @override
  State<NlpTestScreen> createState() => _NlpTestScreenState();
}

class _NlpTestScreenState extends State<NlpTestScreen> {
  final _controller = TextEditingController(
    text: 'நாளை காலை 8 மணிக்கு மருந்து சாப்பிட வேண்டும்',
  );
  List<NerEntity> _entities = [];

  @override
  void initState() {
    super.initState();
    _run();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _run() {
    setState(() {
      _entities = TamilNer.extract(_controller.text);
    });
  }

  Color _colorFor(NerType type) {
    switch (type) {
      case NerType.date:
        return AppTheme.primary;
      case NerType.time:
        return AppTheme.amber;
      case NerType.person:
        return AppTheme.pink;
      case NerType.place:
        return AppTheme.teal;
      case NerType.task:
        return AppTheme.green;
      case NerType.number:
        return AppTheme.purple;
    }
  }

  IconData _iconFor(NerType type) {
    switch (type) {
      case NerType.date:
        return Icons.calendar_today;
      case NerType.time:
        return Icons.schedule;
      case NerType.person:
        return Icons.person;
      case NerType.place:
        return Icons.location_on;
      case NerType.task:
        return Icons.task_alt;
      case NerType.number:
        return Icons.numbers;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Tamil NER — Test'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type Tamil or English text:',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                maxLines: 4,
                style: const TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  hintText: 'நாளை காலை மருந்து...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _run,
                  icon: const Icon(Icons.search),
                  label: const Text('Extract Entities'),
                ),
              ),
              const SizedBox(height: 24),

              // Detected entities
              Text(
                'Detected (${_entities.length}):',
                style: GoogleFonts.nunito(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              if (_entities.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'No entities detected',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                )
              else
                ..._entities.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _colorFor(e.type).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _colorFor(e.type)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(_iconFor(e.type),
                                  color: _colorFor(e.type), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.value,
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${e.type.name}  '
                                    '[${
                                      e.startIndex}-${e.endIndex}]',
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}