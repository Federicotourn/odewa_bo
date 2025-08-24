class CookieManager {
  static CookieManager manager = CookieManager.getInstance();

  static getInstance() {
    return manager;
  }

  void addCookie(String key, String value) {}

  void removeCookie(String name) {}
}
