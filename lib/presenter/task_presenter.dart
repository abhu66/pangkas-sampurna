

import 'package:pangkas_app/model/Task.dart';
import 'package:pangkas_app/services/ApiService.dart';

abstract class TaskScreenContract{
  void onLoadSucces(List<Task> allTask);
  void onLoadError(String errorTxt);
}

class TaskScreenPresenter{
  TaskScreenContract _view;
  ApiService _apiService = new ApiService();
  TaskScreenPresenter(this._view);

  doGetTask(){
    _apiService.getAllTask().then((List<Task> allTask){
      _view.onLoadSucces(allTask);
    }).catchError((err){
      _view.onLoadError(err.toString());
    });
  }
}