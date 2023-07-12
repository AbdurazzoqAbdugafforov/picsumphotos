class Photo {
  Photo({
    String? id,
    String? author,
    int? width,
    int? height,
    String? url,
    String? downloadUrl,
  }) {
    _id = id;
    _author = author;
    _width = width;
    _height = height;
    _url = url;
    _downloadUrl = downloadUrl;
  }

  Photo.fromJson(dynamic json) {
    _id = json['id'];
    _author = json['author'];
    _width = json['width'];
    _height = json['height'];
    _url = json['url'];
    _downloadUrl = json['download_url'];
  }

  String? _id;
  String? _author;
  int? _width;
  int? _height;
  String? _url;
  String? _downloadUrl;

  Photo copyWith({
    String? id,
    String? author,
    int? width,
    int? height,
    String? url,
    String? downloadUrl,
  }) =>
      Photo(
        id: id ?? _id,
        author: author ?? _author,
        width: width ?? _width,
        height: height ?? _height,
        url: url ?? _url,
        downloadUrl: downloadUrl ?? _downloadUrl,
      );

  String? get id => _id;

  String? get author => _author;

  int? get width => _width;

  int? get height => _height;

  String? get url => _url;

  String? get downloadUrl => _downloadUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['author'] = _author;
    map['width'] = _width;
    map['height'] = _height;
    map['url'] = _url;
    map['download_url'] = _downloadUrl;
    return map;
  }
}
