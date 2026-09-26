mixin LoggerMixin {
  void log(String message) {
    print('Log: $message');
  }
}

class User {
  final String id;
  final String name;
  final String? email;

  const User({
    required this.id,
    required this.name,
    this.email,
  });

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }

  void displayInfo() {
    print('User Info: $this');
  }
}

class Admin extends User with LoggerMixin {
  final String role;

  const Admin({
    required super.id,
    required super.name,
    super.email,
    required this.role,
  });

  @override
  String toString() {
    return 'Admin(id: $id, name: $name, email: $email, role: $role)';
  }

  void displayInfo() {
    log('Displaying admin info');
    print('Admin Info: $this');
  }
}

void main() {
  final user = User(id: '1', name: 'Finn Vu', email: 'finnVu@example.com');
  final admin = Admin(id: '2', name: 'John Doe', email: 'john.doe@example.com', role: 'Admin');

  user.displayInfo();
  admin.displayInfo();
}
