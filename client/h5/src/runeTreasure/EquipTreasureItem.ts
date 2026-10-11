import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BagModel } from "../commonModel/BagModel"
import { GodBefallDefine } from "../commonModel/GodBefallModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PetEquipDefine } from "../commonModel/PetEquipDefine"
import { RoleManager } from "../commonModel/RoleManager"
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { FlyShoeMinDistance } from "../scene/SceneConfig"
import { Util } from "../util/Util"

export class EquipTreasureItem extends BaseItem1 {
    public click_group
    public exp_bg
    public effect_group
    public icon_bg
    public icon_light
    public icon_img
    public icon_mask
    public front_effect_group
    public boxImg
    public icon_box
    reddot
    goods_basic
    color
    type_id
    need_refresh
    changed = true
    treasureType
    model = RuneTreasureModel.GetInstance()

    preScale=1
    // boxImg
    public constructor(parent) {
        super(parent)
        this.base_file = "runeTreasure"
        this.layout_file = "EquipTreasureItem"
        this.preload_client_config={
            "ConfigIllusionModel":false
        }
        this.load_callback = function () {
            if(this.need_refresh){
                this.SetData(this.type_id)
            }
            this.InitEvent()
            this.display_obj.scaleX = this.display_obj.scaleY = this.preScale
        }
    }

    public SetData(type_id) {
        let self = this
        self.type_id = type_id
        self.goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(self.type_id)
        self.color = self.goods_basic ? self.goods_basic.color : 1
        if (self.is_loaded) {
            self.need_refresh = false
            if (self.goods_basic) {
                self.icon_bg.skin = `resource/game/runeTreasure/texture/uizbxb_${self.color}.png`
                self.icon_light.skin = `resource/game/runeTreasure/texture/uizbxb_l${self.color}.png`
                self.icon_img.visible = true
                let icon = self.goods_basic.goods_icon
                if (self.goods_basic.type == 34) {
                    self.boxImg.visible = true
                    if (self.treasureType == 1) {
                        icon = `20030002`
                    } else if (self.treasureType == 2) {
                        icon = `20030003`
                    }
                } else {
                    self.boxImg.visible = false
                }
                if(self.goods_basic.type==20 ){
                    if(this.preload_client_config["ConfigIllusionModel"][self.goods_basic.type_id]){
                       ResManager.GetInstance().SetTexture(self,self.icon_img, "resource/game/goodsIcon/" + this.preload_client_config["ConfigIllusionModel"][self.goods_basic.type_id].picture[RoleManager.GetInstance().GetMainRoleVo().career]+ ".png") 
                    }else{
                        ResManager.GetInstance().SetTexture(self, self.icon_img, "resource/game/goodsIcon/" + icon + ".png")
                    }
                }else{
                    ResManager.GetInstance().SetTexture(self, self.icon_img, "resource/game/goodsIcon/" + icon + ".png")
                }
                if (!self.icon_mask) {
                    // this.totalMask = new Laya.Sprite()
                    // this.location.addChild(this.totalMask)
                    // this.totalMask.graphics.clear()
                    // let pie=this.totalMask.graphics.drawRect(10,15,60,70,"#FFFFFF")
                    // this.headIcon.mask = this.totalMask
                    // this.totalMask.visible=false;

                    this.icon_mask = new Laya.Sprite()
                    this.icon_box.addChild(this.icon_mask)
                    this.icon_mask.graphics.clear()
                    this.icon_mask.graphics.drawCircle(45, 45, 45,"#FFFFFF")
                    this.icon_img.mask = self.icon_mask
                    this.icon_mask.visible=false
                }
            }

        } else {
            self.need_refresh = true
        }
    }
    public SetUIEffect(type?) {
        let self = this
        if(type==1){
            this.effect_group.centerX=-3
            this.effect_group.centerY=0
        }else{
            this.effect_group.centerX=-3
            this.effect_group.centerY=-3
        }
        self.AddUIEffect(`ui_duobao_0${type}_01`, self.effect_group, null, 8,  true,null,null,null,null,null,null,null,false)
        // self.AddUIEffect(`ui_equip_icon${this.model.TypeToColor(type)}2`, self.front_effect_group, null, 0.8, true)
    }

