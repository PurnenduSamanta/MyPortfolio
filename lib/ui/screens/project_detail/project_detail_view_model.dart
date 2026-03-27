import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_portfolio/data/model/app_item.dart';

class ProjectDetailData {
  final String summary;
  final String description;
  final List<String> techStack;
  final List<String> highlights;
  final String state;

  const ProjectDetailData({
    required this.summary,
    required this.description,
    required this.techStack,
    required this.highlights,
    required this.state,
  });
}

class ProjectDetailViewModel extends ChangeNotifier {
  final AppItem appItem;

  ProjectDetailViewModel({required this.appItem});

  ProjectDetailData get detail => _buildDummyDetail(appItem.name);

  Future<void> openProject() async {
    final uri = Uri.parse(appItem.link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  ProjectDetailData _buildDummyDetail(String projectName) {
    final stacks = [
      ['Flutter', 'Dart', 'Firebase', 'REST API'],
      ['Kotlin', 'Jetpack', 'Room DB', 'Material 3'],
      ['Flutter', 'Riverpod', 'SQLite', 'Cloud Sync'],
      ['Dart', 'Bloc', 'Node API', 'Analytics'],
    ];
    final hash = projectName.hashCode.abs();
    final stack = stacks[hash % stacks.length];

    return ProjectDetailData(
      summary: '$projectName - Product Preview',
      description:
          'This is a placeholder detail page for $projectName. Later this section will be driven by Google Sheets data so each project can show real context before redirecting.',
      techStack: stack,
      highlights: const [
        'Focused on clean UI, stable performance, and responsive layout behavior.',
        'Implements modular architecture so features can scale safely over time.',
        'Ready for data-driven project metadata from external sheet configuration.',
      ],
      state: 'Preview Mode · Dummy Content',
    );
  }
}
