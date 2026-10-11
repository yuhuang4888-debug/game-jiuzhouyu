import { GodBefall1TipsView } from "./GodBefall1TipsView"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GodBefallAttrItem } from "./GodBefallAttrItem"
import { ResManager } from "../common/ResManager"

export class GodBefallActiveTipsView extends GodBefall1TipsView {
	Local_LoadSuccess
	UpdateView
	_ac_attr_loop_list
	_ac_attr_loop_mgr
	preload_server_config

	public constructor() {
		super()
		this.preload_server_config = {
			"config_god_lv": false,
			"config_god_star": false,
			"config_god_stage": false
		}

		this.Local_LoadSuccess = () => {
			this._ac_attr_loop_list = []
			this._ac_attr_loop_mgr = new LoopScrowViewMgr()
			this._ac_attr_loop_mgr.SetData(this._Scroller1, GodBefallAttrItem, this._ac_attr_loop_list, LoopScrCon.Vertical)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("godBefall", "uijs_046"), true)
			
			this._Scroller1.x = 40
		}

		this.UpdateView = () => {
			let data = this._god_data
			this.UpdateUIModel(data)
			this._lb_name.text = data.name
			let config_god_lv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_lv", false)
			let config_god_star = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_star", false)
			let config_god_stage = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_stage", false)
			let attr_list = this._model.GetAllAttrListByVo(data.id, null, config_god_lv, config_god_star, config_god_stage)
			this.UpdateAttrItems(attr_list)
			this.fight.Updatefighting(this._scmd.power)
			//this._gp_bg.height = 194
			//SetSizeDeltaY(this._gp_bg, 194)
			this._gp_skill.visible = false
			this._gp_attr.visible = true
			//this._btn_ok.y = 971
			//SetLocalPositionY(this._btn_ok, -971)
		}
	}
}
window["GodBefallActiveTipsView"] = GodBefallActiveTipsView