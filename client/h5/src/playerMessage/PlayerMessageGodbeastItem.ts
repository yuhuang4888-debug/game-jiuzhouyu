import { ResManager } from "../common/ResManager"
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneModel } from "../commonModel/RuneModel"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GameResPath } from "../util/GameResPath"
import { PartnerModel } from "../commonModel/PartnerModel"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { Vector2 } from "../util/Vector2"
import { Enum_UILayer } from "../common/LayerManager"
import { PlayerMessagePartnerSkillItem } from "./PlayerMessagePartnerSkillItem"
import { DemonDefine } from "../commonModel/DemonDefine"
import { PlayerMessageDemonTalentItem } from "./PlayerMessageDemonTalentItem"
import { PlayerMessageDemonSkillItem } from "./PlayerMessageDemonSkillItem"
import { GodBeastModel } from "../commonModel/GodBeastModel"
import { GodBeastEquipItem } from "../godBeast/GodBeastEquipItem"
import { PlayerMessageGodBeastEquipItem } from "./PlayerMessageGodBeastEquipItem"

export class PlayerMessageGodbeastItem extends BaseItemRenderer {
    bg: Laya.Image
    img_show: Laya.Box
    lb_name: Laya.Label
    namebg: Laya.Image
    lb_fight: Laya.Label
    _group_equip: Laya.HBox

    model
    res_mgr
    goods_model
    rune_model
    data
    info
    _equip_list_

    public constructor() {
        super()
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageGodbeastItem"
        this.WIDTH = 571
        this.HEIGT = 226
        this._equip_list_ = []
        this.res_mgr = ResManager.GetInstance()
        this.model = RuneTreasureModel.GetInstance()
        this.goods_model = GoodsModel.GetInstance()
        this.rune_model = RuneModel.GetInstance()
        this.Load()
    }

    public load_callback() {
        this.InitView()
        this.InitEquipItems()
    }

    public InitView() {
        ResManager.GetInstance().SetTexture(this,this.bg,GameResPath.GetIcon("playerMessage","ui_rwxx_cy01"))
    }

    public InitEquipItems() {
        for (let pos of GodBeastModel.EQUIP_POS_LIST) {
            let item = new PlayerMessageGodBeastEquipItem(this._group_equip, pos)
            item.Load()
            this._equip_list_[pos] = item
        }
    }


    public dataChanged() {
        if (super.dataChanged()) {
            let path = `resource/game/godBeast/other/${this.data.info.icon_id}.png`
            this.res_mgr.SetTexture(this, this.img_show, path)
            this.lb_name.text = this.data.info.name
            this.lb_fight.text = this.data.score

            for (let key in this._equip_list_) {
                let item = this._equip_list_[key]
                item.SetBeastId(this.data.id)
                item.SetDefault(this.data)
            }

            let list = this.data.equip_list
            for (let data of list) {
                let item = this._equip_list_[data.pos]
                item.SetData(data)
            }
        }
    }

    public DeleteMe() {
        if (this._equip_list_) {
            for (let key in this._equip_list_) {
                this._equip_list_[key].DeleteMe()
            }
            this._equip_list_ = []
        }
        super.DeleteMe()
    }




    public GetComponents() {
        [
            this.bg,
            this.img_show,
            this.lb_name,
            this.namebg,
            this.lb_fight,
            this._group_equip,
        ]
            = this.GetChildrenByNames([

                "bg",
                "img_show",
                "lb_name",
                "namebg",
                "lb_fight",
                "_group_equip",
            ])
    }
}
window["PlayerMessageGodbeastItem"] = PlayerMessageGodbeastItem