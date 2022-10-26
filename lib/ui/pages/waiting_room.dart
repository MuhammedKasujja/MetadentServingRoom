import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metadent_serving_app/blocs/blocs.dart';
import 'package:metadent_serving_app/infra/infra.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../components/components.dart';

class WaitingRoomPage extends StatefulWidget {
  const WaitingRoomPage({Key? key}) : super(key: key);

  @override
  State<WaitingRoomPage> createState() => _WaitingRoomPageState();
}

class _WaitingRoomPageState extends State<WaitingRoomPage> {
  @override
  void initState() {
    context.read<AppointmentsBloc>().add(FetchAppointments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F5F9),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MetaDent - Serving Room'),
      ),
      body: BlocBuilder<AppointmentsBloc, AppointmentsState>(
        builder: (context, state) {
          if (state.data != null) {
            if (state.data!.isEmpty) {
              return const NoDataWidget(message: 'The Waiting Room is empty');
            }
            // return ResponsiveGridView.builder(
            //   itemCount: state.data!.length,
            //   gridDelegate: ResponsiveGridDelegate(
            //     maxCrossAxisExtent: 450,
            //     // crossAxisSpacing: 20,
            //     // mainAxisSpacing: 20,
            //     childAspectRatio: ResponsiveValue(context,
            //         defaultValue: 6.5 / 2,
            //         valueWhen: [
            //           const Condition.largerThan(name: MOBILE, value: 5 / 1.8)
            //         ]).value!,
            //   ),
            //   itemBuilder: (context, index) =>
            //       AppointmentListItem(appointment: state.data![index]),
            // );
            // return ListView.builder(
            //   itemCount: state.data!.length,
            //   // shrinkWrap: true,
            //   // physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, index) =>
            //       AppointmentListItem(appointment: state.data![index]),
            // );
            return ResponsiveRowColumn(
              layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              columnMainAxisSize: MainAxisSize.min,
              rowSpacing: 12,
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 3,
                  rowFit: FlexFit.tight,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Text(
                              'Checked-in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 40, 10),
                            child: Text(
                              'Que Status',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.data!
                              .where((appointment) =>
                                  appointment.status.id == 3 ||
                                  appointment.queue.type ==
                                      QueueType.doctorComing)
                              .length,
                          // shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => AppointmentListItem(
                            appointment: state.data!
                                .where((appointment) =>
                                    appointment.status.id == 3 ||
                                    appointment.queue.type ==
                                        QueueType.doctorComing)
                                .toList()[index],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 3,
                  rowFit: FlexFit.tight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: const BoxDecoration(color: Color(0xffE5E7EB)),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
                          child: Text(
                            'In Treatment',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Table(
                              columnWidths: const {
                                0: FixedColumnWidth(140), // fixed to 100 width
                                1: FlexColumnWidth(),
                                2: FixedColumnWidth(100.0), //fixed to 100 width
                              },
                              children: [
                                const TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      "Token ID.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      "By",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      "Room No.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ]),
                                ...state.data!
                                    .where((appointment) =>
                                        appointment.queue.type ==
                                        QueueType.serving)
                                    .map(
                                      (e) => TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Text(
                                              e.code!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Text(
                                              'Dr. ${e.doctor!.firstName} ${e.doctor!.lastName[0]}.',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10.0),
                                            child: Text(
                                              'N/A',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          if (state.data == null && state.status == AppState.failure) {
            return RetryWidget(
              error: state.error!,
              onRetry: () =>
                  context.read<AppointmentsBloc>().add(FetchAppointments()),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
