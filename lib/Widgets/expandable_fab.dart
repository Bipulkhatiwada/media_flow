import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_bloc.dart';
import 'package:media_flow/bloc/MusicBloc/musicPlayer_state.dart';

class ExpandableFab extends StatefulWidget {
  final void Function() onAddFiles;
  final void Function() onShuffle;

  const ExpandableFab({
    super.key,
    required this.onAddFiles,
    required this.onShuffle,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget _buildButton(
      {required VoidCallback onPressed,
      required IconData icon,
      required String tooltip,
      String? btnType}) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Material(
        color: const Color(0xFF1DB954),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: BlocBuilder<MusicBloc, MusicPlayerState>(
          buildWhen: (previous, current) =>
              previous.isShuffledOn != current.isShuffledOn,
          builder: (context, state) {
            return IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: btnType == "shuffle" && (state.isShuffledOn ?? false)
                    ? Colors.blue
                    : Colors.white,
                size: 28,
              ),
              tooltip: tooltip,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 225,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: _expandAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildButton(
                  btnType: "shuffle",
                  onPressed: widget.onShuffle,
                  icon: Icons.shuffle,
                  tooltip: 'Shuffle',
                ),
                const SizedBox(height: 12),
                _buildButton(
                  onPressed: widget.onAddFiles,
                  icon: Icons.add,
                  tooltip: 'Add Files',
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          _buildButton(
            onPressed: _toggle,
            icon: _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            tooltip: _isExpanded ? 'Close' : 'Open',
          ),
        ],
      ),
    );
  }
}
