/// Firestore collection names and paths, defined once.
class FirestorePaths {
  const FirestorePaths._();

  static const users = 'users';
  static const workouts = 'workouts';
  static const weightEntries = 'weightEntries';
  static const waterLogs = 'waterLogs';

  static String user(String uid) => '$users/$uid';
  static String userWorkouts(String uid) => '${user(uid)}/$workouts';
  static String userWeightEntries(String uid) => '${user(uid)}/$weightEntries';
  static String userWaterLogs(String uid) => '${user(uid)}/$waterLogs';
}
