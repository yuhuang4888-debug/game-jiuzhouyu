import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { UnrealToolTips } from "../common/UnrealToolTips"
import { BossModel } from "../commonModel/BossModel"
import { GodBefallDefine } from "../commonModel/GodBefallModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDeltaY, SetAnchoredPositionY, GlobalTimerQuest, RefGridLayout, RefBoxVLayout } from "../util/Util"

export class BossDomainResultView extends BaseView1 {
	CancelTime
	InitEvent
	LoadSuccess
	OnTime
	Remove
	SetResultData
	StartTime
	UpdateView
	addReward
	back_login_toClose
	time_event_id
	_end_time

	cell_width = 114
	cell_gap = 6
	public constructor() {
		super()


		this.base_file = "bossdomain"
		this.layout_file = "BossDomainResultView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.back_login_toClose = true
		let result_data = null
		let reward_list = []
		let reward_list2 = []
		let left_time = 10
		this.time_event_id = null
		let model = BossModel.GetInstance()
		let boss_type = null
		this._end_time = 0

		let goods_model = GoodsModel.GetInstance()
		let ui_tool_tip_mgr = UIToolTipMgr.GetInstance()
		let local_Math = Math
		let local_TimeUtil = TimeUtil

		//布局数据
		let layout_data = {
			column: 4,
			h_gap: this.cell_gap,
			v_gap: this.cell_gap,
			item_w: this.cell_width,
			item_h: this.cell_width
		}


		this.load_callback = () => {
			this.AddUIEffect("ui_ZiTi_Huode", this._gp_effect, null, 4, true)
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.close_callback = () => {
			this.Remove()
		}

		this.Remove = () => {
			this.CancelTime()
			for (let _tmpi in reward_list) {
				var vo = reward_list[_tmpi]
				vo.DeleteMe()
			}
			for (let _tmpi in reward_list2) {
				var vo = reward_list2[_tmpi]
				vo.DeleteMe()
			}
			reward_list = []
			reward_list2 = []
			result_data = null

			this.ClearUIEffect(this._gp_effect)
		}

		this.LoadSuccess = () => {
			this.scroll.vScrollBarSkin = ""
			this.scroll0.vScrollBarSkin = ""
			let room_info = model.GetEnterBossInfo()
			if (room_info) {
				boss_type = room_info.boss_type
			}
		}

		this.InitEvent = () => {
		}

		this.UpdateView = () => {
			if (!result_data) {
				return
			}

			ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("dungeonCommon", "com_up_bg1"))
			this._lb_tips.text = "奖励"
			let big_box_space=10
			let belog_list = []
			let help_list = []
			let kill_list = []
			for (let key in result_data.reward_type_list) {

				let obj = result_data.reward_type_list[key]
				if (obj.reward_type == 0) {
					belog_list = obj.reward_list //归属奖
				} else if (obj.reward_type == 6) {
					kill_list = obj.reward_list //参与奖
				} else if (obj.reward_type == 7) {
					help_list = obj.reward_list
				}
			}

			let double_belog_list = []
			let double_help_list = []
			let double_kill_list = []
			if (result_data.is_double > 0) {
				for (let key in result_data.reward_type_list2) {
					//双倍奖励列表
					let obj = result_data.reward_type_list2[key]
					if (obj.reward_type2 == 0) {
						double_belog_list = obj.reward_list2 //归属奖
					} else if (obj.reward_type2 == 6) {
						double_kill_list = obj.reward_list2 //参与奖
					} else if (obj.reward_type2 == 7) {
						double_help_list = obj.reward_list2
					}
				}
			}


			let tow_List = belog_list.length > 0 && kill_list.length > 0
			let list = []
			let second_list = []
			if (tow_List) {
				this._lb_tips.text = "归属奖励"
				list = belog_list
				second_list = kill_list.length > 0 && kill_list || help_list
				this._lb_tips0.text = kill_list.length > 0 && "参与奖励" || "协助奖励"
			} else {
				if (belog_list.length > 0) {
					this._lb_tips.text = "归属奖励"
					list = belog_list
				} else {
					list = kill_list.length > 0 && kill_list || help_list
					this._lb_tips.text = kill_list.length > 0 && "参与奖励" || "协助奖励"
				}
			}

			let double_list = []
			let double_second_list = []
			if (tow_List) { //双倍奖励列表
				double_list = double_belog_list
				double_second_list = kill_list.length > 0 && double_kill_list || double_help_list
			} else {
				if (belog_list.length > 0) {
					double_list = double_belog_list
				} else {
					double_list = kill_list.length > 0 && double_kill_list || double_help_list
				}
			}

			//设置Content1的高度  归属奖励
			let len_gs = list.length + double_list.length
			let index = 0
			for (let kk = 0; kk < reward_list.length; kk++) {
				reward_list[kk].SetVisible(false)
			}


			let sc_h1=local_Math.ceil(len_gs / 4) * this.cell_width + (local_Math.ceil(len_gs / 4) - 1) * this.cell_gap
			let scroll_height = sc_h1
			if (scroll_height > 260) {
				scroll_height = 260
			}
			SetSizeDeltaY(this.scroll, scroll_height)
			this.Content1.height = sc_h1


			//设置Content高度  参与奖励
			let len_cy = second_list.length + double_second_list.length
			this._gp_tip_img0.visible = len_cy > 0
			this.scroll0.visible = len_cy > 0

			for (let i = 0; i < reward_list2.length; i++) {
				reward_list2[i].SetVisible(false)
			}

			let sc_h2=local_Math.ceil(len_cy / 4) * this.cell_width + (local_Math.ceil(len_cy / 4) - 1) * this.cell_gap
			this.Content.height = sc_h2
			let scroll_height2 = sc_h2
			if (scroll_height2 > 260) {
				scroll_height2 = 260
			}
			SetSizeDeltaY(this.scroll0, scroll_height2)

			//计时
			this.StartTime()

			//归属奖励
			let ct_1_num = 0
			let asy_func_1 = () => {
				ct_1_num++
				if (ct_1_num >= len_gs) {
					RefGridLayout(this.Content1, layout_data)
				}
			}

			index = 0
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				let [type_id, lock] = goods_model.GetMappingTypeId(vo.style1, vo.type_id1)
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				if (basic) {
					let length = 1
					if (basic.max_overlap == 0 && vo.count1 > 1) {
						length = vo.count1
					}
					index = index + this.addReward(basic, vo, reward_list, length, index, this.Content1, false, asy_func_1)
				}
			}

			for (let _tmpi in double_list) {
				var vo = double_list[_tmpi]
				let [type_id, lock] = goods_model.GetMappingTypeId(vo.style2, vo.type_id2)
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				if (basic) {
					let length = 1
					if (basic.max_overlap == 0 && vo.count2 > 1) {
						length = vo.count2
					}
					index = index + this.addReward(basic, vo, reward_list, length, index, this.Content1, true, asy_func_1)
				}
			}



			//参与奖励

			let ct_2_num = 0
			let asy_func_2 = () => {
				ct_2_num++
				if (ct_2_num >= len_cy) {
					RefGridLayout(this.Content, layout_data)
				}
			}
			index = 0
			for (let _tmpi in second_list) {
				var vo = second_list[_tmpi]
				let [type_id, lock] = goods_model.GetMappingTypeId(vo.style1, vo.type_id1)
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				if (basic) {
					let length = 1
					if (basic.max_overlap == 0 && vo.count1 > 1) {
						length = vo.count1
					}
					index = index + this.addReward(basic, vo, reward_list2, length, index, this.Content, false, asy_func_2)
				}
			}

			for (let _tmpi in double_second_list) {
				var vo = double_second_list[_tmpi]
				let [type_id, lock] = goods_model.GetMappingTypeId(vo.style2, vo.type_id2)
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				if (basic) {
					let length = 1
					if (basic.max_overlap == 0 && vo.count2 > 1) {
						length = vo.count2
					}
					index = index + this.addReward(basic, vo, reward_list2, length, index, this.Content, true, asy_func_2)
				}
			}


			//布局排列
			RefBoxVLayout(this._gp_content, big_box_space,true)
			let bg_h = this._gp_content.y + this._gp_content.height+30
			this._bg.height = bg_h
			this._lb_time.y = this._bg.y + bg_h + 10
		}

