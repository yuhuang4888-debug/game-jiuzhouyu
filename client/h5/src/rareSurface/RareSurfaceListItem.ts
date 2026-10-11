import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GameResPath } from "../util/GameResPath";
import { Config } from "../common/Config";


export class RareSurfaceListItem extends BaseItemRenderer {
    WIDTH = 102
    HEIGT = 114
    model
    cfg_custom_activity
    windows_cfg
    public constructor() {
        super();
        this.base_file = 'rareSurface';
        this.layout_file = 'RareSurfaceListItem';
        this.model = CustomActivityModel.GetInstance()
        this.cfg_custom_activity = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity
        this.windows_cfg = null
        this.Load()
    }

    public load_callback() {
		this.BindVar(this.model, "update_rare_surface", (value?,garde?) => {
            if(this.data && this.data.grade == Number(garde) && !this._img_buy.visible){
                this._img_buy.visible = true
            }
        }
        )
	}
    public childrenCreated() {
        super.createChildren()
    }
    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data) {
                let holiday_info = this.model.holiday_info
                let key = `331@${holiday_info.base_type}@${holiday_info.show_id}`
                let cfg = this.cfg_custom_activity["CAN_CHANGE_RESSORCE_FESTIVAL"]
                if(cfg[key]){
                    this.windows_cfg = cfg[key]
                }
                if(this.windows_cfg){
                    let select = this.selected ? this.windows_cfg.btn_light : this.windows_cfg.btn_dark
                    ResManager.GetInstance().SetImageSprite(this, this._img_select, "rareSurface", select)
                    ResManager.GetInstance().SetImageSprite(this, this._img_buy, "rareSurface", this.windows_cfg.has_buy_bg)
                }
                else{
                    let select = this.selected ? "ui_wgzg_04" : "ui_wgzg_05"  
                    ResManager.GetInstance().SetImageSprite(this, this._img_select, "rareSurface", select)
                }
                this._lab_name.color = this.selected ? "#ba3923" : "#ffffff"
                this._lab_name.text = `${this.data.name}`
                this._img_buy.visible = this.data.status == 2
            }
        }
    }

    _img_select: Laya.Image
    _lab_name: Laya.Label
    _img_buy: Laya.Image
    public GetComponents() {
        [
            this._img_select,
            this._lab_name,
            this._img_buy,
        ]
            = this.GetChildrenByNames([

                "_img_select",
                "_lab_name",
                "_img_buy",
            ])
    }
}
window["RareSurfaceListItem"] = RareSurfaceListItem