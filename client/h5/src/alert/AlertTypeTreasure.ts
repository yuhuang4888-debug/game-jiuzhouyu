import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Split, Util } from "../util/Util"
import { BaseAlert } from "./BaseAlert"

export class AlertTypeTreasure extends BaseAlert {
    //public
    public alert_type: number
    public activity_jump_id
    public is_show_activity=false
    public constructor(show_content, type, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback) {
        super(show_content, ok_callback, cancel_callback, ok_text, cancel_text, left_time, is_close_hide, check_callback, check_text, use_background, good_source, target_text, title_text, three_top_text, three_down_text, show_close_ani, title_img, close_callback)
        this.base_file = "alert"
        this.layout_file = "AlertTypeTreasure"
        this.alert_type = type
        this.destroy_imm = true
    }

    public LoadSuccess() {
        let guide_config_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_treasure_hunt_guide", false)
        ResManager.GetInstance().SetTexture(this,this._img_bg,GameResPath.GetIcon("alert","xx_titleBg_01"))
        let count =0
        for (let key in guide_config_) {
            let list = Split(key, "@")
            if (list[0] == 2) {
                if (list[1] == RuneTreasureModel.GetInstance().treasure_type_id) {
                    if (CustomActivityModel.GetInstance().GetActInfo(list[2], list[3])) {
                        let img = new Laya.Image()
                        this.activity_jump_id=guide_config_[key].jump_id
                        img.skin= GameResPath.GetIcon("alert",guide_config_[key].picture) 
                        img.width=72
                        img.height=72
                        this.activity_icon.addChild(img)
                        if(this.activity_jump_id){
                            Util.AddClickEvent(img,()=>{
                                GlobalEventSystem.Fire(EventName.CLOSE_CONGRATULATION_VIWE)
                                this.Close()
                                OpenFun.OpenFunHandler(this.activity_jump_id)
                            },this,true)
                        }
                        count++
                        if(count>=5){
                            this.activity_icon.width=410
                        }
                        this.is_show_activity=true
                    }
                }
            }
        }
        if(!this.is_show_activity){
            this._img_bg.visible=false
            this._lb_1.visible=false
            this.activity_icon.visible=false
            this.check.pos(230,259)
            this._ok_btn.pos(393,343)
            this._cancel_btn.pos(140,343)
            this._content.pos(70,120)
            this._img_title.pos(57,55)
            this._img_bg_1.height=219
            this.bg.height=414
        }
       
        super.LoadSuccess()
    }
    bg: Laya.Image
    _img_bg_1: Laya.Image
    _img_title: Laya.Image
    _content: Laya.Box
    _content_html: Laya.HTMLDivElement
    _close_btn: Laya.Image
    _cancel_btn: Laya.Image
    cancel_label: Laya.Label
    _ok_btn: Laya.Image
    ok_label: Laya.Label
    check: Laya.Box
    _img_bg: Laya.Image
    _lb_1: Laya.Label
    activity_icon: Laya.HBox
    public GetComponents() {
        [
            this.bg,
            this._img_bg_1,
            this._img_title,
            this._content,
            this._content_html,
            this._close_btn,
            this._cancel_btn,
            this.cancel_label,
            this._ok_btn,
            this.ok_label,
            this.check,
            this._img_bg,
            this._lb_1,
            this.activity_icon,
        ]
            = this.GetChildrenByNames([

                "bg",
                "_img_bg_1",
                "_img_title",
                "_content",
                "_content_html",
                "_close_btn",
                "_cancel_btn",
                "cancel_label",
                "_ok_btn",
                "ok_label",
                "check",
                "_img_bg",
                "_lb_1",
                "activity_icon",
            ])
    }
}
window["AlertTypeTreasure"] = AlertTypeTreasure