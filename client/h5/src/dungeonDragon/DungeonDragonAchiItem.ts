import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DungeonDragonRewardItem } from "./DungeonDragonRewardItem"

export class DungeonDragonAchiItem extends BaseItemRenderer {
	array_reward
	vhscroll

	public WIDTH = 610
	public HEIGT = 120
	public constructor(parent) {
		super()

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonAchiItem"

		this.load_callback = () => {
			this.load_callback1()
		}
		this.Load()
	}

	public load_callback1() {


		//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("dungeonDragon", "uilwfb_029"), true)
		

		Util.AddClickEvent(this._img_check, () => {
			if(this.data){
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonDragonRecordView", this.data.dun_id, this.data.wave)
			}
			
		}
			, this, true)
		Util.AddClickEvent(this._gp_get, () => {
			if(this.data){
				if (0 == this.data.state) {
					BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61054, this.data.dun_id, this.data.wave)
				} else if (1 == this.data.state) {
					Message.show("条件不足")
				} else if (2 == this.data.state) {
					Message.show("已领取")
				}
			}
			
		}
			, this, true)
	}

	public dataChanged() {
		if(!super.dataChanged())return
		let data = this.data
		this._lb_wave.text = "第" + data.wave + "波"
		this._img_get_red.visible = data.state == 0
		Util.SetImageGray(this._gp_get, data.state == 2)
		if (0 == this.data.state) {
			this._lb_get.text = "领取"
		} else if (1 == this.data.state) {
			this._lb_get.text = "未达到"
		} else if (2 == this.data.state) {
			this._lb_get.text = "已领取"
		}
		let list = []
		for (let _tmpi in data.reward) {
			var vo = data.reward[_tmpi]
			table.insert(list, { size: 78, vo: { style: vo[0], typeId: vo[1], count: vo[2] } })
		}

		if(!this.array_reward ){
			this.array_reward = new LoopScrowViewMgr()
			this.array_reward.SetData(this.Content, DungeonDragonRewardItem, list, LoopScrCon.Horizontal)
		}else{
			this.array_reward.replaceAll(list)
		}
		
	}

	public DeleteMe() {

		if (this.array_reward) {
			this.array_reward.DeleteMe()
			this.array_reward = null
		}
		super.DeleteMe()
	}



_Image1:Laya.Image
_gp_get:Laya.Box
_Image2:Laya.Image
_lb_get:Laya.Label
_img_get_red:Laya.Image
_img_check:Laya.Box
_Image22:Laya.Image
_lb_get2:Laya.Label
_lb_wave:Laya.Label
Content:Laya.List
public GetComponents() {
[
this._Image1,
this._gp_get,
this._Image2,
this._lb_get,
this._img_get_red,
this._img_check,
this._Image22,
this._lb_get2,
this._lb_wave,
this.Content,
]
 = this.GetChildrenByNames([

"_Image1",
"_gp_get",
"_Image2",
"_lb_get",
"_img_get_red",
"_img_check",
"_Image22",
"_lb_get2",
"_lb_wave",
"Content",
])
}
}
 window["DungeonDragonAchiItem"]= DungeonDragonAchiItem