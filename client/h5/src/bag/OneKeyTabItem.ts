
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-03-25 10.52:39
////////////////////////////////////////////////////////////////////-

import { BaseItem1 } from "../common/BaseItem1"
import { BagModel } from "../commonModel/BagModel"
import { Util } from "../util/Util"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class OneKeyTabItem
export class OneKeyTabItem extends BaseItem1 {
	public _Group1: Laya.Box;
	public Unselect: Laya.Image;
	public Select: Laya.Image;
	public nameLb: Laya.Label;


	SetData
	InitEvent
	SetSelect
	data
	State

	//function OneKeyTabItem.Constructor()
	//}

	public constructor(parent?) {
		super(parent)

		this.base_file = "bag"
		this.layout_file = "OneKeyUseTab"
		this.State = true;
		let bag_model = BagModel.GetInstance()
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.nameLb.size  = 19
			// }
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._Group1, () => {
				this.SetSelect(!this.State)
			}
				, this, false)
		}

		this.SetData = (data?) => {
			if (data) {
				this.data = data
				this.nameLb.text = this.data.name
			}
		}

		this.SetSelect = (bool?) => {
			if (this.data) {
				this.Select.visible = bool
				this.Unselect.visible = !bool
				this.State = bool
				bag_model.SelectTab(bool, this.data.type, this.data.sub_type)
				bag_model.Fire(BagModel.ONE_KEY_TAB, bool, this.data.type, this.data.sub_type)
			}
		}
	}

	public GetComponents() {
		[
			this._Group1,
			this.Unselect,
			this.Select,
			this.nameLb
		] = this.GetChildrenByNames([
			"_Group1",
			"Unselect",
			"Select",
			"nameLb"
		])
	}
}
window["OneKeyTabItem"] = OneKeyTabItem