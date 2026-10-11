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

export class PlayerMessageDragonBallAttrView extends BaseView1 {

	item
	type_id = 38410000
	data:ProtoRecvVObj<19503>
	dragon_ball_model:DragonBallModel = DragonBallModel.GetInstance()
	public constructor() {
		super()
		this.base_file = "playerMessage"
		this.layout_file = "PlayerMessageDragonBallAttrView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true

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
		this._html_type.style.bold = true

		this._html_fight.style.wordWrap = false
		this._html_fight.style.fontSize = 20
		this._html_fight.style.color = "#ffffff"
		this._html_fight.style.bold = true

		this._html_attr.style.wordWrap = false
		this._html_attr.style.fontSize = 20
		this._html_attr.style.color = "#663915"

		this._html_skill_desc.style.fontSize = 18
		this._html_skill_desc.style.color = "#663915"

		this._html_active_title.style.bold = true
		this._html_active_title.style.wordWrap = false
		this._html_active_title.style.fontSize = 20
		this._html_active_title.style.color = "#663915"

		this._html_active_desc.width = 310
		this._html_active_desc.style.fontSize = 20
		this._html_active_desc.style.color = "#663915"
		this._html_active_desc.style.wordWrap = true
		this._html_active_desc.style.leading = 5

	}

	public Remove() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = false
		}
	}

	public InitEvent() {
	}

	public UpdateView() {
		let data = this.data
		if(!data) return
		
		this._lb_name.text = "龙玉"
		this._html_type.innerHTML = `类型：${HtmlColorTxt("龙玉", "'#ffe222'")}`
		this._html_fight.innerHTML = `战力：${HtmlColorTxt(data.sum_power, "'#ffe222'")}`

		let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.type_id)
		this._img_bg2.skin = GameResPath.GetIcon("common4", "ui_tips_pz_" + goods_basic.color)

		if (!this.item) {
			this.item = new BaseAwardItem(this._box_item, null, null, false)
			this.item.Load()
		}
		this.item.SetItemSize(84, 84)
		this.item.SetData(this.type_id)


		let attr_dic = {}
		//雕像属性
		let config_dragon_ball_kv = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_kv
		if (config_dragon_ball_kv) {
			let attr = ErlangParser.GetInstance().Parse(config_dragon_ball_kv[5].value)
			for (let i in attr) {
				var vo = attr[i]
				if (attr_dic[vo[0]]) {
					attr_dic[vo[0]] += Number(vo[1])
				}
				else {
					attr_dic[vo[0]] = Number(vo[1])
				}
			}
		}

		//星核属性
		let config_dragon_ball = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball
		if (config_dragon_ball) {
			let dragon_data
			for (let key in DragonBallModel.BallInfoDic) {
				var info = DragonBallModel.BallInfoDic[key]
				dragon_data = this.GetDrageonData(info.dragon_id)
				if (dragon_data && dragon_data.level) {
					var cfg = config_dragon_ball[`${info.dragon_id}@${dragon_data.level}`]
					var cur_attr = ErlangParser.GetInstance().Parse(cfg.attr)
					for (let i in cur_attr) {
						var vo = cur_attr[i]
						if (attr_dic[vo[0]]) {
							attr_dic[vo[0]] += Number(vo[1])
						}
						else {
							attr_dic[vo[0]] = Number(vo[1])
						}
					}
				}
			}
		}

		//套装属性
		let config_dragon_ball_figure = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_figure
		if (config_dragon_ball_figure) {
			let info
			for (let key in data.figure_list) {
				info = data.figure_list[key]
				if (info && info.lv) {
					var cfg = config_dragon_ball_figure[`${info.type}@${info.lv}`]
					var cur_attr = ErlangParser.GetInstance().Parse(cfg.attr)
					for (let i in cur_attr) {
						var vo = cur_attr[i]
						if (attr_dic[vo[0]]) {
							attr_dic[vo[0]] += Number(vo[1])
						}
						else {
							attr_dic[vo[0]] = Number(vo[1])
						}
					}
				}
			}
		}

		let attr_str = ""
		let index = 0
		for (let key in attr_dic) {
			var value = attr_dic[key]
			attr_str += `${WordManager.GetProperties(Number(key))}`
			attr_str += `&nbsp;${HtmlColorTxt(`+${WordManager.ConvertToPercentValue(key, value)}`, "'#d15e00'")}`
			if (index % 2 == 0) {
				attr_str += `&nbsp;&nbsp;&nbsp;&nbsp;`
			}
			else {
				attr_str += `<br>`
			}
			index++
		}

		this._html_attr.innerHTML = attr_str

		this._box_skill.y = this._html_attr.y + this._html_attr.contextHeight + 5

		//技能
		if (config_dragon_ball_kv) {
			let skill = ErlangParser.GetInstance().Parse(config_dragon_ball_kv[4].value)
			//只有一个技能
			let skill_id = skill[0][0]
			let skill_lv = skill[0][1]
			let skill_vo: SkillVo = SkillManager.GetInstance().getSkill(skill_id)
			let skill_str = skill_vo.getDesc(skill_lv, false)
			let skill_name = skill_vo.getName()
			let skill_icon = skill_vo.GetIcon()

			this._html_skill_desc.innerHTML = skill_str
			this._html_skill_desc.width = 270
			this._lb_skill_name.text = `【${skill_name}】:`
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_skill_icon, GameResPath.GetSkillIconPath(skill_icon))
		}


		this._box_active_title.y = this._box_skill.y + this._box_skill.height
		//星核效果
		this._html_active_title.innerHTML = "已激活龙玉(<font color='#0a953e'>" + this.GetActiveCount() + "</font>/" + this.dragon_ball_model.GetTotalCount() + ")"

		let list = []
		for (let key in DragonBallModel.BallInfoDic) {
			list.push(DragonBallModel.BallInfoDic[key])
		}

		list.sort((a, b) => {
			return a.index - b.index
		})

		let dragon_str = "", dragon_data
		for (let i = 0; i < list.length; i++) {
			var info = list[i]
			dragon_data = this.GetDrageonData(info.dragon_id)

			var show_lv = (dragon_data && dragon_data.level > 0) ? dragon_data.level : 1
			var cfg = config_dragon_ball[`${info.dragon_id}@${show_lv}`]
			var skill = ErlangParser.GetInstance().Parse(cfg.skill)
			//只有一个技能
			var skill_id = skill[0][0]
			var skill_lv = skill[0][1]
			let skill_vo: SkillVo = SkillManager.GetInstance().getSkill(skill_id)
			let skill_str = skill_vo.getDesc(skill_lv, false)

			if (dragon_data && dragon_data.level > 0) {		//  激活的状态
				dragon_str += "<font color='#ff4f50'>" + info.index + "." + info.name + "</font>" + "&nbsp;<font color='#19ae4a'>" + show_lv + "级</font><br/>"
				dragon_str += skill_str
			} else {						//  未激活状态
				dragon_str += "<font color='#5a1c20'>" + info.index + "." + info.name + "  " + "(未激活)</font><br/>"
				dragon_str += "<font color='#5a1c20'>" + skill_str + "</font>"
			}
			if(i < list.length - 1){
				dragon_str += "<br/>"
			}
		}

		this._html_active_desc.innerHTML = dragon_str
		this._html_active_desc.width = 378

		let height = this._panel_con.y + this._box_active_title.y + this._html_active_desc.y + this._html_active_desc.contextHeight + 25
		this.display_obj.height = this._box_con.height = this._img_bg.height = height
	}


	GetActiveCount(){
		let data = this.data
        let count = 0 
        if(data){
            for(let v of data.ball_list){
                if(v.level > 0){
                    count++
                }
            }
        }
        return count
	}

	GetDrageonData(dragon_id){
		let data = this.data
        if(data){
            for(let v of data.ball_list){
                if(v.dragon_ball_id == dragon_id){
                    return v
                }
            }
        }
	}

	public Open(...new_args): void {
		this.data = new_args[0]
		super.Open()
	}

	_box_con: Laya.Box
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_lb_name: Laya.Label
	_html_type: Laya.HTMLDivElement
	_html_fight: Laya.HTMLDivElement
	_box_item: Laya.Box
	_panel_con: Laya.Panel
	_html_attr: Laya.HTMLDivElement
	_box_skill: Laya.Box
	_img_skill_icon: Laya.Image
	_lb_skill_name: Laya.Label
	_html_skill_desc: Laya.HTMLDivElement
	_box_active_title: Laya.Box
	_html_active_title: Laya.HTMLDivElement
	_html_active_desc: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._box_con,
			this._img_bg,
			this._img_bg2,
			this._lb_name,
			this._html_type,
			this._html_fight,
			this._box_item,
			this._panel_con,
			this._html_attr,
			this._box_skill,
			this._img_skill_icon,
			this._lb_skill_name,
			this._html_skill_desc,
			this._box_active_title,
			this._html_active_title,
			this._html_active_desc,
		]
			= this.GetChildrenByNames([

				"_box_con",
				"_img_bg",
				"_img_bg2",
				"_lb_name",
				"_html_type",
				"_html_fight",
				"_box_item",
				"_panel_con",
				"_html_attr",
				"_box_skill",
				"_img_skill_icon",
				"_lb_skill_name",
				"_html_skill_desc",
				"_box_active_title",
				"_html_active_title",
				"_html_active_desc",
			])
	}
}
window["PlayerMessageDragonBallAttrView"] = PlayerMessageDragonBallAttrView