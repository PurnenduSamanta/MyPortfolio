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

  ProjectDetailData get detail => _buildDetail();

  Future<void> openProject() async {
    final uri = Uri.parse(appItem.link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  ProjectDetailData _buildDetail() {
    final hasRealData = appItem.overview.isNotEmpty ||
        appItem.techStacks.isNotEmpty ||
        appItem.highlights.isNotEmpty;

    if (hasRealData) {
      return ProjectDetailData(
        summary: '${appItem.name} — Project Details',
        description: appItem.overview.isNotEmpty
            ? appItem.overview
            : 'Details for ${appItem.name} will be available soon.',
        techStack: appItem.techStacks.isNotEmpty
            ? appItem.techStacks
            : ['Not specified'],
        highlights: appItem.highlights.isNotEmpty
            ? appItem.highlights
            : ['More details coming soon.'],
        state: 'Live Project',
      );
    }

    // Fallback for projects without sheet data
    return _buildFallbackDetail(appItem.name);
  }

  ProjectDetailData _buildFallbackDetail(String projectName) {
    final stacks = [
      ['Flutter', 'Dart', 'Firebase', 'REST API'],
      ['Kotlin', 'Jetpack', 'Room DB', 'Material 3'],
      ['Flutter', 'Riverpod', 'SQLite', 'Cloud Sync'],
      ['Dart', 'Bloc', 'Node API', 'Analytics'],
    ];
    final hash = projectName.hashCode.abs();
    final stack = stacks[hash % stacks.length];

    return ProjectDetailData(
      summary: '$projectName — Product Preview',
      description:
          'This is a placeholder detail page for $projectName. Add Overview, TechStacks, and Highlights columns in the Google Sheet to show real content.',
      techStack: stack,
      highlights: const [
        'Focused on clean UI, stable performance, and responsive layout.',
        'Implements modular architecture for safe feature scaling.',
        'Data-driven project metadata will appear once sheet columns are filled.',
      ],
      state: 'Preview Mode · Add data in Google Sheet',
    );
  }
}
