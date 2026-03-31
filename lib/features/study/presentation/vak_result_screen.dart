import 'package:flutter/material.dart';

import '../data/models/vak_model.dart';

/// VAK Result Screen - Display learning style assessment results.
class VakResultScreen extends StatelessWidget {
  final VakResult result;

  const VakResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final dominantStyle = result.dominantStyle;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Text(dominantStyle.icon, style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text(
                  'Gaya Belajarmu:',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  dominantStyle.displayName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Score breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Skor Kamu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  _buildScoreBar(context, 'Visual', result.visualScore, '👁️'),
                  const SizedBox(height: 12),
                  _buildScoreBar(
                    context,
                    'Auditory',
                    result.auditoryScore,
                    '👂',
                  ),
                  const SizedBox(height: 12),
                  _buildScoreBar(
                    context,
                    'Kinesthetic',
                    result.kinestheticScore,
                    '✋',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Description
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apa artinya ini?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dominantStyle.description,
                    style: const TextStyle(fontSize: 15, height: 1.6),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Tips
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tips Belajar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._getTipsForStyle(dominantStyle).map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 16)),
                          Expanded(child: Text(tip)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Recalibrate option
                    _showRecalibrateDialog(context);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tes Ulang'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check),
                  label: const Text('Selesai'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildScoreBar(
    BuildContext context,
    String label,
    double score,
    String icon,
  ) {
    final percentage = (score * 100).round();
    final isMax =
        (label == 'Visual' && result.dominantStyle == VakStyle.visual) ||
        (label == 'Auditory' && result.dominantStyle == VakStyle.auditory) ||
        (label == 'Kinesthetic' &&
            result.dominantStyle == VakStyle.kinesthetic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$icon $label',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMax
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: score,
            minHeight: 10,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              isMax ? Theme.of(context).primaryColor : Colors.grey[400]!,
            ),
          ),
        ),
      ],
    );
  }

  List<String> _getTipsForStyle(VakStyle style) {
    switch (style) {
      case VakStyle.visual:
        return [
          'Gunakan mind map dan diagram untuk mencatat',
          'Tonton video pembelajaran di YouTube',
          'Beri warna berbeda untuk setiap topik',
          'Gunakan flashcard dengan gambar',
          'Duduk di depan kelas agar jelas melihat papan tulis',
        ];

      case VakStyle.auditory:
        return [
          'Rekam penjelasan guru dan dengarkan ulang',
          'Diskusi dengan teman belajar',
          'Baca catatan dengan suara keras',
          'Dengarkan podcast edukasi',
          'Ajarkan materi ke orang lain',
        ];

      case VakStyle.kinesthetic:
        return [
          'Belajar sambil bergerak atau berjalan',
          'Lakukan eksperimen dan praktik langsung',
          'Gunakan benda fisik untuk memahami konsep',
          'Ambil istirahat singkat setiap 30 menit',
          'Tulis ulang catatan untuk mengingat',
        ];
    }
  }

  void _showRecalibrateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tes Ulang?'),
        content: const Text(
          'Kamu bisa tes ulang untuk melihat perubahan gaya belajarmu. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to assessment
              Navigator.pop(context);
            },
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );
  }
}
