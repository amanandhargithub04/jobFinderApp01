class BasePresenter<T> {
  T view;

  void attachView(T view) {
    this.view = view;
  }

  bool get isViewAttached {
    return view != null;
  }

  void checkViewAttached(){
    if(view==null){
      throw new Exception("attached view is null!");
    }
  }

  T getView() {
    return this.view;
  }
}