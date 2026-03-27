// Mock data for ClientFlow Mobile - mirrors the web app's hardcoded data

class MockData {
  // === CLIENTS ===
  static List<Map<String, dynamic>> clients = [
    {'company': 'Acme Corp', 'contact': 'John Smith', 'email': 'john@acme.com', 'phone': '+1 555-0100', 'projects': 3, 'status': 'active', 'address': '123 Business Ave, Suite 100', 'since': 'March 2024', 'totalInvoiced': '\$24,200', 'totalPaid': '\$19,700', 'outstanding': '\$4,500'},
    {'company': 'TechStart Inc', 'contact': 'Sarah Johnson', 'email': 'sarah@techstart.io', 'phone': '+1 555-0101', 'projects': 2, 'status': 'active', 'address': '456 Startup Lane', 'since': 'January 2024', 'totalInvoiced': '\$18,500', 'totalPaid': '\$15,200', 'outstanding': '\$3,300'},
    {'company': 'Global Solutions', 'contact': 'Mike Chen', 'email': 'mike@globalsol.com', 'phone': '+1 555-0102', 'projects': 1, 'status': 'active', 'address': '789 Enterprise Blvd', 'since': 'February 2024', 'totalInvoiced': '\$12,800', 'totalPaid': '\$12,800', 'outstanding': '\$0'},
    {'company': 'Design Studio', 'contact': 'Emma Wilson', 'email': 'emma@designstudio.co', 'phone': '+1 555-0103', 'projects': 0, 'status': 'inactive', 'address': '101 Creative Way', 'since': 'November 2023', 'totalInvoiced': '\$8,400', 'totalPaid': '\$8,400', 'outstanding': '\$0'},
    {'company': 'Innovate Labs', 'contact': 'David Brown', 'email': 'david@innovatelabs.com', 'phone': '+1 555-0104', 'projects': 4, 'status': 'active', 'address': '202 Innovation Dr', 'since': 'December 2023', 'totalInvoiced': '\$31,000', 'totalPaid': '\$26,500', 'outstanding': '\$4,500'},
    {'company': 'CloudBridge', 'contact': 'Chris Lee', 'email': 'chris@cloudbridge.io', 'phone': '+1 555-0105', 'projects': 2, 'status': 'active', 'address': '303 Cloud St', 'since': 'April 2024', 'totalInvoiced': '\$9,600', 'totalPaid': '\$9,600', 'outstanding': '\$0'},
    {'company': 'PixelWave', 'contact': 'Mia Torres', 'email': 'mia@pixelwave.co', 'phone': '+1 555-0106', 'projects': 1, 'status': 'inactive', 'address': '404 Pixel Blvd', 'since': 'October 2023', 'totalInvoiced': '\$5,200', 'totalPaid': '\$5,200', 'outstanding': '\$0'},
  ];

  // === PROJECTS ===
  static List<Map<String, dynamic>> projects = [
    {'name': 'Website Redesign', 'client': 'Acme Corp', 'team': ['JD', 'SK', 'MW'], 'status': 'In Progress', 'deadline': 'Mar 15', 'progress': 0.75, 'tasksDone': 9, 'tasksTotal': 12, 'health': 'healthy', 'budget': '\$15,000'},
    {'name': 'Mobile App', 'client': 'TechStart Inc', 'team': ['JD', 'AB'], 'status': 'In Progress', 'deadline': 'Apr 20', 'progress': 0.45, 'tasksDone': 5, 'tasksTotal': 11, 'health': 'at-risk', 'budget': '\$22,000'},
    {'name': 'Brand Identity', 'client': 'Acme Corp', 'team': ['SK'], 'status': 'Completed', 'deadline': 'Feb 28', 'progress': 1.0, 'tasksDone': 8, 'tasksTotal': 8, 'health': 'healthy', 'budget': '\$8,000'},
    {'name': 'E-commerce Platform', 'client': 'Global Solutions', 'team': ['JD', 'SK', 'MW', 'AB'], 'status': 'Planning', 'deadline': 'May 10', 'progress': 0.10, 'tasksDone': 1, 'tasksTotal': 10, 'health': 'critical', 'budget': '\$35,000'},
    {'name': 'Dashboard UI', 'client': 'Innovate Labs', 'team': ['MW'], 'status': 'In Progress', 'deadline': 'Mar 25', 'progress': 0.60, 'tasksDone': 6, 'tasksTotal': 10, 'health': 'at-risk', 'budget': '\$12,000'},
    {'name': 'API Integration', 'client': 'TechStart Inc', 'team': ['AB'], 'status': 'Review', 'deadline': 'Mar 12', 'progress': 0.90, 'tasksDone': 7, 'tasksTotal': 8, 'health': 'healthy', 'budget': '\$6,500'},
  ];

