import 'package:flutter/material.dart';
import 'package:omni_for_pyload/core/utils/format_utils.dart';
import 'package:openapi_client/api.dart';

/// Widget that displays the overview tab with active downloads.
class OverviewTab extends StatelessWidget {
  final List<DownloadInfo> downloads;
  final String? error;

  const OverviewTab({required this.downloads, this.error, super.key});

  Color _getStatusColor(DownloadStatus status) {
    if (status == DownloadStatus.WAITING) {
      return const Color(0xFFF0AD4E);
    } else if (status == DownloadStatus.STARTING) {
      return const Color(0xFF5BC0DE);
    } else if (status == DownloadStatus.DOWNLOADING) {
      return const Color(0xFF5CB85C);
    } else if (status == DownloadStatus.PROCESSING) {
      return const Color(0xFF337AB7);
    } else {
      return const Color(0xFF777777);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return _buildErrorUI(context);
    }

    if (downloads.isEmpty) {
      return const Center(child: Text('No active downloads'));
    }

    return ListView.builder(
      itemCount: downloads.length,
      itemBuilder: (context, index) {
        final download = downloads[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Download name
                  Text(
                    download.name,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Row with size downloaded, percentage, and total size
                  Row(
                    children: [
                      // Left-aligned: size downloaded
                      Expanded(
                        child: Text(
                          formatBytes(download.size - download.bleft),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      // Center-aligned: percentage
                      Expanded(
                        child: Center(
                          child: Text(
                            '${download.percent}%',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      // Right-aligned: total size
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            formatBytes(download.size),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  LinearProgressIndicator(
                    value: download.percent / 100,
                    minHeight: 6,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue[400] ?? Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row with status chip and speed
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left-aligned: status chip
                      Chip(
                        label: Text(
                          download.statusmsg,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: _getStatusColor(download.status),
                      ),
                      const Spacer(),
                      // Right-aligned: speed
                      Chip(
                        label: Text(
                          '${(formatBytes(download.speed))}/s',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        backgroundColor: Theme.of(context)
                            .scaffoldBackgroundColor,
                        shape: const StadiumBorder(
                          side: BorderSide(style: BorderStyle.none),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (index < downloads.length - 1)
              Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
          ],
        );
      },
    );
  }

  Widget _buildErrorUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}
