import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Split, Util } from "../util/Util"
import { BaseItemRenderer } from "./BaseItemRenderer"
import { LinkTool } from "./LinkTool"
import { LinkViewType } from "./LinkViewType"
import { OpenFun } from "./OpenFun"
import { ResManager } from "./ResManager"

export class LinkViewItem extends BaseItemRenderer {
	_Image1: Laya.Image
	targetName: Laya.Label
	btn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_Image2: Laya.Image
	icon: Laya.Image
	double: Laya.Image
	double_time: Laya.Label
	timer_
	Empbtn
	InintEvent

	
	OutlabelDisplay
	public static width = 500
	public static height = 86
	WIDTH = 500
	HEIGT = 90
	public constructor(parent) {
		super()

		this.base_file = "common"
		this.layout_file = "LinkViewItem"
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.double, GameResPath.GetIcon("common", "shuangbei"))
			this.InintEvent()
		}

		this.InintEvent = () => {
			Util.AddClickEvent(this.btn, () => {
				if(!this.data) return
				if(this.data.jump_id == 250){
					if(FirstRechargeModel.GetInstance().IsNoFirstRecharge()){
						Message.show("首充后开启周卡购买")
						return
					}
				}
				OpenFun.OpenFunHandler(this.data.jump_id)
				LinkTool.GetInstance().CacheJumpId(LinkTool.GetInstance().open_type, this.data.jump_id)
				LinkTool.GetInstance().CloseLinkView()
			}, this, true)
		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let iconCfg = this.data.icon
			this.icon.visible = !(!iconCfg)
			if (this.icon.visible) {
				if (iconCfg.isOutSide) {
					ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, GameResPath.GetIcon(iconCfg.asset, iconCfg.name), true)//"client/assets/icon/" + iconCfg.asset + "/" + iconCfg.name + "." + iconCfg.format
				} else {
					ResManager.GetInstance().SetImageSprite(this, this.icon, iconCfg.asset + "_asset", iconCfg.name, true)
				}
			}
			let jump_id = this.data.jump_id
			
			if (CustomActivityModel.GetInstance().IsDoubleAct(jump_id)) {
				let end_time = CustomActivityModel.GetInstance().GetDesTinyEndTime()
				let time = end_time - TimeUtil.getServerTime()
				this.StartTimer(time)
			}
			this.double.visible = this.double_time.visible = CustomActivityModel.GetInstance().IsDoubleAct(jump_id)
			if (this.data && this.data._type && this.data._type == LinkViewType.DestinyTurntable) {
				let actData = CustomActivityModel.GetInstance().GetActData(99, 1)
				let iconData = actData.double_point
				for (let i in iconData) {
					let icon = iconData[i]
					if (icon.jump_id == jump_id && icon.is_buy <= 0) {
						this.double.visible = true
					}
				}
			}
			let list = Split(String(this.data.jump_id), "_")
			let title = ""
			if (list.length >= 2) {
				title = OpenFun.ActivityOpenName(this.data.jump_id)
			} else {
				title = OpenFun.OpenName(this.data.jump_id)
			}
			this.targetName.text = title
		}
	}
	public DeleteMe() {
		if (this.timer_) {
			GlobalTimerQuest.CancelQuest(this.timer_)
			this.timer_ = null
		}
		super.DeleteMe()
	}


	public StartTimer(left_time) {

		if (left_time && left_time > 0) {
			if (!this.timer_) {
				let func = () => {
					if (left_time <= 0) {
						GlobalTimerQuest.CancelQuest(this.timer_)
						this.timer_ = null
						return
					}
					this.double_time.text = `双倍剩余时间:${TimeUtil.timeConvert(left_time, "hh-mm-ss")}`
					left_time = left_time - 1
				}
				func()
				this.timer_ = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
			}
		}
	}

	public GetComponents() {
		[
			this._Image1,
			this.targetName,
			this.btn,
			this._Image11,
			this.labelDisplay,
			this._Image2,
			this.icon,
			this.double,
			this.double_time
		]
			= this.GetChildrenByNames([

				"_Image1",
				"targetName",
				"btn",
				"_Image11",
				"labelDisplay",
				"_Image2",
				"icon",
				"double",
				"double_time"
			])
	}
}
window["LinkViewItem"] = LinkViewItem