  // === TASKS ===
  static List<Map<String, dynamic>> tasks = [
    {'task': 'Design homepage mockup', 'project': 'Website Redesign', 'assignee': 'SK', 'assigneeName': 'Sarah Kim', 'priority': 'High', 'status': 'In Progress', 'due': 'Mar 8', 'overdue': false},
    {'task': 'Implement header component', 'project': 'Website Redesign', 'assignee': 'JD', 'assigneeName': 'John Doe', 'priority': 'High', 'status': 'In Progress', 'due': 'Mar 5', 'overdue': true},
    {'task': 'API integration', 'project': 'Mobile App', 'assignee': 'AB', 'assigneeName': 'Anna Brown', 'priority': 'Medium', 'status': 'To Do', 'due': 'Mar 10', 'overdue': false},
    {'task': 'Final design review', 'project': 'Website Redesign', 'assignee': 'MW', 'assigneeName': 'Mike Wilson', 'priority': 'High', 'status': 'Review', 'due': 'Mar 8', 'overdue': false},
    {'task': 'Client presentation', 'project': 'Brand Identity', 'assignee': 'SK', 'assigneeName': 'Sarah Kim', 'priority': 'Medium', 'status': 'Completed', 'due': 'Feb 28', 'overdue': false},
    {'task': 'Database schema design', 'project': 'E-commerce Platform', 'assignee': 'JD', 'assigneeName': 'John Doe', 'priority': 'High', 'status': 'To Do', 'due': 'Mar 12', 'overdue': false},
    {'task': 'Write unit tests', 'project': 'Mobile App', 'assignee': 'MW', 'assigneeName': 'Mike Wilson', 'priority': 'Low', 'status': 'To Do', 'due': 'Mar 15', 'overdue': false},
  ];

  // === INVOICES ===
  static List<Map<String, dynamic>> invoices = [
    {'id': 'INV-0042', 'client': 'Acme Corp', 'project': 'Website Redesign', 'amount': '\$2,500', 'issue': 'Mar 1', 'due': 'Mar 15', 'status': 'paid'},
    {'id': 'INV-0041', 'client': 'TechStart Inc', 'project': 'Mobile App', 'amount': '\$1,800', 'issue': 'Feb 28', 'due': 'Mar 14', 'status': 'unpaid'},
    {'id': 'INV-0040', 'client': 'Global Solutions', 'project': 'E-commerce', 'amount': '\$4,200', 'issue': 'Feb 15', 'due': 'Mar 1', 'status': 'overdue'},
    {'id': 'INV-0039', 'client': 'Acme Corp', 'project': 'Brand Identity', 'amount': '\$3,200', 'issue': 'Feb 10', 'due': 'Feb 28', 'status': 'paid'},
    {'id': 'INV-0038', 'client': 'Innovate Labs', 'project': 'Dashboard UI', 'amount': '\$2,100', 'issue': 'Mar 5', 'due': 'Mar 20', 'status': 'unpaid'},
  ];

  // === TEAM ===
  static List<Map<String, dynamic>> team = [
    {'name': 'John Doe', 'email': 'john@clientflow.com', 'role': 'Admin', 'tasks': 12, 'projects': 8, 'score': 92, 'online': true},
    {'name': 'Sarah Kim', 'email': 'sarah@clientflow.com', 'role': 'Manager', 'tasks': 8, 'projects': 6, 'score': 88, 'online': true},
    {'name': 'Mike Wilson', 'email': 'mike@clientflow.com', 'role': 'Staff', 'tasks': 15, 'projects': 5, 'score': 85, 'online': false},
    {'name': 'Anna Brown', 'email': 'anna@clientflow.com', 'role': 'Staff', 'tasks': 6, 'projects': 4, 'score': 78, 'online': true},
    {'name': 'Chris Lee', 'email': 'chris@clientflow.com', 'role': 'Manager', 'tasks': 10, 'projects': 7, 'score': 90, 'online': false},
  ];

