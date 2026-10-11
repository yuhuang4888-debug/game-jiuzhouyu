
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-04-21 10.42:42
////////////////////////////////////////////////////////////////////-

import { BaseItem1 } from "../common/BaseItem1"
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { Util, SetAnchoredPositionY, SetSizeDelta, SetAnchoredPositionX } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalTimerQuest } from "../util/Util"
import { Config } from "../common/Config"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class HTMonsterItem
export class HTMonsterItem extends BaseItem1 {
	data
	htId
	index
	model
	mon_type
	need_refresh
	refresh_data
	refresh_pos
	timerId
	posx
	posy

	public constructor(parent?) {
		super(parent)


		this.model = HolyTerritoryModel.GetInstance();
		this.base_file = "holyTerritory"
		this.layout_file = "HTMonsterItem"
		this.preload_server_config = {
			"config_boss_cfg": false
		}
		this.load_callback = () => {

			if (this.need_refresh) {
				this.SetCfg()
				this.need_refresh = null
			}
			if (this.refresh_data) {
				this.SetData(this.data)
				this.refresh_data = null
			}
			if (this.refresh_pos) {
				this.SetPos(this.posx, this.posy)
				this.refresh_pos = null
			}

			this.InitEvent()
		}
	}

	public InitEvent() {


		Util.AddClickEvent(this.clickGroup, () => {
			if (this.data) {
				this.model.Fire(HTEvent.OPEN_VIEW, "HolyTerritoryMonsterView", this.data.boss_id, this.htId, this.data.is_remind, this.index, this.mon_type)
			}
		}
			, this, true)
		this.BindEvent(this.model, HTEvent.UPDATE_RED, () => {
			this.SetRed()
		}
		)
	}
	public SetPos(x, y) {
		this.posx = x
		this.posy = y
		if (this.is_loaded) {
			this.display_obj.x = x
			this.display_obj.y = y
		}
		else
			this.refresh_pos = true
	}

	public SetCfg(cfg?, index?) {

		if (cfg) {
			this.htId = cfg.sanctuary_id
			this.mon_type = cfg.mon_type
			this.index = index
		}
		if (this.is_loaded) {
			if (this.mon_type == 2) {
				ResManager.GetInstance().SetImageSprite(this, this.headBG, "holyTerritory_asset", "uisy_003aa", true)
				SetAnchoredPositionY(this.headBG, -15)
				SetAnchoredPositionY(this.monsterHead, 0)
				SetAnchoredPositionY(this.peaceGp, 65)
				SetAnchoredPositionY(this.timeLabel, 100)
				SetSizeDelta(this.monsterHead, 71, 71)
				SetSizeDelta(this.clickGroup, 71, 125)
			} else if (this.mon_type == 3) {
				ResManager.GetInstance().SetImageSprite(this, this.headBG, "holyTerritory_asset", "uisy_004aa", true)
				SetAnchoredPositionY(this.headBG, -17)
				SetAnchoredPositionY(this.monsterHead, 0)
				SetAnchoredPositionY(this.peaceGp, -23)
				SetSizeDelta(this.monsterHead, 92, 92)
				SetSizeDelta(this.clickGroup, 92, 155)
				SetAnchoredPositionY(this.timeLabel, 115)
			} else {
				ResManager.GetInstance().SetImageSprite(this, this.headBG, "holyTerritory_asset", "uisy_002aa", true)
				SetAnchoredPositionY(this.headBG, -9)
				SetAnchoredPositionY(this.monsterHead, 0)
				SetAnchoredPositionY(this.peaceGp, 47)
				SetSizeDelta(this.monsterHead, 60, 60)
				SetSizeDelta(this.clickGroup, 60, 100)
				SetAnchoredPositionY(this.timeLabel, 85)
			}
			this.shengzhu_bg.visible = this.mon_type == 3
		} else {
			this.need_refresh = true
		}
	}

