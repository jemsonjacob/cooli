import 'package:cooli/helpers/url_helpers.dart';

String urlBase = UrlHelpers.baseURL;

//Register
String urlRegistrationRequestOTP = "${urlBase}register/request-otp";
String urlRegistrationVerifyOTP = "${urlBase}register/verify-otp";
String urlRegistration = "${urlBase}register/store";

String urlLoginGenerateOrganization = "${urlBase}owner/mobile/login";
String urlLoginVerify = "${urlBase}owner/mobile/login/verify";
String urlGetDeviceUserCount = '${urlBase}owner/home/device-user-count';
String urlGetLicenseSummary = '${urlBase}owner/home/license-summary';
String urlGetDeviceList = '${urlBase}owner/device/list';
String urlGetDeviceGroupList = '${urlBase}owner/device-group/list';
String urlGetAddDeviceInDeviceGroup = '${urlBase}owner/device-group/add-device';
String urlGetAddDeviceGroup = '${urlBase}owner/device-group/add';
String urlGetDeviceGroupChangeName = '${urlBase}owner/device-group/change-name';
String urlGetDeviceGroupDeviceList = '${urlBase}owner/device-group/device-list';

String urlAddNewBTDevice = '${urlBase}owner/device/add';
String urlGetDeviceTypeList = '${urlBase}owner/device-type';
String urlGetRemoveDevice = '${urlBase}owner/device/remove';
String urlRemoveUserFromDeviceSharedList =
    '${urlBase}owner/device/device-key-revoke';
String urlGetUserDeleteDevice = '${urlBase}owner/user/delete-device';
String urlTransferDeviceKey = '${urlBase}owner/device/transfer-key/user';
String urlDeleteUserGroup = '${urlBase}owner/user-group/delete';
String urlAddUser = '${urlBase}owner/user/add';
String urlgetUserList = '${urlBase}owner/user/list';
String urlRemoveDeviceGroup = '${urlBase}owner/device-group/delete';
String urlAdminEnableBiometric = '${urlBase}owner/config/biometric-login/store';
