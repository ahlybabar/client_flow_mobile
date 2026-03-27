import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/metric_card.dart';
import '../../data/mock_data.dart';
import '../invoices/invoices_screen.dart';

class MoreScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onToggleTheme;
  final bool isDark;

  const MoreScreen({super.key, required this.onLogout, required this.onToggleTheme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        actions: [
          IconButton(
            icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User profile card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const AvatarCircle(initials: 'JD', size: 48, bgColor: Colors.white24),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('John Doe', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                  Text('Admin · john@clientflow.com', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                ])),
                const Icon(Icons.chevron_right, color: Colors.white54),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Menu sections
          _sectionTitle('Work'),
          _menuItem(context, Icons.receipt_long_outlined, 'Invoices', '${MockData.invoices.length} total', () => _pushScreen(context, const InvoicesScreen())),
          _menuItem(context, Icons.folder_outlined, 'Projects', '${MockData.projects.length} total', () => _pushScreen(context, _ProjectsScreen())),
          _menuItem(context, Icons.payments_outlined, 'Payments', '5 recent', () => _pushScreen(context, _PaymentsScreen())),
          const SizedBox(height: 16),

          _sectionTitle('Management'),
          _menuItem(context, Icons.group_outlined, 'Team', '${MockData.team.length} members', () => _pushScreen(context, _TeamScreen())),
          _menuItem(context, Icons.bar_chart_outlined, 'Analytics', 'Financial & ops', () => _pushScreen(context, _AnalyticsScreen())),
          _menuItem(context, Icons.bolt_outlined, 'Automation', '${MockData.automationRules.length} rules', () => _pushScreen(context, _AutomationScreen())),
          const SizedBox(height: 16),

          _sectionTitle('Other'),
          _menuItem(context, Icons.notifications_outlined, 'Notifications', '${MockData.notifications.where((n) => n['unread'] == true).length} unread', () => _pushScreen(context, _NotificationsScreen())),
          _menuItem(context, Icons.timeline_outlined, 'Activity', 'Recent events', () => _pushScreen(context, _ActivityScreen())),
          _menuItem(context, Icons.settings_outlined, 'Settings', 'Profile & prefs', () => _pushScreen(context, _SettingsScreen(onToggleTheme: onToggleTheme, isDark: dark))),
          const SizedBox(height: 24),

          // Logout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, color: AppColors.danger, size: 20),
              label: const Text('Sign Out', style: TextStyle(color: AppColors.danger)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: AppColors.danger.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _pushScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1)),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: dark ? AppColors.darkCardBg : AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ])),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// ===================== PROJECTS SCREEN =====================
class _ProjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Health summary
          Row(children: [
            _healthChip('Healthy', '3', AppColors.success),
            const SizedBox(width: 8),
            _healthChip('At Risk', '2', AppColors.warning),
            const SizedBox(width: 8),
            _healthChip('Critical', '1', AppColors.danger),
          ]),
          const SizedBox(height: 16),
          ...MockData.projects.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: dark ? AppColors.darkCardBg : AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(p['name'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                _healthBadge(p['health'] as String),
              ]),
              const SizedBox(height: 4),
              Text(p['client'] as String, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 10),
              ProgressBar(progress: (p['progress'] as double), color: _healthColor(p['health'] as String)),
              const SizedBox(height: 6),
              Row(children: [
                Text('${((p['progress'] as double) * 100).toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _healthColor(p['health'] as String))),
                const Spacer(),
                Text('${p['tasksDone']}/${p['tasksTotal']} tasks', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(width: 12),
                Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(p['deadline'] as String, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                ...(p['team'] as List<String>).take(3).map((t) => Padding(padding: const EdgeInsets.only(right: 4), child: AvatarCircle(initials: t, size: 24, bgColor: AppColors.primary))),
                const Spacer(),
                Text(p['budget'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _healthChip(String label, String count, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(children: [
        Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: color)),
      ]),
    ));
  }

  Widget _healthBadge(String health) {
    switch (health) {
      case 'healthy': return StatusBadge.healthy();
      case 'at-risk': return StatusBadge.atRisk();
      default: return StatusBadge.critical();
    }
  }

  Color _healthColor(String health) {
    switch (health) {
      case 'healthy': return AppColors.success;
      case 'at-risk': return AppColors.warning;
      default: return AppColors.danger;
    }
  }
}

// ===================== PAYMENTS SCREEN =====================
class _PaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), childAspectRatio: 1.5,
            children: const [
              MetricCard(label: 'Total Revenue', value: '\$84,200', trend: '+18%', icon: Icons.trending_up, color: AppColors.primary),
              MetricCard(label: 'Outstanding', value: '\$12,300', trend: '-5%', isPositive: false, icon: Icons.schedule, color: AppColors.warning),
              MetricCard(label: 'This Month', value: '\$14,100', trend: '+12%', icon: Icons.today, color: AppColors.success),
              MetricCard(label: 'Failed', value: '\$320', trend: '-2%', icon: Icons.error_outline, color: AppColors.danger),
            ],
          ),
          const SizedBox(height: 20),
          Text('Payment History', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          ...MockData.payments.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: dark ? AppColors.darkCardBg : AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.check_circle_outline, size: 20, color: AppColors.success),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(p['id'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(p['amount'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.success)),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  Text(p['method'] as String, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const Spacer(),
                  Text(p['date'] as String, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ]),
              ])),
            ]),
          )),
        ],
      ),
    );
  }
}

