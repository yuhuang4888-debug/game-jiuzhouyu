import { BaseView1 } from "../common/BaseView1";
import { Config } from "../common/Config";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class GodBeastSkillView extends BaseView1 {

    Local_Open
    InitEvent
    UpdateView
    GetAttrList
    public constructor() {
        super()
        let _model = GodBeastModel.GetInstance(),
            local_Util = Util,
            local_GodBeastEvent = GodBeastEvent,
            local_Number = Number,
            _skill_data_ //[0]=id [1]=lv

        this.base_file = "godBeast"
        this.layout_file = "GodBeastSkillView"
        this.layer_value = Enum_UILayer.Activity;
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true

        this.load_callback = function () {
            this._Scroller1.vScrollBar.visible = false
            this.InitEvent()
        }

        this.open_callback = function () {
            this.UpdateView()
        }
        this.Local_Open = (parms) => {
            [_skill_data_] = parms
            super.Open()
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_ok, () => {
                this.Close()
            }, this, true)

            this.BindEvent(_model, local_GodBeastEvent.UPDATE_ATTR_POWER, (scmd) => {
                this._lb_fight.text = `z${scmd.combat_power}`
            })
        }

        this.UpdateView = () => {
            let skill_id = _skill_data_[0]
            let lv = local_Number(_skill_data_[1])
            let data = Config.PRELOAD_SERVER_CONFIG.config_skill[skill_id]
            if (!data) return
            this._lb_name.text = `名称：${data.name}`
            this._lb_lv.text = `等级：${lv}级`
            ResManager.GetInstance().SetTexture(this, this._img_icon, GameResPath.GetSkillIconPath(data.id))
            let lv_data = JSON.parse(data.lv_data)
            if (!lv_data) return
            let index = Math.max(lv - 1, 0)
            lv_data = lv_data[index]
            this._lb_intro.style.color = "#4a3a32"
            this._lb_intro.style.fontSize = 24
            this._lb_intro.style.width = 416
            this._lb_intro.style.leading = 20
            this._lb_intro.innerHTML = lv_data ? local_Util.StrToHTML(lv_data.desc) : ""

            if (lv_data.power != "0") {
                this._lb_fight.text = `z${lv_data.power}`
            } else {
                let attr_list = this.GetAttrList(lv_data.base_attr)
                if (attr_list.length > 0) {
                    _model.Fire(local_GodBeastEvent.GET_ATTR_POWER, 173, 0, attr_list)
                } else {
                    let power = local_Util.GetSkillPower(skill_id, lv)
                    this._lb_fight.text = power ? `z${power}` : ``
                }
            }
        }

        this.GetAttrList = (attr_list) => {
            let list = []
            for (let info of attr_list) {
                let data = info.split(",")
                if (data[0] != "173") continue
                list.push([local_Number(data[1]), local_Number(data[2])])
            }
            return list
        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }
    

    _Image11: Laya.Image
    _Image2: Laya.Image
    _img_icon: Laya.Image
    _lb_name: Laya.Label
    _lb_lv: Laya.Label
    _lb_fight: Laya.Label
    _btn_ok: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    _Scroller1: Laya.Panel
    _Group1: Laya.VBox
    _Label1: Laya.Label
    _lb_intro: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._img_icon,
            this._lb_name,
            this._lb_lv,
            this._lb_fight,
            this._btn_ok,
            this._Image1,
            this.labelDisplay,
            this._Scroller1,
            this._Group1,
            this._Label1,
            this._lb_intro,
        ]
            = this.GetChildrenByNames([

                "_Image11",
                "_Image2",
                "_img_icon",
                "_lb_name",
                "_lb_lv",
                "_lb_fight",
                "_btn_ok",
                "_Image1",
                "labelDisplay",
                "_Scroller1",
                "_Group1",
                "_Label1",
                "_lb_intro",
            ])
    }
}

window["GodBeastSkillView"] = GodBeastSkillView