	public SetData(data?) {

		this.data = data
		if (this.is_loaded) {
			if (data) {
				this.SetRed()
				this.ClearTimer()
				this.shengzhu_alive.visible = this.mon_type == 3 && data.reborn_time <= 0
				if (data.reborn_time > 0) {
					this.timeLabel.color = ColorUtil.TryParseHtmlString("#FF0000")
					this.timerId = GlobalTimerQuest.AddPeriodQuest(() => {
						this.SetTimeText()
					}, 1, -1)
					this.SetTimeText()
					this.timeLabel.visible = true
					SetAnchoredPositionY(this.nameLabel, -30)
				} else {
					this.nameLabel.color = ColorUtil.TryParseHtmlString("#fffefe")
					this.timeLabel.visible = false
					SetAnchoredPositionY(this.nameLabel, -30)
				}
				let boss_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.boss_id, false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.monsterHead, GameResPath.GetMonsterHeadPath(boss_info.icon))
				this.nameLabel.text = boss_info.name
				// [ts2lua]Config.PRELOAD_SETVER_CONFIG.Bosscfg下标访问可能不正确
				let dsgtCfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dsgt", false)
				let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
				let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, data.boss_id, false, cfgs)
				if (config) {
					if (config && config.sign == 1) {
						this.peaceGp.visible = true
					} else {
						this.peaceGp.visible = false
					}
					let gap = (config && config.sign == 1)?0:(this.mon_type==2?18:10)
					if (this.mon_type == 2) {
						SetAnchoredPositionY(this.timeLabel, 100-gap)
					} else if (this.mon_type == 3) {
						SetAnchoredPositionY(this.timeLabel, 115)
					} else {
						SetAnchoredPositionY(this.timeLabel, 85-gap)
					}
				}

			}
		} else {
			this.refresh_data = true
		}
	}

	public SetTimeText() {


		if (this.data && this.data.reborn_time - TimeUtil.getServerTime() > 0) {
			this.timeLabel.text = TimeUtil.convertTimeColor(this.data.reborn_time - TimeUtil.getServerTime())
			SetAnchoredPositionY(this.nameLabel, -30)
		} else {
			this.ClearTimer()
			this.nameLabel.color = ColorUtil.TryParseHtmlString("#fffefe")
			this.timeLabel.visible = false
			SetAnchoredPositionY(this.nameLabel, -30)
		}
	}

	public ClearTimer() {


		if (this.timerId) {
			this.model.RedFunc()
			GlobalTimerQuest.CancelQuest(this.timerId)
			this.timerId = null
		}
	}

	public DeleteMe() {

		this.ClearTimer()
		super.DeleteMe()
	}

	public SetRed() {
		if (this.data && this.data.boss_id) {
			let monster_red_dir = HolyTerritoryModel.GetInstance().monster_red_dir
			this.red.visible = monster_red_dir[this.data.boss_id] ? true : false
		}

	}


	clickGroup: Laya.Box
	headBG: Laya.Image
	shengzhu_bg: Laya.Image
	monsterHead: Laya.Image
	red: Laya.Image
	nameLabel: Laya.Label
	timeLabel: Laya.Label
	peaceGp: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	shengzhu_alive: Laya.Image
	public GetComponents() {
		[
			this.clickGroup,
			this.headBG,
			this.shengzhu_bg,
			this.monsterHead,
			this.red,
			this.nameLabel,
			this.timeLabel,
			this.peaceGp,
			this._Image1,
			this._Label1,
			this.shengzhu_alive,
		]
			= this.GetChildrenByNames([

				"clickGroup",
				"headBG",
				"shengzhu_bg",
				"monsterHead",
				"red",
				"nameLabel",
				"timeLabel",
				"peaceGp",
				"_Image1",
				"_Label1",
				"shengzhu_alive",
			])
	}
}
window["HTMonsterItem"] = HTMonsterItem