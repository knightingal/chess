import 'dart:math';

import 'package:flutter/material.dart';

class CityInfo {
  final String cityName;
  final int x;
  final int y;

  CityInfo({required this.cityName, required this.x, required this.y});
}

class CityCardInfo {
  final String cityName;
  final int ticket;

  CityCardInfo({required this.cityName, required this.ticket});
}

class LineInfo {
  final String cityName1;
  final String cityName2;
  final Color color;

  LineInfo(
      {required this.cityName1, required this.cityName2, required this.color});
}

Map<String, CityInfo> cityList = {};
List<LineInfo> lineList = [];
List<CityCardInfo> cityCardList = [];
List<CityCardInfo> playerCityCard = [];

void initCityCardInfoList() {
  cityCardList.add(CityCardInfo(cityName: "天津", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "石家庄", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "太原", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "沈阳", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "呼和浩特", ticket: 1));

  cityCardList.add(CityCardInfo(cityName: "card10", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "card11", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "card12", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "card13", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "card14", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "card15", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "card16", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "card17", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "card18", ticket: 1));
  cityCardList.add(CityCardInfo(cityName: "card19", ticket: 1));

  cityCardList.add(CityCardInfo(cityName: "card20", ticket: 2));
  cityCardList.add(CityCardInfo(cityName: "card21", ticket: 2));
  cityCardList.add(CityCardInfo(cityName: "card22", ticket: 2));
  cityCardList.add(CityCardInfo(cityName: "card23", ticket: 2));
  cityCardList.add(CityCardInfo(cityName: "card24", ticket: 2));
  cityCardList.add(CityCardInfo(cityName: "card25", ticket: 2));
  cityCardList.add(CityCardInfo(cityName: "card26", ticket: 2));
  cityCardList.add(CityCardInfo(cityName: "card27", ticket: 2));
  cityCardList.add(CityCardInfo(cityName: "card28", ticket: 2));
  cityCardList.add(CityCardInfo(cityName: "card29", ticket: 2));

  cityCardList.add(CityCardInfo(cityName: "card30", ticket: 3));
  cityCardList.add(CityCardInfo(cityName: "card31", ticket: 3));
  cityCardList.add(CityCardInfo(cityName: "card32", ticket: 3));
  cityCardList.add(CityCardInfo(cityName: "card33", ticket: 3));
  cityCardList.add(CityCardInfo(cityName: "card34", ticket: 3));
  cityCardList.add(CityCardInfo(cityName: "card35", ticket: 3));
  cityCardList.add(CityCardInfo(cityName: "card36", ticket: 3));
  cityCardList.add(CityCardInfo(cityName: "card37", ticket: 3));
  cityCardList.add(CityCardInfo(cityName: "card38", ticket: 3));
  cityCardList.add(CityCardInfo(cityName: "card39", ticket: 3));

  cityCardList.add(CityCardInfo(cityName: "card40", ticket: 4));
  cityCardList.add(CityCardInfo(cityName: "card41", ticket: 4));
  cityCardList.add(CityCardInfo(cityName: "card42", ticket: 4));
  cityCardList.add(CityCardInfo(cityName: "card43", ticket: 4));
  cityCardList.add(CityCardInfo(cityName: "card44", ticket: 4));
  cityCardList.add(CityCardInfo(cityName: "card45", ticket: 4));
  cityCardList.add(CityCardInfo(cityName: "card46", ticket: 4));
  cityCardList.add(CityCardInfo(cityName: "card47", ticket: 4));
  cityCardList.add(CityCardInfo(cityName: "card48", ticket: 4));
  cityCardList.add(CityCardInfo(cityName: "card49", ticket: 4));
}

void initPlayerCityCards() {
  int currentTicket = 0;
  for (;;) {
    int totalCount = cityCardList.length;
    int index = Random().nextInt(totalCount);
    var cityCard = cityCardList[index];
    if (currentTicket + cityCard.ticket > 10) {
      continue;
    }
    cityCardList.remove(cityCard);
    playerCityCard.add(cityCard);
    currentTicket = currentTicket + cityCard.ticket;
    if (currentTicket == 10) {
      break;
    }
  }
}

