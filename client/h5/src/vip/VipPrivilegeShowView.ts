import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { VipModel } from "../commonModel/VipModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { VipAwardItem } from "./VipAwardItem"
import { VipInstructionItem } from "./VipInstructionItem"
import { PlatformManager } from "../PlatformManager"

export class VipPrivilegeShowView extends BaseItem1 {

	InitEvent
	InitTab
	LoadSuccess
	SelectVipLv
	SetExclusiveGift
	SetLabel
	SetWeekItem
	destroy_callback
	extend_receive_btn
	gift_group
	gift_scroller_content
	item_list_
	labelCollection_
	preload_client_config
	scmd_receive_gift_id
	vip_scroller_content


	is_show_buy_red_point = true

	public constructor(parent?) {
		super(parent)

		this.base_file = "vip"
		this.layout_file = "VipPrivilegeShowView"
		this.labelCollection_ = null
		let is_received_ = null
		let select_vip_lv_ = 1
		let gift_config_ = null
		let privilegeCfg_ = null
		let show_list_ = []
		this.item_list_ = []
		let award_list_ = []
		let client_vip_config_ = null
		let forceSelect_ = null
		let resMgr = ResManager.GetInstance()
		let vipM = VipModel
		let vip_model = vipM.GetInstance()
		let local_util = Util
		let msg = Message
		let g_model = GoodsModel.GetInstance()
		this.preload_client_config = {
			"ClientVipPrivilege": false
		}
		this.preload_server_config = {
			"config_vip_config": false
		}
		this.load_callback = () => {

			this.vip_scroller.scrollBar.visible=false
			this.gift_scroller.hScrollBar.visible=false
			this.LoadSuccess()
		}

		// this.destroy_callback = () => {

		// }

		// this.preload_client_config = [ClientVipPrivilege=false]
		this.LoadSuccess = () => {
			privilegeCfg_ = this.preload_client_config["ClientVipPrivilege"]
			gift_config_ = this.preload_server_config["config_vip_config"]
			if (privilegeCfg_ && gift_config_) {
				this.InitTab()
				// [ts2lua]lua中0和空字符串也是true，此处forceSelect_ || vip_model.GetVipLevel() > 0需要确认
				let default_lv = (forceSelect_ || vip_model.GetVipLevel() > 0 && (vip_model.GetVipLevel()) || (1))
				forceSelect_ = null
				this.SetLabel(default_lv)
				this.InitEvent()
			}
			resMgr.SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("vip", "ui_Recharge_11"))
			resMgr.SetOutsideImageSprite(this, this.bg11, GameResPath.GetIcon("vip", "uivip_011"))
			resMgr.SetImageSpriteTrans(this, this.bg2, GameResPath.GetIcon("vip", "uivip_012"), true)
			resMgr.SetOutsideImageSprite(this, this.bg3, GameResPath.GetIcon("vip", "uivip_038_new"))

			resMgr.SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("vip", "uivip_038"), true)
			resMgr.SetImageSpriteTrans(this, this._Image2, GameResPath.GetIcon("vip", "uivip_038"), true)

