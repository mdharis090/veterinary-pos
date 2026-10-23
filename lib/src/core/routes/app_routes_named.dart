import 'app_route_path.dart';

abstract final class AppRoutesNamed {
  static const root = AppRoutePath.root;
  static const dashboard = AppRoutePath.dashboard;
  static const login = AppRoutePath.login;
  static const patients = AppRoutePath.patients;
  static const patientProfile = AppRoutePath.patientProfile;
  static const owners = AppRoutePath.owners;
  static const consultations = AppRoutePath.consultations;
  static const prescriptions = AppRoutePath.prescriptions;
  static const medicines = AppRoutePath.medicines;
  static const inventory = AppRoutePath.inventory;
  static const batches = AppRoutePath.batches;
  static const suppliers = AppRoutePath.suppliers;
  static const purchases = AppRoutePath.purchases;
  static const newPurchase = AppRoutePath.newPurchase;
  static const posBilling = AppRoutePath.posBilling;
  static const sales = AppRoutePath.sales;
  static const returns = AppRoutePath.returns;
  static const payments = AppRoutePath.payments;
  static const reports = AppRoutePath.reports;
  static const settings = AppRoutePath.settings;

  static const dashboardSections = <String, String>{
    'Dashboard': dashboard,
    'Patients': patients,
    'Patients list': patients,
    'Patient profile': patientProfile,
    'Owners': owners,
    'Consultations': consultations,
    'Prescriptions': prescriptions,
    'Medicines': medicines,
    'Inventory': inventory,
    'Batches': batches,
    'Suppliers': suppliers,
    'Purchases': purchases,
    'New purchase': newPurchase,
    'POS Billing': posBilling,
    'Sales': sales,
    'Returns': returns,
    'Payments': payments,
    'Reports': reports,
    'Settings': settings,
  };
}
