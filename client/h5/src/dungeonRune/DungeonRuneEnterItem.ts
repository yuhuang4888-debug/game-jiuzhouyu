import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { PlatformManager } from "../PlatformManager"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"

export class DungeonRuneEnterItem extends BaseItemRenderer {
	public WIDTH = 720 //86 + 13
	public HEIGT = 280

	model
	public constructor(parent) {
		super()
		this.base_file = "dungeonRune"
		this.layout_file = "DungeonRuneEnterItem"
		this.model = BaseDungeonModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	LoadSuccess() {
		if (PlatformManager.IsEyouEnPlatform()) {
			this._lb_floor.y = 183
		}
		this.InitEvent()
	}

	InitEvent() {

	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data) {
				let data = this.data
				let now_floor = data.dun_id - BaseDungeonModel.Rune_Floor_Modulus
				this._lb_floor.text = `第${now_floor}层`

				let need_gray = false
				if (this.model.RuneChallenged(now_floor)) {
					this._img_passed.visible = true
					this._img_lock.visible = false
				} else if (this.model.RuneCanChallenge(now_floor)) {
					this._img_passed.visible = false
					this._img_lock.visible = false
				} else {
					this._img_passed.visible = false
					this._img_lock.visible = true
					need_gray = true
				}

				if (now_floor % 2 == 0) {
					this._gp_con.x = 41
				}
				else {
					this._gp_con.x = 466
				}

				let config_dungeon_wave = Config.PRELOAD_SERVER_CONFIG.config_dungeon_wave
				//2005 符文副本写死的场景 1 1 波数

				let now_floor_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_wave.name, `${data.dun_id}@${2005}@${1}@${1}`, false, config_dungeon_wave)
				// let now_floor_cfg = config_dungeon_wave && config_dungeon_wave[`${data.dun_id}@${2005}@${1}@${1}`]
				
				if(now_floor_cfg){
					let mon_list = ErlangParser.GetInstance().Parse(now_floor_cfg.mon_list)
					let mon_id = mon_list&&mon_list[0] && mon_list[0][0]
					if(mon_id){
						let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, mon_id, false)
						if(mon_cfg){
							let model_data = {
								// clothe_res_id: 10020102,
								clothe_res_id: mon_cfg.icon,
								type: UI_MODEL_TYPE.MONSTER,
								scale: 1.2,
								can_rotate: false,
								show_gray: need_gray,
								layout_file:"DungeonRuneEnterItem"
							}
							ResManager.GetInstance().SetRoleModel(this.base_item, this._gp_model, model_data)
						}
					}
					
				}
			}
		}
	}

	_gp_con: Laya.Box
	_gp_model: Laya.Box
	_lb_floor: Laya.Label
	_img_passed: Laya.Image
	_img_lock: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._gp_model,
			this._lb_floor,
			this._img_passed,
			this._img_lock,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_gp_model",
				"_lb_floor",
				"_img_passed",
				"_img_lock",
			])
	}
}

window["DungeonRuneEnterItem"] = DungeonRuneEnterItem