			// this.RegisterMask(this.gift_group)

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.labelDisplay.size  = 18
			// }
		}

		this.SetLabel = (lv?) => {
			if ((lv <= 0 || lv > vip_model.max_vip_lv) || !privilegeCfg_) {
				return
			}
			// [ts2lua]privilegeCfg_下标访问可能不正确
			show_list_ = privilegeCfg_[lv]
			if (show_list_) {
				select_vip_lv_ = lv
				//策划说要支持非数组
				let list_arr = []
				for (let k in show_list_) {
					var v = show_list_[k]
					if (k != "show_vip_lv") {
						table.insert(list_arr, v)
					}
				}
				table.sort(list_arr, (a?, b?) => {
					return b.new < a.new
				}
				)			
				if(list_arr){
					if (!this.labelCollection_) {
						this.labelCollection_ = new LoopScrowViewMgr()
						this.labelCollection_.SetData(this.vip_scroller, VipInstructionItem, list_arr, LoopScrCon.Vertical)
					}else{
						this.labelCollection_.replaceAll(list_arr)
					}
				}
			}
			this.SelectVipLv(lv)
		}

		this.InitEvent = () => {
			let OnReceiveBtnClick = () => {
				if (select_vip_lv_ > vip_model.GetVipLevel()) {
					msg.show("未达到VIP等级")
					return
				}
				if (is_received_) {
					msg.show("已经领取")
					return
				}

				let reward_cost = JSON.parse(this.preload_server_config["config_vip_config"][select_vip_lv_].reward_cost)
				reward_cost = reward_cost[0][2]
				Alert.Show(`是否花费<font color='#639c12'>${reward_cost}勾玉</font>购买<font color='#639c12'>V${select_vip_lv_}特权礼包</font>`, Alert_Type.Two, () => {
					if (RoleManager.GetInstance().GetMainRoleVo().jin < Number(reward_cost)) {
						OpenFun.OpenFunHandler(21)
						return
					}

					if (this.scmd_receive_gift_id) {
						vip_model.UnBind(this.scmd_receive_gift_id)
						this.scmd_receive_gift_id = null
					}
					this.scmd_receive_gift_id = vip_model.Bind(vipM.SCMD_RECEIVE_EXCLUSIVE_GIFT, () => {
						let award_data = []
						for (let _tmpi in award_list_) {
							var award = award_list_[_tmpi]
							// let data = []
							// table.insert(data, 0)
							// table.insert(data, award.typeId)
							// table.insert(data, award.rewardNum)
							table.insert(award_data,[0,award.typeId,award.rewardNum])
						}
						let view = new CongratulationObtainView(award_data, 10)
						view.Open()
					})

					vip_model.Fire(vipM.RECEIVE_EXCLUSIVE_GIFT, select_vip_lv_)
				}, null, "确定", "取消")
			}

			Util.AddClickEvent(this.receive_btn, OnReceiveBtnClick, this, true)
			let OnWeekBtnClick = () => {
				// [ts2lua]vip_model.can_get_week_list下标访问可能不正确
				if (vip_model.can_get_week_list && vip_model.can_get_week_list[select_vip_lv_]) {
					vip_model.select_vip_lv=select_vip_lv_
					vip_model.Fire(vipM.RECEIVE_WEEK_GIFT, select_vip_lv_)
				} else {
					vip_model.Fire(vipM.OPEN_VIEW, "VipWeekGiftView", select_vip_lv_)
				}
			}

			Util.AddClickEvent(this.vip_box_btn, OnWeekBtnClick, this, true)
			let FlyReWard = (list?) => {
				if (list) {
					// let point = this.vip_box_btn.localToGlobal(20, 20)
					// if (point ) {
					// 	GlobalEventSystem.Fire(EventName.REWARD_FLY, list, {x=point.x, y=point.y})
					// }
					let view = new CongratulationObtainView(list, 10)
					view.Open()
				}
			}

			this.BindEvent(vip_model, vipM.GET_WEEK_REWARD, FlyReWard)
			let OnReceiveSuccess = () => {
				this.SetLabel(select_vip_lv_)
			}

			this.BindEvent(vip_model, vipM.UPDATE_VIP_DATA, OnReceiveSuccess)
			Util.AddClickEvent(this.left_btn, () => {
				this.SetLabel(select_vip_lv_ - 1)
			}
				, this, true)
			// , this)
			Util.AddClickEvent(this.right_btn, () => {
				this.SetLabel(select_vip_lv_ + 1)
			}
				, this, true)
			// , this)
		}

		this.InitTab = () => {
			// if (!this.labelCollection_) {
			// 	this.labelCollection_ = new LoopScrowViewMgr()
			// }
		}

		this.SelectVipLv = (lv?) => {
			if (lv <= 1) {
				this.left_btn.visible = false
			} else {
				this.left_btn.visible = true
			}
			// if (lv >= vip_model.max_vip_lv ) {
			// 	this.right_btn.visible = false 
			// }else{
			// 	this.right_btn.visible = true 
			// }
			let vip_lv = vip_model.GetVipLevel()
			let show_lv = this.preload_client_config["ClientVipPrivilege"][lv + 1] && this.preload_client_config["ClientVipPrivilege"][lv + 1].show_vip_lv
			if (show_lv!=undefined && vip_lv >= show_lv) {
				this.right_btn.visible = true
			} else {
				this.right_btn.visible = false
			}

			// this.top_vip_img.source = "vip_asset.uivip_041(" + lv + ")"
			ResManager.GetInstance().SetOutsideImageSprite(this, this.top_vip_img, GameResPath.GetIcon("vip", "icon_tq_" + lv) , true)
			let left_red = false
			let right_red = false
			for (let key in vip_model.can_get_week_list) {

				if (key < lv) {
					left_red = true
				} else if (key > lv) {
					right_red = true
				}
			}
			if (!left_red || !right_red) {
				//这里专享礼包改成付费了，不用做红点判断
				// for (let i = 1; i <= vip_model.GetVipLevel(); i++){
				// 	if (! vip_model.has_get_award[i] ) {
				// 		if (lv > i ) {
				// 			left_red = true
				// 		} else if (lv < i ) {
				// 			right_red = true
				// 		}
				// 	}
				// 	if (right_red && left_red ) {
				// 		break
				// 	}
				// }
			}
			this.left_red.visible = left_red
			this.right_red.visible = right_red
			this.SetExclusiveGift(lv)
			this.SetWeekItem(lv)

			let cfg = this.preload_server_config["config_vip_config"][lv]
			let reward_cost =JSON.parse(cfg.reward_cost)
			this.txt_old_price.text = cfg.value
			this.txt_new_price.text = reward_cost[0][2]
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward_cost[0][0], reward_cost[0][1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.img_new_cost, "resource/game/goodsIcon/" + goods_vo.goods_icon + ".png")
			ResManager.GetInstance().SetOutsideImageSprite(this, this.img_old_cost, "resource/game/goodsIcon/" + goods_vo.goods_icon + ".png")
			if(cfg.value>=10000){
				this.txt_underline.text="______"
				this.img_old_cost.x=110
			}else if(cfg.value>=1000){
				this.txt_underline.text="_____"	
				this.img_old_cost.x=100			
			}else {
				this.txt_underline.text="____"	
				this.img_old_cost.x=90
			}
		}

		this.SetExclusiveGift = (lv?) => {
			// this.exclusive_vip_img.source = "vip_asset.uivip_042(" + lv + ")"
			ResManager.GetInstance().SetOutsideImageSprite(this, this.exclusive_vip_img, GameResPath.GetIcon("vip", "icon_zx_" + lv) , true)
			// [ts2lua]gift_config_下标访问可能不正确
			let vip_cfg = gift_config_[lv]
			if (!vip_cfg) {
				return
			}
			select_vip_lv_ = lv
			let rewards_attr =JSON.parse(vip_cfg.rewards)
			let goods_count = 0
			for (let i = 0; i < rewards_attr.length; i++) {
				if (Util.TableSize(rewards_attr[i]) == 2) {

				} else {
					let item = this.item_list_[goods_count]
					if (!item) {
						item = new VipAwardItem(this.Content, null, this.layer_value)
						// item.SetScale(0.7)
						table.insert(this.item_list_, item)
						// item.SetMaskId(1)
						item.Load()
						this.item_list_[goods_count] = item
					}else{
						item.display_obj.width=100 //viewport(0,0,127*0.7,127*0.7)
					}
					// item.visible = true
					item.SetVisible(true)
					// item.includeInLayout = true
					// item.SetScale(0.7)
					let [type_id, lock] = g_model.GetMappingTypeId(rewards_attr[i][0], rewards_attr[i][1])
					let goods_vo = g_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						item.SetData(goods_vo.type_id, rewards_attr[i][2], lock)
						item.ExcuteCallback(() => {
							if (goods_vo.color >= 4) {
								item.SetBoxEffect(goods_vo.color)
							} else {
								item.ClearBoxEffect()
							}
						}
						)
					} else {
						// console.log("goodsVo is null type_id:" + type_id)
						console.log("goodsVo is null type_id:" + type_id)
					}
					// award_list_.splice(goods_count, 1, {typeId=type_id, rewardNum=rewards_attr[i][2]})
					award_list_[goods_count] = { typeId: type_id, rewardNum: rewards_attr[i][2] }
					goods_count = goods_count + 1
				}
			}

			for (let i = goods_count; i <= this.item_list_.length; i++) {
				let item = this.item_list_[i]
				if (item) {
					item.display_obj.width=0.0000001 //viewport(0,0,0.00001,0.00001)
					item.SetVisible(false)
					this.Content.refresh()
				}
				table.remove(award_list_, i)
			}

			let item_width = 100
			this.gift_scroller.width = 5 * item_width
			this.gift_scroller.x = (this._Group4.width - this.gift_scroller.width) / 2
			if(rewards_attr.length<6){
				this.Content.x = (this.gift_scroller.width - (goods_count * item_width)) / 2 + 13
			}else{
				this.Content.x = 0
			}
		
			this.gift_scroller.hScrollBar.mouseWheelEnable =  rewards_attr.length>=6
			this.gift_scroller.hScrollBar.touchScrollEnable =  rewards_attr.length>=6

			if (lv > vip_model.GetVipLevel()) {
				this.receive_btn.visible = true
				this.received_img_down.visible = false
				Util.SetImageGray(this.extend_receive_btn, true)
				if (PlatformManager.IsEyouEnPlatform()) {
					this.labelDisplay.fontSize = 18
				}
				this.labelDisplay.text = "Vip" + lv + "可领取"
				// this.labelDisplay.GetComponent("Outline").effectColor = ColorUtil.TryParseHtmlString("#5e5146")
				this.red_dot.visible = false
			} else {
				is_received_ = vip_model.IsReceivedGift(lv)
				if (is_received_) {
					this.receive_btn.visible = false
					this.received_img_down.visible = true
					// Util.SetImageGray(this.extend_receive_btn, true)
					// this.labelDisplay.text = "已领取"
					this.red_dot.visible = false
					// this.labelDisplay.GetComponent("Outline").effectColor = ColorUtil.TryParseHtmlString("#5e5146")
				} else {
					this.receive_btn.visible = true
					this.received_img_down.visible = false
					if (PlatformManager.IsEyouEnPlatform()) {
						this.labelDisplay.fontSize = 22
					}
					this.labelDisplay.text = "领取"
					Util.SetImageGray(this.extend_receive_btn, false)
					// this.red_dot.visible = true 
					this.red_dot.visible = this.is_show_buy_red_point
					// this.labelDisplay.GetComponent("Outline").effectColor = ColorUtil.TryParseHtmlString("#de6025")
				}
			}
		}

		this.SetWeekItem = (lv?) => {
			// [ts2lua]gift_config_下标访问可能不正确
			let vip_cfg = gift_config_[lv]
			if (!vip_cfg) {
				return
			}
			// this.week_vip_img.source = "vip_asset.uivip_042(" + lv + ")"
			ResManager.GetInstance().SetOutsideImageSprite(this, this.week_vip_img, GameResPath.GetIcon("vip", "icon_mr_"+ lv), true)
			if (lv > vip_model.GetVipLevel()) {
				this.vip_box_red_dot.visible = false
				this.received_img.visible = false
				// [ts2lua]vip_model.can_get_week_list下标访问可能不正确
			} else if (vip_model.can_get_week_list && vip_model.can_get_week_list[lv]) {
				this.vip_box_red_dot.visible = true
				this.received_img.visible = false
			} else {
				this.vip_box_red_dot.visible = false
				this.received_img.visible = true
			}
			this.price_label.text = vip_cfg.value
		}
	}

	public SetVisible(state?) {

		super.SetVisible(state)
		//礼包改成付费购买，红点只在第一次显示，之后关闭红点
		if (!state) {
			this.is_show_buy_red_point = false
			if (this.is_loaded) {
				this.red_dot.visible = false
			}
		}
	}

	public DeleteMe() {

		if (this.item_list_) {
			for (let _tmpi in this.item_list_) {
				var vo = this.item_list_[_tmpi]
				vo.DeleteMe()
				vo = null
			}
			this.item_list_ = []
		}
		if (this.labelCollection_) {
			this.labelCollection_.DeleteMe()
			this.labelCollection_ = null
		}

		if (this.scmd_receive_gift_id) {
			VipModel.GetInstance().UnBind(this.scmd_receive_gift_id)
			this.scmd_receive_gift_id = null
		}
		super.DeleteMe()
	}



