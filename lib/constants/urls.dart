class Urls {
  static String baseUrl = 'http://127.0.0.1:3000/api';
  // static String baseUrl = 'https://api.paytonic.app/api';

  // Authentication endpoints
  static String authLogin = '$baseUrl/auth/login';
  static String authClientLogin = '$baseUrl/auth/client/login';

  // Backoffice endpoints
  static String backofficeUsers = '$baseUrl/backoffice/users';
  static String backofficeClients = '$baseUrl/backoffice/clients';
  static String backofficeRequests = '$baseUrl/backoffice/requests';

  // Companies endpoints
  static String companies = '$baseUrl/companies';

  // Requests endpoints
  static String requests = '$baseUrl/requests';
}
