
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-04-21 10.39:43
////////////////////////////////////////////////////////////////////-

import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class holyTerritoryRecordRenderer
export class holyTerritoryRecordRenderer extends BaseItemRenderer {
	public static width = 443
	public static height = 44
	WIDTH = 443
	HEIGT = 44
	is_set = false
	public constructor(parent) {
		super()


		this.base_file = "holyTerritory"
		this.layout_file = "holyTerritoryRecordRenderer"
		this.load_callback = () => {

			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("holyTerritory", "uisy_060"), true)
			if (!this.is_set) {
				this.Setdata()
				this.is_set = true
			}
		}
		this.Load()
	}

	Setdata() {
		if (this.data) {
			let time = TimeUtil.timeConversion(this.data.time, "hh:MM:ss")
			// [ts2lua]lua中0和空字符串也是true，此处this.data.is_show需要确认
			this.recordLabel.style.fontSize = 18
			this.recordLabel.style.valign = "center"
			this.recordLabel.style.color = "#663915"
			this.recordLabel.width = 500
			this.recordLabel.style.bold = true
			this.recordLabel.innerHTML = Util.StrToHTML(time + " 被" + this.data.name + "击杀" + ((this.data.is_show && this.data.is_show != 0) && (",减少" + this.data.reduce_point + "异域积分") || ("")) + " ")
		}
	}
	public dataChanged() {
		if (super.dataChanged) {
			if (this.is_loaded) {
				this.is_set = true
				this.Setdata()
			} else {
				this.is_set = false
			}
		}


	}

	_Group1: Laya.Box
	recordLabel: Laya.HTMLDivElement
	_Image1: Laya.Image
	public GetComponents() {
		[
			this._Group1,
			this.recordLabel,
			this._Image1,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"recordLabel",
				"_Image1",
			])
	}
}
window["holyTerritoryRecordRenderer"] = holyTerritoryRecordRenderer