_Group5:Laya.Box
bg3:Laya.Image
_Image1:Laya.Image
_Image2:Laya.Image
vip_scroller:Laya.List
_Group1:Laya.HBox
top_vip_img:Laya.Image
_Image3:Laya.Image
more_img:Laya.Image
more_label:Laya.Label
_Group4:Laya.Box
bg1:Laya.Image
bg11:Laya.Image
bg2:Laya.Image
gift_scroller:Laya.Panel
Content:Laya.HBox
_Image4:Laya.Image
_Image5:Laya.Image
receive_btn:Laya.Box
_Image11:Laya.Image
labelDisplay:Laya.Label
received_img_down:Laya.Image
_Group2:Laya.HBox
exclusive_vip_img:Laya.Image
_Image6:Laya.Image
vip_box_btn:Laya.Image
_Group3:Laya.HBox
week_vip_img:Laya.Image
_Image7:Laya.Image
_Label1:Laya.Label
price_label:Laya.Label
received_img:Laya.Image
vip_box_red_dot:Laya.Image
red_dot:Laya.Image
group_old:Laya.Box
txt_old_price_desc:Laya.Label
txt_old_price:Laya.Label
img_old_cost:Laya.Image
txt_underline:Laya.Label
group_new:Laya.Box
txt_new_desc:Laya.Label
txt_new_price:Laya.Label
img_new_cost:Laya.Image
left_btn:Laya.Image
right_btn:Laya.Image
left_red:Laya.Image
right_red:Laya.Image
public GetComponents() {
[
this._Group5,
this.bg3,
this._Image1,
this._Image2,
this.vip_scroller,
this._Group1,
this.top_vip_img,
this._Image3,
this.more_img,
this.more_label,
this._Group4,
this.bg1,
this.bg11,
this.bg2,
this.gift_scroller,
this.Content,
this._Image4,
this._Image5,
this.receive_btn,
this._Image11,
this.labelDisplay,
this.received_img_down,
this._Group2,
this.exclusive_vip_img,
this._Image6,
this.vip_box_btn,
this._Group3,
this.week_vip_img,
this._Image7,
this._Label1,
this.price_label,
this.received_img,
this.vip_box_red_dot,
this.red_dot,
this.group_old,
this.txt_old_price_desc,
this.txt_old_price,
this.img_old_cost,
this.txt_underline,
this.group_new,
this.txt_new_desc,
this.txt_new_price,
this.img_new_cost,
this.left_btn,
this.right_btn,
this.left_red,
this.right_red,
]
 = this.GetChildrenByNames([

"_Group5",
"bg3",
"_Image1",
"_Image2",
"vip_scroller",
"_Group1",
"top_vip_img",
"_Image3",
"more_img",
"more_label",
"_Group4",
"bg1",
"bg11",
"bg2",
"gift_scroller",
"Content",
"_Image4",
"_Image5",
"receive_btn",
"_Image11",
"labelDisplay",
"received_img_down",
"_Group2",
"exclusive_vip_img",
"_Image6",
"vip_box_btn",
"_Group3",
"week_vip_img",
"_Image7",
"_Label1",
"price_label",
"received_img",
"vip_box_red_dot",
"red_dot",
"group_old",
"txt_old_price_desc",
"txt_old_price",
"img_old_cost",
"txt_underline",
"group_new",
"txt_new_desc",
"txt_new_price",
"img_new_cost",
"left_btn",
"right_btn",
"left_red",
"right_red",
])
}
}
 window["VipPrivilegeShowView"]= VipPrivilegeShowView