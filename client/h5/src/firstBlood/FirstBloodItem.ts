import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { FirstBloodModel, FirstBloodEvent } from "../commonModel/FirstBloodModel"
import { Util, Trim } from "../util/Util"
import { Config } from "../common/Config"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"


export class FirstBloodItem extends BaseItemRenderer {
	boss_id
	killed_img
	monster_img
	name_text
	red_img
	select_img
	image: Laya.Image
	_all_kill: Laya.Image

	public WIDTH = 240
	public HEIGT = 85
	public constructor(parent) {
		super()


		this.base_file = "firstBlood"
		this.layout_file = "FirstBloodItem"
		this.Load()
	}


	public load_callback() {
		this.BindEvent(FirstBloodModel.GetInstance(),FirstBloodEvent.UPDATE_KILL_RED,() =>{
			this.UpdateRed()
		})
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data && this.is_loaded) {
				let data = this.data
				let monster = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.object_id, false)
				let name = String(monster.name)
				let lv = String(monster.lv)
				this.name_text.style.fontSize = 18
				this.name_text.style.color = "#FFFFFF"
				this.name_text.innerHTML = Util.StrToHTML(Trim(name) + "&nbsp;&nbsp;<font color='#ffea60'>Lv" + lv + "</font>"
				)
				this.name_text.width = 500
				this.select_img.visible = this.selected
				let source = this.data.boss_picture
				ResManager.GetInstance().SetImageSprite(this, this.monster_img, "firstBlood_asset", source)

				this.boss_id = data.object_id

				this.UpdateRed()
			}
		}
	}






	public UpdateRed() {
		if(!this.data || this.use_delete_method){
			return
		}
		//判断红点的逻辑
		let role_id  = RoleManager.GetInstance().GetMainRoleId()
		let kill_info = FirstBloodModel.GetInstance().GetKillInfo(96, this.data.sub_type)
		let info = null
		if (kill_info && kill_info.first_blood_list) {
			for (let k in kill_info.first_blood_list) {
				var v = kill_info.first_blood_list[k]
				if (this.boss_id == v.boss_id) {
					info = v
					break
				}
			}
		}
		//
		let shared_reward_state_list = FirstBloodModel.GetInstance().shared_reward_state_list
		let info1 = null
		if (shared_reward_state_list) {
			for (let k in shared_reward_state_list) {
				var v = shared_reward_state_list[k]
				if (this.boss_id == v.boss_id) {
					info1 = v
					break
				}
			}
		}
		let bool = (info && info.reward_state == 0) && true || false
		let bool1=(info1 && info1.shared_status == 0) && true || false
		// if(info1.shared_status ==0 || info1.shared_status == 1){
		// 	this._all_kill.visible = true
		// }else{
		// 	this._all_kill.visible = false
		// }
		let is_self_kill = (info && info.first_blood_role_id ==role_id) && true || false
		this.red_img.visible = bool || bool1
		//let bool1 = info && true || false
		if(is_self_kill){
			ResManager.GetInstance().SetImageSprite(this.base_item,this.killed_img,"firstBlood","ui_activity_16")
			this.killed_img.y=13
		}else{
			ResManager.GetInstance().SetImageSprite(this.base_item,this.killed_img,"firstBlood","ui_activity_15")
			this.killed_img.y=15
		}
		this.killed_img.visible = info && (info.reward_state == 0 || info.reward_state == 1)
	}

	public GetComponents() {
		[
			this.image,
			this.monster_img,
			this.image,
			this.select_img,
			this.name_text,
			this.red_img,
			this.killed_img,
			this._all_kill
		]
			= this.GetChildrenByNames([

				"image",
				"monster_img",
				"image",
				"select_img",
				"name_text",
				"red_img",
				"killed_img",
				"_all_kill"
			])
	}
}
window["FirstBloodItem"] = FirstBloodItem