import 'package:firebase_auth/firebase_auth.dart' as firebase;

class User {
  const User({required this.uid});
  factory User.fromFirebaseUser(firebase.User user) => User(uid: user.uid);

  ///[User]'s unique id.
  final String uid;
  @override
  bool operator ==(Object other) => other is User && other.uid == uid;

  @override
  int get hashCode => Object.hashAll([uid]);
}