// ===================== TEAM SCREEN =====================
class _TeamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Team')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...MockData.team.map((m) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: dark ? AppColors.darkCardBg : AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Row(children: [
              Stack(children: [
                AvatarCircle(initials: m['name'].toString().split(' ').map((s) => s[0]).join(), size: 44, bgColor: AppColors.primary),
                Positioned(right: 0, bottom: 0, child: Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    color: m['online'] == true ? AppColors.success : AppColors.textMuted,
                    shape: BoxShape.circle,
                    border: Border.all(color: dark ? AppColors.darkCardBg : AppColors.cardBg, width: 2),
                  ),
                )),
              ]),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(m['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  StatusBadge(
                    label: m['role'] as String,
                    color: m['role'] == 'Admin' ? AppColors.primary : (m['role'] == 'Manager' ? AppColors.info : AppColors.textSecondary),
                    bgColor: m['role'] == 'Admin' ? AppColors.primaryLight : (m['role'] == 'Manager' ? AppColors.infoLight : AppColors.hoverBg),
                  ),
                ]),
                const SizedBox(height: 4),
                Text(m['email'] as String, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Row(children: [
                  Text('${m['tasks']} tasks · ${m['projects']} projects', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const Spacer(),
                  SizedBox(width: 60, child: ProgressBar(progress: (m['score'] as int) / 100, color: (m['score'] as int) > 85 ? AppColors.success : AppColors.warning)),
                  const SizedBox(width: 6),
                  Text('${m['score']}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: (m['score'] as int) > 85 ? AppColors.success : AppColors.warning)),
                ]),
              ])),
            ]),
          )),
        ],
      ),
    );
  }
}

// ===================== ANALYTICS SCREEN =====================
class _AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Financial', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), childAspectRatio: 1.5,
            children: const [
              MetricCard(label: 'Monthly Revenue', value: '\$24,500', trend: '+18%', icon: Icons.trending_up, color: AppColors.primary),
              MetricCard(label: 'Avg Invoice', value: '\$2,850', trend: '+5%', icon: Icons.receipt, color: AppColors.success),
              MetricCard(label: 'Revenue/Client', value: '\$4,210', trend: '+8%', icon: Icons.person, color: AppColors.info),
              MetricCard(label: 'Client LTV', value: '\$18,400', trend: '+12%', icon: Icons.star, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 20),
          Text('Operational', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), childAspectRatio: 1.5,
            children: const [
              MetricCard(label: 'Task Velocity', value: '32/wk', trend: '+15%', icon: Icons.speed, color: AppColors.primary),
              MetricCard(label: 'Delivery Time', value: '4.2 days', trend: '-8%', icon: Icons.timer, color: AppColors.success),
              MetricCard(label: 'Utilization', value: '78%', trend: '+3%', icon: Icons.trending_up, color: AppColors.warning),
              MetricCard(label: 'New Clients', value: '12/mo', trend: '+25%', icon: Icons.person_add, color: AppColors.info),
            ],
          ),
          const SizedBox(height: 20),
          // Revenue chart placeholder
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: dark ? AppColors.darkCardBg : AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Revenue Trends', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('Last 6 months performance', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              Center(child: Icon(Icons.show_chart, size: 48, color: AppColors.primary.withValues(alpha: 0.3))),
              const Spacer(),
              Center(child: Text('Charts available on Dashboard', style: TextStyle(fontSize: 12, color: AppColors.textMuted))),
            ]),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ===================== AUTOMATION SCREEN =====================
