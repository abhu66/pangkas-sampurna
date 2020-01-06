


import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/services/ApiService.dart';

abstract class LoginScreenContract{
  void onLoginSuccess(Karyawan karyawan);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter{
  LoginScreenContract _view;
  ApiService _apiService = new ApiService();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password){
    _apiService.login(username, password).then((Karyawan karyawan){
      _view.onLoginSuccess(karyawan);
    }).catchError((err) {
      _view.onLoginError(err.toString());
    });
  }

}