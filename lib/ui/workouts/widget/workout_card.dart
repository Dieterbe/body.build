import 'package:bodybuild/model/workouts/workout.dart' as model;
import 'package:bodybuild/ui/datetime.dart';
import 'package:bodybuild/ui/workouts/page/workouts_screen.dart';
import 'package:bodybuild/ui/workouts/widget/workout_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutCard extends ConsumerStatefulWidget {
  const WorkoutCard(this.workout, {super.key});

  final model.Workout workout;

  @override
  ConsumerState<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends ConsumerState<WorkoutCard> {
  final GlobalKey<PopupMenuButtonState<String>> _popupMenuKey =
      GlobalKey<PopupMenuButtonState<String>>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: widget.workout.isActive ? Theme.of(context).colorScheme.primaryContainer : null,
      child: ListTile(
        onTap: () => context.go('/${WorkoutsScreen.routeName}/${widget.workout.id}'),
        onLongPress: () => _popupMenuKey.currentState?.showButtonMenu(),
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: widget.workout.isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '${widget.workout.sets.length}',
            style: TextStyle(
              color: widget.workout.isActive
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          widget.workout.isActive
              ? 'Resume Active Workout'
              : formatHumanDateTimeMinutely(widget.workout.startTime),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: widget.workout.isActive
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${widget.workout.sets.length} sets • ${widget.workout.exerciseIds.length} exercises',
              style: TextStyle(
                color: widget.workout.isActive
                    ? Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                    : null,
              ),
            ),
            Text('Duration: ${formatHumanDuration2(widget.workout.duration)}'),
            if (widget.workout.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                widget.workout.notes!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: WorkoutPopupMenu(widget.workout, menuKey: _popupMenuKey),
      ),
    );
  }
}
