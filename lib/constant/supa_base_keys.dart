import 'package:supabase_flutter/supabase_flutter.dart';

class SupaBaseCall {
  static const urlSupabase = "https://miojbztjrzdmwdyzhdoy.supabase.co";
  static const supabsePubKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pb2pienRqcnpkbXdkeXpoZG95Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzQwNDUwMzgsImV4cCI6MTk4OTYyMTAzOH0.S1B4_GbHE2veNNOEgeIddP7t4LOfaGM6y2AF-gvMRh4";
  static const supabseSecKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pb2pienRqcnpkbXdkeXpoZG95Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3NDA0NTAzOCwiZXhwIjoxOTg5NjIxMDM4fQ.M4vwHjkShVLjQrtGskLv0wVqZFuI-j6gep8PZA2eieg";
  static const supabsejwtSec =
      "EPn1mdaQa//6DHJPls4Z2NmoK1A/Ul3kEhTcg+2CFNGoDMquuhvUA4r4cxsyShgjiWuuXOCdFxg43w+Mx78Y8A==";
  static const supabsedbpassword = "nGuxlg3fiAmL8h6V";
  static final supabaseService = Supabase.instance.client;
}
