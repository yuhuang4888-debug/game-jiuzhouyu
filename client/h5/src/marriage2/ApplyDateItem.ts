
////////////////////////////////////////////////////////////////////-

import { PlatformManager } from "../PlatformManager"
import { TimeUtil } from "../util/TimeUtil"
import { BaseItemRenderer } from "../common/BaseItemRenderer"

// u3d (C) CompanyName, All Rights Reserved

// Created by: AuthorName

// Date: 2020-04-14 20.58:32

////////////////////////////////////////////////////////////////////-



// To edit this template in: Data/Config/Template.lua

// To disable this template, check off menuitem: Options-Enable Template File



//-@class ApplyDateItem

export class ApplyDateItem extends BaseItemRenderer {


	public WIDTH: number = 184
	public HEIGT: number = 54
	public constructor(parent) {
		super()

		this.base_file = "marriage2"
		this.layout_file = "ApplyDateItem"
		this.load_callback = () => {
			// if (PlatformManager.IsEyouEnPlatform()) {

			// 	SetAnchoredPositionX(this.dateLabel, 105)

			// }

		}
		this.Load();
	}



	public dataChanged() {
		if (!super.dataChanged()) return;
		let date = new Date(this.data.time)
		this.select.visible = this.selected;

		//this.week.source = "marriage2_asset.uijh_138" + date.getDay() + ""

		// ResManager.GetInstance().SetImageSprite(this, this.week, "marriage2_asset", "uijh_138" + date.getDay(), true);


		if (PlatformManager.IsEyouEnPlatform()) {
			this.dateLabel.text = TimeUtil.WeekNumToFont(date.getMonth() + 1) + " " + date.getDate()
		} else {
			// this.dateLabel.text = (date.getMonth() + 1) + "月" + date.getDate() + "日" + TimeUtil.WeekNumToFont(date.getMonth() + 1);
			let day = date.getDay() == 0 ? 7 : date.getDay();
			this.dateLabel.text = `${(date.getMonth() + 1)}月${date.getDate()}日 (周${TimeUtil.WeekNumToFont(day)})`;
		}

	}
	_Group1: Laya.Box
	_Image1: Laya.Image
	select: Laya.Image
	week: Laya.Image
	dateLabel: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this._Image1,
			this.select,
			this.week,
			this.dateLabel,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_Image1",
				"select",
				"week",
				"dateLabel",
			])
	}
}
window["ApplyDateItem"] = ApplyDateItem