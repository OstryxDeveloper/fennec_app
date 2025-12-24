# Container-Specific Media Upload Update

## What Changed

The media gallery system now supports **container-specific media addition and removal**. When you tap a container to add media, it goes directly into that specific position. When you delete, it removes from that exact container.

---

## Key Updates

### 1. **ImagePickerCubit** — Container Index Support

All pick methods now accept an optional `containerIndex` parameter:

```dart
// Pick images and add to container at index 0
Future<void> pickImagesFromGallery({int? containerIndex}) async {
  // ...
  final newItem = MediaItem(...);

  if (containerIndex != null && containerIndex < maxMediaItems) {
    if (containerIndex < mediaList.length) {
      mediaList[containerIndex] = newItem;  // Replace existing
    } else {
      mediaList.add(newItem);  // Append
    }
  }
}

// Same for:
pickVideoFromGallery({int? containerIndex})
pickImageFromCamera({int? containerIndex})
```

### 2. **removeMedia Method** — Index-Based Removal

```dart
void removeMedia(String? id, {int? index}) {
  if (id != null) {
    mediaList.removeWhere((item) => item.id == id);
  } else if (index != null && index >= 0 && index < mediaList.length) {
    mediaList.removeAt(index);  // Remove by position
  }
  emit(ImagePickerLoaded(mediaList: mediaList));
}
```

---

## Usage Flow

### **Adding Media to Container 2**

```
User taps Container 2
  ↓
_showMediaPickerOptions(context, cubit, containerIndex: 2)
  ↓
User picks image
  ↓
cubit.pickImagesFromGallery(containerIndex: 2)
  ↓
mediaList[2] = newItem
  ↓
BlocBuilder rebuilds
  ↓
Image appears in Container 2
```

### **Removing from Container 2**

```
User taps delete on Container 2
  ↓
cubit.removeMedia(media!.id, index: 2)
  ↓
mediaList.removeAt(2)
  ↓
BlocBuilder rebuilds
  ↓
Container 2 becomes empty
```

---

## Files Updated

1. **imagepicker_cubit.dart**
   - Added `containerIndex` parameter to all pick methods
   - Updated `removeMedia()` to support both ID and index removal
2. **kyc_gallery_screen.dart**

   - Pass `containerIndex` when calling `_showMediaPickerOptions()`
   - Updated all 6 container calls: `containerIndex: 0`, `containerIndex: 1`, etc.
   - Updated method signature: `_showMediaPickerOptions(BuildContext, ImagePickerCubit, {int? containerIndex})`
   - Pass `containerIndex` to cubit methods in bottom sheet options

3. **media_container_widget.dart**
   - Updated delete button to pass `index` parameter: `cubit.removeMedia(media!.id, index: index)`

---

## Design Benefits

✅ **Precise Control** — Media goes exactly where tapped, not just appended to list  
✅ **Quick Replacement** — Tap container → pick new image → immediately replaces existing one  
✅ **Drag Still Works** — Reordering via drag-and-drop still functions normally  
✅ **Clean Deletion** — Delete removes from exact position, container stays in grid

---

## Example Behavior

**Initial State (2 items)**:

```
[Image1] [Image2] [Empty]
[Empty] [Empty] [Empty]
```

**User taps Container 5 (bottom right) → picks video**:

```
[Image1] [Image2] [Empty]
[Empty] [Empty] [Video3]
```

**User taps delete on Container 1 (top left)**:

```
[Empty] [Image2] [Empty]
[Empty] [Empty] [Video3]
```

**User drags Image2 to Container 1**:

```
[Image2] [Empty] [Empty]
[Empty] [Empty] [Video3]
```

---

## Testing

1. Tap Container 0 → Pick image → Should appear in position 0
2. Tap Container 5 → Pick video → Should appear in position 5
3. Tap delete on Container 2 → Should remove only that position
4. Drag Container 0 to Container 3 → Should reorder correctly
5. Tap empty Container → Can still add media there

All interactions now maintain **index-position integrity** throughout the gallery.
