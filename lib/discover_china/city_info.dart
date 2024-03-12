class CityInfo {
  final String cityName;
  final int x;
  final int y;

  CityInfo({required this.cityName, required this.x, required this.y});
}

Map<String, CityInfo> cityList = {};

void initCityList() {
  cityList["beijing"] = CityInfo(cityName: "北京", x: 6, y: 4);
  cityList["tianjin"] = CityInfo(cityName: "天津", x: 5, y: 5);
  cityList["huhehaote"] = CityInfo(cityName: "呼和浩特", x: 4, y: 7);
  cityList["xishuangbaina"] = CityInfo(cityName: "西双版纳", x: 3, y: 10);
  cityList["kunming"] = CityInfo(cityName: "昆明", x: 4, y: 10);
  cityList["nanjing"] = CityInfo(cityName: "南京", x: 10, y: 5);
  cityList["hangzhou"] = CityInfo(cityName: "杭州", x: 11, y: 7);
  cityList["shanghai"] = CityInfo(cityName: "上海", x: 11, y: 6);
  cityList["taibei"] = CityInfo(cityName: "台北", x: 12, y: 7);
}
