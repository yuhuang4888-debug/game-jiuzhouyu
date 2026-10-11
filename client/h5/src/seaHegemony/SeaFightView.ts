import { BaseItem1 } from "../common/BaseItem1"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GoodsModel } from "../commonModel/GoodsModel"

export class SeaFightView extends BaseItem1 {
	Dispose
	InitView
	cfg_sea
	res_mgr

	public constructor(parent?) {
		super(parent)
		this.base_file = "seaHegemony"
		this.layout_file = "SeaFightView"
		this.preload_client_config = {
			"ClientSeaHegemony": false
		}

		this.res_mgr = ResManager.GetInstance()
		let local_model = SeaHegemonyModel
		let local_modelIns = local_model.GetInstance()
		let rewardList = null

		this.load_callback = () => {
			this._Scroller1.hScrollBarSkin=""
			this.cfg_sea = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientSeaHegemony", true)
			SetHtmlStyle(this.tipsLb,{f:18,c:"#cecde2",ww:false})
			SetHtmlStyle(this.timeLb,{f:18,c:"#cecde2",ww:false})
			SetHtmlStyle(this.statusLb,{f:18,c:"#ffffff",ww:false})
			this.res_mgr.SetOutsideImageSprite(this, this.bg1, GameResPath.GetIconOtherPath("seaHegemony","ui_shzb_030"))
			ResManager.GetInstance().SetImageSprite(this,this._Image2,"country","ui_shzb_013")

			this.InitView()
		}

		this.Dispose = () => {
			if (rewardList) {
				for (let _tmpi in rewardList) {
					let vo = rewardList[_tmpi]
					vo.DeleteMe()
				}
				rewardList = null
			}
		}

		this.InitView = () => {
			Util.AddClickEvent(this.goBtn, () => {
				let camp = local_modelIns.seaHegemonyData.camp
				if (camp) {
					local_modelIns.Fire(local_model.REQUEST_PROTO, 18613, "i", 49000 + camp)
				}
			}, this, true)

			Util.AddClickEvent(this.rewardBtn, () => {
				local_modelIns.Fire(local_model.OPEN_VIEW, "SeaReawrdPreView", 1)
			}, this, true)

			Util.AddClickEvent(this.guildBtn, () => {
				let camp = local_modelIns.seaHegemonyData.camp
				local_modelIns.Fire(local_model.OPEN_VIEW, "SeaFightGuildView", camp || 1)
			}, this, true)

			this.BindEvent(local_modelIns, local_model.START_DATA, () => {
				if (this.use_delete_method) {
					return
				}
				this.activeRed.visible = local_modelIns.nomalActiveRed
			})

			this.activeRed.visible = local_modelIns.nomalActiveRed
			let startData = local_modelIns.StartInfo
			if (startData) {
				let time_open=startData.start_time !=0&& startData.start_time < TimeUtil.getServerTime() && TimeUtil.getServerTime() < startData.end_time
				if (startData.act_type == 1&& time_open) {
					this.statusLb.innerHTML = Util.StrToHTML("争夺状态:<font color='#ffeba4'>进行中</font>")
					this.timeLb.innerHTML = Util.StrToHTML("海王争夺时间:<font color='#a0ff67'>进行中</font>")
				} else {
					let str = null
					if (local_modelIns.hasFight) {
						str = "反击战"
					} else {
						str = "争夺战"
					}
					this.statusLb.innerHTML = Util.StrToHTML("争夺状态:<font color='#ffeba4'>" + str + "</font>")
					let time = local_modelIns.activeStartTime[1]
					if (time) {
						let time_str = TimeUtil.timeConversion(time.start_time, "")
						this.timeLb.innerHTML =`海王争夺时间:${HtmlColorTxt(time_str,"'#a0ff67'")}`
					}
				}
			}

			
			if (this.cfg_sea) {
				rewardList = []
				let rewardData = this.cfg_sea.showSeaFightReward
				this.Content.x=(this._Scroller1.width-(rewardData.length*90+(rewardData.length-1)*this.Content.space))/2
				let i = 0
				do {
					let vo = rewardData[i]
					let item = new BaseAwardItem(this.Content)
					item.Load()
					let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
					item.SetData(type_id, vo[2])
					rewardList[i] = item
					item.SetItemSize(90, 90)
					i = i + 1
				} while ((i < rewardData.length))
			}
			this.tipsLb.innerHTML = Util.StrToHTML("当前海域结社战力<font color='#a0ff67'>排名前4</font>的结社可参加玩法")
		}
	}

	public DeleteMe() {
		this.Dispose()
		super.DeleteMe()
	}


bg1:Laya.Image
_Image1:Laya.Image
rewardBtn:Laya.Image
guildBtn:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_Image5:Laya.Image
_Scroller1:Laya.Panel
Content:Laya.HBox
goBtn:Laya.Box
_Image11:Laya.Image
labelDisplay:Laya.Label
activeRed:Laya.Image
statusLb:Laya.HTMLDivElement
timeLb:Laya.HTMLDivElement
tipsLb:Laya.HTMLDivElement
titleLb:Laya.Label
public GetComponents() {
[
this.bg1,
this._Image1,
this.rewardBtn,
this.guildBtn,
this._Image2,
this._Image3,
this._Image5,
this._Scroller1,
this.Content,
this.goBtn,
this._Image11,
this.labelDisplay,
this.activeRed,
this.statusLb,
this.timeLb,
this.tipsLb,
this.titleLb,
]
 = this.GetChildrenByNames([

"bg1",
"_Image1",
"rewardBtn",
"guildBtn",
"_Image2",
"_Image3",
"_Image5",
"_Scroller1",
"Content",
"goBtn",
"_Image11",
"labelDisplay",
"activeRed",
"statusLb",
"timeLb",
"tipsLb",
"titleLb",
])
}
}
 window["SeaFightView"]= SeaFightView