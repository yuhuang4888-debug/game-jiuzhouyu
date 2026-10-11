import { BaseView1 } from "../common/BaseView1"
import { CongratulationObtainView, enum_CongratulaionType } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine, Enum_Btn_Type, Enum_Currency_Type } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPosition, RefBoxChildsLayout, GlobalTimerQuest } from "../util/Util"
import { LTItem } from "./LTItem"
import "../LuckyTreasure/LTItem"
import "../LuckyTreasure/LuckyTreasureRecordView"
import { TimeUtil } from "../util/TimeUtil"

export class LuckyTreasureView extends BaseView1 {
	DestoryCB
	InitBtn
	InitEvent
	InitRreward
	InitView
	RefPool
	Reset
	SetActInfo
	SetImg
	click_bg_toClose
	destroy_callback
	is_center
	jump_anime
	not_show_item_use
	open_callback
	reward_items
	show_open_movie
	use_background
	GetItemPos
	_update_time


	public constructor() {
		super()


		this.jump_anime = false;
		this.reward_items = [];
		let model = CustomActivityModel.GetInstance()
		let local_Util = Util
		let local_CustomActivityDefine = CustomActivityDefine

		let goods_model = GoodsModel.GetInstance()
		let info_ = null
		let data_ = null
		let cond_info_ = null
		let b_ = null
		let s_ = null
		let time_item_ = null
		let record_item_ = null
		let one_btn_ = null
		let ten_btn_ = null
		this.base_file = "luckyTreasure"
		this.layout_file = "LuckyTreasureView"
		this.preload_client_config={"ConfigCustomActivityView":false}
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.not_show_item_use = true
		this.show_open_movie = true
		let cur_sorting_order = null
		this.load_callback = () => {
			ResManager.GetInstance().LoadFont(this, "pray", this._p_num, 20,false,()=>{
				this.InitView()
			})
			this.InitEvent()
			this.InitView()
		}

		this.destroy_callback = () => {
			if(this._update_time){
				GlobalTimerQuest.CancelQuest(this._update_time)
				this._update_time=null
			}
			this.DestoryCB()
		}

		this.InitEvent = () => {

			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("luckyTreasure", "uixytb_002"))
			Util.AddClickEvent(this._instruction, () => {
				if (b_ == null || s_ == null) {
					return
				}
				let id = model.getActInstructionId(String(b_), String(s_))
				if (id) {
					GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, Number(id))
				}
			}
				, this, true)
			Util.AddClickEvent(this._close, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this._anime, () => {
				this.jump_anime = !this.jump_anime
				// [ts2lua]lua中0和空字符串也是true，此处this.jump_anime需要确认
				let source = (this.jump_anime && this.jump_anime != 0) && "com_ui_gx1" || "com_ui_gx"
				
				ResManager.GetInstance().SetImageSpriteTrans(this, this._anime, GameResPath.GetIcon("common_asset", source), true)
			}
				, this, true)
			let updata_view = (...new_args) => {
				let args = new_args
				if (args[0] == b_ && args[1] == s_) {
					if (args[2] == 33213) {
						let data = model.GetActData(b_, s_)
						let pool = (data && data.pool) && data.pool[0]
						if (pool) {
							this.RefPool(pool.count)
						}
					} else {
						if (!data_) {
							this.InitView()
							return
						}
						this.Reset()
					}
				}
			}


			Util.AddClickEvent(this._box_record, () => {
				if(info_){
					GlobalEventSystem.Fire(EventName.OPEN_VIEW,"LuckyTreasureRecordView",info_)
				}
			}, this, true)

