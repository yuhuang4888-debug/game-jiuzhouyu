import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossModel } from "../commonModel/BossModel"
import { GuildModel, GuildEvent, GuildAssistType } from "../commonModel/GuildModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetHtmlStyle, Util } from "../util/Util"
import { Config } from "../common/Config"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"

export class BossDomainScenePanel extends BaseItem1 {
	InitEvent
	LoadSuccess
	SetBossData
	SetHelpStatus
	initItem
	initView
	loop_mgr
	updateView
	_boss_data
	SwitchBtn
	ChangeOpen
	need_fresh_
	bool_cache_
	public constructor(parent?) {
		super(parent)


		this.base_file = "bossdomain"
		this.layout_file = "BossDomainScenePanel"
		this.preload_client_config = { "ConfigGuild": false, "ClientDomainBoss": false }
		let open_help = null
		let guild_model = GuildModel.GetInstance()
		let _model = BossModel.GetInstance()
		let _itemType = "role_rank"
		let local_BossModel = BossModel
		this.need_fresh_=false
		this.bool_cache_=false
		this.load_callback = () => {
			this._sc_panel.vScrollBarSkin = ""
			SetHtmlStyle(this._lb_desc, { c: "#ffffff", f: 20, w: 252, lh: 25 })
			this.InitEvent()
			this.LoadSuccess()
		}



		this.InitEvent = () => {
			this.BindEvent(_model, local_BossModel.DOMAINBOSS_ROLE_RANK_RETURN, () => {
				this.initItem()
			}
			)



			this.BindEvent(GuildModel.GetInstance(), GuildEvent.CHANGED_CONDS_ASSIST, () => {
				this.SetHelpStatus(this.bool_cache_)
			})


			Util.AddClickEvent(this._box_intro, (target?, x?, y?) => {
				let guild_model = GuildModel.GetInstance()
				let is_open = guild_model.IsOpenAssist(GuildAssistType.TYPE_DOMAIN_BOSS)
				if (!is_open) {
					Message.show(`${guild_model.GetAssistOpenDesc(GuildAssistType.TYPE_DOMAIN_BOSS)}`)
					return
				}
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.InstructionGuildHelp)
			}
				, this, true)
			Util.AddClickEvent(this._box_help, () => {
				if (!this._boss_data) {
					return
				}
				let guild_model = GuildModel.GetInstance()
				let is_open = guild_model.IsOpenAssist(GuildAssistType.TYPE_DOMAIN_BOSS)
				if (!is_open) {
					Message.show(`${guild_model.GetAssistOpenDesc(GuildAssistType.TYPE_DOMAIN_BOSS)}`)
					return
				}
				let data = this._boss_data
				let rdata = guild_model.GetReqData()
				if (rdata && rdata.target_id != data.instance_id) {
					guild_model.Fire(GuildEvent.REQUEST_PROTO, 40403, "l", rdata.assist_id)
				}
				guild_model.Fire(GuildEvent.REQUEST_PROTO, 40401, "chil", 1, local_BossModel.BossType.domainserver, data.type_id, data.instance_id)
			}
				, this, true)
		}



		this.updateView = () => {
			if (this.is_loaded) {
				this.LoadSuccess()
			}
		}

		this.LoadSuccess = () => {
			this.initView()
			if(this.need_fresh_){
				this.SetHelpStatus(this.bool_cache_)
				this.need_fresh_=false
			}
		}

		this.SwitchBtn = (e?) => {
			let radioGroup = e.target
			let key = radioGroup.selectedValue
			if (_itemType == key) {
				return
			}
			_itemType = key
			this.initView()
		}

		this.initView = () => {
			let config = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientDomainBoss", true)//Config.ClientDomainBoss
			let sceneId = SceneManager.GetInstance().GetSceneId()
			let descCfg = config.domianBossScene[sceneId]
			if (descCfg) {
				this._lb_desc.innerHTML = Util.StrToHTML(descCfg.desc)
				this._lb_desc.style.width = 252
			}
			this.initItem()
		}

		this.initItem = () => {
			// let dataList = _model.role_rank_list
			// if (dataList.length < _model.role_rank_length) {
			// 	for (let i = 1; i <= _model.role_rank_length - dataList.length; i++) {
			// 		table.insert(dataList, null)
			// 	}
			// }

			// if (!this.loop_mgr) {
			// 	this.loop_mgr = new LoopScrowViewMgr()
			// 	this.loop_mgr.SetData(this.Content, BossDomainScenePanelItem, dataList,LoopScrCon.Vertical)
			// } else {
			// 	this.loop_mgr.replaceAll(dataList)
			// }
		}

		this.SetHelpStatus = (bool?) => {
			this.bool_cache_=bool
			if (this.is_loaded) {
				this.need_fresh_ = false
				open_help = guild_model.IsCanOpenAssist()
				if (bool && open_help) {
					bool = true
				} else {
					bool = false
				}

				this._box_intro.visible=this._box_help.visible = bool
			}else{
				this.need_fresh_ =true
			}
		}

		this.SetBossData = (data?) => {
			this._boss_data = data
		}



	}


	public DeleteMe() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		super.DeleteMe()
	}




	_img_bg: Laya.Image
	_Image2_title2: Laya.Image
	_Label4: Laya.Label
	_sc_panel: Laya.Panel
	_lb_desc: Laya.HTMLDivElement
	_box_intro: Laya.Box
	_img_intro: Laya.Image
	_lb_intro: Laya.Label
	_box_help: Laya.Box
	_img_help: Laya.Image
	_lb_help: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._Image2_title2,
			this._Label4,
			this._sc_panel,
			this._lb_desc,
			this._box_intro,
			this._img_intro,
			this._lb_intro,
			this._box_help,
			this._img_help,
			this._lb_help,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image2_title2",
				"_Label4",
				"_sc_panel",
				"_lb_desc",
				"_box_intro",
				"_img_intro",
				"_lb_intro",
				"_box_help",
				"_img_help",
				"_lb_help",
			])
	}
}
window["BossDomainScenePanel"] = BossDomainScenePanel