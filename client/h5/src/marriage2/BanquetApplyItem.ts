
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: AuthorName
// Date: 2020-04-14 20.58:00
////////////////////////////////////////////////////////////////////-

import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class BanquetApplyItem
export class BanquetApplyItem extends BaseItemRenderer {

	public WIDTH = 360;
	public HEIGT = 66;

	public constructor(parent) {
		super()

		this.base_file = "marriage2"
		this.layout_file = "BanquetApplyItem"
		this.load_callback = () => {
			Util.AddClickEvent(this.applyBtn, () => {
				if (this.data) {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "ChoseBanquetView", this.data.day, this.data.time_id)
					// BanquetModel.GetInstance().Fire(BanqEvent.OPEN_VIEW, "ChoseBanquetView", this.data.day, this.data.time_id)
				}
			}
				, this, true)
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("marriage2", "uijh_146"))

		}
		this.Load();

	}

	public dataChanged() {
		if (!super.dataChanged()) return;

		if (this.data) {
			let begin_time = JSON.parse(this.data.begin_time);
			let end_time = JSON.parse(this.data.end_time);
			// this.timeLabel.text = begin_time[0] + ":" + (begin_time[1] == "0" && "00" || begin_time[1]) + "~" + end_time[0] + ":" + (end_time[1] == "0" && "00" || end_time[1])
			this.timeLabel.text = `${begin_time[0]}:${begin_time[1] == "0" ? "00" : begin_time[1]}~${end_time[0]}:${end_time[1] == "0" ? "00" : end_time[1]}`;
			let time = this.data.time
			let orderList = this.data.order_list
			if (orderList && orderList[0]) {
				let color = "#c748e1"
				if (orderList[0].wedding_type == 2) {
					color = "#ff4200"
				} else if (orderList[0].wedding_type == 3) {
					color = "#60aeff"
				}
				let wedding_info_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_wedding_info", false)
				// [ts2lua]wedding_info_cfg下标访问可能不正确
				this.banLabel.color = color;
				this.banLabel.text = wedding_info_cfg[orderList[0].wedding_type].wedding_name;//`${Util.HtmlColorTxt(wedding_info_cfg[orderList[0].wedding_type].wedding_name, color)}`;//Util.StrToHTML("<font color=" + color + ">" + wedding_info_cfg[orderList[0].wedding_type].wedding_name + "</font>"
				this.applyBtn.visible = false
				let roleId = RoleManager.GetInstance().GetMainRoleId()
				if (orderList[0].role_id_m == roleId || orderList[0].role_id_w == roleId) {
					this.statusLabel.text = `我的预约`
					this.statusLabel.color = "#663915";

				} else {
					this.statusLabel.color = "#d6505c";
					this.statusLabel.text = `已被预约`
				}
			} else {
				this.banLabel.color = "#663915";
				this.banLabel.text = "暂无"
				let future_time = TimeUtil.GetFutureZeroStamp(this.data.day)
				let _time = future_time + Number(begin_time[0]) * 3600 + Number(begin_time[1]) * 60
				let cur_time = TimeUtil.getServerTime()
				if (cur_time > _time) {
					this.applyBtn.visible = false
					this.statusLabel.text = `已过期`
					this.statusLabel.color = "#d6505c";

				} else {
					this.applyBtn.visible = true
					this.statusLabel.text = ""
				}
			}
			this.banLabel.width = 100;
		}
	}



	_Group1: Laya.Box
	_Image1: Laya.Image
	timeLabel: Laya.Label
	banLabel: Laya.Text
	statusLabel: Laya.Label
	applyBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	Content11: Laya.List
	public GetComponents() {
		[
			this._Group1,
			this._Image1,
			this.timeLabel,
			this.banLabel,
			this.statusLabel,
			this.applyBtn,
			this._Image11,
			this.labelDisplay,
			this.Content11,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_Image1",
				"timeLabel",
				"banLabel",
				"statusLabel",
				"applyBtn",
				"_Image11",
				"labelDisplay",
				"Content11",
			])
	}
}
window["BanquetApplyItem"] = BanquetApplyItem