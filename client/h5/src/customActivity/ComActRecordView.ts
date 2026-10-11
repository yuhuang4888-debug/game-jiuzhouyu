import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { TSCrackController } from "../commonController/TSCrackController"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RedEnvelopeRebateModel } from "../commonModel/RedEnvelopeRebateModel"
import { RoleManager } from "../commonModel/RoleManager"
import { TreasureMapModel } from "../commonModel/TreasureMapModel"
import { ColorUtil, ColorType, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GetSizeDeltaX, Util, GetSizeDeltaY, SetSizeDelta, SetSizeDeltaX, HtmlColorTxt, GlobalTimerQuest, SetLocalPositionY, Color, SetHtmlStyle } from "../util/Util"

export class ComActRecordView extends BaseItem1 {
	CancelAniTimer
	CancelStopTimer
	GetRecordText
	InitEvent
	InitView
	Local_DeleteMe
	PlayAni
	ResetRecord
	SetData
	SetRecord
	StarAni
	StarAniTimer
	StarStopTimer
	ani_timer
	base_type
	hide_prefix
	is_data
	item_type
	mod_id
	need_reset
	record_index
	record_info
	record_list
	record_loop_mgr
	record_type
	stop_ani_timer
	sub_type
	parent_wnd
	color_
	prams
	is_fresh
	type
	need_fresh
	new_data  //是否是新数据
	is_down   //数据最底部
	count     //下拉到第几个
	ComActRecordType = {
		this_record: 2,
		all_record: 1
	}



