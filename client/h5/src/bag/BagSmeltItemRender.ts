
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-03-25 10.50:51
////////////////////////////////////////////////////////////////////-

import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { BagModel } from "../commonModel/BagModel"
import { EquipModel } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class BagSmeltItemRender
export class BagSmeltItemRender extends BaseItemRenderer {
    WIDTH = 88.9
    HEIGT = 88.9

    public conta: Laya.Box;
    public defaultImg: Laya.Image;
    public up: Laya.Image;
    public down: Laya.Image;
    public ban: Laya.Image;
    public grade: Laya.Label;
    public star_group: Laya.Box;
    public star_1: Laya.Image;
    public star_2: Laya.Image;
    public star_3: Laya.Image;
    public star_4: Laya.Image;
    public time_limit: Laya.Image;
    public lock: Laya.Image;
    public redMask: Laya.Image;
    public _bad_icon: Laya.Image;
    public group_eff: Laya.Box;

    Callback
    item
    model
    // public static width = 99.5
    // public static height = 99.5


    public constructor() {
        super()

        this.base_file = "bag"
        this.layout_file = "bagItemRenderer"
        this.model = BagModel.GetInstance();

        this.Callback = () => {
            if (this.data) {
                let equip_fusion_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_equip_fusion", false)
                if (this.model.smeltSelectList[this.data.goods_id]) {
                    this.model.SelectSmeltGoods(this.data.goods_id, this.data.type_id, false, equip_fusion_cfgs, this.data.goods_num)
                    this.item.SetSelect(false)
                } else {
                    if (this.model.smeltNum >= this.model.smeltMax) {
                        Message.show("每次最多可吞噬50个道具")
                        return
                    }
                    let addFunc = () => {
                        if (this.item && this.data) {
                            this.model.SelectSmeltGoods(this.data.goods_id, this.data.type_id, true, equip_fusion_cfgs, this.data.goods_num)
                            this.item.SetSelect(true)
                        }
                    }

                    let equip_type = this.data.equip_type
                    if (((this.data.star && this.data.star >= 2) || (equip_type && (((equip_type == 3 || equip_type == 5) || equip_type == 9) || equip_type == 7))) && !this.model.notShowTwoStarTips) {
                        Alert.Show("当前装备价值较高，是否确认选中吞噬？", Alert_Type.AlertTypeCheckBox, addFunc, null, null, null, null, null, (bool?) => {
                            this.model.notShowTwoStarTips = bool
                        }
                        )
                    } else {
                        addFunc()
                    }
                }
            }
        }

        this.Load()
    }

    public load_callback() {
        this.display_obj.scaleX = 0.7
        this.display_obj.scaleY = 0.7
        // for (let i = 1; i <= 4; i++){
        // 	this["star_" + i] = this.GetChild("star_group/star_" + i).gameObject
        // }
        this.item = new BaseAwardItem(this.conta)
        this.item.Load()
        this.item.ExcuteCallback(() => {
            ResManager.GetInstance().SetImageSprite(this, this.item.select_image, "bag_asset", "select")
            //this.item.select_image.source = "bag_json.select_png"

            this.item.SetClickCallBack(this.Callback)
        }
        )
        this.BindEvent(this.model, BagModel.UPDATE_SMELT_DROP, () => {
            this.dataChanged()
        }
        )
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data) {
                let num = null
                if (this.data.type != 10) {
                    num = this.data.goods_num
                }
                this.item.SetData(this.data.type_id, num, this.data.bind)
                if (this.model.smeltSelectList[this.data.goods_id]) {
                    this.item.SetSelect(true)
                } else {
                    this.item.SetSelect(false)
                }
            } else {
                this.item.SetData(null, null, null, null, null, true)
                this.item.ClearItemEffect()
            }
            this.item.ExcuteCallback(() => {
                this.RefreshEquipState()
            })
        }

    }

    public RefreshEquipState() {
        this.up.visible = false
        this.down.visible = false
        this.ban.visible = false
        if (this.data) {
            let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.type_id)
            if (goods_basic && goods_basic.type == 10) {
                let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, this.data.type_id, false)
                let roleVo = RoleManager.GetInstance().GetMainRoleVo()
                let career = roleVo.career
                let diff_career = cfg.career_id != 0 && cfg.career_id != career
                let ditt_sex = cfg.sex != 0 && roleVo.sex != cfg.sex
                this.ban.visible = (diff_career || roleVo.level < cfg.level || ditt_sex)
                if (!this.ban.visible) {
                    let wear_equip_info = EquipModel.GetInstance().GetWearEquipInfo(this.data.equip_type)
                    this.up.visible = !wear_equip_info || wear_equip_info.rating < this.data.rating
                    this.down.visible = wear_equip_info && wear_equip_info.rating > this.data.rating
                } else {
                    this.up.visible = false
                    this.down.visible = false
                }
                let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_equip_attr", false)
                if (equip_attr_cfg) {
                    let equip_attr = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, this.data.type_id, false, equip_attr_cfg)
                    if (equip_attr) {
                        if(PlatformManager.IsEyouEnPlatform()){
							this.grade.text = "G"+equip_attr.stage
						}else{
							this.grade.text = equip_attr.stage + "阶"
						}
                        this.star_group.visible = true
                        for (let i = 1; i <= 4; i++) {
                            this["star_" + i].visible = i <= equip_attr.star
                        }
                        this._bad_icon.visible = equip_attr.class_type == 1
                    }
                }
            } else {
                this.SetSpace()
            }
        } else {
            this.SetSpace()
        }
    }

    public SetSpace() {

        this.grade.text = ""
        this.star_group.visible = false
        this._bad_icon.visible = false
    }

    public DeleteMe() {
        if (this.item) {
            this.item.DeleteMe()
            this.item = null
        }
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this.conta,
            this.defaultImg,
            this.up,
            this.down,
            this.ban,
            this.grade,
            this.star_group,
            this.star_1,
            this.star_2,
            this.star_3,
            this.star_4,
            this.time_limit,
            this.lock,
            this.redMask,
            this._bad_icon,
            this.group_eff
        ] = this.GetChildrenByNames([
            "conta",
            "defaultImg",
            "up",
            "down",
            "ban",
            "grade",
            "star_group",
            "star_1",
            "star_2",
            "star_3",
            "star_4",
            "time_limit",
            "lock",
            "redMask",
            "_bad_icon",
            "group_eff"
        ])
    }
}
window["BagSmeltItemRender"] = BagSmeltItemRender