


import 'package:pangkas_app/model/History.dart';
import 'package:pangkas_app/services/ApiService.dart';

abstract class HistoryTabContract{
  void onLoadSuccess(History history);
  void onLoadErrorr(String txtError);
}

class HistoryTabPresenter{
  HistoryTabContract _view;
  ApiService _apiService = new ApiService();
  HistoryTabPresenter(this._view);

  doGetTotal(String idnKaryawan) async{
    _apiService.getTotalIncome(idnKaryawan).then((History history){
      _view.onLoadSuccess(history);
    }).catchError((error){
      _view.onLoadErrorr(error.toString());
    });
  }
}