		this.addReward = (basic?, vo?, list?, length?, index?, _gp?, is_double?, func?) => {
			let count = 0
			let i = 0
			do {
				let goods_vo = null
				if (vo.goods_id1) {
					goods_vo = goods_model.GetGoodsVoByGoodsId(vo.goods_id1)
				}
				if (vo.goods_id2) {
					goods_vo = goods_model.GetGoodsVoByGoodsId(vo.goods_id2)
				}
				let item: EquipmentItem = list[index]
				if (!item) {
					item = new EquipmentItem(_gp)
					item.SetClickCallBack(() => {
						if (basic.type == 10) {
							ui_tool_tip_mgr.AppendEquipTips(basic.type_id, null, null, goods_vo, null, [1])
						} else if (basic.type == GodBefallDefine.EQUIP_TYPE) {
							ui_tool_tip_mgr.AppendGodEquipTips(basic.type_id, goods_vo)
						} else if (basic.type == UnrealModel.goods_type) {
							ui_tool_tip_mgr.AppendUnrealTips(basic.type_id, goods_vo, null, [0])//{UnrealToolTips.Btn.close}
						} else if (basic.type == StarEquipModel.GOODS_TYPE && basic.subtype < 11) {
							ui_tool_tip_mgr.AppendStarEquipToolTips(basic.type_id, goods_vo, null, [0])//{UnrealToolTips.Btn.close}
						} else {
							ui_tool_tip_mgr.AppendGoodsTips(basic.type_id, null, null, goods_vo)
						}
					}
					)
					item.SetItemSize(this.cell_width, this.cell_width)
					item.Load()
					table.insert(list,item)
				}
				item.ExcuteCallback(() => {
					if (basic.type == UnrealModel.goods_type) {
						item.SetData(basic.type_id)
					} else {
						let count = vo.count1 && vo.count1 || vo.count2
						let show_count = length > 1 && 1 || count
						item.SetData(basic.type_id, show_count)
					}
					if (is_double) {
						item.setTipsImg("uipj_046", "bossdomain_asset")
						item.setTipsImgPos(70, 0)
						item.setTipsImgSize(0.6,0.6)
					}

					if (func) func()
				}
				)
				item.SetVisible(true)
				count = count + 1
				i = i + 1
			} while ((i < length))
			return count
		}



