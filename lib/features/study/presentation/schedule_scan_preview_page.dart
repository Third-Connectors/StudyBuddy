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
    
    // Start/stop scanner animation based on state
    if (state.isScanning) {
      if (!_scannerController.isAnimating) _scannerController.repeat(reverse: true);
    } else {
      _scannerController.stop();
    }

    if (state.selectedImage == null) {
      // If image is cleared, pop the page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Parallax Image Header ─────────────────────────────────────────
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.45,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black,
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
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // The Schedule Image
                  Hero(
                    tag: 'schedule_image',
                    child: Image.file(
                      state.selectedImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  // Scanner Overlay (only when scanning)
                  if (state.isScanning)
                    AnimatedBuilder(
                      animation: _scannerAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: MediaQuery.of(context).size.height * 0.45 * _scannerAnimation.value,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyanAccent.withOpacity(0.5),
                                  blurRadius: 15,
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
          ),

          // ── The Content Card ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: _buildMainContent(state),
              ),
            ),
          ),
          
          // Padding to allow scrolling past bottom buttons
          const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
        ],
      ),
    );
  }

  Widget _buildMainContent(ScheduleState state) {
    if (state.isScanning) {
      return Column(
        children: [
          const SizedBox(height: 20),
          const CircularProgressIndicator(color: Colors.cyan),
          const SizedBox(height: 32),
          const Text(
            'Menganalisis Jadwal...',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'AI sedang mengubah gambar menjadi jadwal digital',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 15),
          ),
          const SizedBox(height: 100),
        ],
      );
    }

    if (state.ocrResult != null) {
      return _buildResultsList(state, state.ocrResult!);
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.document_scanner_rounded, size: 56, color: Colors.cyan),
        ),
        const SizedBox(height: 24),
        const Text(
          'Siap Mengekstrak',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Text(
          'AI kami siap mendeteksi semua mata pelajaran, jam, dan lokasi dari foto jadwalmu.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: () => ref.read(scheduleNotifierProvider.notifier).processImage(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan[700],
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: Colors.cyan.withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              'Mulai Ekstrak AI 🚀',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsList(ScheduleState state, OcrResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hasil Ekstraksi AI',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  Text('Periksa kembali sebelum menyimpan', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Text(
                '${result.extractedSchedules.length} Jadwal',
                style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Results list (No separate scroll here, scroll is parent)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: result.extractedSchedules.length,
          itemBuilder: (context, index) {
            final schedule = result.extractedSchedules[index];
            return _buildResultCard(schedule);
          },
        ),
        
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton.icon(
            onPressed: state.isSaving
                ? null
                : () {
                    ref.read(scheduleNotifierProvider.notifier).saveSchedules();
                    Navigator.pop(context);
                  },
            icon: state.isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.check_circle_rounded),
            label: Text(state.isSaving ? 'Menyimpan...' : 'Simpan Semua Jadwal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: Colors.green.withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(ScheduleEntry schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              schedule.subjectCode.substring(0, 2).toUpperCase(),
              style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(schedule.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('HH:mm').format(schedule.startTime)} - ${DateFormat('HH:mm').format(schedule.endTime)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(schedule.location, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
