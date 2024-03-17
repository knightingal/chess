class CityInfo {
  final String cityName;
  final int x;
  final int y;

  CityInfo({required this.cityName, required this.x, required this.y});
}

Map<String, CityInfo> cityList = {};

void initCityList() {
  cityList["呼伦贝尔"] = CityInfo(cityName: "呼伦贝尔", x: 11, y: 0);
  cityList["佳木斯"] = CityInfo(cityName: "佳木斯", x: 13, y: 0);
  cityList["哈尔滨"] = CityInfo(cityName: "哈尔滨", x: 12, y: 1);
  cityList["长春"] = CityInfo(cityName: "长春", x: 12, y: 2);
  cityList["乌鲁木齐"] = CityInfo(cityName: "乌鲁木齐", x: 2, y: 2);

  cityList["沈阳"] = CityInfo(cityName: "沈阳", x: 12, y: 3);
  cityList["北京"] = CityInfo(cityName: "北京", x: 11, y: 4);
  cityList["呼和浩特"] = CityInfo(cityName: "呼和浩特", x: 9, y: 4);
  cityList["敦煌"] = CityInfo(cityName: "敦煌", x: 3, y: 4);

  cityList["天津"] = CityInfo(cityName: "天津", x: 11, y: 5);
  cityList["石家庄"] = CityInfo(cityName: "石家庄", x: 10, y: 5);
  cityList["太原"] = CityInfo(cityName: "太原", x: 9, y: 5);
  cityList["大连"] = CityInfo(cityName: "大连", x: 12, y: 5);
  cityList["银川"] = CityInfo(cityName: "银川", x: 8, y: 5);
  cityList["兰州"] = CityInfo(cityName: "兰州", x: 7, y: 5);
  cityList["西宁"] = CityInfo(cityName: "西宁", x: 6, y: 5);
  cityList["可可西里"] = CityInfo(cityName: "可可西里", x: 4, y: 5);
  cityList["阿里地区"] = CityInfo(cityName: "阿里地区", x: 2, y: 5);

  cityList["青岛"] = CityInfo(cityName: "青岛", x: 13, y: 6);
  cityList["济南"] = CityInfo(cityName: "济南", x: 12, y: 6);
  cityList["郑州"] = CityInfo(cityName: "郑州", x: 11, y: 6);
  cityList["洛阳"] = CityInfo(cityName: "洛阳", x: 10, y: 6);
  cityList["西安"] = CityInfo(cityName: "西安", x: 9, y: 6);
  cityList["天水"] = CityInfo(cityName: "天水", x: 8, y: 6);

  cityList["上海"] = CityInfo(cityName: "上海", x: 13, y: 7);
  cityList["南京"] = CityInfo(cityName: "南京", x: 12, y: 7);
  cityList["合肥"] = CityInfo(cityName: "合肥", x: 11, y: 7);

  cityList["杭州"] = CityInfo(cityName: "杭州", x: 13, y: 8);
  cityList["武汉"] = CityInfo(cityName: "武汉", x: 10, y: 8);
  cityList["张家界"] = CityInfo(cityName: "张家界", x: 9, y: 8);
  cityList["重庆"] = CityInfo(cityName: "重庆", x: 8, y: 8);
  cityList["成都"] = CityInfo(cityName: "成都", x: 7, y: 8);
  cityList["拉萨"] = CityInfo(cityName: "拉萨", x: 3, y: 8);

  cityList["福州"] = CityInfo(cityName: "福州", x: 12, y: 9);
  cityList["南昌"] = CityInfo(cityName: "南昌", x: 11, y: 9);
  cityList["长沙"] = CityInfo(cityName: "长沙", x: 9, y: 9);
  cityList["贵阳"] = CityInfo(cityName: "贵阳", x: 8, y: 9);
  cityList["丽江"] = CityInfo(cityName: "丽江", x: 5, y: 9);

  cityList["台北"] = CityInfo(cityName: "台北", x: 13, y: 10);
  cityList["厦门"] = CityInfo(cityName: "厦门", x: 11, y: 10);
  cityList["桂林"] = CityInfo(cityName: "桂林", x: 9, y: 10);
  cityList["昆明"] = CityInfo(cityName: "昆明", x: 7, y: 10);

  cityList["高雄"] = CityInfo(cityName: "高雄", x: 13, y: 11);
  cityList["广州"] = CityInfo(cityName: "广州", x: 10, y: 11);
  cityList["南宁"] = CityInfo(cityName: "南宁", x: 8, y: 11);
  cityList["西双版纳"] = CityInfo(cityName: "西双版纳", x: 6, y: 11);

  cityList["香港"] = CityInfo(cityName: "香港", x: 11, y: 12);
  cityList["澳门"] = CityInfo(cityName: "澳门", x: 10, y: 12);

  cityList["海口"] = CityInfo(cityName: "海口", x: 8, y: 13);
}
