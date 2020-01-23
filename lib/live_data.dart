class LiveData {
  static String code;
  static String favoriteLanguage;
  static String token;
  static String phone;

  //static const String SERVER_URL = 'https://iview.host/ar/api/';
  static const String STORAGE_PATH = 'https://iview.host/uploads/videos/';

  static String get serverUrl {
    if (favoriteLanguage == 'ar') {
      return 'https://iview.host/ar/api/';
    }
    return 'https://iview.host/en/api/';
  }
}
