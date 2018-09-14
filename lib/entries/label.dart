class Label {
  int id;
  String nameCN;
  String nameEN;

  Label(this.nameCN, this.nameEN);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Label &&
          runtimeType == other.runtimeType &&
          nameCN == other.nameCN &&
          nameEN == other.nameEN;

  @override
  int get hashCode => nameCN.hashCode ^ nameEN.hashCode;

  @override
  String toString() {
    return 'Label{id: $id, nameCN: $nameCN, nameEN: $nameEN}';
  }
}
