import 'package:geo_pulse/geo_pulse/features/notifications/data/data_source/notifications_data_source.dart';
import 'package:geo_pulse/geo_pulse/features/notifications/data/repo/notifications_repo_imp.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/features/home/data/data_source/checkIn_remote_data_source.dart';
import 'package:geo_pulse/geo_pulse/features/home/data/repository/checkIn_repo_impl.dart';
import 'package:geo_pulse/geo_pulse/features/home/presentation/controller/controller/check_in_controller.dart';

import '../../features/approvals/data/data_source/approval_remote_data_source.dart';
import '../../features/approvals/data/repository/approval_repo_impl.dart';
import '../../features/approvals/presentation/controller/tracking_approvals_controller.dart';
import '../../features/attendance/data/data_source/attendence_remote_data_source.dart';
import '../../features/attendance/data/repository/attendence_repo_impl.dart';
import '../../features/attendance/presentation/controller/controller/attendance_controller.dart';
import '../../features/dashboard/hr_dashboard/presentation/controller/tracking_hr_controller.dart';
import '../../features/dashboard/my_dashboard/presentation/controller/tracking_dashboard_controller.dart';
import '../../features/notifications/presentation/controller/notification_controller.dart';
import '../../features/users/logic/add_department_controller.dart';
import '../../features/users/logic/add_employee_controller.dart';
import '../../features/home/presentation/controller/controller/tracking_home_controller.dart';
import '../../features/location/data/data_source/location_remote_data_source.dart';
import '../../features/location/data/repository/location_repo_impl.dart';
import '../../features/location/presentation/controller/controller/edit_geofencing_controller.dart';
import '../../features/location/presentation/controller/controller/geofencing_controller.dart';
import '../../features/location/presentation/controller/controller/location_controller.dart';
//import '../../features/notification_serevice/notification_controller.dart';
import '../../features/request/data/data_source/request_remote_data_source.dart';
import '../../features/request/data/repository/request_repo_impl.dart';
import '../../features/request/presentation/controller/requests_controller.dart';
import '../../features/request_type/data/data_source/request_type_remote_data_source.dart';
import '../../features/request_type/data/repository/request_type_repo_impl.dart';
import '../../features/request_type/presentation/controller/request_types_controller.dart';

configurationDependencies() {
  Get.lazyPut(() => UserController(), fenix: true);
  Get.lazyPut(() => AddDepartmentController(), fenix: true);
  Get.lazyPut(() => TrackingHomeController(), fenix: true);

  Get.lazyPut(
      () => CheckInController(
            checkInRepo: CheckinRepoImpl(
              checkinRemoteDataSource: CheckinRemoteDataSource(),
            ),
          ),
      fenix: true);
  Get.lazyPut(
      () => TrackingRequestsController(
            requestRepo: RequestRepoImpl(
              requestRemoteDataSource: RequestRemoteDataSource(),
            ),
          ),
      fenix: true);
  Get.lazyPut(
      () => TrackingApprovalsController(
            approvalRepo: ApprovalRepoImpl(
              remoteDataSource: ApprovalRemoteDataSource(),
            ),
            requestsRepo: RequestRepoImpl(
              requestRemoteDataSource: RequestRemoteDataSource(),
            ),
          ),
      fenix: true);
  Get.lazyPut(
      () => TrackingAttendanceController(
            attendenceRepo: AttendenceRepoImpl(
              remoteDataSource: AttendenceRemoteDataSource(),
            ),
          ),
      fenix: true);
  Get.lazyPut(
    () => TrackingDashboardController(
      requestRepo: RequestRepoImpl(
        requestRemoteDataSource: RequestRemoteDataSource(),
      ),
      attendenceRepo: AttendenceRepoImpl(
        remoteDataSource: AttendenceRemoteDataSource(),
      ),
    ),
    fenix: true,
  );
  Get.lazyPut(
    () => LocationController(
      locationRepo: LocationRepoImpl(
        locationRemoteDataSource: LocationRemoteDataSource(),
      ),
    ),
    fenix: true,
  );
  Get.lazyPut(
      () => RequestTypeController(
            requestTypeRepo: RequestTypeRepoImpl(
              requestTypeRemoteDataSource: RequestTypeRemoteDataSource(),
            ),
          ),
      fenix: true);
  Get.lazyPut(
      () => TrackingHRController(
            requestsRepo: RequestRepoImpl(
              requestRemoteDataSource: RequestRemoteDataSource(),
            ),
            attendenceRepo: AttendenceRepoImpl(
              remoteDataSource: AttendenceRemoteDataSource(),
            ),
          ),
      fenix: true);
  Get.lazyPut(
    () => GeofencingController(),
    fenix: true,
  );
  Get.lazyPut(
      () => AppNotificationController(
            notificationRepo: NotificationsRepoImp(
              dataSource: NotificationsDataSource(),
            ),
          ),
      fenix: true);
  Get.lazyPut(() => EditGeofencingController(), fenix: true);
}
