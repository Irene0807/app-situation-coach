import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class PageEvaluation extends StatelessWidget {
  const PageEvaluation({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = dummyEnglishAbilities.keys.toList();
    final scores = dummyEnglishAbilities.values.map((v) => v).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Speaking Skill Evaluation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 10, 49, 108),
            ),
          ),
          const SizedBox(height: 24),

          // 六邊形
          SizedBox(
            height: 250,
            child: RadarChart(
              ticks: const [20, 40, 60, 80, 100],
              features: labels,
              data: [scores],
              graphColors: const [Colors.teal],
              featuresTextStyle: const TextStyle(fontSize: 12),
              outlineColor: Colors.teal,
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Skill Breakdown',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // ✅ 能力值的進度條
          Expanded(
            child: ListView.builder(
              itemCount: labels.length,
              itemBuilder: (context, index) {
                final name = labels[index];
                final value = dummyEnglishAbilities[name]!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$name: ${value.toInt()}'),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: value / 100,
                        backgroundColor: Colors.grey[300],
                        color: Colors.teal,
                        minHeight: 8,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
