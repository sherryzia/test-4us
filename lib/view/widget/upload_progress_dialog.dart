import 'package:flutter/material.dart';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/view/widget/my_text_widget.dart';

class UploadProgressDialog extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String statusText;
  final String? fileName;
  final String? fileSize;
  final bool isCompleted;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const UploadProgressDialog({
    Key? key,
    required this.progress,
    required this.statusText,
    this.fileName,
    this.fileSize,
    this.isCompleted = false,
    this.hasError = false,
    this.errorMessage,
    this.onCancel,
    this.onRetry,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isCompleted || hasError,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError 
                ? Colors.red 
                : isCompleted 
                  ? Colors.green 
                  : kSecondaryColor, 
              width: 2
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasError 
                    ? Colors.red.withOpacity(0.2)
                    : isCompleted 
                      ? Colors.green.withOpacity(0.2)
                      : kSecondaryColor.withOpacity(0.2),
                ),
                child: Center(
                  child: hasError
                    ? const Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Colors.red,
                      )
                    : isCompleted
                      ? const Icon(
                          Icons.check_circle_outline,
                          size: 40,
                          color: Colors.green,
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 4,
                                backgroundColor: Colors.white24,
                                valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                              ),
                            ),
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 24,
                              color: kPrimaryColor,
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Status Text
              MyText(
                text: hasError 
                  ? 'Upload Failed' 
                  : isCompleted 
                    ? 'Upload Successful!' 
                    : 'Uploading Video...',
                size: 18,
                color: hasError 
                  ? Colors.red 
                  : isCompleted 
                    ? Colors.green 
                    : kPrimaryColor,
                weight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // File Info
              if (fileName != null) ...[
                MyText(
                  text: fileName!,
                  size: 14,
                  color: kPrimaryColor.withOpacity(0.8),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (fileSize != null) ...[
                  const SizedBox(height: 4),
                  MyText(
                    text: fileSize!,
                    size: 12,
                    color: kPrimaryColor.withOpacity(0.6),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
              ],
              
              // Progress Bar (only when uploading)
              if (!isCompleted && !hasError) ...[
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white24,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Progress Percentage
                MyText(
                  text: '${(progress * 100).toStringAsFixed(1)}%',
                  size: 16,
                  color: kPrimaryColor,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
              
              // Status Message
              MyText(
                text: hasError 
                  ? (errorMessage ?? 'An error occurred during upload')
                  : isCompleted 
                    ? 'Your video has been uploaded successfully!'
                    : statusText,
                size: 14,
                color: hasError 
                  ? Colors.red.withOpacity(0.8)
                  : kPrimaryColor.withOpacity(0.8),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              if (hasError) ...[
                Row(
                  children: [
                    if (onCancel != null) ...[
                      Expanded(
                        child: _buildActionButton(
                          text: 'Cancel',
                          onTap: onCancel!,
                          isPrimary: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: _buildActionButton(
                        text: 'Retry',
                        onTap: onRetry ?? () {},
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ] else if (isCompleted) ...[
                _buildActionButton(
                  text: 'Done',
                  onTap: onClose ?? () {},
                  isPrimary: true,
                ),
              ] else ...[
                // Cancel button during upload
                if (onCancel != null)
                  _buildActionButton(
                    text: 'Cancel Upload',
                    onTap: onCancel!,
                    isPrimary: false,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          gradient: isPrimary
            ? const LinearGradient(
                colors: [kSecondaryColor, kPurpleColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
          color: isPrimary ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: isPrimary 
            ? null 
            : Border.all(color: kPrimaryColor.withOpacity(0.5), width: 1),
        ),
        child: Center(
          child: MyText(
            text: text,
            size: 16,
            color: isPrimary ? Colors.white : kPrimaryColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Helper function to show upload progress dialog
void showUploadProgressDialog(
  BuildContext context, {
  required double progress,
  required String statusText,
  String? fileName,
  String? fileSize,
  bool isCompleted = false,
  bool hasError = false,
  String? errorMessage,
  VoidCallback? onCancel,
  VoidCallback? onRetry,
  VoidCallback? onClose,
}) {
  showDialog(
    context: context,
    barrierDismissible: isCompleted || hasError,
    builder: (context) => UploadProgressDialog(
      progress: progress,
      statusText: statusText,
      fileName: fileName,
      fileSize: fileSize,
      isCompleted: isCompleted,
      hasError: hasError,
      errorMessage: errorMessage,
      onCancel: onCancel,
      onRetry: onRetry,
      onClose: onClose,
    ),
  );
}