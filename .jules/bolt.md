2024-05-20 - [ScrollController Attachment in IndexedStack], **Learning:** [When using multiple ScrollViews wrapped in an IndexedStack, they stay mounted in the widget tree. Assigning a single ScrollController to multiple mounted CustomScrollViews causes a state assertion error on scroll.], **Action:** [Provide unique ScrollControllers to each nested ScrollView inside an IndexedStack, or conditionally use them, then sync state through dedicated listeners.]

## 2024-05-24 - [ListenableBuilder UI Rebuilds & Expensive O(N) Operations]
**Learning:** [Flutter's `ListenableBuilder` triggers a full screen rebuild on any `notifyListeners()` from its controller. Unrelated state changes, like `toggleFavorite`, will inadvertently force O(N) list filtering computations to re-run if not memoized, destroying performance on large lists.]
**Action:** [Memoize derived/filtered lists in the controller cache, and invalidate them ONLY in the specific setters that affect the filter constraints.]