	public constructor(parent?) {
		super(parent)
		this.is_fresh = false
		this.parent_wnd = parent
		this.base_type = null
		this.sub_type = null
		this.ani_timer = null
		this.stop_ani_timer = null
		this.item_type = 1
		this.hide_prefix = null
		this.mod_id = null
		this.record_loop_mgr = null
		this.is_data = false
		this.is_down = false
		this.count = 1
		this.record_index = 0
		this.record_list = []
		this.record_type = this.ComActRecordType.all_record
		this.base_file = "customActivity"
		this.layout_file = "ComActRecordView"
		this.need_fresh = false
		let act_model = CustomActivityModel.GetInstance()
		let local_CustomActivityDefine = CustomActivityDefine
		let local_TreasureMapModel = TreasureMapModel

		this.load_callback = () => {
			if (this.is_fresh) {
				this.SetData(this.prams)
				this.is_fresh = false
			}
			this.InitEvent()

			if (this.need_fresh) {
				this.need_fresh = false
				this.ResetRecord(this.type)
			}
		}

		this.InitEvent = () => {
			this.BindEvent(act_model, local_CustomActivityDefine.EVENT.UP_LOG_LIST, (scmd?) => {
				if (scmd.base_type == this.base_type && scmd.sub_type == this.sub_type) {
					this.record_info = scmd
					if (scmd.log_list.length > 0 && this.record_type == this.ComActRecordType.all_record) {
						this.CancelAniTimer()
						this._lb_desc.visible = false
						for (let _tmpi in scmd.log_list) {
							let vo = scmd.log_list[_tmpi]
							vo.hide_prefix = this.hide_prefix
							vo.limit_width = GetSizeDeltaX(this.parent_wnd)
						}
						this.new_data = true
						this.is_down = false
						this.count = 1
						this.SetRecord(scmd.log_list)
					}
					if (scmd.self_list && scmd.self_list.length > 0 && this.record_type == this.ComActRecordType.this_record) {
						this.CancelAniTimer()
						this._lb_desc.visible = false
						for (let _tmpi in scmd.self_list) {
							let vo = scmd.self_list[_tmpi]
							vo.hide_prefix = this.hide_prefix
							vo.limit_width = GetSizeDeltaX(this.parent_wnd)
						}
						this.SetRecord(scmd.self_list)
					}
					if ((scmd.log_list.length == 0 && this.record_type == this.ComActRecordType.all_record) || (scmd.self_list && scmd.self_list.length == 0 && this.record_type == this.ComActRecordType.this_record)) {
						this._lb_desc.visible = true
					}
				}
			}
			)

			this.BindEvent(local_TreasureMapModel.GetInstance(), local_TreasureMapModel.TM_RECORD_LIST,(scmd?) => {
					if (scmd.mod_id == this.mod_id ) {
						if (scmd.log_list.length > 0 ) {
							this.CancelAniTimer()
							for (let _tmpi in scmd.log_list) {
								let vo = scmd.log_list[_tmpi]
								vo.hide_prefix = this.hide_prefix
								vo.limit_width = GetSizeDeltaX(this.parent_wnd)
							}
							this.SetRecord(scmd.log_list)
						}
						this._lb_desc.visible = scmd.log_list.length == 0 
					}
				}
			)

			let onGroupTouchHandler = () => {
				this.CancelStopTimer()
				this.CancelAniTimer()
			}
			//AddDownEvent(this._Viewport,onGroupTouchHandler)
			this.display_obj.on(Laya.Event.MOUSE_DOWN, this, onGroupTouchHandler)
			let OnTouchEndHandler = () => {
				this.StarStopTimer()
			}
			this.display_obj.on(Laya.Event.MOUSE_UP, this, OnTouchEndHandler)
			//AddUpEvent(this._Viewport,OnTouchEndHandler)
			//Util.AddClickEvent(this._Viewport,OnTouchEndHandler,this,false)
		}

		this.InitView = () => {
			SetHtmlStyle(this._record, { c: this.color_, f: 20, lh: 25 })
			// this._panel.vScrollBarSkin = ""
			let view_width = GetSizeDeltaX(this.parent_wnd)
			let view_height = GetSizeDeltaY(this.parent_wnd)
			SetSizeDelta(this.display_obj, view_width, view_height)
			SetSizeDelta(this._panel, view_width, view_height)
			SetSizeDeltaX(this._record, view_width)
			this._record.x = this._record.y = 0

			this._lb_desc.color = this.item_type == 1 && "#c4cbda" || ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.ORANGE)

			if (this.base_type != null) {
				act_model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33197, this.base_type, this.sub_type)
			} else if (this.mod_id != null) {
				if (this.mod_id == 20303) {
					local_TreasureMapModel.GetInstance().Fire(local_TreasureMapModel.TM_REQUEST_SCMD, 20303)
				}
			}
		}

		this.SetRecord = (log_list?) => {

			this.record_index = 1
			this.record_list = []
			let show_str = ""
			for (let i in log_list) {
				let v = log_list[i]
				let str = this.GetRecordText(v)
				if (log_list[(Number(i) + 1).toString()] == undefined) {
					str = str.replace("<br>", "")
				}
				table.insert(this.record_list, str)
				show_str = show_str + str
			}
			// show_str = string.sub(show_str, 1, -2)
			this._record.innerHTML = show_str
			this._record.style.height = log_list.length * 25
			this._record.style.width = this.parent_wnd ? this.parent_wnd.width : 100
			this._panel.refresh()
			this.StarStopTimer()

		}

		this.GetRecordText = (data?) => {
			let result_str = "";

			if (this.base_type == RedEnvelopeRebateModel.ACT_TYPE) {
				result_str = `${HtmlColorTxt(data.name, ColorUtil.GetColorLight(ColorType.GREEN))}${HtmlColorTxt('提现成功!', ColorUtil.GetColorLight(ColorType.WHITE))}<br>`;
				return result_str;
			}
			for (let _tmpi in data.reward_list) {
				let vo = data.reward_list[_tmpi]

				if (this.base_type == 116) {
					let str = "好运来袭，抽奖获得了"
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.style, vo.typeId)
					let goods_name = GoodsModel.GetGoodsNameWithColorDark(type_id)
					result_str = `${str}${vo.count}个${goods_name}<br>`
				} else {
					let str = data.hide_prefix && "" || "人品爆发，"
					let is_mask = data.name == "蒙面人" && data.role_id == RoleManager.GetInstance().GetMainRoleId()
					let name = is_mask && "蒙面人(自己)" || (data.server_num && ("S" + data.server_num + "." + data.name) || (data.name))

					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.style, vo.typeId)
					if (this.item_type == 1) {
						let goods_name = GoodsModel.GetGoodsNameWithColorLight(type_id)
						result_str = `${str}恭喜${HtmlColorTxt(name, ColorUtil.GetColorLight(ColorType.GREEN))}获得${vo.count}个${goods_name}<br>`
						//str + "恭喜" + HtmlColorTxt(name, ColorUtil.GetColorLight(ColorType.GREEN)) + "获得" + vo.count + "个" + goods_name + "\n"
					} else if (this.item_type == 2) {
						let goods_name = GoodsModel.GetGoodsNameWithColorDark(type_id)
						result_str = `${str}恭喜${HtmlColorTxt(name, ColorUtil.GetColorDark(ColorType.GREEN))}获得${vo.count}个${goods_name}<br>`
						// "<font color='#4a3a32'>" + str + "恭喜</font>" + HtmlColorTxt(name, ColorUtil.GetColorDark(ColorType.GREEN)) +
						//  "<font color='#4a3a32'>获得" + vo.count + "个</font>" + goods_name + "<br>"
					}
				}

				return result_str
			}
		}

		this.CancelAniTimer = () => {
			if (this.ani_timer) {
				GlobalTimerQuest.CancelQuest(this.ani_timer)
				this.ani_timer = null
			}
		}

		this.StarAni = () => {
			if (this.use_delete_method) {
				return
			}
			this.CancelAniTimer()

			let count = Util.TableSize(this.record_list)
			if (count > 4) {
				this._panel.scrollTo(0, 0)
				this.need_reset = true
				this.ani_timer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.PlayAni()
				}, 1, -1)
			} else {
				this._panel.scrollTo(0, 0)
			}
		}

		this.PlayAni = () => {
			if (this.use_delete_method) {
				return
			}
			// if (this.need_reset ) {
			// 	this.need_reset = false
			// 	SetLocalPositionY(this._record, 0)
			// }
			if (this.new_data) {
				this._panel.scrollTo(0, 0)
				this.new_data = false
				return
			} else {
				if (!this.is_down) {
					this._panel.scrollTo(0, 25 * this.count)
					if (this._panel.vScrollBar.max <= 25 * this.count) {
						this.is_down = true
						return
					}
					this.count++
					return
				}
			}
			this.record_index = this.record_index + 1
			if (this.record_index > this.record_list.length) {
				this.record_index = 0
			}
			let cur_str = ""
			for (let i = this.record_index; i < this.record_list.length; i++) {
				if (this.record_index == 0 && i == this.record_list.length - 1) {
					let str = this.record_list[i].replace("<br>", "")
					cur_str = cur_str + str
					break
				}
				if (this.record_list[i] && this.record_list[i].indexOf("<br>") == -1) {
					this.record_list[i] = this.record_list[i] + "<br>"
				}
				cur_str = cur_str + this.record_list[i]


			}
			for (let i = 0; i < this.record_index; i++) {
				if (i == this.record_index - 1) {
					let str = this.record_list[i].replace("<br>", "")
					cur_str = cur_str + str
				} else {
					cur_str = cur_str + this.record_list[i]
				}
			}

			// cur_str = string.sub(cur_str, 1, -2)
			this._record.innerHTML = cur_str
			this._record.style.width = this.parent_wnd ? this.parent_wnd.width : 100
			this._panel.refresh()
			this._panel.scrollTo(0, this._panel.vScrollBar.max)
		}

		this.StarAniTimer = () => {
			this.StarAni()
			this.CancelStopTimer()
		}

		this.StarStopTimer = () => {
			this.CancelAniTimer()
			this.CancelStopTimer()
			// this.stop_ani_timer = GlobalTimerQuest.AddPeriodQuest(() => {
			Laya.timer.once(2000, this, this.StarAniTimer)
			// }, 2, -1)
		}

		this.CancelStopTimer = () => {
			if (this.stop_ani_timer) {
				GlobalTimerQuest.CancelQuest(this.stop_ani_timer)
				this.stop_ani_timer = null
			}
		}

		this.SetData = (...new_args) => {
			this.prams = new_args
			if (!this.is_loaded) {
				this.is_fresh = true
				return
			}
			this.is_fresh = false

			this.base_type = this.prams[0]
			this.sub_type = this.prams[1]
			if (this.prams[2]) {
				this.item_type = this.prams[2]
			}
			if (this.prams[3]) {
				this.hide_prefix = this.prams[3]
			}

			this.mod_id = this.prams[4]
			this.color_ = this.prams[5] ? this.prams[5] : "#5a1c20"
			this.InitView()
		}

		this.Local_DeleteMe = () => {
			this.CancelAniTimer()
			this.CancelStopTimer()
		}
		this.ResetRecord = (type?) => {
			this.type = type
			if (!this.is_loaded) {
				this.need_fresh = true
				return
			}
			this.need_fresh = false
			this.CancelAniTimer()
			let list = []
			if (this.record_info) {
				if (type == this.ComActRecordType.this_record) {
					list = this.record_info.self_list
				} else {
					list = this.record_info.log_list
				}
			}
			let bool = list && list.length > 0 && true || false
			this._lb_desc.visible = !bool
			if (bool) {
				this.SetRecord(list)
			} else {
				this.SetRecord([])
			}
			this.record_type = type
		}

	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}


	_lb_desc: Laya.Label
	_panel: Laya.Panel
	_record: Laya.HTMLDivElement
	img_bg: Laya.Image
	public GetComponents() {
		[
			this._lb_desc,
			this._panel,
			this._record,
			this.img_bg
		]
			= this.GetChildrenByNames([

				"_lb_desc",
				"_panel",
				"_record",
				"img_bg"
			])
		this._panel.vScrollBar.visible = false
	}
}
window["ComActRecordView"] = ComActRecordView