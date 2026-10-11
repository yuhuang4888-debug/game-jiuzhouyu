
////////////////////////////////////////////////////////////////////-

import { BaseItem1 } from "../common/BaseItem1"
import { GetSizeDeltaX, SetSizeDeltaX, Util } from "../util/Util"

// u3d (C) CompanyName, All Rights Reserved

// Created by: AuthorName

// Date: 2020-04-17 19.05:26

////////////////////////////////////////////////////////////////////-



// To edit this template in: Data/Config/Template.lua

// To disable this template, check off menuitem: Options-Enable Template File



//-@class BarrageItem

export class BarrageItem extends BaseItem1 {

	time_out



	public constructor(parent?) {
		super(parent)

		this.base_file = "marriage2"
		this.layout_file = "BarrageItem"
		this.load_callback = () => {
			this.Lb.style.fontSize = 20;
			this.Lb.style.wordWrap = false;
		}
	}


	public SetInfo(info?) {
		this.ClearTime()
		this.Lb.innerHTML = `${Util.HtmlColorTxt(info.name, "'#353c1d'")}:${Util.HtmlColorTxt(info.msg, "'#b94e14'")}`
		this.time_out = setTimeout(() => {
			// LayoutRebuilder(this.Lb)
			let width = GetSizeDeltaX(this.Lb) + 40
			SetSizeDeltaX(this.BG, width)
			// SetSizeDeltaX(this.form, width)
		}, 0.1)

	}
	public ClearTime() {
		if (this.time_out) {
			clearTimeout(this.time_out)
			this.time_out = null
		}
	}

	public DeleteMe() {
		this.ClearTime()
		super.DeleteMe()
	}




	BG: Laya.Image
	Lb: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.BG,
			this.Lb,
		]
			= this.GetChildrenByNames([

				"BG",
				"Lb",
			])
	}
}
window["BarrageItem"] = BarrageItem