void initLineList() {
  lineList
      .add(LineInfo(cityName1: "呼伦贝尔", cityName2: "哈尔滨", color: Colors.red));
  lineList
      .add(LineInfo(cityName1: "佳木斯", cityName2: "哈尔滨", color: Colors.blue));
  lineList
      .add(LineInfo(cityName1: "长春", cityName2: "哈尔滨", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "长春", cityName2: "沈阳", color: Colors.red));
  lineList
      .add(LineInfo(cityName1: "北京", cityName2: "沈阳", color: Colors.orange));
  lineList
      .add(LineInfo(cityName1: "大连", cityName2: "沈阳", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "北京", cityName2: "呼和浩特", color: Colors.red));
  lineList
      .add(LineInfo(cityName1: "北京", cityName2: "石家庄", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "北京", cityName2: "天津", color: Colors.blue));

  lineList
      .add(LineInfo(cityName1: "大连", cityName2: "青岛", color: Colors.orange));
  lineList.add(LineInfo(cityName1: "济南", cityName2: "青岛", color: Colors.blue));
  lineList
      .add(LineInfo(cityName1: "济南", cityName2: "天津", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "上海", cityName2: "青岛", color: Colors.green));

  lineList.add(LineInfo(cityName1: "太原", cityName2: "石家庄", color: Colors.blue));
  lineList
      .add(LineInfo(cityName1: "济南", cityName2: "石家庄", color: Colors.green));
  lineList
      .add(LineInfo(cityName1: "呼和浩特", cityName2: "石家庄", color: Colors.orange));
  lineList
      .add(LineInfo(cityName1: "呼和浩特", cityName2: "太原", color: Colors.green));

  lineList
      .add(LineInfo(cityName1: "银川", cityName2: "太原", color: Colors.purple));
  lineList
      .add(LineInfo(cityName1: "银川", cityName2: "呼和浩特", color: Colors.blue));
  lineList.add(LineInfo(cityName1: "银川", cityName2: "兰州", color: Colors.green));
  lineList
      .add(LineInfo(cityName1: "银川", cityName2: "西宁", color: Colors.orange));

  lineList.add(LineInfo(cityName1: "郑州", cityName2: "太原", color: Colors.red));
  lineList
      .add(LineInfo(cityName1: "郑州", cityName2: "济南", color: Colors.orange));
  lineList
      .add(LineInfo(cityName1: "郑州", cityName2: "洛阳", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "郑州", cityName2: "武汉", color: Colors.blue));

  lineList
      .add(LineInfo(cityName1: "西安", cityName2: "天水", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "西安", cityName2: "洛阳", color: Colors.blue));
  lineList
      .add(LineInfo(cityName1: "武汉", cityName2: "洛阳", color: Colors.orange));
  lineList.add(LineInfo(cityName1: "西安", cityName2: "武汉", color: Colors.green));
  lineList.add(LineInfo(cityName1: "兰州", cityName2: "天水", color: Colors.red));
  lineList.add(LineInfo(cityName1: "兰州", cityName2: "西宁", color: Colors.blue));

  lineList
      .add(LineInfo(cityName1: "成都", cityName2: "天水", color: Colors.orange));
  lineList.add(LineInfo(cityName1: "成都", cityName2: "丽江", color: Colors.green));
  lineList.add(LineInfo(cityName1: "成都", cityName2: "重庆", color: Colors.blue));

  lineList
      .add(LineInfo(cityName1: "南京", cityName2: "上海", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "南京", cityName2: "杭州", color: Colors.blue));
  lineList.add(LineInfo(cityName1: "南京", cityName2: "合肥", color: Colors.green));
  lineList.add(LineInfo(cityName1: "南京", cityName2: "济南", color: Colors.red));

  lineList.add(LineInfo(cityName1: "上海", cityName2: "杭州", color: Colors.red));
  lineList.add(LineInfo(cityName1: "武汉", cityName2: "合肥", color: Colors.red));

  lineList
      .add(LineInfo(cityName1: "武汉", cityName2: "张家界", color: Colors.purple));
  lineList
      .add(LineInfo(cityName1: "重庆", cityName2: "张家界", color: Colors.orange));
  lineList
      .add(LineInfo(cityName1: "重庆", cityName2: "昆明", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "丽江", cityName2: "昆明", color: Colors.blue));

  lineList
      .add(LineInfo(cityName1: "可可西里", cityName2: "敦煌", color: Colors.orange));
  lineList
      .add(LineInfo(cityName1: "可可西里", cityName2: "西宁", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "可可西里", cityName2: "拉萨", color: Colors.red));
  lineList
      .add(LineInfo(cityName1: "可可西里", cityName2: "阿里地区", color: Colors.green));
  lineList.add(LineInfo(cityName1: "敦煌", cityName2: "西宁", color: Colors.green));
  lineList
      .add(LineInfo(cityName1: "敦煌", cityName2: "乌鲁木齐", color: Colors.blue));
  lineList
      .add(LineInfo(cityName1: "阿里地区", cityName2: "乌鲁木齐", color: Colors.red));
  lineList
      .add(LineInfo(cityName1: "阿里地区", cityName2: "拉萨", color: Colors.blue));
  lineList
      .add(LineInfo(cityName1: "丽江", cityName2: "拉萨", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "丽江", cityName2: "西宁", color: Colors.red));
  lineList
      .add(LineInfo(cityName1: "丽江", cityName2: "西双版纳", color: Colors.orange));
  lineList.add(LineInfo(cityName1: "昆明", cityName2: "西双版纳", color: Colors.red));
  lineList
      .add(LineInfo(cityName1: "昆明", cityName2: "贵阳", color: Colors.orange));
  lineList.add(LineInfo(cityName1: "昆明", cityName2: "南宁", color: Colors.green));

  lineList
      .add(LineInfo(cityName1: "长沙", cityName2: "张家界", color: Colors.green));
  lineList
      .add(LineInfo(cityName1: "长沙", cityName2: "南昌", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "长沙", cityName2: "桂林", color: Colors.red));
  lineList.add(LineInfo(cityName1: "长沙", cityName2: "香港", color: Colors.blue));
  lineList
      .add(LineInfo(cityName1: "长沙", cityName2: "福州", color: Colors.orange));
  lineList.add(LineInfo(cityName1: "张家界", cityName2: "桂林", color: Colors.blue));
  lineList.add(LineInfo(cityName1: "张家界", cityName2: "贵阳", color: Colors.red));
  lineList
      .add(LineInfo(cityName1: "贵阳", cityName2: "南宁", color: Colors.purple));
  lineList
      .add(LineInfo(cityName1: "桂林", cityName2: "南宁", color: Colors.orange));
  lineList.add(LineInfo(cityName1: "广州", cityName2: "南宁", color: Colors.blue));
  lineList.add(LineInfo(cityName1: "海口", cityName2: "南宁", color: Colors.red));

  lineList.add(LineInfo(cityName1: "香港", cityName2: "广州", color: Colors.green));
  lineList.add(LineInfo(cityName1: "澳门", cityName2: "广州", color: Colors.red));
  lineList
      .add(LineInfo(cityName1: "桂林", cityName2: "广州", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "香港", cityName2: "澳门", color: Colors.green));
  lineList
      .add(LineInfo(cityName1: "海口", cityName2: "澳门", color: Colors.orange));
  lineList
      .add(LineInfo(cityName1: "香港", cityName2: "厦门", color: Colors.purple));
  lineList
      .add(LineInfo(cityName1: "香港", cityName2: "高雄", color: Colors.orange));
  lineList.add(LineInfo(cityName1: "厦门", cityName2: "高雄", color: Colors.green));
  lineList
      .add(LineInfo(cityName1: "台北", cityName2: "上海", color: Colors.orange));
  lineList
      .add(LineInfo(cityName1: "台北", cityName2: "高雄", color: Colors.purple));
  lineList.add(LineInfo(cityName1: "台北", cityName2: "福州", color: Colors.green));
  lineList.add(LineInfo(cityName1: "厦门", cityName2: "福州", color: Colors.red));
  lineList.add(LineInfo(cityName1: "杭州", cityName2: "南昌", color: Colors.green));
  lineList.add(LineInfo(cityName1: "福州", cityName2: "南昌", color: Colors.blue));
  lineList
      .add(LineInfo(cityName1: "杭州", cityName2: "福州", color: Colors.purple));
}

