
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-04-22 16.55:00
////////////////////////////////////////////////////////////////////-

import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { ResManager } from "../common/ResManager"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SnatchTreasureModel } from "../commonModel/SnatchTreasureModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class SnatchTreasureIntegralItem
export class SnatchTreasureIntegralItem extends BaseItemRenderer {

	_model
	have_guild
	is_own_guild
	public static width = 319
	public static height = 35
	WIDTH = 165
	HEIGT = 525

	public constructor(parent) {
		super()

		this.base_file = "snatchTreasure"
		this.layout_file = "SnatchTreasureIntegralItem"
		this._model = SnatchTreasureModel.GetInstance()
		this.load_callback = () => {
			Util.AddClickEvent(this.btn, () => {
				if (!this.HaveMineGuild()) {
					if (GuildModel.IsHasGuild()) {
						Message.show("您当前已有所属结社")
						return
					}
					if(!this.data) return
					GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40002, "l", this.data.guild_id)
				}
				else {
					let base_window = BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT
					base_window.SetSelectIndex(1)
					HolyTerritoryModel.GetInstance().Fire(HTEvent.OPEN_VIEW, "HolyTerritoryMapView", this.data.dunid)
				}
			}, true)
			//ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("snatchTreasure", "uisydb_003"), true)
			//ResManager.GetInstance().SetImageSpriteTrans(this, this._img_select, GameResPath.GetIcon("snatchTreasure", "uisydb_004"), true)
		}
		this.Load()
	}


	public dataChanged() {

		if (super.dataChanged()) {
			let data = this.data
			let territory_kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_territory_kv", false)
			this.have_guild = data.guild_id != 0
			this.btn.visible = data.guild_id != 0
			this.is_own_guild = this.have_guild && RoleManager.GetInstance().GetMainRoleVo().guild_id == data.guild_id
			this.have.visible = this.have_guild
			this.none.visible = !this.have_guild
			this._img_select.visible = this.is_own_guild
			if (this.HaveMineGuild()) {
				this.btn_text.text = this.is_own_guild ? "守卫" : "争夺"
			}
			else {
				this.btn_text.text = "申请加入"
			}
			if (this.have_guild) {
				this.guild_name.text = `[${data.guild_name}]`
				this.score.text = data.score
				let score_num = Number(data.score)
				let cfg = this._model.getKvConfig(1, territory_kv_cfg)
				let list = (cfg && (JSON.parse(cfg.value)) || ({}))
				let point = 0
				for (const key in list) {
					let value = list[key]
					let min = Number(value[0])
					let max = Number(value[1])
					if (score_num >= min && score_num <= max) {
						point = this._model.getPoint(value[2], territory_kv_cfg)
						break
					}
					point = this._model.getPoint(value[2], territory_kv_cfg)
				}
				this.point.text = `${String(point)}%`
				this.progress.height = (score_num / 3000) * 245

			}
			else {
				this.progress.height = 0

			}
			let dunid = data.dunid
			let source = ""
			switch (dunid) {
				case 1:
					source = this.is_own_guild ? "uisy_039c" : "uisy_039f"
					break;

				case 2:
					source = this.is_own_guild ? "uisy_039a" : "uisy_039d"
					break;
				case 3:
					source = this.is_own_guild ? "uisy_039b" : "uisy_039e"
					break;
			}
			ResManager.GetInstance().SetImageSprite(this, this.holy_icon, "snatchTreasure", source)
			let parent = <Laya.HBox>this.guild_name.parent
			parent.refresh()
			parent = <Laya.HBox>this.score.parent
			parent.refresh()
			parent = <Laya.HBox>this.point.parent
			parent.refresh()




			// let select = false
			// if (this.data && !Util.IsTableEmpty(this.data)) {
			// 	let min = Number(this.data[0])
			// 	let max = Number(this.data[1])
			// 	let point = this._model.getPoint(this.data[2], territory_kv_cfg)
			// 	this._lb.text = min + ("-") + max + "积分，奖励*" + point + "%"
			// 	let score = this._model._dunData.territory_score
			// 	select = (score >= min && score <= max) && this._model._dunData.have_territory == 1
			// } else {
			// 	let point = this._model.getPoint(37004, territory_kv_cfg)
			// 	this._lb.text = "无领地玩家，奖励*" + point + "%"
			// 	select = this._model._dunData.have_territory != 1
			// }
			// this._img_select.visible = select
			// // [ts2lua]lua中0和空字符串也是true，此处select需要确认
			// this._lb.color = select ? "#0a953e" : "#663915"
		}

	}
	public HaveMineGuild() {
		let dungeon_data = this._model._dunData
		if (dungeon_data) {
			let list = dungeon_data.belong_list
			let have_mine_guild = false
			for (let key in list) {
				let v = list[key]
				if (v.guild_id == RoleManager.GetInstance().GetMainRoleVo().guild_id && v.guild_id != 0) {
					have_mine_guild = true
					break
				}
			}
			return have_mine_guild
		}
	}


	_Image1: Laya.Image
	_img_select: Laya.Image
	progress: Laya.Image
	holy_icon: Laya.Image
	btn: Laya.Box
	btn_text: Laya.Label
	have: Laya.Box
	guild_name: Laya.Label
	score: Laya.Label
	point: Laya.Label
	none: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._img_select,
			this.progress,
			this.holy_icon,
			this.btn,
			this.btn_text,
			this.have,
			this.guild_name,
			this.score,
			this.point,
			this.none,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_select",
				"progress",
				"holy_icon",
				"btn",
				"btn_text",
				"have",
				"guild_name",
				"score",
				"point",
				"none",
			])
	}
}
window["SnatchTreasureIntegralItem"] = SnatchTreasureIntegralItem