## 2024-05-18 - [O(N) Lookups during UI Rebuilds]
**Learning:** `WallpaperController` performed expensive mapping over `allKnownWallpapers` to compute favorites and custom collections on every rebuild because of how `ListenableBuilder` triggers an update for the entire tree, which includes multiple nested calls.
**Action:** When a controller is heavily bound to UI rebuilds, extract static computations (maps, counts, curated sub-lists) into local variables/caches that only rebuild on data mutations (`initialize` or `import`), not on UI getter access.
