class Model {
  String name;
  String path = "assets/models/";

  Model(this.name) {
    path += name;
  }
}