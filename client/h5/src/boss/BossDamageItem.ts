import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossSceneEvent, BossSceneManager } from "../commonController/BossSceneManager"
import { BossModel } from "../commonModel/BossModel"
import { GuildAssistType, GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"
import { BossDamageSubItem } from "./BossDamageSubItem"
import { InstructionType } from "../common/InstructionType"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"

export class BossDamageItem extends BaseItem1 {


	assist_dic
	boss_damage_dic_
	boss_data
	boss_scene_mgr
	boss_type
	item_loop_mgr
	main_role_vo
	help_cache
	guild_model
	show
	mine_vo
	need_fresh_
	is_show_help_
	//ChangeOpen
	public constructor(parent?) {
		super(parent)

		this.base_file = "boss"
		this.layout_file = "BossDamageItem"

		//协助
		this.boss_data = null
		this.assist_dic = {}
		this.help_cache = null
		this.need_fresh_=null

		this.guild_model = GuildModel.GetInstance()
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
		this.show = true
		this.is_show_help_=false

		this.preload_client_config = {
			"ConfigGuild": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
		}

	}

	public LoadSuccess() {
		SetHtmlStyle(this._html_tips,{c:"#ffffff",f:18,w:220,ww:false})
		this.UpdataView()
		this.InitEvent()

		if (this.need_fresh_ ) {
			this.SetHelpStatus(this.is_show_help_)
			this.need_fresh_ = false
		}

	}

	public InitEvent() {

		this.BindEvent(GlobalEventSystem, EventName.ADD_BOSS_DAMAGE_DATA, (vo?) => {
			this.AddBossDamage(vo)
		}
		)
		this.BindEvent(GlobalEventSystem, EventName.REMOVE_BOSS_DAMAGE_DATA, (monster_id?, list?) => {
			this.RemoveDamage(monster_id, list)
		}
		)
		this.BindEvent(this.boss_scene_mgr, BossSceneEvent.CLEAN_DAMAGE_BOSS_INS_ID, (monster_id?) => {
			this.RemoveDamage(monster_id, null, true)
		}
		)
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_BOSS_DAMAGE_DATA, (monster_id?, list?) => {
			this.UpdateBossDamage(monster_id, list)
		}
		)

		this.BindEvent(GlobalEventSystem, EventName.UPDATE_ASSIST_DATA, (monster_id?, list?, type_id?) => {
			let dic = {}
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				dic[vo.assist_id] = vo
			}
			this.assist_dic[monster_id] = dic
		}
		)

		this.BindEvent(GlobalEventSystem, EventName.ADD_ASSIST_DATA, (scmd?) => {
			let dic = this.assist_dic[scmd.instance_id]
			if (dic) {
				dic[scmd.assist_id] = scmd
				this.UpdateScrollItem()
			}
		}
		)
		this.BindEvent(GlobalEventSystem, EventName.REMOVE_ASSIST_DATA, (scmd?) => {
			let dic = this.assist_dic[scmd.instance_id]
			if (dic) {
				delete dic[scmd.assist_id]
				this.UpdateScrollItem()
			}
		}
		)
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_FLAG_DATA, (instance_id?, list?, type_id?) => {
			let dic = this.boss_damage_dic_ && this.boss_damage_dic_[instance_id]
			if (dic) {
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					let data = dic[vo.player_id]
					if (data) {
						data.assist_id = vo.assist_id
					}
				}
				this.UpdateScrollItem()
			}
		}
		)


		this.BindEvent(this.guild_model, GuildEvent.CHANGED_CONDS_ASSIST, () => {
			this.SetHelpStatus(this.is_show_help_)
		})

		Util.AddClickEvent(this._img_arrow, () => {
			BossModel.GetInstance().Fire(BossModel.SHOW_DAMAGE, false)
			//SetLocalScale(this.arrow, this.show && 1 || -1, 1, 1)
		}, this, true)

		Util.AddClickEvent(this._box_intro, () => {
			let help_type = this.GetAssistType()
			let is_open = this.guild_model.IsOpenAssist(help_type)
			if (!is_open) {
				Message.show(`${this.guild_model.GetAssistOpenDesc(help_type)}`)
				return
			}
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.InstructionGuildHelp)
		}, this, true)

		Util.AddClickEvent(this._box_help, () => {
			if (!this.boss_data) {
				return
			}
			let data = this.boss_data
			let rdata = this.guild_model.GetReqData()
			let help_type = this.GetAssistType()
			let is_open = this.guild_model.IsOpenAssist(help_type)
			if (!is_open) {
				Message.show(`${this.guild_model.GetAssistOpenDesc(help_type)}`)
				return
			}
			if (rdata && rdata.target_id != data.instance_id) {
				this.guild_model.Fire(GuildEvent.REQUEST_PROTO, 40403, "l", rdata.assist_id)
			}
			let type = (this.boss_type && BossModel.cross_boss_base_index && this.boss_type > BossModel.cross_boss_base_index) && 10 || this.boss_type
			this.guild_model.Fire(GuildEvent.REQUEST_PROTO, 40401, "chil", 1, type, data.type_id, data.instance_id)
		}, this, true)
	}

	public SetData() {
	}

	public UpdataView() {
		this.UpdateScrollItem()
	}

	public AddBossDamage(vo?) {

		let dic = this.boss_damage_dic_ && this.boss_damage_dic_[vo.monster_id]
		if (dic) {
			let data = dic[vo.player_id]
			if (data) {
				data.damage = data.damage + vo.damage
				data.player_name = vo.player_name
			} else {
				dic[vo.player_id] = vo
			}
			this.item_loop_mgr.replaceAll(this.GetDamageList())
			this.UpdateScrollItem()
		}
	}

	public RemoveDamage(monster_id?, list?, all?) {

		if (all == null) {
			all = false
		}
		let dic = this.boss_damage_dic_ && this.boss_damage_dic_[monster_id]
		if (dic) {
			if (all) {
				delete this.boss_damage_dic_[monster_id]
			} else {
				for (let _tmpi in list) {
					var data = list[_tmpi]
					if (dic[data.player_id]) {
						delete dic[data.player_id]
					}
				}
			}
			this.mine_vo = null
			this.UpdateScrollItem()
		}
	}

	public UpdateBossDamage(monster_id?, list?) {

		if (!this.boss_damage_dic_) {
			this.boss_damage_dic_ = {}
		}
		let dic = {}
		for (let _tmpi in list) {
			var vo = list[_tmpi]
			dic[vo.player_id] = vo
		}
		this.boss_damage_dic_[monster_id] = dic
		this.UpdateScrollItem()
	}

	public GetDamageList() {

		let list = []
		let ins_id = this.boss_scene_mgr.GetDamageBossInstanceId()
		let monster_list = Scene.GetInstance().FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 2000, null, null, null)[0]
		if (this.boss_damage_dic_ && this.boss_damage_dic_[ins_id]) {
			let role_id = RoleManager.GetInstance().GetMainRoleId()
			let addic = {}//协助者伤害数据
			let pdic = {}//请求者数据
			let adr_list = []//协助自己者数据
			let adic = this.assist_dic[ins_id]//所有的协助队伍信息
			let dic = this.boss_damage_dic_[ins_id]
			let total_damage = 0
			//总伤害
			if (SceneManager.GetInstance().IsFieldBossScene() || SceneManager.GetInstance().IsFieldInfiniteBossScene()) {
				if (monster_list && monster_list[0]) {
					let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, monster_list[0].vo.type_id, false)
					if (cfg)
						total_damage = cfg.hp_lim
				}
			} else {
				for (let player_id in dic) {
					let vo = dic[player_id]
					total_damage = total_damage + vo.damage
				}
			}
			//协助信息处理
			for (let player_id in dic) {

				let vo = dic[player_id]
				if (adic && adic[vo.assist_id]) {
					let aVo = adic[vo.assist_id]
					if (aVo.player_id != vo.player_id) {
						let addata = addic[aVo.player_id]
						if (addata) {
							addata.damage = addata.damage + vo.damage
						} else {
							addic[aVo.player_id] = { vo: vo, damage: vo.damage }
						}
						if (aVo.player_id == role_id) {
							table.insert(adr_list, vo)
						}
					} else {
						pdic[vo.player_id] = vo
					}
				}
			}
			if (!total_damage) { return list }
			for (let player_id in dic) {

				let vo = dic[player_id]
				//1自己有协助者 2自己没协助者 3有协助但不同类型 4没协助
				if (vo.assist_id > 0 && addic[vo.player_id]) {
					let damage = vo.damage + addic[vo.player_id].damage
					let ddata = { player_name: vo.player_name, damage: damage }
					table.insert(list, ddata)
					delete addic[vo.player_id] 	//添加到所属的求助者的伤害数据中后要删掉
				} else if (vo.assist_id > 0 && pdic[vo.player_id]) {
					table.insert(list, vo)
				} else if (vo.assist_id > 0 && adic && !adic[vo.assist_id]) {
					table.insert(list, vo)
				} else if (vo.assist_id == 0) {
					table.insert(list, vo)
				}
			}
			//防止漏掉
			for (let player_id in addic) {

				let addata = addic[player_id]
				let aVo = adic[addata.vo.assist_id]
				aVo.damage = addata.damage
				table.insert(list, aVo)
			}
			table.sort(list, (a?, b?) => {
				return a.damage > b.damage
			})

			let index = 1
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (!vo.damage || vo.damage == 0) {
					vo.modulus = 0
				} else {
					let price = Math.floor((vo.damage * 100 / total_damage) * 100)
					vo.modulus = price / 100//Number(string.format("%.2f", vo.damage * 100 / total_damage))
					//vo.modulus = Number(string.format("%.2f", vo.damage * 100 / total_damage))
				}
				vo.rank = index
				if (vo.player_id == role_id) {
					this.mine_vo = vo
				}
				index = index + 1
			}
			GlobalEventSystem.Fire(EventName.UPDATE_ASSIST_DAMAGE, adr_list, total_damage)
		}
		return list
	}
	public UpdateScrollItem() {

		if (!this.item_loop_mgr) {
			this.item_loop_mgr = new LoopScrowViewMgr()
			this.item_loop_mgr.SetData(this._list_item, BossDamageSubItem, this.GetDamageList(), LoopScrCon.Vertical)
		} else {
			this.item_loop_mgr.replaceAll(this.GetDamageList())
		}
		this._html_tips.visible = false
		if (SceneManager.GetInstance().IsFieldBossScene()) {
			this._box_mine.visible = false
			let monster_list = Scene.GetInstance().FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 2000, null, null, null)[0]
			this._img_bg3.visible=this._html_tips.visible =true
			this._img_bg3.height = 48
			let color = '"#eee661"'
			if (monster_list && monster_list.length > 0) {
				let id = monster_list[0] && monster_list[0].vo.type_id
				let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
				let boss_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, id, false, cfgs)
				let hurt_limit = boss_cfg && boss_cfg.hurt_limit
				if (hurt_limit) {
						this._html_tips.innerHTML = `造成伤害达${HtmlColorTxt(hurt_limit+"%",color)}的玩家每人<br>可获得一份${HtmlColorTxt("完整的归属奖励",color)}`
				}
			}else{
				this._html_tips.innerHTML = `造成一定伤害的玩家每人可<br>以获得一份${HtmlColorTxt("完整的归属奖励",color)}`
			}
		}
		else if (this.mine_vo) {
			this._img_bg3.visible = true
			this._box_mine.visible = true

			this._img_bg3.height = 36
			this._img_rank.visible = this.mine_vo.rank <= 3
			this._lb_rank.visible = this.mine_vo.rank > 3

			if (this.mine_vo.rank <= 3) {
				let str = this.mine_vo.rank > 2 && "uizdpz_0" || "uizdpz_00"
				ResManager.GetInstance().SetImageSprite(this, this._img_rank, "boss_asset", str + (7 + this.mine_vo.rank))
			} else {
				this._lb_rank.text = this.mine_vo.rank
			}
			this._lb_name.text = this.mine_vo.player_name
			this._lb_damage.text = this.mine_vo.modulus + "%"
		} else {
			this._box_mine.visible = false
			this._img_bg3.visible = false
		}
	}

	public SetHelpStatus(bool?) {
		this.is_show_help_ = bool
		if (this.is_loaded) {
			this.need_fresh_ = false
			this.help_cache = bool
			
			if (SceneManager.GetInstance().IsFieldInfiniteBossScene()) {
				//世界boss无限层不显示协助
				this._box_help.visible = this._box_intro.visible = false
			} else {
				if (bool && this.guild_model.IsCanOpenAssist()) {
					bool = true
				} else {
					bool = false
				}
	
				this._box_help.visible = this._box_intro.visible = bool
			}


		}
		else {
			this.need_fresh_ = true
		}

	}

	public SetBossData(data?) {

		this.boss_data = data
	}

	public SetBossType(boss_type?) {

		this.boss_type = boss_type
	}

	private GetAssistType(){


		if(SceneManager.GetInstance().IsFieldBossScene()){
			return GuildAssistType.TYPE_FIELD_BOSS
		}

		if(SceneManager.GetInstance().IsHolyBossScene()){
			return GuildAssistType.TYPE_HOLY_BOSS
		}

		return ""
	}

	public DeleteMe() {

		if (this.boss_damage_dic_) {
			this.boss_damage_dic_ = null
		}
		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = null
		}
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_list_item: Laya.List
	_img_arrow: Laya.Image
	_lb_title: Laya.Label
	_html_tips: Laya.HTMLDivElement
	_box_mine: Laya.Box
	_img_rank: Laya.Image
	_lb_rank: Laya.Label
	_lb_name: Laya.Label
	_lb_damage: Laya.Label
	_box_intro: Laya.Box
	_img_intro: Laya.Image
	_lb_intro: Laya.Label
	_box_help: Laya.Box
	_img_help: Laya.Image
	_lb_help: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._list_item,
			this._img_arrow,
			this._lb_title,
			this._html_tips,
			this._box_mine,
			this._img_rank,
			this._lb_rank,
			this._lb_name,
			this._lb_damage,
			this._box_intro,
			this._img_intro,
			this._lb_intro,
			this._box_help,
			this._img_help,
			this._lb_help,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_list_item",
				"_img_arrow",
				"_lb_title",
				"_html_tips",
				"_box_mine",
				"_img_rank",
				"_lb_rank",
				"_lb_name",
				"_lb_damage",
				"_box_intro",
				"_img_intro",
				"_lb_intro",
				"_box_help",
				"_img_help",
				"_lb_help",
			])
	}
}

window["BossDamageItem"] = BossDamageItem