import 'package:flutter/material.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/utils/export_utils.dart';

class SearchSearchBarWidget extends StatefulWidget {
  const SearchSearchBarWidget({Key? key}) : super(key: key);

  @override
  _SearchSearchBarWidgetState createState() => _SearchSearchBarWidgetState();
}

class _SearchSearchBarWidgetState extends State<SearchSearchBarWidget> {
  // Controller
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Bloc
    final _searchBloc = context.read<SearchBloc>();

    // Update Bloc
    _searchBloc.add(const SetSearch(null));
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _searchBloc = context.read<SearchBloc>();

    return BlocSelector<SearchBloc, SearchValue, String?>(
      selector: (state) {
        return state.search;
      },
      builder: (context, state) {
        return textFormFieldFill(
          controller: _searchController,
          keyboardType: TextInputType.text,
          onChanged: () {
            // Update Bloc
            _searchBloc.add(SetSearch(_searchController.text));
          },
          style: medium14(Colors.white),
          hintText: "Search...",
          onTap: null,
          fillColor: colorThird.withOpacity(0.2),
          prefix: null,
          suffix: (state == null || state.isEmpty)
              ? null
              : GestureDetector(
                  onTap: () {
                    // Clear
                    _searchController.clear();
                    // Update Bloc
                    _searchBloc.add(const SetSearch(null));
                  },
                  child: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
          leftMargin: 0,
          topMargin: 0,
          rightMargin: 12,
          bottomMargin: 0,
        );
      },
    );
  }
}
