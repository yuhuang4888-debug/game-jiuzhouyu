import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { DailyModel } from "../commonModel/DailyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, Trim } from "../util/Util"


export class DailyLimitActivityTipsView extends BaseView1 {
  OpenCallback
  SetTimeStr
  LoadSuccess
  InitEvent
  _Local_Open
  public constructor() {
    super()

    let model = DailyModel.GetInstance()

    // let escort_model = EscortModel.GetInstance()
    let _data = null
    let _item_list = null
    this.base_file = "daily"
    this.layout_file = "DailyLimitActivityTipsView"
    this.layer_value = Enum_UILayer.Activity
    this.is_center = true
    this.destroy_imm = true
    this.use_background = true
    this.click_bg_toClose = true
    this.show_open_movie = true
    this.preload_server_config = {
      "config_num_by_vip": false,
      "config_ac_kv": false
    }
    this.load_callback = () => {
      this.LoadSuccess()
      this.InitEvent()
    }

    this.open_callback = () => {
      this.OpenCallback()
    }

    this.destroy_callback = () => {
      for (let _tmpi in _item_list) {
        var obj = _item_list[_tmpi]
        obj.DeleteMe()
      }
      _item_list = null
    }

    this.LoadSuccess = () => {
      // this.RegisterMask(this.reward_scroll)
      _item_list = []
      this._Scroller1.vScrollBar.visible = false
      this._Scroller2.hScrollBar.visible = false
    }

    this.InitEvent = () => {
      let close_fun = () => {
        this.Close()
      }

      Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
    }

    this._Local_Open = (parms?) => {
      _data = parms
      super.Open()
    }

    this.OpenCallback = () => {
      if (!_data) {
        return
      }
      if (_data.ac_cfg) {
        ResManager.GetInstance().SetImageSpriteTrans(this, this.icon, GameResPath.GetDailyIconPath(_data.ac_cfg.ac_icon))
        let max = "1"
        if (_data.liveness_cfg) {
          max = (_data.liveness_cfg.max == 0 && ("不限") || (_data.liveness_cfg.max))
          if (_data.module == 460 && _data.module_sub == 2) {
            let config_ac_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_ac_kv", false);
            let config_num_by_vip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false);
            let [max_time, max_liveness] = model.GetPersonalBossTimesAndLiveness(_data.liveness_cfg.live, config_ac_kv, config_num_by_vip)
            max = String(max_time)
          }
        }
        let data = _data
        // let is_double_escort = escort_model.IsDoubleEscort(_data.module, _data.module_sub, _data.ac_sub)
        // if (is_double_escort) {
        //   let escmodel = escort_model
        //   let escort = model.GetDailyTaskVo(escmodel.EscortModule, escmodel.EscortSubModule, escmodel.EscortFunId)
        //   if (escort) {
        //     data = escort
        //   }
        // }
        this.name_str.text = _data.ac_cfg.ac_name
        this.times.style.fontSize = 22
        this.times.width = 280
        this.times.style.color = "#663915"
        this.times.innerHTML = Util.StrToHTML("次数:<font color='#0a953e'>" + (_data.max_num == 0 ? max : (data.num + "/" + _data.max_num)) + "</font>");
        let level = (_data.ac_cfg.start_lv > 370 && ("神创" + ((_data.ac_cfg.start_lv - 370))) || (_data.ac_cfg.start_lv))
        this.level_limit.text = "达到" + level + "级"
        this.SetTimeStr()
        this.content.text = Trim(_data.ac_cfg.about)
        // SetSizeDeltaY(this.Content, this.content.preferredHeight + 10)
        //SetSizeDeltaY(this.content_scroll, this.content.preferredHeight)
        let list = _data.reward_list
        if (list) {
          let item = null
          let i = 0
          do {
            item = _item_list[i]
            if (!item) {
              item = new BaseAwardItem(this.Content1, null, this.layer_value)
              _item_list[i] = item
              // item.SetMaskId(1)
              item.Load()
              item.SetScale(0.75)
            }
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(list[i][0], list[i][1])
            item.SetData(type_id, 0)
            i = i + 1
          } while ((i < list.length))
        }
      }
    }

    this.SetTimeStr = () => {
      let time = TimeUtil.getServerTime()
      let dateObj = new Date(time * 1000);//时间戳为10位需*1000，时间戳为13位的话不需乘1000
      let active_time_list = JSON.parse(_data.ac_cfg.time_region)
      if (active_time_list.length > 0) {
        let str = ""
        let vo
        for (let i = 0; i < active_time_list.length; i++) {
          vo = active_time_list[i]
          let start_hour = vo[0][0]
          let start_min = vo[0][1]
          let end_hour = vo[1][0]
          let end_min = vo[1][1]
          let hour_length = 0
          if (Number(start_hour) <= Number(end_hour)) {
            hour_length = Number(end_hour) - Number(start_hour)
          } else {
            hour_length = 24 + Number(end_hour) - Number(start_hour)
          }
          let min_length = Number(end_min) - Number(start_min)
          let all_mins = hour_length * 60 + min_length
          str = TimeUtil.GetTimeLengthByMin(all_mins)
        }
        this.time_length.text = str
      } else {
        this.time_length.text = "全天开放"
      }
    }


  }

  public Open(...new_args) {

    this._Local_Open(...new_args)
  }

  _Image1: Laya.Image
  closeBtn: Laya.Image
  _Image2: Laya.Image
  icon: Laya.Image
  _Image3: Laya.Image
  name_str: Laya.Label
  times: Laya.HTMLDivElement
  _Label1: Laya.Label
  _Label2: Laya.Label
  _Label3: Laya.Label
  level_limit: Laya.Label
  time_length: Laya.Label
  line1: Laya.Image
  reward_bg: Laya.Image
  _Scroller1: Laya.Panel
  Content: Laya.VBox
  content: Laya.Label
  _Label4: Laya.Label
  _Scroller2: Laya.Panel
  Content1: Laya.HBox
  public GetComponents() {
    [
      this._Image1,
      this.closeBtn,
      this._Image2,
      this.icon,
      this._Image3,
      this.name_str,
      this.times,
      this._Label1,
      this._Label2,
      this._Label3,
      this.level_limit,
      this.time_length,
      this.line1,
      this.reward_bg,
      this._Scroller1,
      this.Content,
      this.content,
      this._Label4,
      this._Scroller2,
      this.Content1,
    ]
      = this.GetChildrenByNames([

        "_Image1",
        "closeBtn",
        "_Image2",
        "icon",
        "_Image3",
        "name_str",
        "times",
        "_Label1",
        "_Label2",
        "_Label3",
        "level_limit",
        "time_length",
        "line1",
        "reward_bg",
        "_Scroller1",
        "Content",
        "content",
        "_Label4",
        "_Scroller2",
        "Content1",
      ])
  }
}
window["DailyLimitActivityTipsView"] = DailyLimitActivityTipsView