		this.SetResultData = (data?) => {
			result_data = data
		}

		this.StartTime = () => {
			this.CancelTime()
			this._end_time = left_time + local_TimeUtil.getServerTime()
			this.time_event_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTime()
			}, 1)
			this.OnTime()
		}

		this.OnTime = () => {
			let left_time = this._end_time - local_TimeUtil.getServerTime()
			if (left_time < 0) {
				this.Close()
				return
			}
			this._lb_time.text = left_time + "秒后自动关闭"
		}

		this.CancelTime = () => {
			if (this.time_event_id) {
				GlobalTimerQuest.CancelQuest(this.time_event_id)
				this.time_event_id = null
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_box_1: Laya.Box
	_bg: Laya.Image
	_gp_effect: Laya.Box
	_gp_content: Laya.Box
	_gp_tip_img: Laya.Box
	_Image1: Laya.Image
	_lb_tips: Laya.Label
	scroll: Laya.Panel
	Content1: Laya.Box
	_gp_tip_img0: Laya.Box
	_Image2: Laya.Image
	_lb_tips0: Laya.Label
	scroll0: Laya.Panel
	Content: Laya.Box
	_lb_time: Laya.Label
	public GetComponents() {
		[
			this._box_1,
			this._bg,
			this._gp_effect,
			this._gp_content,
			this._gp_tip_img,
			this._Image1,
			this._lb_tips,
			this.scroll,
			this.Content1,
			this._gp_tip_img0,
			this._Image2,
			this._lb_tips0,
			this.scroll0,
			this.Content,
			this._lb_time,
		]
			= this.GetChildrenByNames([

				"_box_1",
				"_bg",
				"_gp_effect",
				"_gp_content",
				"_gp_tip_img",
				"_Image1",
				"_lb_tips",
				"scroll",
				"Content1",
				"_gp_tip_img0",
				"_Image2",
				"_lb_tips0",
				"scroll0",
				"Content",
				"_lb_time",
			])
	}
}
window["BossDomainResultView"] = BossDomainResultView