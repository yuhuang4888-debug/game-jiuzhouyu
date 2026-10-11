import { BaseItem1 } from "../common/BaseItem1"
import { GlobalTimerQuest, SetMaterialTexture, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { SYTweenLite } from "../util/SYTweenLite"
import { RuneTreasureEvent, RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneModel } from "../commonModel/RuneModel"
import { WordManager } from "../common/WordManager"
import { ArtifactIllusionView } from "../pet/artifact/ArtifactIllusionView"
import { ColorUtil } from "../util/ColorUtil"

export class PlayerMessageRuneItem extends BaseItem1 {
    _btn_click: Laya.Box
    _img_icon: Laya.Image
    _img_color: Laya.Image
    _lb_msg1: Laya.Label
    _lb_msg2: Laya.Label
    _lb_msg3: Laya.Label
    _img_bg: Laya.Image
    runeBox: Laya.Box
    runeBgImg: Laya.Image
    runeCardImg: Laya.Image
    runeBg1Img: Laya.Image
    runeTitleImg: Laya.Image
    runeLevel: Laya.Label
    is_awake: Laya.Image

    model
    res_mgr
    goods_model
    rune_model

    data
    need_refresh = false
    is_anim = false
    anim_time = 0.2
    tween_id1 = null
    tween_id2 = null
    rune_color = {
        1: "rune_N",
        2: "rune_R",
        3: "rune_SR",
        4: "rune_SSR",
        5: "rune_UR",
        6: "rune_SP"
    }
    //rune_mat:Laya.EffectMaterial
    //rune_tex

    public constructor(parent) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageRuneItem"

        this.res_mgr = ResManager.GetInstance()
        this.model = RuneTreasureModel.GetInstance()
        this.goods_model = GoodsModel.GetInstance()
        this.rune_model = RuneModel.GetInstance()

        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvent()

            if (this.need_refresh) {
                this.need_refresh = false
                this.SetData(this.data)
            }
        }
    }

    public LoadSuccess() {

    }

    public InitEvent() {

    }

    public SetData(data) {
        this.data = data
        if (!this.is_loaded) {
            this.need_refresh = true
            return
        }
        let is_awake =false
        if(this.data.attr_list.length> 0 ){
            for(let key in this.data.attr_list){
                if( this.data.attr_list[key].awake_lv > 0){
                    is_awake = true
                }
            }
        }
        if(is_awake){
            this.is_awake.visible = true
        }else{
            this.is_awake.visible  = false
        }

        let url = "resource/game/runeIcon/" + this.data.goods_type_id + ".png"
        // this.res_mgr.SetOutsideImageSprite(this, this._img_icon, url)
        let basic = this.goods_model.GetGoodsBasicByTypeId(this.data.goods_type_id)
        if (basic) {
            this.runeBox.visible = true
            ResManager.GetInstance().SetImageSprite(this, this.runeTitleImg, "rune", "color_" + basic.color)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.runeBgImg, "resource/game/runeCard/icon_kpbg_0" + basic.color + ".png")
            ResManager.GetInstance().SetOutsideImageSprite(this, this.runeBg1Img, "resource/game/runeCard/icon_kp_0" + basic.color + ".png")
            ResManager.GetInstance().SetOutsideImageSprite(this, this.runeCardImg, "resource/game/runeCard/" + basic.type_id + ".png")
            // let color = ColorUtil.GetColorLight(this.data.color,false)
            // this.runeLevel.color = color
            this.runeLevel.bold = false
           this.runeLevel.text = basic.goods_name + "  Lv."+this.data.lv
        }
    }

    public DeleteMe() {
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this._btn_click,
            this._img_icon,
            this._img_color,
            this._lb_msg1,
            this._lb_msg2,
            this._lb_msg3,
            this._img_bg,
            this.runeBox,
            this.runeBgImg,
            this.runeCardImg,
            this.runeBg1Img,
            this.runeTitleImg,
            this.runeLevel,
            this.is_awake
        ]
            = this.GetChildrenByNames([

                "_btn_click",
                "_img_icon",
                "_img_color",
                "_lb_msg1",
                "_lb_msg2",
                "_lb_msg3",
                "_img_bg",
                "runeBox",
                "runeBgImg",
                "runeCardImg",
                "runeBg1Img",
                "runeTitleImg",
                "runeLevel",
                "is_awake"
            ])
    }
}
window["PlayerMessageRuneItem"] = PlayerMessageRuneItem