  // === PAYMENTS ===
  static List<Map<String, dynamic>> payments = [
    {'id': 'PAY-0089', 'invoice': 'INV-0042', 'amount': '\$2,500', 'method': 'Bank Transfer', 'date': 'Mar 10, 2025'},
    {'id': 'PAY-0088', 'invoice': 'INV-0039', 'amount': '\$3,200', 'method': 'Stripe', 'date': 'Feb 28, 2025'},
    {'id': 'PAY-0087', 'invoice': 'INV-0038', 'amount': '\$1,500', 'method': 'PayPal', 'date': 'Feb 20, 2025'},
    {'id': 'PAY-0086', 'invoice': 'INV-0037', 'amount': '\$2,800', 'method': 'Bank Transfer', 'date': 'Feb 15, 2025'},
    {'id': 'PAY-0085', 'invoice': 'INV-0036', 'amount': '\$4,100', 'method': 'Stripe', 'date': 'Feb 10, 2025'},
  ];

  // === NOTIFICATIONS ===
  static List<Map<String, dynamic>> notifications = [
    {'type': 'task', 'title': 'Task assigned to you', 'body': 'Design homepage mockup was assigned to you by John Doe.', 'time': '2 hours ago', 'unread': true},
    {'type': 'invoice', 'title': 'Invoice paid', 'body': 'INV-0042 for \$2,500 was paid by Acme Corp.', 'time': '1 day ago', 'unread': true},
    {'type': 'project', 'title': 'Project update', 'body': 'Website Redesign is now 75% complete.', 'time': '2 days ago', 'unread': false},
    {'type': 'task', 'title': 'Overdue task', 'body': 'Implement header component is overdue by 2 days.', 'time': '3 days ago', 'unread': false},
  ];

  // === ACTIVITIES ===
  static List<Map<String, dynamic>> activities = [
    {'event': 'Client created', 'detail': 'TechStart Inc', 'user': 'John Doe', 'time': '10 min ago'},
    {'event': 'Project updated', 'detail': 'Website Redesign · 75% complete', 'user': 'Mike Wilson', 'time': '2 hours ago'},
    {'event': 'Task completed', 'detail': 'Design homepage mockup', 'user': 'Sarah Kim', 'time': '3 hours ago'},
    {'event': 'Invoice paid', 'detail': 'INV-0042 · \$2,500', 'user': 'System', 'time': '1 day ago'},
    {'event': 'New project started', 'detail': 'Mobile App - TechStart Inc', 'user': 'John Doe', 'time': '2 days ago'},
    {'event': 'Client created', 'detail': 'Global Solutions', 'user': 'Anna Brown', 'time': '3 days ago'},
  ];

  // === AUTOMATION RULES ===
  static List<Map<String, dynamic>> automationRules = [
    {'name': 'Notify on overdue tasks', 'trigger': 'Task overdue > 3 days', 'condition': 'Priority is High or Critical', 'action': 'Notify project manager', 'enabled': true, 'runs': 24, 'lastRun': '2 hours ago', 'icon': '⚡'},
    {'name': 'Invoice reminder', 'trigger': 'Invoice unpaid after 7 days', 'condition': 'Amount > \$500', 'action': 'Send reminder email', 'enabled': true, 'runs': 12, 'lastRun': '1 day ago', 'icon': '💰'},
    {'name': 'Auto-generate invoice', 'trigger': 'Project completed', 'condition': 'Has billable hours', 'action': 'Generate final invoice', 'enabled': true, 'runs': 8, 'lastRun': '3 days ago', 'icon': '📄'},
    {'name': 'Project health alert', 'trigger': 'Health = Critical', 'condition': 'Always', 'action': 'Notify team + Slack', 'enabled': true, 'runs': 3, 'lastRun': '5 days ago', 'icon': '🔴'},
    {'name': 'Welcome new client', 'trigger': 'New client created', 'condition': 'Always', 'action': 'Send welcome email', 'enabled': false, 'runs': 15, 'lastRun': '1 week ago', 'icon': '👋'},
    {'name': 'Task completion', 'trigger': 'Status = Completed', 'condition': 'Active project', 'action': 'Update progress', 'enabled': true, 'runs': 56, 'lastRun': '4 hours ago', 'icon': '✅'},
  ];
}
