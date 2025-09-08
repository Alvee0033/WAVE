import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CollaboratePage extends StatefulWidget {
  const CollaboratePage({super.key});

  @override
  State<CollaboratePage> createState() => _CollaboratePageState();
}

class _CollaboratePageState extends State<CollaboratePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<CollaborationSession> _sessions = [
    CollaborationSession(
      id: '1',
      name: 'Climate Research Team',
      participants: 8,
      isActive: true,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
      host: 'Dr. Sarah Johnson',
      topic: 'Arctic Temperature Analysis',
    ),
    CollaborationSession(
      id: '2',
      name: 'Environmental Monitoring',
      participants: 12,
      isActive: true,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 15)),
      host: 'Prof. Michael Chen',
      topic: 'Deforestation Patterns',
    ),
    CollaborationSession(
      id: '3',
      name: 'Wildfire Response Team',
      participants: 5,
      isActive: false,
      lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
      host: 'Alex Rodriguez',
      topic: 'California Fire Analysis',
    ),
  ];

  final List<Annotation> _annotations = [
    Annotation(
      id: '1',
      author: 'Dr. Sarah Johnson',
      content: 'Notice the temperature spike in this region',
      location: 'Arctic Circle',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      type: AnnotationType.text,
    ),
    Annotation(
      id: '2',
      author: 'Prof. Michael Chen',
      content: 'Significant forest loss detected here',
      location: 'Amazon Basin',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      type: AnnotationType.highlight,
    ),
    Annotation(
      id: '3',
      author: 'Alex Rodriguez',
      content: 'Fire perimeter marked',
      location: 'California, USA',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: AnnotationType.shape,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Main content area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildMainContent(),
                  ),
                ],
              ),
            ),
          ),
          // Right sidebar with chat and participants
          _buildRightSidebar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.modernCardDecoration(),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.secondaryColor, AppTheme.primaryColor],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Multi-User Collaboration',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Real-time collaboration with shared annotations and live cursors',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCollaborationStats(),
                  ],
                ),
              ),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollaborationStats() {
    final activeSessions = _sessions.where((s) => s.isActive).length;
    final totalParticipants = _sessions.fold(0, (sum, s) => sum + s.participants);

    return Row(
      children: [
        _buildStatCard('Active Sessions', activeSessions.toString(), AppTheme.primaryColor),
        const SizedBox(width: 16),
        _buildStatCard('Participants', totalParticipants.toString(), AppTheme.secondaryColor),
        const SizedBox(width: 16),
        _buildStatCard('Annotations', _annotations.length.toString(), AppTheme.accentColor),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$value $label',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _buildActionButton(Icons.add, 'New Session'),
        const SizedBox(width: 12),
        _buildActionButton(Icons.video_call, 'Start Meeting'),
        const SizedBox(width: 12),
        _buildActionButton(Icons.share, 'Share Session'),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: IconButton(
          onPressed: () {
            // Handle action
          },
          icon: Icon(
            icon,
            color: AppTheme.textSecondaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Row(
      children: [
        // Sessions list
        Expanded(
          flex: 2,
          child: _buildSessionsList(),
        ),
        const SizedBox(width: 24),
        // Annotations list
        Expanded(
          flex: 1,
          child: _buildAnnotationsList(),
        ),
      ],
    );
  }

  Widget _buildSessionsList() {
    return Container(
      decoration: AppTheme.modernCardDecoration(),
      child: Column(
        children: [
          _buildSessionsHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final session = _sessions[index];
                return _buildSessionCard(session);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Active Sessions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              _createNewSession();
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('New Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(CollaborationSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: session.isActive 
              ? AppTheme.primaryColor.withOpacity(0.2)
              : AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: session.isActive ? AppTheme.successColor : AppTheme.textSecondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  session.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              _buildStatusBadge(session.isActive),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            session.topic,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.people, '${session.participants} participants'),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.person, session.host),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Last activity: ${_formatTimestamp(session.lastActivity)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const Spacer(),
              if (session.isActive)
                ElevatedButton(
                  onPressed: () {
                    _joinSession(session);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Join'),
                )
              else
                OutlinedButton(
                  onPressed: () {
                    _viewSession(session);
                  },
                  child: const Text('View'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive 
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.textSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive 
              ? AppTheme.successColor.withOpacity(0.3)
              : AppTheme.textSecondaryColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'INACTIVE',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isActive ? AppTheme.successColor : AppTheme.textSecondaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.borderColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnotationsList() {
    return Container(
      decoration: AppTheme.modernCardDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.borderColor, width: 1),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'Recent Annotations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.edit,
                  color: AppTheme.textSecondaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _annotations.length,
              itemBuilder: (context, index) {
                final annotation = _annotations[index];
                return _buildAnnotationCard(annotation);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnotationCard(Annotation annotation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getAnnotationColor(annotation.type),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  annotation.author,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Text(
                _formatTimestamp(annotation.timestamp),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            annotation.content,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            annotation.location,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: const Border(
          left: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          _buildParticipantsSection(),
          _buildChatSection(),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Participants (8)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildParticipantCard('Dr. Sarah Johnson', 'Host', true),
          _buildParticipantCard('Prof. Michael Chen', 'Co-host', true),
          _buildParticipantCard('Alex Rodriguez', 'Participant', true),
          _buildParticipantCard('Dr. Emma Wilson', 'Participant', false),
          _buildParticipantCard('James Liu', 'Participant', true),
        ],
      ),
    );
  }

  Widget _buildParticipantCard(String name, String role, bool isOnline) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                name.split(' ').map((n) => n[0]).join(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? AppTheme.successColor : AppTheme.textSecondaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Chat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildChatMessage('Dr. Sarah Johnson', 'What do you think about this temperature pattern?', DateTime.now().subtract(const Duration(minutes: 5))),
                          _buildChatMessage('Prof. Michael Chen', 'The spike is quite significant. Let me check the historical data.', DateTime.now().subtract(const Duration(minutes: 3))),
                          _buildChatMessage('Alex Rodriguez', 'I can see the correlation with the wind patterns.', DateTime.now().subtract(const Duration(minutes: 1))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.borderColor, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppTheme.borderColor),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              // Handle send message
                            },
                            icon: const Icon(Icons.send, color: AppTheme.primaryColor),
                          ),
                        ],
                      ),
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

  Widget _buildChatMessage(String author, String message, DateTime timestamp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                author,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatTimestamp(timestamp),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAnnotationColor(AnnotationType type) {
    switch (type) {
      case AnnotationType.text:
        return AppTheme.primaryColor;
      case AnnotationType.highlight:
        return AppTheme.warningColor;
      case AnnotationType.shape:
        return AppTheme.accentColor;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _createNewSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Session'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Session Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('New session created successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _joinSession(CollaborationSession session) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joining session: ${session.name}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _viewSession(CollaborationSession session) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing session: ${session.name}'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }
}

class CollaborationSession {
  final String id;
  final String name;
  final int participants;
  final bool isActive;
  final DateTime lastActivity;
  final String host;
  final String topic;

  CollaborationSession({
    required this.id,
    required this.name,
    required this.participants,
    required this.isActive,
    required this.lastActivity,
    required this.host,
    required this.topic,
  });
}

class Annotation {
  final String id;
  final String author;
  final String content;
  final String location;
  final DateTime timestamp;
  final AnnotationType type;

  Annotation({
    required this.id,
    required this.author,
    required this.content,
    required this.location,
    required this.timestamp,
    required this.type,
  });
}

enum AnnotationType {
  text,
  highlight,
  shape,
}

