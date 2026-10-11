import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName } from "../common/EventName";
import { ModuleType, RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { GodBeastModel } from "../commonModel/GodBeastModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, Util } from "../util/Util";
import { PlayerMessageBeatTips } from "./PlayerMessageBeatTips";

export class PlayerMessageGodBeastEquipItem extends BaseItem1 {
    private _model = GodBeastModel.GetInstance();
    private _pos: number;
    private _beast_id: number;
    private _color: number;
    private _item: EquipmentItem;
    private _data;
    private _beast_data;
    needRefresh_data
    need_set_default
    _godBeastTips
    public constructor(parent, pos) {
        super(parent)
        this.base_file = "godBeast"
        this.layout_file = "GodBeastEquipItem"
        this._pos = pos
        this._godBeastTips = null
        this.load_callback = ()=>{
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
        this.display_obj.scaleX = 0.6
        this.display_obj.scaleY = 0.6

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
                // let info = this._model.GetWearEquipInfo(this._data.goods_id)
                // if (!info) return
                let btn_list =[0]// this._beast_data && this._beast_data.state == 2 ? [3, 6] : [3, 1]
                // UIToolTipMgr.GetInstance().AppendGodBeastTips(this._data.goods_id, null, null, this._data, undefined, btn_list)
                if (!this._godBeastTips) {
                    this._godBeastTips = new PlayerMessageBeatTips()
                }
                this._godBeastTips.SetData(this._data.goods_id, null, null, this._data, undefined, btn_list)
                this._godBeastTips.Open()
            } else {
                // GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GodBeastSelectView", this._beast_id, this._pos)
            }
        }, this, true)
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
            // let info = this._model.GetWearEquipInfo(data.goods_id)
            // if (!info) return
            this._item.SetData(data.goods_id)
            this._item.SetStrengthen(data.stren)
            this.SetEquipItemVisible(true)

        }
    }



    private SetEquipItemVisible(visible: boolean) {
        if (!this._item) return
        this._item.SetVisible(visible)
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
window["PlayerMessageGodBeastEquipItem"] = PlayerMessageGodBeastEquipItem