class _AutomationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Automation')),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            _statChip('6', 'Total', AppColors.textPrimary, dark),
            const SizedBox(width: 8),
            _statChip('5', 'Active', AppColors.success, dark),
            const SizedBox(width: 8),
            _statChip('118', 'Runs', AppColors.primary, dark),
            const SizedBox(width: 8),
            _statChip('~32h', 'Saved', AppColors.warning, dark),
          ]),
          const SizedBox(height: 16),
          ...MockData.automationRules.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: dark ? AppColors.darkCardBg : AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(r['icon'] as String, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(child: Text(r['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: r['enabled'] == true ? AppColors.successLight : AppColors.hoverBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(r['enabled'] == true ? 'Active' : 'Paused', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: r['enabled'] == true ? AppColors.success : AppColors.textMuted)),
                ),
              ]),
              const SizedBox(height: 10),
              _flowPill('⚡ When', r['trigger'] as String, AppColors.warningLight, const Color(0xFF92400E)),
              const SizedBox(height: 4),
              _flowPill('⚙ If', r['condition'] as String, AppColors.primaryLight, const Color(0xFF3730A3)),
              const SizedBox(height: 4),
              _flowPill('✓ Then', r['action'] as String, AppColors.successLight, const Color(0xFF166534)),
              const SizedBox(height: 8),
              Text('${r['runs']} runs · Last: ${r['lastRun']}', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _statChip(String value, String label, Color color, bool dark) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: dark ? AppColors.darkCardBg : AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ]),
    ));
  }

  Widget _flowPill(String prefix, String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text('$prefix: $text', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: fg)),
    );
  }
}

// ===================== NOTIFICATIONS SCREEN =====================
class _NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [TextButton(onPressed: () {}, child: const Text('Mark all read'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: MockData.notifications.map((n) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: n['unread'] == true ? AppColors.primaryLight.withValues(alpha: 0.3) : (dark ? AppColors.darkCardBg : AppColors.cardBg),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: n['type'] == 'task' ? AppColors.primaryLight : (n['type'] == 'invoice' ? AppColors.successLight : AppColors.warningLight),
                shape: BoxShape.circle,
              ),
              child: Icon(
                n['type'] == 'task' ? Icons.task_alt : (n['type'] == 'invoice' ? Icons.payments : Icons.folder),
                size: 18,
                color: n['type'] == 'task' ? AppColors.primary : (n['type'] == 'invoice' ? AppColors.success : AppColors.warning),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(n['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(n['body'] as String, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(n['time'] as String, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ])),
            if (n['unread'] == true) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
          ]),
        )).toList(),
      ),
    );
  }
}

// ===================== ACTIVITY SCREEN =====================
class _ActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: MockData.activities.map((a) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: dark ? AppColors.darkCardBg : AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.bolt, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(a['event'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(a['detail'] as String, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text('${a['user']} · ${a['time']}', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ])),
          ]),
        )).toList(),
      ),
    );
  }
}

// ===================== SETTINGS SCREEN =====================
class _SettingsScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const _SettingsScreen({required this.onToggleTheme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Account'),
          _settingTile('Profile', 'Manage your personal info', Icons.person_outline, dark),
          _settingTile('Security', 'Password & authentication', Icons.lock_outline, dark),
          const SizedBox(height: 16),
          _sectionTitle('Preferences'),
          _toggleSetting('Dark Mode', 'Toggle dark/light theme', Icons.dark_mode_outlined, isDark, onToggleTheme, dark),
          _settingTile('Language', 'English (US)', Icons.language, dark),
          _settingTile('Time Zone', 'Pacific Time', Icons.access_time, dark),
          const SizedBox(height: 16),
          _sectionTitle('Workspace'),
          _settingTile('General', 'Company settings', Icons.business_outlined, dark),
          _settingTile('Team', 'Manage team members', Icons.group_outlined, dark),
          _settingTile('Billing', 'Plans & payment', Icons.credit_card_outlined, dark),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1)),
    );
  }

  Widget _settingTile(String title, String subtitle, IconData icon, bool dark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: dark ? AppColors.darkCardBg : AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Row(children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ])),
        const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
      ]),
    );
  }

  Widget _toggleSetting(String title, String subtitle, IconData icon, bool value, VoidCallback onChanged, bool dark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: dark ? AppColors.darkCardBg : AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Row(children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ])),
        Switch(value: value, onChanged: (_) => onChanged(), activeTrackColor: AppColors.primary),
      ]),
    );
  }
}
