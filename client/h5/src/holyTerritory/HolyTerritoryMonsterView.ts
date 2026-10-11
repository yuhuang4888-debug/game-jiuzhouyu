import { BaseView1, OpenMode } from "../common/BaseView1"
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { RoleManager } from "../commonModel/RoleManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { EquipmentItem } from "../common/EquipmentItem"
import { holyTerritoryRecordRenderer } from "./holyTerritoryRecordRenderer"
import { Config } from "../common/Config"
import { BossModel } from "../commonModel/BossModel"
export class HolyTerritoryMonsterView extends BaseView1 {
	CloseFunc
	InitEvent
	InitView
	Local_Open
	SelectIndex
	SetRemind
	change_scene_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	loop_mgr
	recordScroller
	show_open_movie
	use_background

	public constructor() {
		super()

		let model = HolyTerritoryModel.GetInstance()
		let local_Util = Util
		let local_HTEvent = HTEvent
		let boss_base_model = BossModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()

		let local_Config = Config
		let recordArr_ = null
		let rewardList_ = null
		let bossId_ = null
		let htId_ = null
		let remind_ = null
		let index_ = 0
		let mon_type_ = null
		let hasData_ = false
		this.base_file = "holyTerritory"
		this.layout_file = "HolyTerritoryMonsterView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true

		this.is_center = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.preload_server_config = {
			"config_boss_cfg": false
		}
		this.load_callback = () => {
			this.rewardScroller.hScrollBar.visible = false
			// if (PlatformMgr.GetInstance().IsEyouKrPlatform() ) {
			// 	this._Label1.size  = 16
			// }
			this.InitView()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.CloseFunc()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.dropBtn, () => {
				this.SelectIndex(1)
			}
				, this, true)
			Util.AddClickEvent(this.killBtn, () => {
				this.SelectIndex(2)
			}
				, this, true)
			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.followGroup, () => {
				// [ts2lua]lua中0和空字符串也是true，此处remind_需要确认
				model.Fire(local_HTEvent.REQUEST_PROTO, 28305, "cic", htId_, bossId_, ((remind_ && remind_ != 0) ? 0 : 1))
			}
				, this, true)
			Util.AddClickEvent(this.enterBtn, () => {
				if (bossId_) {
					//let equip_bag_cell = boss_base_model.GetBossKeyValue(bossId_, "min_equip_bag_cell")
					//let god_bag_cell = boss_base_model.GetBossKeyValue(bossId_, "min_god_bag_cell")
					//let enter_func = () => {
					boss_base_model.SetEnterBossInfo({ boss_id: bossId_ })
					model.Fire(local_HTEvent.REQUEST_PROTO, 28303, "c", htId_)
					model.Fire(local_HTEvent.REQUEST_PROTO, 28301, "c", htId_)
					//}

					//goods_model:CheckEquipNum(equip_bag_cell, god_bag_cell, enter_func)
				}
			}
				, this, true)
			this.BindEvent(model, local_HTEvent.UPDATE_FGOLLOW_INFO, (scmd?) => {
				if ((scmd && scmd.sanctuary_id == htId_) && scmd.boss_id == bossId_) {
					remind_ = scmd.remind
					this.SetRemind(scmd.remind)
				}
			}
			)
			this.BindEvent(model, local_HTEvent.KILL_DATA, (scmd?) => {
				if (scmd.boss_id == bossId_ && scmd.sanctuary_id == htId_) {
					this.loop_mgr.replaceAll(scmd.kill_log)
				}
			}
			)
		}

		this.Local_Open = (...new_args) => {
			let parm = new_args
			if (parm) {
				bossId_ = parm[0]
				htId_ = parm[1]
				remind_ = parm[2]
				index_ = parm[3]
				mon_type_ = parm[4]
				if (this.is_loaded) {
					this.InitView()
				}
			}
			super.Open()
		}

		this.InitView = () => {

			this.SelectIndex(1)
			if (!rewardList_) {
				rewardList_ = []
			}
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11, GameResPath.GetIcon("holyTerritory", "com_head_border"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIconOtherPath("holyTerritory", "ui_holyland_24"), true)
			// [ts2lua]cfgs下标访问可能不正确
			let _cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
			let boss_cfgs = _cfg[bossId_]
			let reward = null
			if (boss_cfgs) {
				reward = JSON.parse(boss_cfgs.ratio_goods)
				let career = RoleManager.GetInstance().GetMainRoleVo().career
				let _reward_list = []
				for (let key in reward) {

					// [ts2lua]reward下标访问可能不正确
					let obj = reward[key]
					if (Number(obj[0]) == career) {
						_reward_list = obj[1]
						break
					}
				}
				let i = 0
				if (i < _reward_list.length) {
					do {
						let item = rewardList_[i]
						if (!item) {
							item = new EquipmentItem(this.Content1)
						}
						rewardList_[i] = item
						item.Load()
						item.SetScale(0.65)
						//item:ExcuteCallback(() => {
						let [type_id, lock] = goods_model.GetMappingTypeId(_reward_list[i][0], _reward_list[i][1])
						let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
						item.SetData(type_id, _reward_list[i][2])
						//}
						//)
						i = i + 1
					} while ((i < _reward_list.length))
				}
			}
			// [ts2lua]model.killData下标访问可能不正确
			let sou = model.killData[htId_ + "@" + bossId_] || {}


			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this.Content, holyTerritoryRecordRenderer, sou, LoopScrCon.Vertical, 1)


			this.SetRemind(remind_)
			let data = bossId_
			let boss_info = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, data, false)
			let score = model.GetScore(mon_type_, htId_, boss_info) || ""
			this.desLabel.style.fontSize = 20
			this.desLabel.style.valign = "left"
			this.desLabel.style.color = "#663915"
			this.desLabel.width = 500
			this.desLabel.style.bold = true
			this.desLabel.style.leading = 5
			this.desLabel.innerHTML = Util.StrToHTML("<font color='#b94a00'>" + boss_info.name + "</font>" + "<br/>" + score)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.headImg, GameResPath.GetMonsterHeadPath(boss_info.icon))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.BG, GameResPath.GetIcon("holyTerritory", "uisy_053"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.dropBG, GameResPath.GetIcon("holyTerritory", "uisy_054"), true)
		}

		this.SelectIndex = (index?) => {
			this.dropGroup.visible = (index == 1)
			this.killGroup.visible = (index != 1)
			if (!hasData_ && index == 2) {
				model.Fire(local_HTEvent.REQUEST_PROTO, 28311, "ci", htId_, bossId_)
				hasData_ = true
			}
		}

		this.SetRemind = (bool?) => {
			bool = bool && bool != 0
			// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
			this.followImg.visible = bool
			// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
			this.unfollowImg.visible = !bool
		}

		this.CloseFunc = () => {
			if (rewardList_) {
				for (let index in rewardList_) {

					// [ts2lua]rewardList_下标访问可能不正确
					if (rewardList_[index]) {
						// [ts2lua]rewardList_下标访问可能不正确
						rewardList_[index].DeleteMe()
						// [ts2lua]rewardList_下标访问可能不正确
						rewardList_[index] = null
					}
				}
				rewardList_ = null
			}
			hasData_ = false
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}


	}

	public Open(...new_args) {

		this.Local_Open(...new_args)

	}




	BG: Laya.Image
	_Image11: Laya.Image
	headImg: Laya.Image
	closeBtn: Laya.Image
	headGroup: Laya.Box
	desLabel: Laya.HTMLDivElement
	dropGroup: Laya.Box
	dropBG: Laya.Image
	_Image2: Laya.Image
	enterBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	followGroup: Laya.Box
	unfollowImg: Laya.Image
	followImg: Laya.Image
	_Label1: Laya.Label
	rewardScroller: Laya.Panel
	Content1: Laya.HBox
	UnopenLabel: Laya.Label
	killBtn: Laya.Image
	killGroup: Laya.Box
	_Image3: Laya.Image
	dropBtn: Laya.Image
	Content: Laya.List
	bg1: Laya.Image
	public GetComponents() {
		[
			this.BG,
			this._Image11,
			this.headImg,
			this.closeBtn,
			this.headGroup,
			this.desLabel,
			this.dropGroup,
			this.dropBG,
			this._Image2,
			this.enterBtn,
			this._Image1,
			this.labelDisplay,
			this.followGroup,
			this.unfollowImg,
			this.followImg,
			this._Label1,
			this.rewardScroller,
			this.Content1,
			this.UnopenLabel,
			this.killBtn,
			this.killGroup,
			this._Image3,
			this.dropBtn,
			this.Content,
			this.bg1
		]
			= this.GetChildrenByNames([

				"BG",
				"_Image11",
				"headImg",
				"closeBtn",
				"headGroup",
				"desLabel",
				"dropGroup",
				"dropBG",
				"_Image2",
				"enterBtn",
				"_Image1",
				"labelDisplay",
				"followGroup",
				"unfollowImg",
				"followImg",
				"_Label1",
				"rewardScroller",
				"Content1",
				"UnopenLabel",
				"killBtn",
				"killGroup",
				"_Image3",
				"dropBtn",
				"Content",
				"bg1"
			])
	}
}
window["HolyTerritoryMonsterView"] = HolyTerritoryMonsterView