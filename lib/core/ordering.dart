/// Position for an item placed between [before] and [after] (either may be null at the ends).
double positionBetween(double? before, double? after) {
  if (before == null && after == null) return 1;
  if (before == null) return after! - 1;
  if (after == null) return before + 1;
  return (before + after) / 2;
}

/// Moves an item like ReorderableListView.onReorder does and returns its new position value.
/// [positions] are the current positions in display order.
({int index, double position, bool needsNormalize}) reorderPosition(List<double> positions, int oldIndex, int newIndex) {
  if (newIndex > oldIndex) newIndex -= 1;
  final rest = [...positions]..removeAt(oldIndex);
  final before = newIndex > 0 ? rest[newIndex - 1] : null;
  final after = newIndex < rest.length ? rest[newIndex] : null;
  final pos = positionBetween(before, after);
  final tight = before != null && after != null && (after - before).abs() < 1e-6;
  return (index: newIndex, position: pos, needsNormalize: tight);
}
