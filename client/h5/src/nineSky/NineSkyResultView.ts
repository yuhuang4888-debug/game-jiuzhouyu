import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { NineSkyResultOwnerItem } from "./NineSkyResultOwnerItem"

export class NineSkyResultView extends BaseView1 {


	count_down_id
	left_time = 20
	reward_item_list
	result_info: ProtoRecvVObj<13507>
	voice
	item_loop_mgr
	goods_model: GoodsModel
	nine_sky_model: NineSkyModel
	public constructor() {
		super()
		this.base_file = "nineSky"
		this.layout_file = "NineSkyResultView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.is_center = true

		this.goods_model = GoodsModel.GetInstance()
		this.nine_sky_model = NineSkyModel.GetInstance()
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
		this._list_reward_owners.vScrollBarSkin = ""
		//resource/game/dungeonCommon/other/com_up_bg1.png
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconOtherPath("dungeonCommon", "com_up_bg1"))

		Util.AddClickEvent(this._box_leave, () => {
			this.Close()
		}, this, true)

	}

	public Remove() {
		if (this.voice) {
			SoundManager.GetInstance().StopSoundEffect(this.voice)
			this.voice = null
		}

		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = undefined
		}

		if (this.reward_item_list) {
			for (let _tmpi in this.reward_item_list) {
				var obj = this.reward_item_list[_tmpi]
				obj.DeleteMe()
			}
			this.reward_item_list = null
		}
		this.CancelTime()
	}

	public UpdateView() {
		let result_info = this.result_info
		if (result_info) {
			this.voice = CommonManager.GetInstance().PlayFightingVoice(2)
			this._lb_tips.text = `经过浴血奋战，您成功晋升至\n九魂妖塔第${result_info.max_floor}层`
			let list = result_info.reward
			let len = list.length


			let first_player_name = result_info.first_player
			if (!first_player_name) {
				first_player_name = "无人登顶"
			}
			else if (result_info.first_server_num && this.nine_sky_model.server_type > 1) {
				first_player_name = `s${result_info.first_server_num}.${first_player_name}`
			}
			this._lb_first_name.text = first_player_name

			if (this.item_loop_mgr) {
				this.item_loop_mgr.replaceAll(result_info.get_list)
			}
			else {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this._list_reward_owners, NineSkyResultOwnerItem, result_info.get_list, LoopScrCon.Vertical)
			}

			if (!this.reward_item_list) {
				this.reward_item_list = []
			}

			let i = len
			if (i < this.reward_item_list.length) {
				do {
					this.reward_item_list[i].SetVisible(false)
					i = i + 1
				} while ((i < this.reward_item_list.length))
			}

			if (len > 0) {
				let item
				for (let key in list) {
					item = this.reward_item_list[key]
					if (!item) {
						item = new EquipmentItem(this._panel_reward)
						this.reward_item_list[key] = item
						item.SetItemSize(77, 77)
						item.Load()
					}
					item.SetPosition(Number(key) * 90, 0)
					let vo = list[key]
					let [type_id, lock] = this.goods_model.GetMappingTypeId(vo.style, vo.typeId)
					let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						item.SetData(goods_vo.type_id, vo.count, lock)
					}
					item.SetVisible(true)
				}
			}

			if (len <= 5) {
				this._panel_reward.width = len * 90
			}
			else {
				this._panel_reward.width = 460
			}

			this.StartTime()
		}
	}

	public StartTime() {

		this.CancelTime()
		let end_time = this.left_time + TimeUtil.getServerTime()
		let loop_func = () => {
			let left_time = end_time - TimeUtil.getServerTime()
			if (left_time < 0) {
				this.Close()
				return
			}
			this._lb_leave.text = "离开(" + left_time + ")"
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

	public Open(...new_args) {
		let parms = new_args
		this.result_info = parms[0]
		super.Open()
	}
	
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_bg5: Laya.Image
	_img_bg6: Laya.Image
	_lb_tips: Laya.Label
	_box_leave: Laya.Box
	_img_leave: Laya.Image
	_lb_leave: Laya.Label
	_lb_first: Laya.Label
	_lb_first_name: Laya.Label
	_panel_reward: Laya.Panel
	_list_reward_owners: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._img_bg5,
			this._img_bg6,
			this._lb_tips,
			this._box_leave,
			this._img_leave,
			this._lb_leave,
			this._lb_first,
			this._lb_first_name,
			this._panel_reward,
			this._list_reward_owners,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_img_bg5",
				"_img_bg6",
				"_lb_tips",
				"_box_leave",
				"_img_leave",
				"_lb_leave",
				"_lb_first",
				"_lb_first_name",
				"_panel_reward",
				"_list_reward_owners",
			])
	}
}
window["NineSkyResultView"] = NineSkyResultView
