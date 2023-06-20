import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../mains/constants/colors.dart';
import '../../mains/models/dashboard_model.dart';
import '../../mains/screens/dashboard.dart';
import '../../mains/services/dashboard_serivce.dart';
import '../../mains/services/network/api_status.dart';

class HomeDriverPage extends StatefulWidget {
  const HomeDriverPage({super.key});

  @override
  State<HomeDriverPage> createState() => _HomeDriverPageState();
}

class _HomeDriverPageState extends State<HomeDriverPage> {
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

  AppBar get _buildAppBar {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Dashboard',
        style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600, fontSize: 22),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
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
          child: Text(context.read<DashboardService>().errorMsg),
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
              title: 'Delivery',
              subtitle: 'Total PO which controller has confirmed',
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
}
