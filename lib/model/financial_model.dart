class FinancialModel {
  int? id;
  String? tipe;
  String? keterangan;
  String? jml_uang;
  String? tanggal;
  String? createdAt; 

  FinancialModel({this.id, this.tipe, this.keterangan, this.jml_uang, this.tanggal, this.createdAt});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['tipe'] = tipe;
    map['keterangan'] = keterangan;
    map['jml_uang'] = jml_uang;
    map['tanggal'] = tanggal;
    map['createdAt'] = createdAt;

    return map;
  }

  FinancialModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.tipe = map['tipe'];
    this.keterangan = map['keterangan'];
    this.jml_uang = map['jml_uang'];
    this.tanggal = map['tanggal'];
    this.createdAt = map['createdAt'];
  }

}
