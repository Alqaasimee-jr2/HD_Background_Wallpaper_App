2024-05-20 - [ScrollController Attachment in IndexedStack], **Learning:** [When using multiple ScrollViews wrapped in an IndexedStack, they stay mounted in the widget tree. Assigning a single ScrollController to multiple mounted CustomScrollViews causes a state assertion error on scroll.], **Action:** [Provide unique ScrollControllers to each nested ScrollView inside an IndexedStack, or conditionally use them, then sync state through dedicated listeners.]


## 2025-05-18 - Memoize O(N) getters in ChangeNotifier with ListenableBuilder
**Learning:** `ListenableBuilder` triggers a full rebuild whenever `notifyListeners()` is called. If the `ChangeNotifier` contains O(N) getters (like filtering a large list of wallpapers based on search text or category), they will be re-evaluated on every rebuild (e.g. toggling a favorite icon) causing severe performance degradation.
**Action:** Always memoize expensive derived state (filtered lists, complex aggregates) in a private nullable cache variable within the `ChangeNotifier` controller, and invalidate (set to `null`) only when the source dependencies of that state change.
