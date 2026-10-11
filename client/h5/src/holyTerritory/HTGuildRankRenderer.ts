
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-04-21 10.38:46
////////////////////////////////////////////////////////////////////-

import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ColorUtil } from "../util/ColorUtil"
// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class HTGuildRankRenderer

export class HTGuildRankRenderer extends BaseItemRenderer {
	public WIDTH = 660
	public HEIGT = 42
	is_set = false
	public constructor(parent) {
		super()

		this.base_file = "holyTerritory"
		this.layout_file = "HTGuildRankRenderer"
		this.load_callback = () => {
			if (!this.is_set) {
				this.Setdata()
				this.is_set = true
			}
		}
		this.Load()
	}

	Setdata() {
		if (this.data) {
			if (this.data.rank > 3) {
				this.topImg.visible = false
				this.rankLabel.text = this.data.rank
			} else {
				this.topImg.visible = true
				this.rankLabel.text = ""
			}
			this.nameLabel.text = this.data.guild_name
			this.chiefLabel.text = this.data.guild_chairman_name
			this.memberLabel.text = this.data.menber_num + "/" + this.data.all_num
			this.fightLabel.text = this.data.top_power && (this.data.top_power + (" + ")) || this.data.avg_power
			// [ts2lua]lua中0和空字符串也是true，此处this.data.this需要确认
			let color = ColorUtil.TryParseHtmlString(this.data.this && "#0a953e" || "#763320")
			let color2 = ColorUtil.TryParseHtmlString(this.data.this && "#0a953e" || "#d15e00")
			this.chiefLabel.color = color
			this.memberLabel.color = color
			this.fightLabel.color = color2
			this.nameLabel.color = color
			this.rankLabel.color = color
		}
	}
	public dataChanged() {
		if (super.dataChanged()) {
			if (this.is_loaded) {
				this.is_set = true
				this.Setdata()
			} else {
				this.is_set = false
			}
		}
	}

	_Group1: Laya.Box
	_Image1: Laya.Image
	topImg: Laya.Image
	rankLabel: Laya.Label
	nameLabel: Laya.Label
	chiefLabel: Laya.Label
	memberLabel: Laya.Label
	fightLabel: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this._Image1,
			this.topImg,
			this.rankLabel,
			this.nameLabel,
			this.chiefLabel,
			this.memberLabel,
			this.fightLabel,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_Image1",
				"topImg",
				"rankLabel",
				"nameLabel",
				"chiefLabel",
				"memberLabel",
				"fightLabel",
			])
	}
}
window["HTGuildRankRenderer"] = HTGuildRankRenderer