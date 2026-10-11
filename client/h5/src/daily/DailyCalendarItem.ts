import { BaseItem1 } from "../common/BaseItem1"
import { DailyModel } from "../commonModel/DailyModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { ErlangParser } from "../util/ErlangParser"
import { TimeUtil } from "../util/TimeUtil"
import { Trim } from "../util/Util"


export class DailyCalendarItem extends BaseItem1 {
  data
  model
  needRefresh

  public constructor(parent?) {
    super(parent)
    this.base_file = "daily"
    this.layout_file = "DailyCalendarItem"
    this.model = DailyModel.GetInstance()

    this.load_callback = () => {
      this.LoadSuccess()
      this.InitEvents()
    }
  }

  public DeleteMe() {

    super.DeleteMe()
  }

  public LoadSuccess() {


  }

  public InitEvents() {

    if (this.needRefresh) {
      this.SetData(this.data)
    }
  }

  public SetData(data?) {
    this.data = data
    if (this.is_loaded && this.data) {
      this.time_label.text = Trim(this.data.doc)
      let curTime = TimeUtil.GetZoneTime()
      // let weekday = Number(os.date("%w", curTime))
      let date = new Date(curTime * 1000)
      let weekday = date.getDay()
      //let weekday = Number(os.date("%w",TimeUtil.getServerTime()))
      if (weekday == 0) {
        weekday = 7
      }
      this.SetDaysActivity(this.data.day_1, 1, weekday)
      this.SetDaysActivity(this.data.day_2, 2, weekday)
      this.SetDaysActivity(this.data.day_3, 3, weekday)
      this.SetDaysActivity(this.data.day_4, 4, weekday)
      this.SetDaysActivity(this.data.day_5, 5, weekday)
      this.SetDaysActivity(this.data.day_6, 6, weekday)
      this.SetDaysActivity(this.data.day_7, 7, weekday)
    } else {
      this.needRefresh = true
    }
  }

  public SetDaysActivity(activity_str?, day?, weekday?) {

    if (this.data) {
      let str = ""
      let list = JSON.parse(activity_str)
      let count = 0
      if (list && list.length > 0) {
        let open_server_day = ServerTimeModel.GetInstance().GetOpenServerDay()
        let real_open_server_day = open_server_day
        if (weekday <= day) {
          real_open_server_day = open_server_day + day - weekday
        } else {
          real_open_server_day = open_server_day - weekday - day
          if (real_open_server_day <= 0) {
            real_open_server_day = 1
          }
        }
        let vo = null
        let cfg = null
        let i = 0
        do {
          vo = list[i]
          if (real_open_server_day >= Number(vo[3]) && real_open_server_day <= Number(vo[4])) {
            cfg = this.model.GetAcCfg(vo[0], vo[1], vo[2])
            if (cfg) {
              count = count + 1
              if (count == 1) {
                str = cfg.ac_name
              } else {
                str = str + "\n" + cfg.ac_name
              }
            }
          }
          i = i + 1
        } while ((i < list.length))
      }
      this["label" + day].fontSize = count > 2 && 16 || 18
      this["label" + day].text = Trim(str)
    }
  }


  _Image1: Laya.Image
  _Image2: Laya.Image
  _Image3: Laya.Image
  _Image4: Laya.Image
  _Image5: Laya.Image
  _Image6: Laya.Image
  _Image7: Laya.Image
  _Image8: Laya.Image
  _Group1: Laya.Box
  time_label: Laya.Label
  _Group2: Laya.Box
  label1: Laya.Label
  _Group3: Laya.Box
  label2: Laya.Label
  _Group4: Laya.Box
  label3: Laya.Label
  today_bg: Laya.Image
  _Group5: Laya.Box
  label4: Laya.Label
  _Group6: Laya.Box
  label5: Laya.Label
  _Group7: Laya.Box
  label6: Laya.Label
  _Group8: Laya.Box
  label7: Laya.Label
  public GetComponents() {
    [
      this._Image1,
      this._Image2,
      this._Image3,
      this._Image4,
      this._Image5,
      this._Image6,
      this._Image7,
      this._Image8,
      this._Group1,
      this.time_label,
      this._Group2,
      this.label1,
      this._Group3,
      this.label2,
      this._Group4,
      this.label3,
      this.today_bg,
      this._Group5,
      this.label4,
      this._Group6,
      this.label5,
      this._Group7,
      this.label6,
      this._Group8,
      this.label7,
    ]
      = this.GetChildrenByNames([

        "_Image1",
        "_Image2",
        "_Image3",
        "_Image4",
        "_Image5",
        "_Image6",
        "_Image7",
        "_Image8",
        "_Group1",
        "time_label",
        "_Group2",
        "label1",
        "_Group3",
        "label2",
        "_Group4",
        "label3",
        "today_bg",
        "_Group5",
        "label4",
        "_Group6",
        "label5",
        "_Group7",
        "label6",
        "_Group8",
        "label7",
      ])
  }
}
window["DailyCalendarItem"] = DailyCalendarItem