			this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, updata_view)
			let get_reward = (...new_args) => {
				let args = new_args
				if (args[0] == b_ && args[1] == s_) {


					let rewards = args[2] && args[2].reward
					let list = []
					if (rewards)
						for (let v of rewards) {
							let info = []
							info.push(v.reward_list[0].style)
							info.push(v.reward_list[0].typeId)
							info.push(v.reward_list[0].count)
							if (v.rare == 2) {
								info.push(true)
							}
							list.push(info)
						}
					if (list.length > 0) {
						let view = new CongratulationObtainView(list, 10,null,null,null,null,enum_CongratulaionType.rare_reward)
						view.Open()
					}
				}
			}

			this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, get_reward)
		}

		this.InitView = () => {
			let info = info_
			if (!info) {
				return
			}
			this.Reset()
			let b = b_
			let s = s_
			let data = data_
			if (!data) {
				return
			}
			model.CloseACTRed(b, s)
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
			if (cfg && info) {
				model.LoadCompontRes(this, cfg, "LuckyTreasureView", info.show_id)
			}
			if (!time_item_) {
				time_item_ = model.LoadActTimer(this._time, info.etime, 20, "#00fa64", null, "#ffffff", "活动剩余时间：", null, null, false)
			}
			// if (!record_item_) {
			// 	record_item_ = model.LoadActRecord(this._record, b, s, 2)
			// }

			let pool_rew = data.pool
			if (pool_rew) {
				let [type, lock] = goods_model.GetMappingTypeId(pool_rew[0].style, pool_rew[0].typeId)
				let basic = goods_model.GetGoodsBasicByTypeId(type)
				if (basic) {
					ResManager.GetInstance().SetOutsideImageSprite(this,this._p_diamond,GameResPath.GetGoodsIconPath(basic.goods_icon))
				}
				this.RefPool(pool_rew[0].count)
			}
			this.InitBtn()
			this.InitRreward()


			//倒计时
			if(this._update_time){
				GlobalTimerQuest.CancelQuest(this._update_time)
				this._update_time=null
			}

			if (!this._update_time) {
				let UpdateTime=()=>{
					let expire_time = TimeUtil.GetFutureZeroStamp(1)
					let left_sce= expire_time - TimeUtil.getServerTime()
					let left_str=TimeUtil.timeConvert(left_sce, "dd-hh-mm-ss")
					this._lb_time.changeText(left_str)
				}
				this._update_time = GlobalTimerQuest.AddPeriodQuest(UpdateTime, 1, -1)

				UpdateTime()
			}
		}

		this.Reset = () => {
			let info = info_
			if (!info) {
				return
			}
			let b = info.base_type
			let s = info.sub_type
			b_ = b
			s_ = s
			data_ = model.GetActData(b, s)
			cond_info_ = model.GetActCondition(b, s, "info")
		}

		this.RefPool = (num?) => {
			if (num == null) {
				return
			}
			this._p_num.text = num
			RefBoxChildsLayout(this._Group1,3)

			if (b_ == null || s_ == null) {
				return
			}
			let cond = cond_info_
			if (cond) {
				let pool_range = cond.pool_range
				let i = 1
				if (pool_range && pool_range.length > 0) {
					for (let _tmpi in pool_range) {
						var v = pool_range[_tmpi]
						if (Number(v[0]) <= num && (v[1] == "null" || Number(v[1]) >= num)) {
							this.SetImg(this._pool, v[2], null, true)
							break
						}
						i = i + 1
					}
				}
			}
		}

		this.InitRreward = () => {
			let data = data_
			if (!data) {
				return
			}
			let list = data.reward_list
			if (!list || !list.length) {
				return
			}
			let sort_func = (a?, b?) => {
				return a.grade < b.grade
			}

			table.sort(list, sort_func)
			if (this.reward_items.length > 0) {
				for (let _tmpi in this.reward_items) {
					var item = this.reward_items[_tmpi]
					item.SetVisible(false)
				}
			}
			for (let i in list) {

				let item = this.reward_items[i]
				if (!item) {
					item = new LTItem(this._reward)
					item.Load()
					let arr = this.GetItemPos(Number(i))
					item.SetPosition(arr[0], arr[1])
					table.insert(this.reward_items, item)
				}
				item.ExcuteCallback(() => {
					item.SetData(list[i], b_, s_, cur_sorting_order + 1)
					item.SetVisible(true)
				}
				)
			}
		}


		this.GetItemPos = (i) => {
			let gap_w = 116 //间隔
			let gap_h = 120 //间隔
			let top = 1   //上边距
			let left =1	//左边距
			let cell_gap= 35//特别的高度
			let child_num = 4 //每个part的物体数量
			let index = i + 1
			let temp1 = index % child_num
			temp1 = temp1 >= 1 ? 1 : 0
			let temp_index = Math.floor(index / child_num) + temp1
			let x = 0, y = 0

			let temp2 = i % child_num  //0 1 2 3
			switch (temp_index) {
				case 1:
					x = temp2 * gap_w
					y = 0
					break;
				case 2:
					x = child_num * gap_w
					y = temp2==0?temp2 * gap_h:temp2 * gap_h+cell_gap
					break;
				case 3:
					x = (child_num - temp2) * gap_w
					y = (temp2==0?child_num * gap_h:child_num * gap_h+cell_gap)+cell_gap
					break;
				case 4:
					x = 0
					y = (child_num - temp2) * gap_h+cell_gap
					break;
			}
			return [x + left, y + top]
		}

		this.InitBtn = () => {
			let cond = cond_info_
			if (cond) {
				let posY = 12
				let cost = cond["one_cost"]
				let btn_dic = {}
				btn_dic["text"] = ""
				let source = GameResPath.GetIcon("common", "ui_button_rect13")
				one_btn_ = model.LoadActBtn(this._btn1, one_btn_, data_, cost[0], btn_dic, 1, source,
					null, true, true, null, Enum_Btn_Type.ONE,Enum_Currency_Type.Special,null,[CustomActivityModel.LUC_TREA_LIMIT])
				if (one_btn_) {

					one_btn_.ExcuteCallback(() => {
						one_btn_._name_0.text = "抽奖1次"
						one_btn_._name_0.fontSize = 22
						one_btn_._name_0.stroke = 2
						one_btn_._name_0.strokeColor = "#3e9298"


						one_btn_._name_0.x = 38
						one_btn_._name_0.y = posY

						one_btn_._lb_have_0.mouseEnabled = false
						one_btn_._lb_have_0.stroke = 2
						one_btn_._lb_have_0.strokeColor = "#485d9c"
						one_btn_._lb_have_0.fontSize = 16

						one_btn_._lb_cost_0.stroke = 2
						one_btn_._lb_cost_0.strokeColor = "#485d9c"
						one_btn_._lb_cost_0.fontSize = 16
						one_btn_._lb_cost_0.mouseEnabled = false

						one_btn_._img_cost_0.width = 23
						one_btn_._img_cost_0.height = 23

						one_btn_._gp_cost_0.centerX = 3
						one_btn_._gp_cost_0.y = posY + 22

						one_btn_.display_obj.width = 153
						one_btn_._one.width = 153
						one_btn_._gp_cost_0.mouseEnabled = false
						one_btn_._gp_cost_0.mouseThrough = true
						one_btn_._red_0.pos(125, -10)
						//one_btn_.SetRedPos(-20,-10)
					})
				}


				cost = cond["ten_cost"]
				btn_dic = {}
				btn_dic["text"] = ""
				source = GameResPath.GetIcon("common", "ui_button_rect12")


				ten_btn_ = model.LoadActBtn(
					this._btn2, ten_btn_, data_, cost[0], btn_dic,
					 10, source,null, true, true, 
					 null, Enum_Btn_Type.ONE,Enum_Currency_Type.Special,null,[CustomActivityModel.LUC_TREA_LIMIT])
				if (ten_btn_) {

					ten_btn_.ExcuteCallback(() => {
						ten_btn_._name_0.text = "抽奖10次"
						ten_btn_._name_0.fontSize = 22
						ten_btn_._name_0.stroke = 2
						ten_btn_._name_0.strokeColor = "#c95b37"


						ten_btn_._name_0.x = 33
						ten_btn_._name_0.y = posY

						ten_btn_._lb_have_0.stroke = 2
						ten_btn_._lb_have_0.strokeColor = "#af4200"
						ten_btn_._lb_have_0.fontSize = 16
						ten_btn_._lb_have_0.mouseEnabled = false

						ten_btn_._lb_cost_0.stroke = 2
						ten_btn_._lb_cost_0.strokeColor = "#af4200"
						ten_btn_._lb_cost_0.fontSize = 16
						ten_btn_._lb_cost_0.mouseEnabled = false

						ten_btn_._img_cost_0.width = 23
						ten_btn_._img_cost_0.height = 23


						ten_btn_._gp_cost_0.centerX = 4
						ten_btn_._gp_cost_0.y = posY + 22

						ten_btn_._one.width = 153

						ten_btn_._gp_cost_0.mouseEnabled = false
						ten_btn_._gp_cost_0.mouseThrough = true

						ten_btn_._red_0.pos(125, -10)
					})
				}


			}


		}

		this.SetImg = (target?, name?, url?, nativesize?) => {
			if (!nativesize) {
				nativesize = false
			}
			let _path = null
			if (url) {
				_path = url
			} else {
				_path = GameResPath.GetIcon("luckyTreasure",name)//"resource/game/luckyTreasure/texture/" + name + ".png"
			}
			ResManager.GetInstance().SetImageSpriteTrans(this, target, _path, nativesize)
		}

		this.SetActInfo = (info?, parm?) => {
			info_ = info
		}

		this.DestoryCB = () => {
			if (time_item_) {
				time_item_.DeleteMe()
			}
			time_item_ = null
			if (record_item_) {
				record_item_.DeleteMe()
			}
			record_item_ = null
			if (one_btn_) {
				one_btn_.DeleteMe()
			}
			one_btn_ = null
			if (ten_btn_) {
				ten_btn_.DeleteMe()
			}
			ten_btn_ = null
			if (this.reward_items.length > 0) {
				for (let _tmpi in this.reward_items) {
					var item = this.reward_items[_tmpi]
					item.DeleteMe()
				}
				this.reward_items = []
			}
		}


	}


	public DeleteMe() {
		super.DeleteMe()
	}


_Image1:Laya.Image
_Image_title:Laya.Image
_Image22:Laya.Image
_reward:Laya.Box
_pool:Laya.Image
_time:Laya.Box
_btn1:Laya.Box
_btn2:Laya.Box
_Group1:Laya.Box
_p_num:Laya.Label
_p_diamond:Laya.Image
_close:Laya.Image
_instruction:Laya.Image
_anime:Laya.Image
_Label2:Laya.Label
_box_record:Laya.Box
_lb_time:Laya.Label
public GetComponents() {
[
this._Image1,
this._Image_title,
this._Image22,
this._reward,
this._pool,
this._time,
this._btn1,
this._btn2,
this._Group1,
this._p_num,
this._p_diamond,
this._close,
this._instruction,
this._anime,
this._Label2,
this._box_record,
this._lb_time,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image_title",
"_Image22",
"_reward",
"_pool",
"_time",
"_btn1",
"_btn2",
"_Group1",
"_p_num",
"_p_diamond",
"_close",
"_instruction",
"_anime",
"_Label2",
"_box_record",
"_lb_time",
])
}
}
 window["LuckyTreasureView"]= LuckyTreasureView