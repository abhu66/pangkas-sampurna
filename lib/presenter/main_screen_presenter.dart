import 'package:pangkas_app/model/History.dart';
import 'package:pangkas_app/model/Task.dart';
import 'package:pangkas_app/services/ApiService.dart';

abstract class MainScreenContact{
  void onLoadSuccess(dynamic obj);
  void onLoadError(String errorTxt);
}

class MainScreenPresenter{
  MainScreenContact _view;
  ApiService _apiService = new ApiService();
  MainScreenPresenter(this._view);
  
  doGetTasks(){
    _apiService.getAllTask().then((List<Task> allTask){
      _view.onLoadSuccess(allTask);
    }).catchError((err){
      return _view.onLoadError(err.toString());
    });
  }

  doSubmitTask(String idn_karyawan, String task, String biaya,String keterangan){
    _apiService.submitHistory(idn_karyawan, task,biaya, keterangan).then((dynamic str){
      _view.onLoadSuccess(str.toString());
    }).catchError((error){
      return _view.onLoadError(error.toString());
    });
  }
}