import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager, SoundManager } from "../common/SoundManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class NineSkyFloorRewardView extends BaseView1 {

	count_down_id
	end_time
	floor
	item_list
	left_time

	goods_model:GoodsModel
	nine_sky_model:NineSkyModel
	voice

	public constructor() {
		super()
		this.base_file = "nineSky"
		this.layout_file = "NineSkyFloorRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.background_alpha = 0
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.is_center = true

		this.nine_sky_model = NineSkyModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.item_list = null
		this.floor = null
		this.left_time = 5
		this.count_down_id = null
		this.end_time = null

		this.preload_server_config = {
			"config_nine":false,
		}

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public LoadSuccess() {
		this._panel_reward.hScrollBarSkin = ""
		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
	}

	public UpdateView() {
		if (!this.floor) {
			return
		}

		this.voice=CommonManager.GetInstance().PlayFightingVoice(2)

		let nine_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_nine", false)
		let cfg = nine_cfg[this.nine_sky_model.server_type + "@" + this.floor]
		let list = JSON.parse(cfg.award)
		let len = list.length
		if (!this.item_list) {
			this.item_list = []
		}
		let i = len
		if (i < this.item_list.length) {
			do {
				this.item_list[i].SetVisible(false)
				i = i + 1
			} while ((i < this.item_list.length))
		}

		if (len > 0) {
			let item
			for (let key in list) {
				item = this.item_list[key]
				if (!item) {
					item = new BaseAwardItem(this._panel_reward)
					item.SetItemSize(85, 85)
					this.item_list[key] = item
					item.Load()
				}
				item.SetPosition(Number(key) * 90, 0)
				let vo = list[key]
				let [type_id, lock] = this.goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo[2], lock)
				} else {
					console.log("goods_vo is null TypeID:" + vo.typeId)
				}
				item.SetVisible(true)
			}
		}

		if(len <= 5){
			this._panel_reward.width = len * 90
		}
		else{
			this._panel_reward.width = 460
		}


		this._lb_desc.text = "恭贺您首次成功晋升至九魂妖塔" + this.floor + "层"
		this.StartTime()
	}

	public StartTime() {
		this.CancelTime()
		this.end_time = this.left_time + TimeUtil.getServerTime()
		let loop_func = () => {
			let left_time = this.end_time - TimeUtil.getServerTime()
			if (left_time < 0) {
				this.Close()
				return
			}
			this._lb_count_time.text = left_time + "秒后自动关闭"
		}
		this.count_down_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
		loop_func()
	}

	public CancelTime() {
		if (this.count_down_id) {
			GlobalTimerQuest.CancelQuest(this.count_down_id)
			this.count_down_id = null
		}
	}

	public Remove() {

		if (this.voice) {
			SoundManager.GetInstance().StopSoundEffect(this.voice)
			this.voice = null
		}
		
		this.CancelTime()
		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list = false
		}
	}

	public Open(...new_args) {
		let parm = new_args
		if (parm) {
			this.floor = parm[0]
		}
		super.Open()
	}

_img_bg:Laya.Image
_img_close:Laya.Image
_img_bg2:Laya.Image
_lb_desc:Laya.Label
_lb_count_time:Laya.Label
_panel_reward:Laya.Panel
_img_bg3:Laya.Image
_lb_title:Laya.Label
public GetComponents() {
[
this._img_bg,
this._img_close,
this._img_bg2,
this._lb_desc,
this._lb_count_time,
this._panel_reward,
this._img_bg3,
this._lb_title,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_close",
"_img_bg2",
"_lb_desc",
"_lb_count_time",
"_panel_reward",
"_img_bg3",
"_lb_title",
])
}
}
window["NineSkyFloorRewardView"] = NineSkyFloorRewardView
