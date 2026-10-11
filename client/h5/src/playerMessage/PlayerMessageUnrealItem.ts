import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { UnrealModel } from "../commonModel/UnrealModel"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"
import { PlayerMessageUnrealTips } from "./PlayerMessageUnrealTips"

export class PlayerMessageUnrealItem extends BaseItem1 {
    private _item: EquipmentItem
    private model: UnrealModel
    data
    need_refresh_data
    attr_cfg
    load_cfg
    data_cache
    is_first_update = true
    equip_type

    res_mgr
    decoration_attr_cfg
    decoration_level_max_cfg
    //decoration_level_cfg
    //decoration_stage_cfg
    //decoration_stage_max_cfg

    public constructor(parent) {
        super(parent)
        this.base_file = "unreal"
        this.layout_file = "UnrealEquipItem"

        this.model = UnrealModel.GetInstance()
        this.res_mgr = ResManager.GetInstance()

        this.load_callback = ()=> {
            this.LoadSuccess()
            this.InitEvent()
        }
    }

    public DeleteMe() {
        if (this._item) {
            this._item.DeleteMe()
            this._item = null
        }
        super.DeleteMe()
    }

    private LoadSuccess() {
        this.decoration_attr_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_decoration_attr", false)
        this.decoration_level_max_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_decoration_level_max", false)
        if (this.need_refresh_data) {
            this.UpdateView()
            this.need_refresh_data = false
        }
    }

    private InitEvent() {
        // Util.AddClickEvent(this._lock, () => {
        //     if (!this.model.CheckCellUnLockState(this.equip_type)) {
        //         let all_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dec_unlock_cell", false)
        //         if (all_cfg) {
        //             let cfg = all_cfg[this.equip_type]
        //             if (cfg) {
        //                 let key = UnrealModel.goods_type + "@" + this.equip_type
        //                 let unreal_pos_name = Config.PRELOAD_SERVER_CONFIG.GoodsSubtype[key] && Config.PRELOAD_SERVER_CONFIG.GoodsSubtype[key].subtype_name
        //                 if (cfg && unreal_pos_name) {
        //                     Message.show("[" + unreal_pos_name + "]" + "部位在装备总阶数达" + cfg.unlock_stage + "阶时解锁")
        //                 }
        //             }
        //         }
        //         return
        //     }
        // }, this, false)

        // this.BindEvent(this.model, UnrealModel.UPDATE_CELL_UN_LOCK_STATE, () => {
        //     this._lock.visible = !this.model.CheckCellUnLockState(this.equip_type)
        // }
        // )

        // this.BindEvent(this.model, UnrealModel.UPDATE_EQUIP_STREN_DATA, (cell) => {
        //     if (this.data && cell == this.data.cell) {
        //         this.UpdateView()
        //     }
        // })
    }

    public SetData(data) {
        this.data = data
        if (this.is_loaded) {
            this.UpdateView()
        }
        else {
            this.need_refresh_data = true
        }
    }

    public SetEquipType(type?) {
        this.equip_type = type
    }

    private UpdateView() {
        if (!this._item) {
            this._item = new EquipmentItem(this.con)
            this._item.Load()
            this._item.SetItemSize(85, 85)
            this._item.SetClickCallBack(this.ClickCallBack)
        }

        if (this.data) {
            this.con.visible = true
            this._lock.visible = false
            if(this.data.type_id){
                this._img_bg.visible = false
                this._item.SetVisible(true)
                this._item.SetData(this.data.type_id)
                this.attr_cfg = this.model.GetUnrealData(this.data.type_id, this.decoration_attr_cfg)
                this.UpdateStrenLevel()
            }else{
                this._item.SetVisible(false)
            }
        }
        else {
            this.con.visible = false
            this._img_bg.visible = true
            this._item.SetVisible(false)
            this._lock.visible = true
        }
        this.UpdateRed()

        if (this.is_first_update) {
            this.is_first_update = false
            this.data_cache = this.data
        }
        else {
            if ((!this.data_cache && this.data) || (this.data_cache && this.data && this.data_cache.goods_id != this.data.goods_id)) {
                //this.AddUIEffect("ui_Strengthen_glow", this._gp_effect, null, null, null, null, null, null, null, true)
            }
            this.data_cache = this.data
        }
    }

    private UpdateStrenLevel() {
        if (this.is_loaded) {
            if (this.data && this._item && this.attr_cfg) {
                let max_key = `${this.data.equip_type}@${this.attr_cfg.stage}@${this.data.color}`
                let max_cfg = this.model.GetUnrealStrenMax(max_key, this.decoration_level_max_cfg)
                let stren_data = this.model.GetStrenData(this.data.cell)
                let stren = stren_data ? stren_data.level : 0
                if (max_cfg && max_cfg.limit_level < stren)
                    stren = max_cfg.limit_level
                if (this.data.other_info == 1) {
                    stren = this.data.lv
                }
                this._item.SetStrengthen(stren)
            }
        }
    }

    private ClickCallBack = () => {
        if (this.data){
            let _unrealBeastTips = new PlayerMessageUnrealTips()
            _unrealBeastTips.SetData(this.data.type_id, this.data, undefined, [0], null)
            _unrealBeastTips.Open()

        }
        // UIToolTipMgr.GetInstance().AppendUnrealTips(this.data.type_id, this.data, undefined, [0, 4])
    }

    private UpdateRed = () => {
        // 查看别人装备不应该有红点所以注释
        // let red = this.model.RefreshUnrealWearRedSingle(this.equip_type)
        // this._img_red.visible = red
    }

    _img_bg: Laya.Image
    _lock: Laya.Image
    con: Laya.Box
    _img_red: Laya.Image
    _gp_effect: Laya.Box
    public GetComponents() {
        [
            this._img_bg,
            this._lock,
            this.con,
            this._img_red,
            this._gp_effect,
        ]
            = this.GetChildrenByNames([
                "_img_bg",
                "_lock",
                "con",
                "_img_red",
                "_gp_effect",
            ])
    }
}
window["PlayerMessageUnrealItem"] = PlayerMessageUnrealItem