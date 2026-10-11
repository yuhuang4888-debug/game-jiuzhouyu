import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { MarriageModel } from "../commonModel/MarriageModel"
import { GameResPath } from "../util/GameResPath"
import { AtlasUrl, GlobalTimerQuest, Util } from "../util/Util"

export class MarriageRingChangeView extends BaseView1 {

    Local_Open
    LoadSuccess
    UpdateView
    SetModel
    ClearEffect
    OnTimer
    time_id
    cur_time = 0
    time_down = 10
    public constructor() {
        super()
        let _model = MarriageModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            _stage_: number

        this.base_file = "pet"
        this.layout_file = "OutwardChangedView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.background_alpha = 1
        this.click_bg_toClose = true
        this.is_center = true
        this.load_callback = function () {
            this.LoadSuccess()
        }
        this.open_callback = function () {
            SoundManager.GetInstance().PlaySoundEffect("3_huode")
            this.UpdateView()
        }
        this.destroy_callback = function () {
            this.ClearEffect()
            if (this.time_id) {
                GlobalTimerQuest.CancelQuest(this.time_id)
                this.time_id = null
            }
            this.time_down = 10
        }
        this.preload_server_config = {
            "config_ring_stage": false
        }

        this.Local_Open = (parms) => {
            [_stage_] = parms
            super.Open()
        }

        this.LoadSuccess = () => {
            this.image_name.visible = false
            res_mgr.SetTexture(this, this.table_img, "resource/game/pet/texture/uixxxjs_001.png")

            Util.AddClickEvent(this.click_group, () => {
                this.Close()
            }, this, false)
        }

        this.UpdateView = () => {
            this.SetModel()
        }

        this.SetModel = () => {
            this.model_group.visible = false
            this.outward_img.visible = true

            let config = res_mgr.GetGameConfigFromCache(this, "config_ring_stage", false)
            let stage_data = _model.GetRingStageData(_stage_, config)
            if (!stage_data) return
            this.outward_img.size(325, 325)
            this.outward_img.scale(0.7, 0.7)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.outward_img, GameResPath.GetIcon("marriage", stage_data.resource_id))


            if (!this.time_id) {
                this.time_id = GlobalTimerQuest.AddPeriodQuest(this.OnTimer, 1)
                this.OnTimer()
            }
        }

        this.OnTimer = () => {
            if (this.use_delete_method) {
                return
            }
            let left_time = this.time_down - this.cur_time
            if (left_time <= 0) {
                this.Close()
                return
            }
            this.tipstext.text = left_time + "秒后自动关闭"
            this.cur_time = this.cur_time + 1
        }


        this.ClearEffect = () => {
        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }

    image_text_group: Laya.Box
    tipstext: Laya.Label
    table_img: Laya.Image
    image_bigglow_group: Laya.Box
    _Image1: Laya.Image
    _Image2: Laya.Image
    success_image: Laya.Image
    model_group: Laya.Box
    image_text: Laya.Image
    outward_img: Laya.Image
    image_name: Laya.Image
    nameBox: Laya.Box
    titleImg: Laya.Image
    name_label: Laya.Label
    click_group: Laya.Box
    wx_share_con: Laya.Box
    _gp_effect_icon: Laya.Box
    dsgt_icon_image: Laya.Image
    img_con: Laya.Box
    model_img: Laya.Image
    click: Laya.Image
    btnUse: Laya.Image
    useLab: Laya.Label
    btnClose: Laya.Image
    closeLab: Laya.Label
    public GetComponents() {
        [
            this.image_text_group,
            this.tipstext,
            this.table_img,
            this.image_bigglow_group,
            this._Image1,
            this._Image2,
            this.success_image,
            this.model_group,
            this.image_text,
            this.outward_img,
            this.image_name,
            this.nameBox,
            this.titleImg,
            this.name_label,
            this.click_group,
            this.wx_share_con,
            this._gp_effect_icon,
            this.dsgt_icon_image,
            this.img_con,
            this.model_img,
            this.click,
            this.btnUse,
            this.useLab,
            this.btnClose,
            this.closeLab,
        ]
            = this.GetChildrenByNames([

                "image_text_group",
                "tipstext",
                "table_img",
                "image_bigglow_group",
                "_Image1",
                "_Image2",
                "success_image",
                "model_group",
                "image_text",
                "outward_img",
                "image_name",
                "nameBox",
                "titleImg",
                "name_label",
                "click_group",
                "wx_share_con",
                "_gp_effect_icon",
                "dsgt_icon_image",
                "img_con",
                "model_img",
                "click",
                "btnUse",
                "useLab",
                "btnClose",
                "closeLab",
            ])
    }
}
window["MarriageRingChangeView"] = MarriageRingChangeView