    public DeleteMe() {
        let self = this
        self.ClearUIEffect(self.effect_group)
        self.ClearUIEffect(self.front_effect_group)
        super.DeleteMe()
    }
    public InitEvent() {
        let self = this
        // self.click_group.addEventListener(egret.TouchEvent.TOUCH_END, () => {
        // }, self)
        Util.AddClickEvent(self.click_group, () => {
            if (self.goods_basic) {
                let uitoolMgr = UIToolTipMgr.GetInstance()
                let type = self.goods_basic.type
                let subType = self.goods_basic.subtype
                if (type == 10) {
                    uitoolMgr.AppendEquipTips(self.goods_basic.type_id)
                } else if (type == 39) {
                    uitoolMgr.AppendGodBeastTips(self.goods_basic.type_id)
                } else if (type == UnrealModel.goods_type) {
                    uitoolMgr.AppendUnrealTips(self.goods_basic.type_id, undefined, undefined, undefined, undefined, [0])
                } else if (BagModel.IlluType[type] == subType) {
                    uitoolMgr.AppendIllusionTips(self.goods_basic.type_id)
                } else if ((type == PetEquipDefine.HORSE_TYPE_ID
                    || type == PetEquipDefine.PARTNER_TYPE_ID)
                    && subType <= PetEquipDefine.EQUIP_POS_COUNT) {
                    uitoolMgr.AppendPetEquipTips(self.goods_basic.type_id)
                } else if (type == 34) {
                    this.model.Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "HolyDeviceShowView", self.goods_basic.type_id)
                    if (this.treasureType) {
                        this.model.Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41614, "c", this.treasureType)
                        this.model.Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41613, "c", this.treasureType)
                    }
                } else if (type == GodBefallDefine.EQUIP_TYPE) {
                    uitoolMgr.AppendGodEquipTips(self.goods_basic.type_id)
                } else if (type == GodBefallDefine.GOOD_TYPE
                    && subType == GodBefallDefine.STAGE_SUBTYPE) {
                    uitoolMgr.AppendIllusionTips(self.goods_basic.type_id)
                } else {
                    uitoolMgr.AppendGoodsTips(self.goods_basic.type_id)
                }
            }
        }, self, false)
    }

    public SetScale(scale) {
        if (this.is_loaded) {
            this.display_obj.scaleX = this.display_obj.scaleY = scale
        }else{
            this.preScale=scale
        }
    }

    //中间特殊的icon拥有一个底
    public AddExpImg(type) {
        this.exp_bg.skin = `resource/game/runeTreasure/texture/uizbxb_005${type}.png`
    }

    public GetX() {
        if (this.is_loaded) {
            return this.display_obj.x
        }
    }

    public GetY() {
        if (this.is_loaded) {
            return this.display_obj.y
        }
    }

    public SetX(x) {
        if (this.is_loaded) {
            this.display_obj.x = x
        }
    }

    public SetY(y) {
        if (this.is_loaded) {
            this.display_obj.y = y
        }
    }

    public GetComponents() {
        [
            this.click_group,
            this.exp_bg,
            this.icon_bg,
            this.effect_group,
            this.icon_img,
            this.icon_light,
            this.front_effect_group,
            this.boxImg,
            this.reddot,
            this.icon_box
        ]
            = this.GetChildrenByNames([

                "click_group",
                "exp_bg",
                "icon_bg",
                "effect_group",
                "icon_img",
                "icon_light",
                "front_effect_group",
                "boxImg",
                "reddot",
                "icon_box"
            ])
    }
}

window["EquipTreasureItem"] = EquipTreasureItem