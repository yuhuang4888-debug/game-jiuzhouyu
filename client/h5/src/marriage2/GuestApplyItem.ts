
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: AuthorName
// Date: 2020-04-15 15.53:07
////////////////////////////////////////////////////////////////////-

import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class inviteRenderer
export class GuestApplyItem extends BaseItemRenderer {
	// _Image1
	// inviteBtn
	// labelDisplay
	// labelDisplay1
	// nameLabel
	// refuseBtn
	public WIDTH = 360
	public HEIGT = 61
	public constructor(parent) {
		super()

		this.base_file = "marriage2"
		this.layout_file = "guestApplyItem"
		this.load_callback = () => {
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("marriage2", "uijh_146"))
			Util.AddClickEvent(this.inviteBtn, () => {
				if (this.data) {
					if (this.data.isAsk) {
						BanquetModel.GetInstance().Fire(BanqEvent.REQUET_ASK, this.data.role_id, 1)
					} else {
						BanquetModel.GetInstance().Fire(BanqEvent.INVITE_GUEST, this.data.role_id)
					}
				}
			}
				, this, true)
			Util.AddClickEvent(this.refuseBtn, () => {
				BanquetModel.GetInstance().Fire(BanqEvent.REQUET_ASK, this.data.role_id, 2)
			}
				, this, true)
		}
		this.Load();
	}

	public dataChanged() {
		if (!super.dataChanged()) return;
		if (this.data.isAsk) {
			this.labelDisplay1.text = "同意"
			this.refuseBtn.visible = true
		} else {
			this.labelDisplay1.text = "邀请"
			this.refuseBtn.visible = false
		}
		this.nameLabel.text = this.data.role_name || this.data.name
	}

	_Group1: Laya.Box
	_Image1: Laya.Image
	nameLabel: Laya.Label
	refuseBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	inviteBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this._Image1,
			this.nameLabel,
			this.refuseBtn,
			this._Image111,
			this.labelDisplay,
			this.inviteBtn,
			this._Image11,
			this.labelDisplay1,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_Image1",
				"nameLabel",
				"refuseBtn",
				"_Image111",
				"labelDisplay",
				"inviteBtn",
				"_Image11",
				"labelDisplay1",
			])
	}
}
window["GuestApplyItem"] = GuestApplyItem