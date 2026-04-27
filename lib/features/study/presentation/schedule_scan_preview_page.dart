import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../domain/providers/schedule_provider.dart';
import '../data/models/schedule_model.dart';

class ScheduleScanPreviewPage extends ConsumerStatefulWidget {
  const ScheduleScanPreviewPage({super.key});

  @override
  ConsumerState<ScheduleScanPreviewPage> createState() => _ScheduleScanPreviewPageState();
}

class _ScheduleScanPreviewPageState extends ConsumerState<ScheduleScanPreviewPage> 
    with SingleTickerProviderStateMixin {
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scannerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleNotifierProvider);
    
    if (state.isScanning) {
      if (!_scannerController.isAnimating) _scannerController.repeat(reverse: true);
    } else {
      _scannerController.stop();
    }

    if (state.selectedImage == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.black45,
            child: Icon(Icons.close, color: Colors.white),
          ),
          onPressed: () {
            ref.read(scheduleNotifierProvider.notifier).clearScan();
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // ── Image Preview Area ───────────────────────────────────────────
          Expanded(
            flex: state.ocrResult != null ? 2 : 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Hero(
                      tag: 'schedule_image',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          state.selectedImage!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                
                if (state.isScanning)
                  AnimatedBuilder(
                    animation: _scannerAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: 100 + (MediaQuery.of(context).size.height * 0.3 * _scannerAnimation.value),
                        left: 40,
                        right: 40,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0),
                                Colors.cyanAccent,
                                Colors.cyanAccent.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          // ── Bottom Info Card ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            child: _buildCardContent(state),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(ScheduleState state) {
    if (state.isScanning) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.cyan),
          const SizedBox(height: 24),
          const Text('Menganalisis...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('AI sedang membaca jadwalmu', style: TextStyle(color: Colors.grey[600])),
        ],
      );
    }

    if (state.ocrResult != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hasil Ekstraksi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
                child: Text('${state.ocrResult!.extractedSchedules.length} Jadwal', 
                  style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Short preview of subjects
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.ocrResult!.extractedSchedules.take(4).map((s) => Chip(
              label: Text(s.subject, style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[50],
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            )).toList(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: state.isSaving ? null : () {
                ref.read(scheduleNotifierProvider.notifier).saveSchedules();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(state.isSaving ? 'Menyimpan...' : 'Simpan Semua Jadwal'),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Siap Mengekstrak', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text('Ketuk tombol di bawah untuk mulai ekstraksi AI', 
          textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => ref.read(scheduleNotifierProvider.notifier).processImage(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Mulai Ekstrak AI 🚀', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
