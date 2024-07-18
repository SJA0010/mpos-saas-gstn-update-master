// ignore_for_file: file_names

class GstModel {
  GstModel({
    this.flag,
    this.message,
    this.data,
  });

  GstModel.fromJson(dynamic json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? flag;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['flag'] = flag;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.ntcrbs,
    this.adhrVFlag,
    this.lgnm,
    this.stj,
    this.dty,
    this.cxdt,
    this.gstin,
    this.nba,
    this.ekycVFlag,
    this.cmpRt,
    this.rgdt,
    this.ctb,
    this.pradr,
    this.sts,
    this.tradeNam,
    this.isFieldVisitConducted,
    this.ctj,
    this.einvoiceStatus,
    this.lstupdt,
    this.adadr,
    this.ctjCd,
    this.errorMsg,
    this.stjCd,
  });

  Data.fromJson(dynamic json) {
    ntcrbs = json['ntcrbs'];
    adhrVFlag = json['adhrVFlag'];
    lgnm = json['lgnm'];
    stj = json['stj'];
    dty = json['dty'];
    cxdt = json['cxdt'];
    gstin = json['gstin'];
    nba = json['nba'] != null ? json['nba'].cast<String>() : [];
    ekycVFlag = json['ekycVFlag'];
    cmpRt = json['cmpRt'];
    rgdt = json['rgdt'];
    ctb = json['ctb'];
    pradr = json['pradr'] != null ? Pradr.fromJson(json['pradr']) : null;
    sts = json['sts'];
    tradeNam = json['tradeNam'];
    isFieldVisitConducted = json['isFieldVisitConducted'];
    ctj = json['ctj'];
    einvoiceStatus = json['einvoiceStatus'];
    lstupdt = json['lstupdt'];
    ctjCd = json['ctjCd'];
    errorMsg = json['errorMsg'];
    stjCd = json['stjCd'];
  }
  String? ntcrbs;
  String? adhrVFlag;
  String? lgnm;
  String? stj;
  String? dty;
  String? cxdt;
  String? gstin;
  List<String>? nba;
  String? ekycVFlag;
  String? cmpRt;
  String? rgdt;
  String? ctb;
  Pradr? pradr;
  String? sts;
  String? tradeNam;
  String? isFieldVisitConducted;
  String? ctj;
  String? einvoiceStatus;
  String? lstupdt;
  List<dynamic>? adadr;
  String? ctjCd;
  dynamic errorMsg;
  String? stjCd;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ntcrbs'] = ntcrbs;
    map['adhrVFlag'] = adhrVFlag;
    map['lgnm'] = lgnm;
    map['stj'] = stj;
    map['dty'] = dty;
    map['cxdt'] = cxdt;
    map['gstin'] = gstin;
    map['nba'] = nba;
    map['ekycVFlag'] = ekycVFlag;
    map['cmpRt'] = cmpRt;
    map['rgdt'] = rgdt;
    map['ctb'] = ctb;
    if (pradr != null) {
      map['pradr'] = pradr?.toJson();
    }
    map['sts'] = sts;
    map['tradeNam'] = tradeNam;
    map['isFieldVisitConducted'] = isFieldVisitConducted;
    map['ctj'] = ctj;
    map['einvoiceStatus'] = einvoiceStatus;
    map['lstupdt'] = lstupdt;
    if (adadr != null) {
      map['adadr'] = adadr?.map((v) => v.toJson()).toList();
    }
    map['ctjCd'] = ctjCd;
    map['errorMsg'] = errorMsg;
    map['stjCd'] = stjCd;
    return map;
  }
}

class Pradr {
  Pradr({
    this.adr,
    this.addr,
  });

  Pradr.fromJson(dynamic json) {
    adr = json['adr'];
    addr = json['addr'] != null ? Addr.fromJson(json['addr']) : null;
  }
  String? adr;
  Addr? addr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['adr'] = adr;
    if (addr != null) {
      map['addr'] = addr?.toJson();
    }
    return map;
  }
}

class Addr {
  Addr({
    this.flno,
    this.lg,
    this.loc,
    this.pncd,
    this.bnm,
    this.city,
    this.lt,
    this.stcd,
    this.bno,
    this.dst,
    this.st,
  });

  Addr.fromJson(dynamic json) {
    flno = json['flno'];
    lg = json['lg'];
    loc = json['loc'];
    pncd = json['pncd'];
    bnm = json['bnm'];
    city = json['city'];
    lt = json['lt'];
    stcd = json['stcd'];
    bno = json['bno'];
    dst = json['dst'];
    st = json['st'];
  }
  String? flno;
  String? lg;
  String? loc;
  String? pncd;
  String? bnm;
  String? city;
  String? lt;
  String? stcd;
  String? bno;
  String? dst;
  String? st;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['flno'] = flno;
    map['lg'] = lg;
    map['loc'] = loc;
    map['pncd'] = pncd;
    map['bnm'] = bnm;
    map['city'] = city;
    map['lt'] = lt;
    map['stcd'] = stcd;
    map['bno'] = bno;
    map['dst'] = dst;
    map['st'] = st;
    return map;
  }
}
