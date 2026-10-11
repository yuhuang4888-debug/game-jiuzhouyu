import { DragonBallModel } from "../commonModel/DragonBallModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SkillManager } from "../skill/SkillManager"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { Util, Trim } from "../util/Util"
import { BaseAwardItem } from "./BaseAwardItem"
import { BaseView1 } from "./BaseView1"
import { Config } from "./Config"
import { Enum_UILayer } from "./LayerManager"
import { ResManager } from "./ResManager"

export class DragonBallTooltips extends BaseView1 {
	item
	// _details
	model
	act_num
	type_id

	dragon_list
	red_state
	num
	goods_model

	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "DragonBallTooltips"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.is_delay_callback = false

		this.goods_model = GoodsModel.GetInstance()
		this.model = DragonBallModel.GetInstance()

		// this._details = []
		this.num = 7
		this.act_num = 0
		this.red_state = false
		this.dragon_list = []
		this.item = false
		this.type_id = 38410000

		this.load_callback = () => {
			this.LoadSucess()
			// for (let i = 0; i < this._details.length; i++) {
			// 	var v = this._details[i]
			// 	if (v.skill) {
			// 		v.skill.lineSpacing = 1
			// 		if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 			v.skill.lineSpacing = 0.7
			// 		}	
			// 	}
			// }
			this.InitEvent()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public LoadSucess() {
		// for (let i = 1; i <= this.num; i++) {
		// 	this._details[i] = { name: false, skill: false }
		// }
		this.detail_scroller.vScrollBar.visible = false
		this.InitHtmlText()
	}

	public Remove() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = false
		}
	}

	public SetData(type_id?, act_num?, dragon_list?, red_state?) {
		this.act_num = act_num || this.act_num
		this.dragon_list = dragon_list
		this.red_state = red_state || false
	}

	public InitEvent() {
		Util.AddClickEvent(this.btn_use, () => {
			this.model.Fire(DragonBallModel.OPEN_VIEW)
			this.Close()
		}, this, true)

		this.BindEvent(this.goods_model, GoodsModel.CHANGE_BAG_LIST, () => {
			let red = this.model.GetRed()
			this.img_red.visible = red
		})
	}
	
	public InitHtmlText() {
		this.lb_type.width = 200
		this.lb_type.style.fontSize = 20
		this.lb_type.style.color = "#783528"
		
		this.lb_fightnum.width = 200
		this.lb_fightnum.style.fontSize = 20
		this.lb_fightnum.style.color = "#783528"
		
		this.lb_tips.width = 200
		this.lb_tips.style.fontSize = 20
		this.lb_tips.style.color = "#783528"
		this.lb_tips.style.bold = true
		this.lb_tips.style.stroke = 2
		this.lb_tips.style.strokeColor = "#dfd1cd"
		
		this.lb_detail.width = 310
		this.lb_detail.style.fontSize = 20
		this.lb_detail.style.color = "#783528"
		this.lb_detail.style.wordWrap = true
		this.lb_detail.style.leading = 5
	}

	public InitView() {
		//SetAnchoredPosition(this.form, 0, 0)
		this.lb_type.innerHTML = Util.StrToHTML("类型：<font color='#c85a37'>星核</font>")
		this.lb_type.width = 200
		this.lb_fightnum.innerHTML = Util.StrToHTML("战力：<font color='#c85a37'>" + this.model.GetFightNum() + "</font>")
		this.lb_fightnum.width = 200
		this.lb_tips.innerHTML = Util.StrToHTML("已激活星核(<font color='#5dbc54'>" + this.act_num + "</font>/" + this.num + ")")
		this.lb_tips.width = 350

		let index, skill_id, skill_lv
		let skill_info, skill_vo, skill_desc
		let num = 1
		let str = ""
		for (let k in this.dragon_list) {
			var v = this.dragon_list[k]
			// 获取龙珠技能信息
			skill_lv = v.dragon_lv == 0 && 1 || v.dragon_lv
			index = String(v.dragon_id) + "@" + String(skill_lv)
			skill_info = ErlangParser.GetInstance().Parse(Config.PRELOAD_SERVER_CONFIG.config_dragon_ball[index].skill)
			skill_id = Number(skill_info[0][0])
			skill_vo = SkillManager.GetInstance().getSkill(skill_id)
			if (skill_vo) {
				skill_desc = skill_vo.getDesc(skill_lv, false)
			} else {
				skill_desc = "  "
			}

			if (v.dragon_lv > 0) {		//  激活的状态
				str += Util.StrToHTML("<font color='#ff4f50'>" + num + "." + Config.PRELOAD_CLIENT_CONFIG.ConfigDragonBallMsg[v.dragon_id].name + "</font>" + "&nbsp;<font color='#19ae4a'>" + v.dragon_lv + "级</font><br/>")
				str += Util.StrToHTML(skill_desc + "<br/>")
			} else {						//  未激活状态
				str += Util.StrToHTML("<font color='#5a1c20'>" + num + "." + Config.PRELOAD_CLIENT_CONFIG.ConfigDragonBallMsg[v.dragon_id].name + "  " + "(未激活)</font><br/>")
				str += Util.StrToHTML("<font color='#5a1c20'>" + skill_desc + "</font><br/>")
			}
			num = num + 1
		}
		this.lb_detail.innerHTML = str

		if (!this.item) {
			this.item = new BaseAwardItem(this.gp_item)
			this.item.Load()
		}
		this.item.SetItemSize(84, 84)
		this.item.SetData(this.type_id)
		this.item.SetClickCallBack(() => {
			return
		})

		// 红点处理
		this.img_red.visible = this.red_state
	}

	root_wnd: Laya.Box
	img_bg1: Laya.Image
	img_title: Laya.Image
	lb_name: Laya.Label
	img_des2: Laya.Image
	lb_type: Laya.HTMLDivElement
	lb_fightnum: Laya.HTMLDivElement
	gp_item: Laya.Box
	img_title2: Laya.Image
	lb_tips: Laya.HTMLDivElement
	detail_scroller: Laya.Panel
	Content: Laya.VBox
	lb_detail: Laya.HTMLDivElement
	btn_use: Laya.Box
	img_bg: Laya.Image
	lb_text: Laya.Label
	img_red: Laya.Image
	public GetComponents() {
		[
			this.root_wnd,
			this.img_bg1,
			this.img_title,
			this.lb_name,
			this.img_des2,
			this.lb_type,
			this.lb_fightnum,
			this.gp_item,
			this.img_title2,
			this.lb_tips,
			this.detail_scroller,
			this.Content,
			this.lb_detail,
			this.btn_use,
			this.img_bg,
			this.lb_text,
			this.img_red,
		]
			= this.GetChildrenByNames([

				"root_wnd",
				"img_bg1",
				"img_title",
				"lb_name",
				"img_des2",
				"lb_type",
				"lb_fightnum",
				"gp_item",
				"img_title2",
				"lb_tips",
				"detail_scroller",
				"Content",
				"lb_detail",
				"btn_use",
				"img_bg",
				"lb_text",
				"img_red",
			])
	}
}
window["DragonBallTooltips"] = DragonBallTooltips