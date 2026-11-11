import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../services/supabase_community_service.dart';

/// Kartu di halaman DetailPage untuk membuka Ruang Diskusi Komunitas (Powered by Supabase).
class DetailCommunityChatCard extends StatelessWidget {
  const DetailCommunityChatCard({
    super.key,
    required this.activityTitle,
    required this.clubName,
    required this.currentUserRole,
    required this.isJoined,
  });

  final String activityTitle;
  final String clubName;
  final String currentUserRole;
  final bool isJoined;

  void _openCommunityChatSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommunityChatBottomSheet(
        activityTitle: activityTitle,
        clubName: clubName,
        currentUserRole: currentUserRole,
        isJoined: isJoined,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.forum_rounded,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Flexible(
                            child: Text(
                              'Ruang Komunitas & Match Chat',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Diskusi bareng anggota $clubName, info lapangan & koordinasi posisi.',
                        style: const TextStyle(
                          color: AppColors.mutedText,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openCommunityChatSheet(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: BorderSide(
                    color: AppColors.secondary.withValues(alpha: 0.45),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: Text(
                  isJoined
                      ? 'Buka Diskusi Komunitas (Sebagai $currentUserRole)'
                      : 'Lihat & Gabung Diskusi Komunitas',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom Sheet Ruang Diskusi Komunitas yang terhubung ke Supabase.
class CommunityChatBottomSheet extends StatefulWidget {
  const CommunityChatBottomSheet({
    super.key,
    required this.activityTitle,
    required this.clubName,
    required this.currentUserRole,
    required this.isJoined,
  });

  final String activityTitle;
  final String clubName;
  final String currentUserRole;
  final bool isJoined;

  @override
  State<CommunityChatBottomSheet> createState() =>
      _CommunityChatBottomSheetState();
}

class _CommunityChatBottomSheetState extends State<CommunityChatBottomSheet> {
  final SupabaseCommunityService _service = SupabaseCommunityService.instance;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<CommunityChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    // Auto-sync berkala dari Supabase setiap 4 detik agar pesan anggota lain langsung masuk
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _loadMessages(silent: true),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (!silent) {
      setState(() => _isLoading = true);
    }

    final result = await _service.fetchMessages(widget.activityTitle);
    if (!mounted) return;

    final bool hasNewCount = result.length != _messages.length;
    setState(() {
      _messages = result;
      _isLoading = false;
    });

    if (!silent || hasNewCount) {
      _scrollToBottom();
    }
  }

  Future<void> _handleSend([String? presetMessage]) async {
    final text = (presetMessage ?? _messageController.text).trim();
    if (text.isEmpty || _isSending) return;

    if (presetMessage == null) {
      _messageController.clear();
    }

    setState(() => _isSending = true);

    final roleBadge = widget.isJoined ? widget.currentUserRole : 'Calon Peserta';
    await _service.sendMessage(
      activityTitle: widget.activityTitle,
      senderName: 'Daniel (Kamu)',
      senderRole: roleBadge,
      messageText: text,
    );

    final updated = await _service.fetchMessages(widget.activityTitle);
    if (!mounted) return;

    setState(() {
      _messages = updated;
      _isSending = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isCloud = _service.isCloudConnected;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Header Ruang Komunitas
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.groups_rounded,
                      color: AppColors.secondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.clubName,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.cloud_done_rounded,
                              size: 13,
                              color: isCloud
                                  ? AppColors.primary
                                  : AppColors.secondary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                isCloud
                                    ? 'Terhubung ke Supabase Cloud • ${widget.activityTitle}'
                                    : 'Supabase Hybrid Mode • ${widget.activityTitle}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.mutedText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Segarkan Pesan',
                    onPressed: () => _loadMessages(),
                    icon: const Icon(
                      Icons.sync_rounded,
                      color: AppColors.mutedText,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Banner Status Posisi Pengguna
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.primary.withValues(alpha: 0.08),
              child: Row(
                children: [
                  const Icon(
                    Icons.sports_handball_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.isJoined
                          ? 'Kamu bergabung sebagai "${widget.currentUserRole}". Badge posisimu tampil otomatis di chat!'
                          : 'Tips: Klik tombol "Ikut" di halaman detail agar badge posisi bermainmu tampil di chat.',
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Daftar Pesan Komunitas
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isMe = msg.senderName.contains('Daniel');
                        return _CommunityMessageBubble(
                          message: msg,
                          isMe: isMe,
                          formattedTime: _formatTime(msg.createdAt),
                        );
                      },
                    ),
            ),

            // Quick Status Chips (Status Cepat OTW / Sampai Lapangan)
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: SupabaseCommunityService.quickStatusMessages.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final statusText =
                      SupabaseCommunityService.quickStatusMessages[index];
                  return ActionChip(
                    onPressed:
                        _isSending ? null : () => _handleSend(statusText),
                    backgroundColor: AppColors.surface,
                    side: BorderSide(
                      color: AppColors.secondary.withValues(alpha: 0.35),
                    ),
                    label: Text(
                      statusText,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Input Chat
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              color: AppColors.surface,
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _handleSend(),
                        decoration: InputDecoration(
                          hintText: 'Kirim pesan ke anggota ${widget.clubName}...',
                          hintStyle: const TextStyle(
                            color: AppColors.mutedText,
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: _isSending ? null : () => _handleSend(),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                      ),
                      icon: _isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityMessageBubble extends StatelessWidget {
  const _CommunityMessageBubble({
    required this.message,
    required this.isMe,
    required this.formattedTime,
  });

  final CommunityChatMessage message;
  final bool isMe;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.80,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.senderName,
                  style: TextStyle(
                    color: isMe ? Colors.white : AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.22)
                        : message.isHost
                            ? AppColors.accent.withValues(alpha: 0.3)
                            : AppColors.secondary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    message.senderRole,
                    style: TextStyle(
                      color: isMe
                          ? Colors.white
                          : message.isHost
                              ? const Color(0xFF9A6B00)
                              : AppColors.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message.messageText,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.text,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedTime,
              style: TextStyle(
                color: isMe
                    ? Colors.white.withValues(alpha: 0.75)
                    : AppColors.mutedText,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
