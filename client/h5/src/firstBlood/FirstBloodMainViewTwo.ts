import { CustomHeadItem } from "../common/CustomHeadItem"
import { EquipmentItem } from "../common/EquipmentItem"
import { DressModel, DressType } from "../commonModel/DressModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { Trim, Util, SetSizeDeltaX } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { FirstBloodMainView } from "./FirstBloodMainView"
import { Config } from "../common/Config"


export class FirstBloodMainViewTwo extends FirstBloodMainView {
	_playerHead
	all_reward
	boss_id
	boss_link
	item_list
	own_reward
	receive_stage
	reward
	sub_type
	title_bg: Laya.Image
	detail_text
	ScrollView: Laya.Panel
	Content: Laya.Box
	name_gp: Laya.Box
	image1: Laya.Image
	none: Laya.Image
	image: Laya.Image
	head: Laya.Box
	kill_name_text: Laya.Label
	light_img: Laya.Image
	killed_img: Laya.Image
	name_bg: Laya.Image
	pos_text: Laya.Label
	name_text
	line: Laya.Image
	_Image1: Laya.Image
	_Label1: Laya.Label
	all_reward_img: Laya.Image
	all_red_img: Laya.Image
	single_reward_img: Laya.Image
	single_red_img: Laya.Image
	go_btn: Laya.Box
	go_img: Laya.Image
	go_text: Laya.Label
	red_img: Laya.Image
	_gp_model_con: Laya.Box
	ScrollView1: Laya.Panel
	item_content: Laya.HBox

	public constructor(parent?) {
		super()

		this.sub_type = 2
	}
	public SelectMonster(data?) {

		let kill_info = this._model.GetKillInfo(96, 2)
		let info = null
		let info1 = null
		this.boss_id = data.object_id
		if (kill_info && kill_info.first_blood_list) {
			for (let k in kill_info.first_blood_list) {
				var v = kill_info.first_blood_list[k]
				if (this.boss_id == v.boss_id) {
					info1 = v
				}
				if (Trim(v.first_blood_role_name) != "" && this.boss_id == v.boss_id) {
					info = v
					break
				}
			}
		}


		let bool = info && true || false
		this.none.visible = !bool
		this.kill_name_text.visible = bool

		this.pos_text.text = Trim(data.boss_scene_name)
		let monster = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.boss_id, false)
		let name = String(monster.name)
		let lv = String(monster.lv)
		this.name_text.fontSize=20
		this.name_text.color="#FFFFFF"
		this.name_text.innerHTML = Util.StrToHTML(Trim(name) + "<font color='#ffea60'>Lv" + lv + "</font>"
		)
		this.name_text.width=500
		this.go_text.text = "前往击杀"
		this.go_text.color = ColorUtil.TryParseHtmlString("#ffffff")
		Util.SetImageGray(this.go_img, false)
		this.all_reward = ErlangParser.GetInstance().Parse(data.whole_first_blood_reward)
		this.own_reward = ErlangParser.GetInstance().Parse(data.own_reward)
		this.reward = this.all_reward
		this.boss_link = data.boss_link
		// this.go_text.GetComponent("Outline").effectColor = ColorUtil.TryParseHtmlString("#D36A24")
		// this.go_text.GetComponent("Outline").effectDistance = new Vector2(2, -2)
		this.red_img.visible = false
		//this.all_red_img.visible = false 
		//this.single_red_img.visible = false 
		//this.killed_img.visible = bool 

