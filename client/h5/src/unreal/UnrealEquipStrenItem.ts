import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"

export class UnrealEquipStrenItem extends BaseItem1 {

    private _item: EquipmentItem
    private model: UnrealModel

    cache_select_state
    data
    need_refresh_data
    equip_type
    call_back

    private attr_cfg
    public constructor(parent) {
        super(parent)
        this.base_file = "unreal"
        this.layout_file = "UnrealEquipItem"
        this.model = UnrealModel.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvent()
        }
    }

    private LoadSuccess() {
        if (!this._item) {
            this._item = new EquipmentItem(this.con)
            this._item.Load()
            this._item.SetItemSize(85, 85)

        }
        this._item.SetClickCallBack(this.ClickCallBack)
        if (this.need_refresh_data) {
            this.UpdateView()
            this.need_refresh_data = false
        }
        if (this.cache_select_state != null ) {
            this.SetSelect(this.cache_select_state)
            this.cache_select_state = null
        }
    }

    private InitEvent() {
        Util.AddClickEvent(this._lock, () => {
            if (!this.model.CheckCellUnLockState(this.equip_type)) {
                let all_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dec_unlock_cell", false)
                if (all_cfg) {
                    let cfg = all_cfg[this.equip_type]
                    if (cfg) {
                        let key = UnrealModel.goods_type + "@" + this.equip_type
                        let unreal_pos_name = Config.PRELOAD_SERVER_CONFIG.GoodsSubtype[key] && Config.PRELOAD_SERVER_CONFIG.GoodsSubtype[key].subtype_name
                        if (cfg && unreal_pos_name) {
                            Message.show("[" + unreal_pos_name + "]" + "部位在装备总阶数达" + cfg.unlock_stage + "阶时解锁")
                        }
                    }
                }
                return
            }
        }, this, false)

        this.BindEvent(this.model, UnrealModel.UPDATE_CELL_UN_LOCK_STATE, () => {
            this._lock.visible = !this.model.CheckCellUnLockState(this.equip_type)
        }
        )

        this.BindEvent(this.model, UnrealModel.UPDATE_EQUIP_STREN_DATA, (cell) => {
            if (this.data && cell == this.data.cell) {
                this.SetStrenData()
                if (this.is_show_red) {
                    this.UpdateRed()
                }
            }
        })

        this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list) => {
            if (this.use_delete_method) return
            if (!this.is_show_red) return

            for (let vo of goods_list) {
                if (this.model.bind_cost_goods[vo.type_id]) {
                    this.UpdateRed()
                }
            }
        })

        // this.BindEvent(this.model, UnrealModel.STAGE_SUCCESS, (cell) => {
        // 	if (this.data && this.data.cell == cell) {
        // 		if (this.is_show_red)
        // 			this._img_red.visible = this.model.GetEquipCanUp(this.data)
        // 	}
        // })

        this.BindEvent(this.model, UnrealModel.STREN_SUCCESS, (cell) => {
            if (this.data && this.data.cell == cell) {
                if (this.is_show_red) {
                    this.UpdateRed()
                }
                // this.AddUIEffect("ui_Strengthen_glow", this._gp_effect, null, null, null, null, null, null, null, true)
            }
        })
    }

    public SetEquipType(type?) {
        this.equip_type = type
    }


    private is_show_red
    public SetData(data, is_show_red = true) {
        this.data = data
        this.is_show_red = is_show_red
        if (this.is_loaded) {
            this.UpdateView()
        }
        else {
            this.need_refresh_data = true
        }
    }

    private UpdateView() {
        let decoration_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_attr", false)
        if (this.data) {
            this.con.visible = true
            this._img_bg.visible = false
            this._item.SetVisible(true)
            this._item.SetData(this.data.type_id, 1, false, this._item.GetSelectState())

            this.attr_cfg = this.model.GetUnrealData(this.data.type_id, decoration_attr_cfg)
            this.SetStrenData()
            if (this.is_show_red)
                this.UpdateRed()
        }
        else {
            this.con.visible = false
            this._img_red.visible = false
            this._img_bg.visible = true
            this._item.SetVisible(false)
        }
        this._lock.visible = !this.model.CheckCellUnLockState(this.equip_type)
    }


    public SetStrenData() {
        if (this.is_loaded){
            if (this.data && this._item && this.attr_cfg) {
                let max_key = `${this.data.equip_type}@${this.attr_cfg.stage}@${this.data.color}`
                let decoration_level_max_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_level_max", false)
                let max_cfg = this.model.GetUnrealStrenMax(max_key, decoration_level_max_cfg)
                let stren_data = this.model.GetStrenData(this.data.cell)
                let stren = stren_data ? stren_data.level : 0
                if (max_cfg && max_cfg.limit_level < stren)
                    stren = max_cfg.limit_level
                this._item.SetStrengthen(stren)
            }
        }
    }

    public SetCallBack(call_back) {
        this.call_back = call_back
    }

    private ClickCallBack = () => {
        if (this.is_show_red) {
            if (this.call_back && this.data)
                this.call_back(this.data.equip_type)
        }
        else {
            UIToolTipMgr.GetInstance().AppendUnrealTips(this.data.type_id, this.data, undefined, [0])
        }
    }

    public UpdateRed() {
        let decoration_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_attr", false)
        let decoration_level_max_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_level_max", false)
        let decoration_level_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_level", false)
        let decoration_stage_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_stage", false)
        let decoration_stage_max_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_stage_max", false)
        this._img_red.visible = this.model.GetEquipCanUp(this.data,
            decoration_attr_cfg,
            decoration_level_max_cfg,
            decoration_level_cfg,
            decoration_stage_cfg,
            decoration_stage_max_cfg
        )
    }


    public SetSelect(bool?) {

        if (this.is_loaded) {
            this._item.SetSelect(bool)
        } else {
            this.cache_select_state = bool
        }
    }

    public DeleteMe() {
        if (this._item) {
            this._item.DeleteMe()
            this._item = undefined
        }
        super.DeleteMe()
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
window["UnrealEquipStrenItem"] = UnrealEquipStrenItem