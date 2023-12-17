class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registration = '$_baseUrl/registration';
  static const String login = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';

  static String getNewTask(String taskStatus) =>
      '$_baseUrl/listTaskByStatus/$taskStatus';
  static const String getTaskStatusCount = '$_baseUrl/taskStatusCount';

  static String updateTaskStatus(String taskId, String status) =>
      '$_baseUrl/updateTaskStatus/$taskId/$status';

  static String deleteTask(String taskId) => '$_baseUrl/deleteTask/$taskId';
  static String recoverVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String pinVerification(String email, String opt) => '$_baseUrl/RecoverVerifyOTP/$email/$opt';
  static const String updateProfile = '$_baseUrl/profileUpdate';
}
