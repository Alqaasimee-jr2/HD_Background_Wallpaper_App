## 2024-10-22 - Memoizing derived state in ChangeNotifier
**Learning:** High-level widgets use ListenableBuilder with ChangeNotifier. If a getter re-computes an expensive filtered list (like O(N) filtering) on every read, any notifyListeners() call (e.g. from an unrelated state change) will trigger a re-render and re-evaluation. This is a significant bottleneck.
**Action:** Always memoize expensive derived state (filtered lists, mapped values) in ChangeNotifier controllers. Invalidate the cache only when the underlying state that affects it changes.
