import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, Split, Trim } from "../util/Util"
import { Config } from "../common/Config"
import { TopVipModel, TopVipMoneyId } from "../commonModel/TopVipModel"
import { SkillManager } from "../skill/SkillManager"

export class TopVipSkillDetailItem extends BaseItem1 {
	bg_img: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	skill_name_lb: Laya.Label
	_Image2: Laya.Image
	skill_img: Laya.Image
	skill_introduce_lb: Laya.HTMLDivElement
	lock_img:Laya.Image
	index
	need_refresh_data
	skill_id
	is_lock
	public constructor(parent?) {
		super(parent)


		this.need_refresh_data = false;
		this.base_file = "topVip"
		this.layout_file = "TopVipSkillDetailItem"
		this.preload_server_config={
			"config_supreme_vip_skill":false
		}
		this.load_callback = () => {

			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	SetAnchoredPositionX(this.skill_name_lb,15)
			// }
		}

	}

	public LoadSuccess() {

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
	}

	public Setdata(index?) {

		this.index = index
		this.is_lock= index <TopVipModel.GetInstance().GetSkillTask().stage ? false : true
		if(index == TopVipModel.GetInstance().GetSkillTask().stage && TopVipModel.GetInstance().GetSkillTask().sub_stage == 8){
			this.is_lock=false
		}

		let config_supreme_vip_skill = ResManager.GetInstance().GetGameConfigFromCache(this, "config_supreme_vip_skill", false)
		for (let key in config_supreme_vip_skill) {

			// [ts2lua]config_supreme_vip_skill下标访问可能不正确
			let cfg = config_supreme_vip_skill[key]
			let key_arr = Split(key, "@")
			let key_index = Number(key_arr[0])
			let key_stage = Number(key_arr[1])
			if (this.index == key_index && key_stage == 8) {
				let skill_list =JSON.parse(cfg.skill_list)
				for (let _tmpi in skill_list) {
					var id = skill_list[_tmpi]
					this.skill_id = id[0]
				}
			}
		}
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdataView() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("topVip", "ui_task_05"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this.skill_img, "resource/game/skillIcon/" + this.skill_id + ".png")
		// let config_skill = ConfigItemMgr.Instance.skill_data
		let skill_vo = SkillManager.GetInstance().getSkill(this.skill_id)
		if(skill_vo){
			this.skill_name_lb.text = skill_vo.getName()
			this.skill_introduce_lb.innerHTML = skill_vo.getDesc(null, false)
		}
		// let cfg =Config.PRELOAD_SERVER_CONFIG.config_skill[this.skill_id]
		
		// let lv_data = JSON.parse(cfg.lv_data)
		// for (let _tmpi in lv_data) {
		// 	var data = lv_data[_tmpi]
		// 	let detail = data.desc

		// 	this.skill_introduce_lb.innerHTML = Trim(detail)
		// }
		this.lock_img.visible=this.is_lock
		////let a = config
		//for (let key in config_skill) {

		//// [ts2lua]config_skill下标访问可能不正确
		//let cfg = config_skill[key]
		//let id = Number(cfg.id)
		//if (id == this.skill_id ) {

		//}
		//}
	}

	public GetComponents() {
		[
			this.bg_img,
			this._Group1,
			this._Image1,
			this.skill_name_lb,
			this._Image2,
			this.skill_img,
			this.skill_introduce_lb,
			this.lock_img
		]
			= this.GetChildrenByNames([

				"bg_img",
				"_Group1",
				"_Image1",
				"skill_name_lb",
				"_Image2",
				"skill_img",
				"skill_introduce_lb",
				"lock_img"
			])
		this.skill_introduce_lb.style.fontSize=20
		this.skill_introduce_lb.style.color="#774239"
		this.skill_introduce_lb.width=388
		this.skill_introduce_lb.style.leading=10

	}
}
window["TopVipSkillDetailItem"]=TopVipSkillDetailItem