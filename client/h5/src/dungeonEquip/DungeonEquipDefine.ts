import { BaseClass } from "../common/BaseClass";
import { table } from "../common/table";
import { SceneManager } from "../scene/SceneManager";
import { TimeUtil } from "../util/TimeUtil";

export class DungeonEquipDefine extends BaseClass {
  public static OpenLV = 120;
  public static TeamType = 5;
  public static MaxNum = 3;
  public static LevelTips = {
    // 5001: "uizbfb_007_03",
    // 5002: "uizbfb_007_05",
    // 5003: "uizbfb_007_07",
    // 5004: "uizbfb_007_09",
    // 5005: "uizbfb_007_15",
    // 5006: "uizbfb_007_16",
    // 5007: "uizbfb_007_17",
    // 5008: "uizbfb_007_18",
    // 5009: "uizbfb_007_23",
    // 5010: "uizbfb_007_24",
    // 5011: "uizbfb_007_25",
    // 5012: "uizbfb_007_26",
    // 5013: "uizbfb_007_31"
    5001: "新手",
    5002: "基础",
    5003: "普通",
    5004: "困难",
    5005: "专精",
    5006: "达人",
    5007: "强者",
    5008: "大师",
    5009: "末日",
    5010: "噩梦",
    5011: "灾难",
    5012: "灭世",
    5013: "天神"
  }
  public static ScoreCfg = {
    5: { name: "普通", drop: 100, source: "uizbfb_049", drop_source: "uizbfb_051" },
    4: { name: "困难", drop: 125, source: "uizbfb_048", drop_source: "uizbfb_052" },
    3: { name: "修罗", drop: 150, source: "uizbfb_047", drop_source: "uizbfb_040" },
    2: { name: "地狱", drop: 175, source: "uizbfb_046", drop_source: "uizbfb_053" },
    1: { name: "炼狱", drop: 200, source: "uizbfb_045", drop_source: "uizbfb_038" }
  }
  public static ScoreMaxLevel = 1;
  public static HelpDunId = 5001;
  public static InviteInterval = 10;
  public static RefreshRoomInterval = 1;
  public static MatchTotalTime = 15;
  public static HonerId = 36255010;
  public static RecordPos = false;
  public static pos_list = [];
  public static SavePosition(x, y) {
    table.insert(DungeonEquipDefine.pos_list, { pos_x:Math.floor(x), pos_y:Math.floor(y) })
  }

  public static OutputPositionToFile() {
    let txt = ""
    let scene_id = SceneManager.Instance.GetSceneId()
    for (let i in DungeonEquipDefine.pos_list) {

      let v = DungeonEquipDefine.pos_list[i]
      let str = "{" + v.pos_x + "," + v.pos_y + "}"
      let index = Number(i)
      if (index == 1) {
        txt = "[" + str
      }
      else if (index + 1 == DungeonEquipDefine.pos_list.length) {
        txt = txt + "," + str + "]"
      } else {
        txt = txt + "," + str
      }
    }
    DungeonEquipDefine.download(TimeUtil.timeConversion(TimeUtil.getServerTime(), "yyyy/mm/dd hh.MM:ss") + " path", txt)
    DungeonEquipDefine.pos_list = []
  }

  public static download(filename, text) {
    let element = document.createElement('a')
    element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text))
    element.setAttribute('download', filename)
    element.style.display = 'none'
    document.body.appendChild(element)
    element.click()
    document.body.removeChild(element)
  }
}

window["DungeonEquipDefine"] = DungeonEquipDefine