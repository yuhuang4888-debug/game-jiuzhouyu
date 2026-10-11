import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GuildActivityModel, GuildActEvent } from "../commonModel/GuildActivityModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { ErlangParser } from "../util/ErlangParser"
import { SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { EveningFoodItem } from "./EveningFoodItem"
import { Config } from "../common/Config"
import { MainUIManager } from "../common/MainUIManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { LayerManager } from "../common/LayerManager"

export class EveningFoodView extends BaseItem1 {
	food_buff
	guild_feast_max_exp_ratio
	item_list
	model
	config_g
	public constructor(parent?) {
		super(parent)

		this.model = GuildActivityModel.GetInstance()
		this.base_file = "evening"
		this.layout_file = "EveningFoodView"
		this.item_list = []

		this.preload_server_config = { "config_gfeast": false }

		// this.food_buff = ErlangParser.GetInstance().Parse(Config.Gfeast[63].value)
		// this.guild_feast_max_exp_ratio = Config.Gfeast[65].value

		this.load_callback = () => {
			this.config_g = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gfeast", false)
			this.food_buff = JSON.parse(Config.GetConfigVo("config_gfeast", "63", false, this.config_g).value)//JSON.parse(Config.GetConfigVo("config_gfeast", "63", false, this.config_g))
			this.guild_feast_max_exp_ratio =  JSON.parse(Config.GetConfigVo("config_gfeast", "65", false, this.config_g).value)

			this.LoadSuccess()
		}



	}

	public DeleteMe() {
		MainUIManager.GetInstance().RemoveMoveComponent(this)
		for(let i=0;i<this.item_list.length;i++){
			this.item_list[i].DeleteMe()
		}
		this.item_list = []
		super.DeleteMe()
	}

	public LoadSuccess() {
		//this.InitResetData()
		MainUIManager.GetInstance().AddMoveComponent(this, this.sv, false, MainUIManager.MOVE_TYPE.Buttom)
		MainUIManager.GetInstance().AddMoveComponent(this, this._box, false, MainUIManager.MOVE_TYPE.Left)
		MainUIManager.GetInstance().AddMoveComponent(this, this._box2, false, MainUIManager.MOVE_TYPE.Top)
		this.InitView()
		this.InitEvent()
	}

	public InitView() {
		this.PreHtml_txt_exp()
		this.PreHtml_txt_desc()
		this.model.Fire(GuildActEvent.REQUEST_PROTO, 40265)
		this.model.Fire(GuildActEvent.REQUEST_PROTO, 40267)

		this.txt_desc.innerHTML = Util.StrToHTML("在篝火晚宴中，每<font color=\"#00b11d\">5</font>秒将自动获得<font color=\"#ff6519\">经验奖励</font>。")
		this.txt_exp.innerHTML = Util.StrToHTML(`EXP:<font color=\"#ff6519\">0</font>`)
		SetHtmlCenter(this.txt_exp, { x: 0, w: 230 })
	}

	public InitEvent() {

		this.BindEvent(this.model, GuildActEvent.UPDATE_FOOD_LIST, (scmd40265?) => {
			let exp_buff_total = 0
			// let is_all_eat = true
			for (let i = 0; i < scmd40265.food_list.length; i++) {
				var v = scmd40265.food_list[i]

				let item =this.item_list[i] 
				if(!item){
					item = new EveningFoodItem(this.Content)
					item.Load()
					this.item_list[i]=item
				}
				
				item.SetData({ type: v.type, status: v.status })

				if (1 == v.status) {
					exp_buff_total = exp_buff_total + this.food_buff[v.type-1][1]
				} else {
					// is_all_eat = false
				}
			}
			// if (is_all_eat ) {
			// 	this.txt_exp_buff.textFlow = Util.StrToHTML(string.format("当前经验加成<font color='b3ff48'.length>+%d%%[已封顶]</font>", exp_buff_total)
		}
			// }else{
			// 	this.txt_exp_buff.textFlow = Util.StrToHTML(string.format("当前经验加成<font color='b3ff48'.length>+%d%%</font>", exp_buff_total)
		)


		this.BindEvent(this.model, GuildActEvent.UPDATE_EXP, (info?) => {
			if (1 == info.type) {
				this.PreHtml_txt_exp()
				this.txt_exp.innerHTML = Util.StrToHTML(`EXP:<font color='#ff6519'>${info.exp}</font>`)// Util.StrToHTML(string.format("EXP:<font color=0xb3ff48>" + info.exp + "</font>")
				SetHtmlCenter(this.txt_exp, { x: 0, w: 230 })
			}
		}
		)

		this.BindEvent(this.model, GuildActEvent.UPDATE_EXP_BUFF, (scmd40267?) => {
			this.PreHtml_txt_exp_buff()
			if (this.guild_feast_max_exp_ratio == scmd40267.ratio) {
				this.txt_exp_buff.innerHTML = Util.StrToHTML(`当前经验加成<font color="#00fa64">+${scmd40267.ratio}%[已封顶]</font>`)
			} else {
				this.txt_exp_buff.innerHTML = Util.StrToHTML(`当前经验加成<font color="#00fa64">+${scmd40267.ratio}%</font>`)
			}

			SetHtmlCenter(this.txt_exp_buff, { x: 0, w: 351 })
		}
		)


	}

	PreHtml_txt_exp_buff() {
		this.txt_exp_buff.style.color = "#ffffff"
		this.txt_exp_buff.style.fontSize = 20
		this.txt_exp_buff.width = 500
		this.txt_exp_buff.style.align = "center"
	}

	PreHtml_txt_desc() {
		this.txt_desc.style.color = "#7b5250"
		this.txt_desc.style.fontSize = 18
		this.txt_desc.style.wordWrap = true
		this.txt_desc.width = 180
	}


	PreHtml_txt_exp() {
		this.txt_exp.style.color = "#7b5250"
		this.txt_exp.style.fontSize = 18
		this.txt_exp.width = 215
	}



	sv: Laya.Panel
	Content: Laya.HBox
	_box: Laya.Box
	img_left: Laya.Image
	img_1: Laya.Image
	Text: Laya.Label
	txt_exp: Laya.HTMLDivElement
	txt_desc: Laya.HTMLDivElement
	_box2: Laya.Box
	img_exp_buff: Laya.Image
	txt_exp_buff: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.sv,
			this.Content,
			this._box,
			this.img_left,
			this.img_1,
			this.Text,
			this.txt_exp,
			this.txt_desc,
			this._box2,
			this.img_exp_buff,
			this.txt_exp_buff,
		]
			= this.GetChildrenByNames([

				"sv",
				"Content",
				"_box",
				"img_left",
				"img_1",
				"Text",
				"txt_exp",
				"txt_desc",
				"_box2",
				"img_exp_buff",
				"txt_exp_buff",
			])
	}
}
window["EveningFoodView"] = EveningFoodView
