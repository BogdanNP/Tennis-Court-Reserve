import 'package:court_reserve_app/models/search_buddy_request.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/search_buddy_repository.dart';
import 'package:court_reserve_app/screens/buddy_search_list/buddy_search_view_model.dart';
import 'package:court_reserve_app/widgets/buddy_search_card.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BuddySearchScreen extends StatefulWidget {
  final List<TennisCourt> tennisCourtList;

  const BuddySearchScreen({
    Key? key,
    required this.tennisCourtList,
  }) : super(key: key);

  @override
  State<BuddySearchScreen> createState() => _BuddySearchListScreenState();
}

class _BuddySearchListScreenState extends State<BuddySearchScreen> {
  late BuddySearchViewModel _viewModel;
  List<SearchBuddyRequest> buddySearchList = [];
  bool isLoading = false;

  @override
  void initState() {
    _viewModel = BuddySearchViewModel(
      Input(
        PublishSubject(),
        PublishSubject(),
      ),
      SearchBuddyRepository(),
    );

    _viewModel.output.onBuddySearchList.listen((event) {
      if (event.state == OperationState.success) {
        setState(() {
          isLoading = false;
          buddySearchList = event.data!
              .where(
                  (element) => element.reserveStartTime.isAfter(DateTime.now()))
              .toList();
          buddySearchList.sort(
            (a, b) => a.status.length.compareTo(b.status.length),
          );
        });
      } else if (event.state == OperationState.loading) {
        setState(() {
          isLoading = true;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
    _viewModel.output.onAcceptBuddySearchRequest.listen((event) {
      if (event.state == OperationState.success) {
        setState(() {
          _viewModel.input.buddySearchList.add(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Check your inbox. "
                "You should receive an email with the reservation details. "
                "See you at the court!",
              ),
            ),
          );
          isLoading = false;
        });
      } else if (event.state == OperationState.loading) {
        setState(() {
          isLoading = true;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
    _viewModel.input.buddySearchList.add(true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Join game"),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ...buddySearchList.map(
                      (searchBuddyRequest) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BuddySearchCard(
                          searchBuddyRequest: searchBuddyRequest,
                          tennisCourt: widget.tennisCourtList.firstWhere(
                              (element) =>
                                  element.courtId ==
                                  searchBuddyRequest.courtId),
                          onAccept: (buddySearch) {
                            _viewModel.input.acceptSearchBuddyRequest
                                .add(buddySearch);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
