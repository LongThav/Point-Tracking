import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/services/network/api_status.dart';
import '../../../mains/constants/colors.dart';
import '../../../mains/models/dashboard_model.dart';
import '../../../mains/screens/dashboard.dart';
import '../../../mains/services/dashboard_serivce.dart';

class HomeSalePage extends StatefulWidget {
  const HomeSalePage({super.key});

  @override
  State<HomeSalePage> createState() => _HomeSalePageState();
}

class _HomeSalePageState extends State<HomeSalePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DashboardService>().readDashboard(context);
      context.read<DashboardService>().setLoadingDashboard();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      backgroundColor: Colors.white,
      body: _buildBody,
    );
  }

  get _buildAppBar {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      leadingWidth: MediaQuery.of(context).size.width * 0.35,
      leading: Padding(
        padding: EdgeInsets.only(left: 0.h, top: 1.h),
        child: const Center(
          child: Text(
            "Dashboard",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: AppColors.textColor),
          ),
        ),
      ),
    );
  }

  get _buildBody {
    Loadingstatus loadingstatus = context.watch<DashboardService>().loadingstatus;
    switch (loadingstatus) {
      case Loadingstatus.none:
      case Loadingstatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case Loadingstatus.error:
        return Center(
          child: Text(
            context.read<DashboardService>().errorMsg,
            textAlign: TextAlign.center,
          ),
        );
      case Loadingstatus.complete:
        return _buildListDashBoard();
    }
  }

  Widget _buildListDashBoard() {
    DashboardModel productModelList = context.watch<DashboardService>().dashboardModel;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 1.7.h),
        child: Column(
          children: [
            DaskBoardStructure(
              title: 'New Purchase Order',
              subtitle: 'Total PO Which Sales have just created',
              total: '${productModelList.data.dashboard.dashboardNew}',
            ),
            DaskBoardStructure(
              title: 'In Service',
              subtitle: 'Total PO Which customer service are handling',
              total: '${productModelList.data.dashboard.inService}',
            ),
            DaskBoardStructure(
              title: 'Confirm',
              subtitle: 'Total PO which logistic has confirmed',
              total: '${productModelList.data.dashboard.confirm}',
            ),
            DaskBoardStructure(
              title: 'Delivery',
              subtitle: 'Total PO which driver are handling',
              total: '${productModelList.data.dashboard.delivery}',
            ),
            DaskBoardStructure(
              title: 'Delivered',
              subtitle: 'Total PO which completed',
              total: '${productModelList.data.dashboard.delivered}',
            ),
          ],
        ),
      ),
    );
  }

// Widget _buildListDashBoard() {
//   return Center(
//     child: Column(
//       children: [
//         Text("${productModelList.data.dashboard.confirm}"),
//         Text("${productModelList.data.dashboard.dashboardNew}"),
//         Text("${productModelList.data.dashboard.delivered}"),
//         Text("${productModelList.data.dashboard.inService}"),
//         Text("${productModelList.data.dashboard.delivery}"),
//       ],
//     ),
//   );
// }
}
