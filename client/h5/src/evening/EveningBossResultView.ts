import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildActivityModel } from "../commonModel/GuildActivityModel"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class EveningBossResultView extends BaseView1 {
	UpdateTimer
	_auction_list
	_data
	_fix_list
	_gp_auction
	_gp_fix
	_model
	_time
	_time_id
	destroy_callback
	destroy_imm
	is_center
	use_background


	public constructor() {
		super()

		this._auction_list = [];
		this._fix_list = [];
		this.UpdateTimer = () => {
			let rtime = this._time - TimeUtil.getServerTime()
			if (rtime > 0) {
				this._lb_time.text = `${rtime}秒后自动关闭此界面`
			} else {
				this.Close()
			}
		}
		this.base_file = "evening"
		this.layout_file = "EveningBossResultView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true
		this._model = GuildActivityModel.GetInstance()
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()

			//this.display_obj.pos(0, 237)
		}

		this.destroy_callback = () => {
			this.Clear()
		}
	}

	public Open(parms?) {

		this._data = parms
		super.Open()
	}

	public Clear() {

		for (let _tmpi in this._auction_list) {
			var item = this._auction_list[_tmpi]
			item.DeleteMe()
		}
		this._auction_list = []
		for (let _tmpi in this._fix_list) {
			var item = this._fix_list[_tmpi]
			item.DeleteMe()
		}
		this._fix_list = []
		this.ClearTimer()
	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_go, () => {
			OpenFun.OpenFunHandler(156)
			this.Close()
		}
			, this, true)
		Util.AddClickEvent(this._btn_cancel, () => {
			this.Close()
		}
			, this, true)
	}

	public LoadSuccess() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_1, GameResPath.GetIcon("common4", "uijs_038"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_2, GameResPath.GetIcon("common4", "uijs_038"))
		// this.AddUIEffect2("ui_guardssuccess_glow", this._gp_victory, null, {x=1.4, y=1.4}, false, false, false, false, true)
		this.UpdateView()
		this.StartTimer()
	}

	public UpdateView() {

		if (!this._data) {
			return
		}
		let fix_reward = this._data.fix_reward
		for (let i = 1; i <= fix_reward.length; i++) {
			let vo = fix_reward[i]
			let item = this._fix_list[i]
			if (!item) {
				item = new EquipmentItem(this._gp_fix)
				item.Load()
				item.SetItemSize(107, 107)
				this._fix_list[i] = item
			}
			let type_id, is_lock = GoodsModel.GetInstance().GetMappingTypeId(vo.gtype, vo.gtype_id)
			item.SetData(type_id, vo.gnum, is_lock)
		}

		let auction_reward = this._data.auction_reward
		for (let i = 1; i <= auction_reward.length; i++) {
			let vo = auction_reward[i]
			let item = this._auction_list[i]
			if (!item) {
				item = new EquipmentItem(this._gp_auction)
				item.Load()
				item.SetItemSize(107, 107)
				this._auction_list[i] = item
			}
			let type_id, is_lock = GoodsModel.GetInstance().GetMappingTypeId(vo.gtype, vo.gtype_id)
			item.SetData(type_id, vo.gnum, is_lock)
		}
	}

	public StartTimer() {

		this._time = 10 + TimeUtil.getServerTime()
		// this._time = 100000 + TimeUtil.getServerTime()
		if (!this._time_id) {
			this._time_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.UpdateTimer()
			}, 1, -1)
		}
		this.UpdateTimer()
	}

	public ClearTimer() {

		if (this._time_id) {
			GlobalTimerQuest.CancelQuest(this._time_id)
			this._time_id = null
		}
	}

	public DeleteMe(){
		super.DeleteMe()
	}


_gp_victory:Laya.Box
_img_1:Laya.Image
_img_2:Laya.Image
_Image1:Laya.Image
_Image2:Laya.Image
_Scroller1:Laya.Panel
Content:Laya.Box
_Scroller2:Laya.Panel
Content1:Laya.HBox
_Group1:Laya.Box
_Image3:Laya.Image
_Label1:Laya.Label
_Group2:Laya.Box
_Image4:Laya.Image
_Label2:Laya.Label
_btn_go:Laya.Box
_Image5:Laya.Image
_Label3:Laya.Label
_btn_cancel:Laya.Box
_Image6:Laya.Image
_Label4:Laya.Label
_Label5:Laya.Label
_lb_time:Laya.Label
public GetComponents() {
[
this._gp_victory,
this._img_1,
this._img_2,
this._Image1,
this._Image2,
this._Scroller1,
this.Content,
this._Scroller2,
this.Content1,
this._Group1,
this._Image3,
this._Label1,
this._Group2,
this._Image4,
this._Label2,
this._btn_go,
this._Image5,
this._Label3,
this._btn_cancel,
this._Image6,
this._Label4,
this._Label5,
this._lb_time,
]
 = this.GetChildrenByNames([

"_gp_victory",
"_img_1",
"_img_2",
"_Image1",
"_Image2",
"_Scroller1",
"Content",
"_Scroller2",
"Content1",
"_Group1",
"_Image3",
"_Label1",
"_Group2",
"_Image4",
"_Label2",
"_btn_go",
"_Image5",
"_Label3",
"_btn_cancel",
"_Image6",
"_Label4",
"_Label5",
"_lb_time",
])
}
}
 window["EveningBossResultView"]= EveningBossResultView