void initCityList() {
  cityList["呼伦贝尔"] = CityInfo(cityName: "呼伦贝尔", x: 11, y: 0);
  cityList["佳木斯"] = CityInfo(cityName: "佳木斯", x: 13, y: 0);
  cityList["哈尔滨"] = CityInfo(cityName: "哈尔滨", x: 12, y: 1);
  cityList["长春"] = CityInfo(cityName: "长春", x: 11, y: 2);
  cityList["乌鲁木齐"] = CityInfo(cityName: "乌鲁木齐", x: 1, y: 2);

  cityList["沈阳"] = CityInfo(cityName: "沈阳", x: 11, y: 3);
  cityList["北京"] = CityInfo(cityName: "北京", x: 10, y: 4);
  cityList["呼和浩特"] = CityInfo(cityName: "呼和浩特", x: 8, y: 3);
  cityList["敦煌"] = CityInfo(cityName: "敦煌", x: 3, y: 3);

  cityList["天津"] = CityInfo(cityName: "天津", x: 11, y: 5);
  cityList["石家庄"] = CityInfo(cityName: "石家庄", x: 9, y: 5);
  cityList["太原"] = CityInfo(cityName: "太原", x: 8, y: 5);
  cityList["大连"] = CityInfo(cityName: "大连", x: 12, y: 5);
  cityList["银川"] = CityInfo(cityName: "银川", x: 7, y: 5);
  cityList["兰州"] = CityInfo(cityName: "兰州", x: 6, y: 6);
  cityList["西宁"] = CityInfo(cityName: "西宁", x: 5, y: 5);
  cityList["可可西里"] = CityInfo(cityName: "可可西里", x: 3, y: 5);
  cityList["阿里地区"] = CityInfo(cityName: "阿里地区", x: 0, y: 5);

  cityList["青岛"] = CityInfo(cityName: "青岛", x: 12, y: 6);
  cityList["济南"] = CityInfo(cityName: "济南", x: 11, y: 6);
  cityList["郑州"] = CityInfo(cityName: "郑州", x: 10, y: 6);
  cityList["洛阳"] = CityInfo(cityName: "洛阳", x: 9, y: 6);
  cityList["西安"] = CityInfo(cityName: "西安", x: 8, y: 7);
  cityList["天水"] = CityInfo(cityName: "天水", x: 7, y: 7);

  cityList["上海"] = CityInfo(cityName: "上海", x: 12, y: 7);
  cityList["南京"] = CityInfo(cityName: "南京", x: 11, y: 7);
  cityList["合肥"] = CityInfo(cityName: "合肥", x: 10, y: 7);

  cityList["杭州"] = CityInfo(cityName: "杭州", x: 12, y: 8);
  cityList["武汉"] = CityInfo(cityName: "武汉", x: 9, y: 8);
  cityList["张家界"] = CityInfo(cityName: "张家界", x: 8, y: 8);
  cityList["重庆"] = CityInfo(cityName: "重庆", x: 7, y: 8);
  cityList["成都"] = CityInfo(cityName: "成都", x: 6, y: 8);
  cityList["拉萨"] = CityInfo(cityName: "拉萨", x: 2, y: 8);

  cityList["福州"] = CityInfo(cityName: "福州", x: 12, y: 9);
  cityList["南昌"] = CityInfo(cityName: "南昌", x: 10, y: 8);
  cityList["长沙"] = CityInfo(cityName: "长沙", x: 9, y: 9);
  cityList["贵阳"] = CityInfo(cityName: "贵阳", x: 7, y: 9);
  cityList["丽江"] = CityInfo(cityName: "丽江", x: 4, y: 9);

  cityList["台北"] = CityInfo(cityName: "台北", x: 13, y: 10);
  cityList["厦门"] = CityInfo(cityName: "厦门", x: 11, y: 10);
  cityList["桂林"] = CityInfo(cityName: "桂林", x: 8, y: 10);
  cityList["昆明"] = CityInfo(cityName: "昆明", x: 6, y: 9);

  cityList["高雄"] = CityInfo(cityName: "高雄", x: 12, y: 11);
  cityList["广州"] = CityInfo(cityName: "广州", x: 9, y: 11);
  cityList["南宁"] = CityInfo(cityName: "南宁", x: 7, y: 11);
  cityList["西双版纳"] = CityInfo(cityName: "西双版纳", x: 5, y: 11);

  cityList["香港"] = CityInfo(cityName: "香港", x: 10, y: 12);
  cityList["澳门"] = CityInfo(cityName: "澳门", x: 9, y: 12);

  cityList["海口"] = CityInfo(cityName: "海口", x: 8, y: 13);
}
