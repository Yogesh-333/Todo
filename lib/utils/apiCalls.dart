import 'dart:convert';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import '../data_models/todoModel.dart';
import 'constants.dart';

class ApiCall extends GetxController {
  //## Api call to fetch records from notion DB ##//
  fetchTodo() async {
    List<TodoModel> result = [];
    var url = Uri.parse(
        ApiDetails.apiUrl + '/databases/${ApiDetails.dataBaseID}/query');
    var response = await http.post(url, headers: {
      'Notion-Version': ApiDetails.notionVersion,
      'Authorization': 'Bearer ' + ApiDetails.securityToken
    });
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      var parse1 = parse['results'];
      for (Map i in parse1) {
        String pageId = i['id'];
        String content = i['properties']['todo']['title'][0]['plain_text'];
        String status = i['properties']['status']['rich_text'][0]['plain_text'];
        result.add(TodoModel(pageId, status, content));
      }
    }

    return result;
  }

  insertTodo(String todo) async {
    try {
      var url = Uri.parse(ApiDetails.apiUrl + '/pages/');
      var response = await http.post(url,
          headers: {
            'Notion-Version': ApiDetails.notionVersion,
            'Authorization': 'Bearer ' + ApiDetails.securityToken,
            'Content-Type': 'application/json'
          },
          body: json.encode({
            "parent": {"database_id": ApiDetails.dataBaseID},
            "properties": {
              "status": {
                "type": "rich_text",
                "rich_text": [
                  {
                    "type": "text",
                    "text": {"content": "active", "link": null},
                    "annotations": {
                      "bold": false,
                      "italic": false,
                      "strikethrough": false,
                      "underline": false,
                      "code": false,
                      "color": "default"
                    },
                    "plain_text": "active",
                    "href": null
                  }
                ]
              },
              "todo": {
                "id": "title",
                "type": "title",
                "title": [
                  {
                    "type": "text",
                    "text": {"content": todo, "link": null},
                    "annotations": {
                      "bold": false,
                      "italic": false,
                      "strikethrough": false,
                      "underline": false,
                      "code": false,
                      "color": "default"
                    },
                    "plain_text": todo,
                    "href": null
                  }
                ]
              }
            }
          }));
      if (response.statusCode == 200) {
        var parse = jsonDecode(response.body);
        String pageId = parse['id'];
        return pageId;
      }
    } catch (e) {
      return "fail";
    }
    return "fail";
  }

  updateTodo(String pageId, String todo,String status) async {
    try {
      var url = Uri.parse(ApiDetails.apiUrl + '/pages/' + pageId);
      var response = await http.patch(
        url,
        headers: {
          'Notion-Version': ApiDetails.notionVersion,
          'Authorization': 'Bearer ' + ApiDetails.securityToken,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "properties": {
            "status": {
              "type": "rich_text",
              "rich_text": [
                {
                  "type": "text",
                  "text": {"content": status, "link": null},
                  "annotations": {
                    "bold": false,
                    "italic": false,
                    "strikethrough": false,
                    "underline": false,
                    "code": false,
                    "color": "default"
                  },
                  "plain_text": status,
                  "href": null
                }
              ]
            },
            "todo": {
              "id": "title",
              "type": "title",
              "title": [
                {
                  "type": "text",
                  "text": {"content": todo, "link": null},
                  "annotations": {
                    "bold": false,
                    "italic": false,
                    "strikethrough": false,
                    "underline": false,
                    "code": false,
                    "color": "default"
                  },
                  "plain_text": todo,
                  "href": null
                }
              ]
            }
          }
        }),
      );
      if (response.statusCode == 200) {
        var parse = jsonDecode(response.body);
        String pageId = parse['id'];
        return pageId;
      }
    } catch (e) {
      return "fail";
    }
    return "fail";
  }

  deleteTodo(String pageId)async {
    try {
      var url = Uri.parse(ApiDetails.apiUrl + '/pages/' + pageId);
      var response = await http.patch(
        url,
        headers: {
          'Notion-Version': ApiDetails.notionVersion,
          'Authorization': 'Bearer ' + ApiDetails.securityToken,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "archived":true
        }),
      );
      if (response.statusCode == 200) {
        var parse = jsonDecode(response.body);
        String pageId = parse['id'];
        return pageId;
      }
    } catch (e) {
      return "fail";
    }
    return "fail";
  }
}
