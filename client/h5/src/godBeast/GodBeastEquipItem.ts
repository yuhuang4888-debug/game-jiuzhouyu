import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName } from "../common/EventName";
import { ModuleType, RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { GodBeastModel } from "../commonModel/GodBeastModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, Util } from "../util/Util";

export class GodBeastEquipItem extends BaseItem1 {
    private _model = GodBeastModel.GetInstance();
    private _pos: number;
    private _beast_id: number;
    private _color: number;
    private _item: EquipmentItem;
    private _data;
    private _beast_data;
    needRefresh_data
    need_set_default
    public constructor(parent, pos) {
        super(parent)
        this.base_file = "godBeast"
        this.layout_file = "GodBeastEquipItem"
        this._pos = pos
        this.load_callback = function () {
            this.LoadSuccess()
        }
    }

    public DeleteMe() {
        if (this._item) {
            this._item.DeleteMe()
            this._item = undefined
        }
        super.DeleteMe()
    }

    private LoadSuccess() {
        this.display_obj.scaleX = 0.73
        this.display_obj.scaleY = 0.73

        this._img_icon.skin = AtlasUrl("godBeast", `godBeast_pos_${this._pos}`)
        this.InitEvent()

        if (this.need_set_default){
            this.SetDefault(this._beast_data)
            this.need_set_default = null
        }
        if (this.needRefresh_data){
            this.SetData(this.needRefresh_data)
            this.needRefresh_data = null
        }
    }

    private InitEvent() {
        Util.AddClickEvent(this._group_click, () => {
            if (!this._beast_id || !this._pos) return
            if (this._data) {
                let info = this._model.GetWearEquipInfo(this._data.goods_id)
                if (!info) return
                let btn_list = this._beast_data && this._beast_data.state == 2 ? [3, 6] : [3, 1]
                UIToolTipMgr.GetInstance().AppendGodBeastTips(info.type_id, null, null, info, undefined, btn_list)
            } else {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GodBeastSelectView", this._beast_id, this._pos)
            }
        }, this, true)

        this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (mType, rType) => {
            if(!this._beast_data)return
            if((ModuleType.BEAST_EQUIP == mType && rType == this._beast_data.id)
            ||(ModuleType.BEAST_REPLACE == mType && this._beast_data.id * 10000 + this._pos)
            ||(ModuleType.BEAST_STREN == mType)){
                this._reddot.visible = this.CheckReddot()
            }
        })
    }

    public SetBeastId(id) {
        this._beast_id = id
    }

    public SetData(data) {
        this._data = data
        if (this.is_loaded){
            this.UpdateEquipItem(data)
            this._gp_star.visible = false
        }else{
            this.needRefresh_data = data
        }
    }

    public SetDefault(beast_data?) {
        this._beast_data = beast_data
        if(this.is_loaded){
            this._reddot.visible = false
            this._data = undefined
            this.SetEquipItemVisible(false)
            let eudemons_equip_pos_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_eudemons_equip_pos", false)
            let cond = this._model.GetBeastEquipCond(this._beast_id, this._pos, eudemons_equip_pos_cfg)
            this._img_bg.skin = AtlasUrl("common", `com_goods_plate_${cond.color}`)
            // this._reddot.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BEAST_EQUIP, this._beast_id)
            this._reddot.visible = this.CheckReddot()
            this._gp_star.visible = true
            for (let i = 0; i < 3; i++) {
                let img:Laya.Image = this._gp_star.getChildAt(i) as Laya.Image
                img.visible = i + 1 <= cond.star
            }
        }else{
            this.need_set_default = true
        }
    }

    private UpdateEquipItem(data) {
        if (this.is_loaded && data){
            if (!this._item) {
                this._item = new EquipmentItem(this._group_item)
                this._item.Load()
                this._item.SetItemSize(115, 115)
                this._item.SetShowTips(false)
            }
            let info = this._model.GetWearEquipInfo(data.goods_id)
            if (!info) return
            this._item.SetData(info.type_id)
            this._item.SetStrengthen(data.stren)
            this.SetEquipItemVisible(true)
    
            // this._reddot.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BEAST_EQUIP, this._beast_id)
            this._reddot.visible = this.CheckReddot()
        }
    }

    // private CheckReddot() {
    //     if (!this._beast_data) return false
    //     let beast_info = this._model.GetBeastInfo()
    //     if (!beast_info) return false
    //     let dic = GoodsModel.GetInstance().beastbag_type_dic
    //     //没有该位置装备
    //     if (!dic[this._pos] || dic[this._pos].length < 1) return false
    //     //出战位已满且不是出战神兽
    //     let fight_count = this._model._fight_count
    //     let has_empty = beast_info.fight_count > fight_count
    //     if (!has_empty && this._beast_data.state != 2) return false
    //     let color = this._model.GetBeastEquipCond(this._beast_id, this._pos)
    //     for (let equip of dic[this._pos]) {
    //         //品质不满足条件
    //         if (equip.color < color) continue
    //         //身上没有穿装备
    //         if (!this._data) return true
    //         //背包装备评分比身上装备评分高
    //         let wear = this._model.GetWearEquipInfo(this._data.goods_id)
    //         if (wear && equip.rating > wear.rating) return true
    //     }
    // }

    private SetEquipItemVisible(visible: boolean) {
        if (!this._item) return
        this._item.SetVisible(visible)
    }

    private CheckReddot() {
        if (!this._beast_data) return false
        let red1 = false
        let id = this._beast_data.id * 10000 + this._pos
        let red2 = RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.BEAST_REPLACE, id)
        let red3
        if (this._data) {
            red3 = RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.BEAST_STREN, this._data.goods_id)
        }else{
            red1 = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BEAST_EQUIP, this._beast_data.id)
        }
        return red1 || red2 || red3
    }
    _group_click: Laya.Box
    _img_bg: Laya.Image
    _img_icon: Laya.Image
    _lb_cond: Laya.Label
    _gp_star: Laya.VBox
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _group_item: Laya.Box
    _reddot: Laya.Image
    _img_click: Laya.Image
    public GetComponents() {
        [
            this._group_click,
            this._img_bg,
            this._img_icon,
            this._lb_cond,
            this._gp_star,
            this._Image1,
            this._Image2,
            this._Image3,
            this._group_item,
            this._reddot,
            this._img_click,
        ]
            = this.GetChildrenByNames([

                "_group_click",
                "_img_bg",
                "_img_icon",
                "_lb_cond",
                "_gp_star",
                "_Image1",
                "_Image2",
                "_Image3",
                "_group_item",
                "_reddot",
                "_img_click",
            ])
    }
}
window["GodBeastEquipItem"] = GodBeastEquipItem