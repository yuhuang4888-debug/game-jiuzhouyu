import { ChatModel } from "../commonModel/ChatModel"
import { DragonBallModel, IDragonBallInfo, IDragonSuitInfo } from "../commonModel/DragonBallModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SkillManager } from "../skill/SkillManager"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util, Trim, HtmlColorTxt } from "../util/Util"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { SkillVo } from "../skill/SkillVo"
import { GameResPath } from "../util/GameResPath"

export class DragonBallTipsView extends BaseView1 {

	cur_dragon_id
	model: DragonBallModel = DragonBallModel.GetInstance()
	public constructor() {
		super()
		this.base_file = "dragonBall"
		this.layout_file = "DragonBallTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public LoadSuccess() {
		this._panel_con.vScrollBarSkin = ""

		this._html_type.style.wordWrap = false
		this._html_type.style.fontSize = 20
		this._html_type.style.color = "#ffffff"

		this._html_fight.style.wordWrap = false
		this._html_fight.style.fontSize = 20
		this._html_fight.style.color = "#ffffff"

		this._html_attr.style.wordWrap = false
		this._html_attr.style.fontSize = 20
		this._html_attr.style.color = "#663915"

		// this._html_skill_desc.style.wordWrap = false
		this._html_skill_desc.style.fontSize = 20
		this._html_skill_desc.style.color = "#663915"

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)
	}

	public Remove() {
		this.cur_dragon_id = undefined
	}

	public InitEvent() {
	}

	public UpdateView() {
		if (!this.cur_dragon_id) return
		let info = DragonBallModel.GetBallInfo(this.cur_dragon_id)
		if (!info) return
		let name = `${WordManager.NumConvertStage(info.index)}星龙玉`
		let data = this.model.GetDrageonData(this.cur_dragon_id)

		this._lb_name.text = name

		this._html_type.innerHTML = `类型：${HtmlColorTxt("龙玉", "'#ffe222'")}`

		let is_active = data && data.dragon_lv > 0

		let lv
		if (is_active) {
			lv = data.dragon_lv
			this._lb_base_attr_name.text = "基础属性"
		}
		else {
			lv = '未激活'
			this._lb_base_attr_name.text = "激活属性"
		}

		this._html_fight.innerHTML = `等级：${HtmlColorTxt(lv, "'#ffe222'")}`

		this._img_icon.skin = GameResPath.GetIcon("dragonBall", info.res)
		this.AddUIEffect("ui_goods_red", this._box_icon_effect, null, 14)



		let config_dragon_ball = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball
		if (config_dragon_ball) {
			let attr_dic = {}

			let show_cfg
			if (is_active) {
				show_cfg = config_dragon_ball[`${info.dragon_id}@${data.dragon_lv}`]
			}
			else {
				show_cfg = config_dragon_ball[`${info.dragon_id}@1`]
			}

			var show_attr = ErlangParser.GetInstance().Parse(show_cfg.attr)
			for (let i in show_attr) {
				var vo = show_attr[i]
				if (attr_dic[vo[0]]) {
					attr_dic[vo[0]] += Number(vo[1])
				}
				else {
					attr_dic[vo[0]] = Number(vo[1])
				}
			}

			let attr_str = ""
			// let index = 0
			for (let key in attr_dic) {
				var value = attr_dic[key]
				attr_str += `${WordManager.GetProperties(Number(key))}`
				attr_str += `&nbsp;${HtmlColorTxt(`+${WordManager.ConvertToPercentValue(key, value)}`, "'#d15e00'")}`
				// if (index % 2 == 0) {
				// 	attr_str += `&nbsp;&nbsp;&nbsp;&nbsp;`
				// }
				// else {
				// 	attr_str += `<br>`
				// }
				// index++
				attr_str += `<br>`
			}

			this._html_attr.innerHTML = attr_str

			this._box_skill_desc.y = this._html_attr.y + this._html_attr.contextHeight + 5
			this._html_skill_desc.y = this._box_skill_desc.y + 40

			var skill = ErlangParser.GetInstance().Parse(show_cfg.skill)
			//只有一个技能
			var skill_id = skill[0][0]
			var skill_lv = skill[0][1]
			let skill_vo: SkillVo = SkillManager.GetInstance().getSkill(skill_id)
			let skill_desc = skill_vo.getDesc(skill_lv, false)

			let skill_desc_str = ""
			if (is_active) {		//  激活的状态
				skill_desc_str += "<font color='#ff4f50'>" + info.name + "</font>" + "&nbsp;<font color='#19ae4a'>" + show_cfg.lv + "级</font><br/>"
				skill_desc_str += skill_desc
			} else {						//  未激活状态
				skill_desc_str += "<font color='#5a1c20'>" + info.name + "  " + "(未激活)</font><br/>"
				skill_desc_str += "<font color='#5a1c20'>" + skill_desc + "</font>"
			}

			this._html_skill_desc.innerHTML = skill_desc_str
			this._html_skill_desc.width = 380


			this._panel_con.height = this._html_skill_desc.y + this._html_skill_desc.contextHeight

			let height = this._panel_con.height + this._panel_con.y + 90

			if (height < 550)
				height = 550

			this.display_obj.height = height
		}
	}

	public Open(...parms): void {
		if (parms) {
			this.cur_dragon_id = parms[0]
		}
		super.Open()
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_lb_name: Laya.Label
	_html_type: Laya.HTMLDivElement
	_html_fight: Laya.HTMLDivElement
	_box_item: Laya.Box
	_img_icon_bg: Laya.Image
	_img_icon: Laya.Image
	_box_icon_effect: Laya.Box
	_panel_con: Laya.Panel
	_lb_base_attr_name: Laya.Label
	_html_attr: Laya.HTMLDivElement
	_box_skill_desc: Laya.Box
	_html_skill_desc: Laya.HTMLDivElement
	_img_close: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._lb_name,
			this._html_type,
			this._html_fight,
			this._box_item,
			this._img_icon_bg,
			this._img_icon,
			this._box_icon_effect,
			this._panel_con,
			this._lb_base_attr_name,
			this._html_attr,
			this._box_skill_desc,
			this._html_skill_desc,
			this._img_close,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_lb_name",
				"_html_type",
				"_html_fight",
				"_box_item",
				"_img_icon_bg",
				"_img_icon",
				"_box_icon_effect",
				"_panel_con",
				"_lb_base_attr_name",
				"_html_attr",
				"_box_skill_desc",
				"_html_skill_desc",
				"_img_close"
			])
	}
}
window["DragonBallTipsView"] = DragonBallTipsView