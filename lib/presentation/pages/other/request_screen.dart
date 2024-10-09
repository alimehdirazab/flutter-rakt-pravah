import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';
import 'package:rakt_pravah/presentation/pages/home/home_page.dart';
import 'package:rakt_pravah/presentation/widgets/blood_request_tile.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});
  static const String routeName = 'RequestsPage';

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool _isOpenRequests = true;

  @override
  void initState() {
    super.initState();
    context.read<MainCubit>().getBloodRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.routeName,
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text('Requests'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            if (_isOpenRequests) {
              context.read<MainCubit>().getBloodRequestList();
            } else {
              context.read<MainCubit>().getAcceptedBloodRequestList();
            }
            return Future.delayed(const Duration(seconds: 1));
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isOpenRequests
                              ? AppColors.primaryColor
                              : Colors.grey[200],
                          foregroundColor: _isOpenRequests
                              ? Colors.white
                              : AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ), // Rectangle shape
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isOpenRequests = true;
                          });
                          context.read<MainCubit>().getBloodRequestList();
                        },
                        child: const Text('Open Requests'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_isOpenRequests
                              ? AppColors.primaryColor
                              : Colors.grey[200],
                          foregroundColor: !_isOpenRequests
                              ? Colors.white
                              : AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(5),
                            ), // Rectangle shape
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isOpenRequests = false;
                          });
                          context
                              .read<MainCubit>()
                              .getAcceptedBloodRequestList();
                        },
                        child: const Text('Closed Requests'),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<MainCubit, MainState>(
                    builder: (context, state) {
                      if (_isOpenRequests) {
                        if (state is BloodRequestListLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is BloodRequestListError) {
                          return Center(child: Text(state.errorMessage));
                        } else if (state is BloodRequestListSuccess) {
                          return ListView.builder(
                            itemCount:
                                state.bloodRequestListResponse.data.length,
                            itemBuilder: (context, index) {
                              final request =
                                  state.bloodRequestListResponse.data[index];
                              return BloodRequestTile(
                                  request: request, type: 'open');
                            },
                          );
                        }
                      } else {
                        if (state is AcceptedBloodRequestListLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is AcceptedBloodRequestListError) {
                          return Center(child: Text(state.errorMessage));
                        } else if (state is AcceptedBloodRequestListSuccess) {
                          return ListView.builder(
                            itemCount:
                                state.bloodRequestListResponse.data.length,
                            itemBuilder: (context, index) {
                              final request =
                                  state.bloodRequestListResponse.data[index];
                              return BloodRequestTile(
                                request: request,
                                type: 'close',
                              );
                            },
                          );
                        }
                      }
                      return Container(); // Return an empty container if no state is matched
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