		if (info1) {
			let show_name = info1 && info1.show_first_blood == 1 && true || false
			this.name_gp.visible = show_name
			this.receive_stage = info1.reward_state
			//this.killed_img.visible = info1.reward_state == 0 || info1.reward_state == 1 
			if (this.receive_stage == 0) {
				this.go_text.text = "领取"
				this.red_img.visible = true
				//this.single_red_img.visible = true 
			} else if (this.receive_stage == 1) {
				this.go_text.text = "已领取"
				Util.SetImageGray(this.go_img, true)
				// SetTextGray(this.go_text)
				// this.go_text.GetComponent("Outline").effectColor = ColorUtil.TryParseHtmlString("#5B5858")
				// this.go_text.GetComponent("Outline").effectDistance = new Vector2(1, -1)
				// this.go_btn.GetComponent("EmptyRaycast").raycastTarget = false
			}
			if (info) {
				this.kill_name_text.text = String(info.first_blood_role_name)
				if (this.kill_name_text.width > 150) {
					SetSizeDeltaX(this.kill_name_text, this.kill_name_text.width)
				} else {
					SetSizeDeltaX(this.kill_name_text, 150)
				}
				// this.go_btn.GetComponent("EmptyRaycast").raycastTarget = true

				let main_role_name = RoleManager.GetInstance().GetMainRoleVo().name
				if (main_role_name != Trim(info.first_blood_role_name)) {
					if (this.receive_stage == 0 || this.receive_stage == 1) {
						this.reward = this.own_reward
					}
				}

				if (this._playerHead == null) {
					this._playerHead = new CustomHeadItem(this.head)
					this._playerHead.Load()
				}
				let frame_id = DressModel.GetInstance().GetDressByType(info.dress_list, DressType.Photo)
				info.career = info.role_carrer
				info.sex = info.role_sex
				info.role_id = info.first_blood_role_id
				this._playerHead.SetRoleVoData(info)
				this._playerHead.SetVisible(true)
			} else {
				if (this._playerHead) {
					this._playerHead.SetVisible(false)
				}
			}
		}


		this.ShowModel()//data.boss_model
		this.SetReward()
	}

	public SetReward() {

		let i = 1
		if (this.item_list && this.item_list.length > 0) {
			for (let i in this.item_list) {
				var v = this.item_list[i]
				v.DeleteMe()
				v = null
			}
			this.item_list = []
		}
		for (let _ in this.reward) {
			var v = this.reward[_]
			let item = new EquipmentItem(this.item_content, null, "UI")
			this.item_list[i] = item
			// item.SetMaskId(1)

			item.Load()
			item.SetItemSize(75, 75)
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(v[0], v[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				item.SetData(goods_vo.type_id, v[2], lock)
				let is_all_reward = false
				for (let key in this.own_reward) {
					var value = this.own_reward[key]
					let [type_id_, lock_] = GoodsModel.GetInstance().GetMappingTypeId(value[0], value[1])
					if (type_id == type_id_) {
						is_all_reward = true
						break
					}
				}
				if (is_all_reward) {
					item.ExcuteCallback(() => {
						item.setTipsImg("uiss_003b", "firstBlood_asset")
						item.setTipsImgPos(50, -8)
						item.setTipsImgSize(127 / 75, 127 / 75)
						// item.ReplaceUIShader(item._img_tips.gameObject)
					})
				}
			}
			i = i + 1
		}
	}

	public GetComponents() {
		[
			this.title_bg,
			this.detail_text,
			this.ScrollView,
			this.Content,
			this.name_gp,
			this.image1,
			this.none,
			this.image,
			this.image,
			this.head,
			this.kill_name_text,
			this.image1,
			this.light_img,
			this.killed_img,
			this.name_bg,
			this.pos_text,
			this.name_text,
			this.line,
			this._Image1,
			this._Label1,
			this.all_reward_img,
			this.all_red_img,
			this.single_reward_img,
			this.single_red_img,
			this.go_btn,
			this.go_img,
			this.go_text,
			this.red_img,
			this._gp_model_con,
			this.ScrollView1,
			this.item_content,
		]
			= this.GetChildrenByNames([

				"title_bg",
				"detail_text",
				"ScrollView",
				"Content",
				"name_gp",
				"image1",
				"none",
				"image",
				"image",
				"head",
				"kill_name_text",
				"image1",
				"light_img",
				"killed_img",
				"name_bg",
				"pos_text",
				"name_text",
				"line",
				"_Image1",
				"_Label1",
				"all_reward_img",
				"all_red_img",
				"single_reward_img",
				"single_red_img",
				"go_btn",
				"go_img",
				"go_text",
				"red_img",
				"_gp_model_con",
				"ScrollView1",
				"item_content",
			])
	}
}
window["FirstBloodMainViewTwo"] = FirstBloodMainViewTwo
