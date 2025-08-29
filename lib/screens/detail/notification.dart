import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required bool isRead,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isRead ? Colors.white : const Color(0xFFF4E4BC).withOpacity(0.3),
        border: Border.all(
          color: isRead ? Colors.grey.withOpacity(0.2) : const Color(0xFFF3B950).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: iconColor != null 
                        ? [iconColor, iconColor.withOpacity(0.8)]
                        : [const Color(0xFFF3B950), const Color(0xFFE8A63C)],
                    ),
                    borderRadius: BorderRadius.circular(22.5),
                    boxShadow: [
                      BoxShadow(
                        color: (iconColor ?? const Color(0xFFF3B950)).withOpacity(0.3),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3B950),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedNotification(Widget child, double delay) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E4BC),
      body: Column(
        children: [
          // Header Section
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF3B950),
                    Color(0xFFE8A63C),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x40000000),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Top navigation
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'Notification',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Mark all as read functionality
                              setState(() {
                                // Update all notifications to read
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Mark All Read',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Notification summary
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '3 pesan belum terbaca',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Notifications List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Today Section
                  _buildAnimatedNotification(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Hari Ini',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _buildNotificationItem(
                          icon: Icons.work,
                          title: 'Order Baru Tersedia',
                          message: 'Ada pekerjaan tukang listrik di daerah Yogyakarta. Segera ambil sebelum terlambat!',
                          time: '5 menit yang lalu',
                          isRead: false,
                          iconColor: Colors.green,
                          onTap: () {
                            // Navigate to order detail
                          },
                        ),

                        _buildNotificationItem(
                          icon: Icons.payment,
                          title: 'Pembayaran Diterima',
                          message: 'Pembayaran sebesar Rp 150.000 telah diterima untuk pekerjaan kemarin.',
                          time: '1 jam yang lalu',
                          isRead: false,
                          iconColor: Colors.blue,
                          onTap: () {
                            // Navigate to payment detail
                          },
                        ),

                        _buildNotificationItem(
                          icon: Icons.star,
                          title: 'Review Baru',
                          message: 'Anda mendapat review 5 bintang dari pelanggan. Pertahankan kualitas kerja!',
                          time: '3 jam yang lalu',
                          isRead: false,
                          iconColor: Colors.orange,
                          onTap: () {
                            // Navigate to reviews
                          },
                        ),
                      ],
                    ),
                    0.2,
                  ),

                  const SizedBox(height: 30),

                  // Yesterday Section
                  _buildAnimatedNotification(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Kemarin',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildNotificationItem(
                          icon: Icons.check_circle,
                          title: 'Pekerjaan Selesai',
                          message: 'Pekerjaan tukang kayu di Jl. Malioboro telah selesai dan mendapat konfirmasi.',
                          time: 'Kemarin, 18:30',
                          isRead: true,
                          iconColor: Colors.green.shade600,
                          onTap: () {
                            // Navigate to completed job
                          },
                        ),

                        _buildNotificationItem(
                          icon: Icons.message,
                          title: 'Pesan Baru',
                          message: 'Pelanggan mengirim pesan tentang detail pekerjaan yang akan datang.',
                          time: 'Kemarin, 14:20',
                          isRead: true,
                          iconColor: Colors.purple,
                          onTap: () {
                            // Navigate to chat
                          },
                        ),

                        _buildNotificationItem(
                          icon: Icons.schedule,
                          title: 'Pengingat Jadwal',
                          message: 'Jangan lupa! Anda memiliki janji kerja besok pagi pukul 08:00.',
                          time: 'Kemarin, 10:15',
                          isRead: true,
                          iconColor: Colors.red,
                          onTap: () {
                            // Navigate to schedule
                          },
                        ),
                      ],
                    ),
                    0.4,
                  ),

                  const SizedBox(height: 30),

                  // This Week Section
                  _buildAnimatedNotification(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Minggu Ini',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildNotificationItem(
                          icon: Icons.verified,
                          title: 'Akun Terverifikasi',
                          message: 'Selamat! Akun Anda telah berhasil diverifikasi dan siap menerima order.',
                          time: '3 hari yang lalu',
                          isRead: true,
                          iconColor: Colors.blue.shade600,
                          onTap: () {
                            // Navigate to profile verification
                          },
                        ),

                        _buildNotificationItem(
                          icon: Icons.update,
                          title: 'Update Aplikasi',
                          message: 'Rampungin.id versi 2.1 tersedia! Update untuk mendapat fitur terbaru.',
                          time: '5 hari yang lalu',
                          isRead: true,
                          iconColor: Colors.indigo,
                          onTap: () {
                            // Navigate to app update
                          },
                        ),
                      ],
                    ),
                    0.6,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}