import { BaseView1 } from "../common/BaseView1";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { Enum_UILayer } from "../common/LayerManager";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

//伴侣-求婚提示界面
export class MarriageAskTipsView extends BaseView1 {

    private _head: CustomHeadItem;

    Local_Open
    LoadSuccess
    InitEvent
    UpdateView
    public constructor() {
        super()
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageAskTipsView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        // this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            local_Util = Util,
            REQUEST_PROTO = MarriageEvent.REQUEST_PROTO,
            _data_

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_086, GameResPath.GetIcon("marriage", "ui_marry_30"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("marriage", "uijh_090"))
            this.LoadSuccess()
            this.InitEvent()
        }

        this.destroy_callback = function () {
            if (this._head) {
                this._head.DeleteMe()
                this._head = null
            }
        }

        this.Local_Open = (parms) => {
            [_data_] = parms
            super.Open()
        }

        this.LoadSuccess = () => {
            if (!_data_) return
            this._head = new CustomHeadItem(this._head_con)
            this._head.Load()

            let data = _data_
            this._lb_power.text = `z${data.combat_power}`
            this._lb_name.text = data.name
            this._lb_msg.text = data.msg
            this._head.SetRoleVoData(data)

            res_mgr.SetTexture(this, this.img1, "resource/game/marriage/texture/uijh_081.png")
            res_mgr.SetTexture(this, this._img_bg, "resource/game/marriage/texture/uijh_090.png")

            // res_mgr.SetTexture(this, this._img_086, "resource/game/marriage/texture/uijh_086.png")
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_agree, () => {
                _model.Fire(REQUEST_PROTO, 17223, "lc", _data_.role_id, 1)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_refuse, () => {
                _model.Fire(REQUEST_PROTO, 17223, "lc", _data_.role_id, 2)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_close, () => {
                _model.Fire(REQUEST_PROTO, 17223, "lc", _data_.role_id, 2)
                this.Close()
            }, this, true)
        }

        this.UpdateView = () => {

        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }

    img1: Laya.Image
    _img_bg: Laya.Image
    img2: Laya.Image
    img3: Laya.Image
    img4: Laya.Image
    _img_086: Laya.Image
    group1: Laya.HBox
    _btn_refuse: Laya.Box
    _Image11: Laya.Image
    labelDisplay11: Laya.Label
    _btn_agree: Laya.Box
    _Image111: Laya.Image
    labelDisplay111: Laya.Label
    _btn_close: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    _lb_name: Laya.Label
    _lb_msg: Laya.Label
    _lb_power: Laya.Label
    _head_con: Laya.Box
    public GetComponents() {
        [
            this.img1,
            this._img_bg,
            this.img2,
            this.img3,
            this.img4,
            this._img_086,
            this.group1,
            this._btn_refuse,
            this._Image11,
            this.labelDisplay11,
            this._btn_agree,
            this._Image111,
            this.labelDisplay111,
            this._btn_close,
            this._Image1,
            this.labelDisplay,
            this._lb_name,
            this._lb_msg,
            this._lb_power,
            this._head_con,
        ]
            = this.GetChildrenByNames([

                "img1",
                "_img_bg",
                "img2",
                "img3",
                "img4",
                "_img_086",
                "group1",
                "_btn_refuse",
                "_Image11",
                "labelDisplay11",
                "_btn_agree",
                "_Image111",
                "labelDisplay111",
                "_btn_close",
                "_Image1",
                "labelDisplay",
                "_lb_name",
                "_lb_msg",
                "_lb_power",
                "_head_con",
            ])
    }
}
window["MarriageAskTipsView"] = MarriageAskTipsView