class ARImageResponse {
  String objectScanned;

  ARImageResponse({required this.objectScanned});
  
  factory ARImageResponse.fromJson(Map<String, dynamic> json) {
    return ARImageResponse(
      objectScanned: json['object_scanned'],
    );
  }

}
