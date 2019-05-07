import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';

part 'form_store.g.dart';

class CustomColor extends Color {
  CustomColor(int value) : super(value);
}

class FormStore = _FormStore with _$FormStore;

abstract class _FormStore implements Store {
  final FormErrorState error = FormErrorState();

  @observable
  CustomColor color;

  @observable
  String name = '';

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  ObservableFuture<bool> _usernameCheck = ObservableFuture.value(true);

  @computed
  bool get isUserCheckPending => _usernameCheck.status == FutureStatus.pending;

  @computed
  bool get canLogin => !error.hasErrors;

  List<ReactionDisposer> _disposers;

  @action
  void setUsername(String value) {
    name = value;
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  void setupValidations() {
    _disposers = [
      reaction((_) => name, validateUsername),
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword)
    ];
  }

  // ignore: avoid_void_async
  @action
  void validateUsername(String value) {
    if (isNull(value) || value.isEmpty) {
      error.username = 'Cannot be blank';
      return;
    }
    try {
      checkAndValidateUsername(value).then((isValid) {
        error.username = null;
        if (!isValid) {
          error.username = 'Username cannot be "admin"';
          return;
        }
      });
    } on Object catch (_) {
      error.username = null;
    }
  }

  Future<bool> checkAndValidateUsername(String value) async {
    _usernameCheck = ObservableFuture(checkValidUsername(value));
    final isValid = await _usernameCheck;
    return isValid;
  }

  @action
  void validatePassword(String value) {
    error.password = isNull(value) || value.isEmpty ? 'Cannot be blank' : null;
  }

  @action
  void validateEmail(String value) {
    error.email = isEmail(value) ? null : 'Not a valid email';
  }

  Future<bool> checkValidUsername(String value) async {
    await Future.delayed(Duration(seconds: 1));

    return value != 'admin';
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void validateAll() {
    validatePassword(password);
    validateEmail(email);
    validateUsername(name);
  }
}

class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState implements Store {
  @observable
  String username;

  @observable
  String email;

  @observable
  String password;

  @computed
  bool get hasErrors => username != null || email != null || password != null;
}
