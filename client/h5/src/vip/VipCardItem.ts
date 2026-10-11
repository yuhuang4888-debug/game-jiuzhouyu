import { BaseItem1 } from "../common/BaseItem1"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { VipModel } from "../commonModel/VipModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, SetSizeDeltaX, SetHtmlCenter } from "../util/Util"
import { GameResPath } from "../util/GameResPath"
import { VipSubFlagItem } from "./VipSubFlagItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { Mathf } from "../util/Mathf"



export class VipCardItem extends BaseItem1 {
	CancelOverTime
	CancelTime
	InitEvent
	SetData
	StartOverTime
	StartTime
	is_delay_callback
	is_free
	onOverTimer
	onTimer
	over_timer_id_
	sohw_list
	timer_id_
	IsShowElement
	CreatFlagItem
	left_label_scroller
	right_label_scroller
	UpdateVipStageInfo


	public constructor(parent?, prefab_asset?, layer_value?, card_type?) {
		super(parent)

		this.sohw_list = [];
		this.is_free = false;
		this.base_file = "vip"
		this.layout_file = "VipCardItem"
		this.left_label_scroller = null
		this.right_label_scroller = null
		let over_time_ = null
		this.over_timer_id_ = null
		let client_config_data_ = null
		let server_config_data_ = null
		let need_refresh_ = null
		let show_tips_cfg_ = null
		let now_server_cfg_ = null
		let end_time_ = null
		this.timer_id_ = null
		let card_type_ = null
		let now_price_ = null
		let msg = Message
		let time_util = TimeUtil
		let vipM = VipModel
		let vip_model = vipM.GetInstance()

		card_type_ = card_type

		this.load_callback = () => {

			this.button_label.style.fontSize=20
			this.button_label.style.color="#ffffff"
			this.button_label.style.stroke=2
			this.button_label.style.strokeColor="#d15e30"
			this.button_label.style.wordWrap = false
			this.show_label_1.style.fontSize=24
			this.show_label_1.style.color="#ffffff"
			this.show_label_1.style.wordWrap=false
			this.show_label_2.style.fontSize=24
			this.show_label_2.style.color="#ffffff"
			this.show_label_2.style.wordWrap=false
			this.show_label_3.style.fontSize=24
			this.show_label_3.style.color="#ffffff"
			this.show_label_3.style.wordWrap=false
			this.lable_level_des.style.fontSize = 16
			this.lable_level_des.style.color="#663915"
			this.lable_level_des.style.wordWrap = false

			this.IsShowElement()
			for (let i = 1; i <= 3; i++) {

				this["imgshow_point_" + i] = this["show_point_"+i] //this.GetChild("_Group1/privilege_group/show_point_" + i).GetComponent("Image")
				this["textshow_label_" + i] = this["show_label_"+i] //this.GetChild("_Group1/privilege_group/show_label_" + i).GetComponent("Text")
			}
			for (let i = 1; i <= 3; i++) {
				this["textshow_label_" + i].fontSize = 20
				// this.more_label.fontSize = 18
			}
			this.InitEvent()
		}

		this.IsShowElement = () => {
			this.privilege_group.visible = false
			this.more_btn.visible = false
			this.more_label.visible = false
			this._Image1.visible = true
			this.line_img.visible = true
		}

		this.InitEvent = () => {
			let refresh_data = () => {
                this.UpdateVipStageInfo()
				let card_data = vip_model.noble_Card_info[server_config_data_.vip_type]
				this.offer_img.visible = false
				this.StartOverTime(card_data.time)
            }
            this.BindEvent(vip_model ,VipModel.CHANGE_DISCOUNT_IMG_AND_REFRESH_CARD_ITEM, refresh_data)

			let OnActiveBtnClick = () => {
				if (!server_config_data_) {
					return
				}
				if (server_config_data_.price == 0) {
					if (end_time_ && end_time_ > time_util.getServerTime()) {
						msg.show("领取条件不足")
					} else {
						vip_model.Fire(vipM.REQUEST_PROTO, 45007, "c", server_config_data_.vip_type)
					}
				} else {
					if (vip_model.active_card_type && server_config_data_.vip_type < vip_model.active_card_type) {
						msg.show("您已激活更高等级的特权卡")
					} else if (vip_model.active_card_type && server_config_data_.vip_type == vip_model.active_card_type) {
						msg.show("您已激活此特权")
					} else {
						if (!now_price_ && server_config_data_) {
							now_price_ = server_config_data_.price
						}
						if (RoleManager.GetInstance().GetMainRoleVo().jin >= now_price_) {
							vip_model.Fire(vipM.BUY_VIP_CARD, server_config_data_.vip_type)
						} else {
							OpenFun.OpenFunHandler(21)
						}
					}
				}
			}

			Util.AddClickEvent(this.btn_group, OnActiveBtnClick, this, true)
			Util.AddClickEvent(this.more_btn, () => {
				if (show_tips_cfg_) {
					vip_model.Fire(vipM.OPEN_VIEW, "VipRuleView", show_tips_cfg_)
				}
			}
				, this, true)
		}

		this.SetData = (client_cfg?, server_cfg?, show_tips_cfg?, now_server_cfg?) => {
			//ClientVipPrivilege
			client_config_data_ = client_cfg
			//Config.Vipcard
			server_config_data_ = server_cfg
			show_tips_cfg_ = show_tips_cfg
			now_server_cfg_ = now_server_cfg
			if (this.is_loaded) {
				this.button_label.width=120
				// this.button_label.GetComponent("Outline").enabled = true
				// let bg_url = "resource/game/vip/texture/" + client_config_data_.card_bg + ".png"
				let bg_url = "resource/game/vip/texture/" + client_config_data_.card_bg + ".png"
				ResManager.GetInstance().SetOutsideImageSprite(this, this.card_bg, bg_url, true)
				// this.card_img.source = "vip_asset." + client_config_data_.card_img + ""
				// this.card_name_img.source = "vip_asset." + client_config_data_.card_name + ""
				// this.lv_up_img.source = "vip_asset.uivip_034(" + (16 - server_config_data_.give_lv) + ")"
				// this.more_btn.source = "vip_asset." + client_config_data_.more_btn + ""
				// ResManager.GetInstance().SetOutsideImageSprite(this, this.card_img, GameResPath.GetIcon("vip", client_config_data_.card_img), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.card_img, GameResPath.GetIcon("vip", client_config_data_.card_img), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.card_name_img, GameResPath.GetIcon("vip", client_config_data_.card_name), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.lv_up_img, GameResPath.GetIcon("vip", "uivip_034(" + (16 - server_config_data_.give_lv) + ")"), true)
				ResManager.GetInstance().SetImageSprite(this, this.more_btn, "vip_asset", client_config_data_.more_btn, true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.image_vip_exp_front, GameResPath.GetIcon("vip", "vipui_slider_front"), false)

				ResManager.GetInstance().SetOutsideImageSprite(this, this.image_bg_left, GameResPath.GetIcon("vip", "uivip_info_bg_35"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.image_bg_right, GameResPath.GetIcon("vip", "uivip_info_bg_36"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.image_title_left, GameResPath.GetIcon("vip", "vipui_privilege_num"), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.image_title_right, GameResPath.GetIcon("vip", "vipui_privilege_add"), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.image_little_vip_1, GameResPath.GetIcon("vip", "uivip_030e"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.image_little_vip_2, GameResPath.GetIcon("vip", "uivip_032c"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.image_little_vip_4, GameResPath.GetIcon("vip", "uivip_033c"), false)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.offer_img, GameResPath.GetIcon("vip", "uivip_limit_31"), false)
				
				

				
				this.more_label.text = "点击查看更多"
				if (server_config_data_.price == 0) {
					this.free_img.visible = true
					// ResManager.GetInstance().SetImageSprite(this, this.free_img, "vip_asset", client_config_data_.free_img, true)
					ResManager.GetInstance().SetOutsideImageSprite(this, this.free_img, "resource/game/vip/texture/" + client_config_data_.free_img + ".png", true)
					this.price_group.visible = false
					this.button_label.innerHTML = ""
					// this.button_label.GetComponent("Outline").effectColor = ColorUtil.TryParseHtmlString("#62a932")
					// ResManager.GetInstance().SetImageSprite(this, this.button_img, "vip_asset", "ui_009b.png", true)
					this.button_img.skin = "resource/game/common/texture/com_rect_btn2.png"
					this.red_dot.visible = false
					if (vip_model.can_receve_card_list) {
						this.button_label.style.fontSize = 26
						let end_time = null
						for (let _tmpi in vip_model.can_receve_card_list) {
							var vo = vip_model.can_receve_card_list[_tmpi]
							if (vo.use_card == server_config_data_.vip_type) {
								end_time = vo.time
							}
						}
						this.CancelTime()
						if (end_time != 2) {
							if (end_time - time_util.getServerTime() <= 0) {
								this.red_dot.visible = true
								this.button_label.innerHTML = "立即领取"
							} else {
								this.StartTime(end_time)
							}
						} else {
							this.button_label.innerHTML = "已领取"
							// Util.SetImageGray(this.button_label, true)
							// Util.SetImageGray(this.button_label, true)
							// this.button_label.GetComponent("Outline").enabled = false
							// Util.SetImageGray(this.button_img.GetComponent("ImageExtend"), true)
							// this.button_img.touchEnabled = false
						}
					}
				} else {
					this.free_img.visible = false
					this.price_group.visible = true
					// ResManager.GetInstance().SetImageSprite(this, this.button_img, "vip_asset", "ui_009a.png", true)
					this.button_img.skin = "resource/game/common/texture/com_rect_btn1.png"
					// ResManager.GetInstance().SetImageSprite(this, this.price_bg, "vip_asset", client_config_data_.price_bg, true)
					ResManager.GetInstance().SetOutsideImageSprite(this, this.price_bg, GameResPath.GetIcon("vip", client_config_data_.price_bg), false)
					this.old_price_label.text = client_config_data_.old_price.toString()
					// this.old_price.text = client_config_data_.old_price
					// this.button_label.strokeColor = "#d15e30"
					// this.button_label.GetComponent("Outline").effectColor = ColorUtil.TryParseHtmlString("#d15e30")
					// [ts2lua]vip_model.noble_Card_info下标访问可能不正确
					let card_data = vip_model.noble_Card_info[server_config_data_.vip_type]
					if (card_data && card_data.is_active == 1) {
						if (card_data.is_forever != 0) {
							// this.button_label.textFlow = Util.StrToHTML("<font size=26>已永久激活</font>")
							this.button_label.style.fontSize = 26
							this.button_label.innerHTML = Util.StrToHTML("已永久激活")
						} else {
							this.StartOverTime(card_data.time)
						}
						if (server_config_data_.vip_type == 4) {
							// this.ClearUIEffect(this.button_effect_group)
						}
					} else {
						if (server_config_data_.vip_type == 4) {
							// this.AddUIEffect2("ui_button1_1", this.button_effect_group, null, 1.4, true)
						}
						// this.button_label.textFlow = Util.StrToHTML("<font size=26>立即开通</font>")
						this.button_label.style.fontSize = 26
						this.button_label.innerHTML = Util.StrToHTML("立即开通")
						this.button_label.x= this.btn_group.width / 2-this.button_label.contextWidth/2
						this.button_label.y= this.btn_group.height / 2-this.button_label.contextHeight/2
					}
					// if ((vip_model.active_card_type && vip_model.active_card_type > 3) && vip_model.active_card_type < server_config_data_.vip_type ) {
					if (vip_model.active_card_type && vip_model.active_card_type < server_config_data_.vip_type && !(vip_model.HasTempCard() && 1 == vip_model.active_card_type)) {
						this.offer_img.visible = true
						if (now_server_cfg_) {
							// this.old_price_label.text = "V" + vip_model.active_card_type + "卡折扣减" + now_server_cfg_.price + "勾玉"
							this.now_price_label.text = (server_config_data_.price - now_server_cfg_.price).toString()
							now_price_ = server_config_data_.price - now_server_cfg_.price
						}
					} else {
						// this.old_price_label.text = ""
						// this.offer_img.visible = false
						this.offer_img.visible = false
						this.now_price_label.text = server_config_data_.price
						now_price_ = server_config_data_.price
					}
					// this.line_img.source = "vip_asset." + client_config_data_.line_img + ""
					ResManager.GetInstance().SetImageSprite(this, this.line_img, "vip_asset", client_config_data_.line_img, true)
					this.CancelTime()
				}
				let i = 0
				do {
					let vo = client_config_data_.show_tips[i]
					if (vo) {
						// [ts2lua]this下标访问可能不正确
						// this["show_point_" + (i + 1].source) = "vip_asset." + client_config_data_.point_img + ""
						ResManager.GetInstance().SetImageSprite(this, this["imgshow_point_" + (i + 1)], "vip_asset", client_config_data_.point_img, true)
						// [ts2lua]this下标访问可能不正确
						this["show_label_" + (i + 1)].innerHTML = Util.StrToHTML(vo)
					}
					i = i + 1
				} while ((i < client_config_data_.show_tips.length))

				for (let i = client_config_data_.show_tips.length + 1; i <= 3; i++) {
					this["show_label_" + (i + 1)].innerHTML = ""
				}
				this.button_label.x= this.btn_group.width/2-this.button_label.contextWidth/2
				this.button_label.y= this.btn_group.height/2-this.button_label.contextHeight/2
				// let i = client_config_data_.show_tips.length + 1
				this.UpdateVipStageInfo()
				this.CreatFlagItem()
			}
		}

		this.CreatFlagItem = () => {
			let creat_entity = (parent?, data?, sroller?) => {
				if(data){
					if (!sroller) {
						sroller = new LoopScrowViewMgr()
						sroller.SetData(parent, VipSubFlagItem, data, LoopScrCon.Vertical)
					}else{
						sroller.replaceAll(data)
					}
				}

				// for (let key in data) {
				// 	let flag_item = list_content[key]
				// 	if(!flag_item){
				// 		flag_item = new VipSubFlagItem(parent)
				// 		list_content[key] = flag_item
				// 		flag_item.Load()
				// 	}
				// 	if(flag_item){
				// 		flag_item.ExcuteCallback(() => {
				// 			flag_item.SetData(data[key])
				// 		})
				// 	}
				// }
			}
			let left_flag_array = client_config_data_.left_show_tip
			let right_flag_array = client_config_data_.right_show_tip

			creat_entity(this.list_left, left_flag_array, this.left_label_scroller)
			creat_entity(this.list_right, right_flag_array, this.right_label_scroller)
		}

		this.UpdateVipStageInfo = () => {
			const vip_exp_max_len = 310
			const V4_max_exp = 250
			const per_exp_need_money = 100
			const max_vip_lv = 4
			
			let vip_lv = vip_model.GetVipLevel()
			if(vip_lv != 0 && vip_lv < max_vip_lv){
				let cur_exp = vip_model.GetExp()
				let need_exp = vip_model.GetNextStageExp()
				SetSizeDeltaX(this.image_vip_exp_front, vip_exp_max_len * Mathf.Min(1, cur_exp / V4_max_exp))
				this.lable_vip_exp_value.text = `${Math.ceil(cur_exp)}/${V4_max_exp}`
				let need_money = (V4_max_exp - cur_exp) * per_exp_need_money
				// SetHtmlCenter(this.lable_level_des, { "x": this.lable_level_des.parent["width"]/2 , "w": 30 })
				this.lable_level_des.x = 85
				this.lable_level_des.y = 25
				this.lable_level_des.innerHTML = Util.StrToHTML(`还需消费<font color='#fe1a1a'>${need_money}</font>勾玉升至V4`)
			}
			else{
				let len = null
				if(vip_lv == 0){
					// SetHtmlCenter(this.lable_level_des, {"x": this.lable_level_des.parent["width"]/2, "w": 30})
					this.lable_level_des.x = -15
					this.lable_level_des.y = 25
					this.lable_level_des.innerHTML =  Util.StrToHTML("还需消费<font color='#fe1a1a'>25000</font>勾玉升至V4<font color='#fe1a1a'>(购买VIP卡可获得经验)</font>")
					this.lable_vip_exp_value.text = "0/250"
					len = 0
				}
				else{
					// SetHtmlCenter(this.lable_level_des, {"x": this.lable_level_des.parent["width"]/2, "w": 30})
					this.lable_level_des.x = 107
					this.lable_level_des.y = 25
					this.lable_level_des.innerHTML = Util.StrToHTML("恭喜已达到V4等级")
					this.lable_vip_exp_value.text = "已达V4"
					len = vip_exp_max_len
				}
				SetSizeDeltaX(this.image_vip_exp_front, len)
			}
			
		}

		this.StartTime = (end_time?) => {
			this.CancelTime()
			end_time_ = end_time
			this.timer_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.onTimer()
			}, 1, -1)
			this.onTimer()
		}

		this.onTimer = () => {
			let close_time = end_time_ - time_util.getServerTime()
			if (close_time <= 0) {
				this.CancelTime()
				this.button_label.innerHTML = "立即领取"
				return
			} else {
				this.button_label.style.fontSize = 20
				if (this.button_label) {
					this.button_label.innerHTML = Util.StrToHTML(time_util.timeConvert(close_time, "hh:mm:ss") + "后<br/>免费领取")
				}
			}
			this.button_label.x=this.btn_group.width/2-this.button_label.contextWidth/2
			this.button_label.y=this.btn_group.height/2-this.button_label.contextHeight/2
		}

		this.CancelTime = () => {
			if (this.timer_id_) {
				GlobalTimerQuest.CancelQuest(this.timer_id_)
				this.timer_id_ = null
			}
			if(this.over_timer_id_){
				GlobalTimerQuest.CancelQuest(this.over_timer_id_)
				this.over_timer_id_=null
			}
		}

		this.StartOverTime = (end_time?) => {
			over_time_ = end_time
			this.CancelTime()
			this.CancelOverTime()
			this.over_timer_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.onOverTimer()
			}, 1, -1)
			this.onOverTimer()
		}

		this.onOverTimer = () => {
			let close_time = over_time_ - time_util.getServerTime()
			if (close_time <= 0) {
				this.CancelTime()
				this.button_label.style.fontSize = 26
				this.button_label.innerHTML = "立即开通"
				return
			} else {
				if (this.button_label) {
					this.button_label.style.fontSize = 20
					// if (! isNaN(Number(close_time)) ) {
					if (Number(close_time)) {
						this.button_label.innerHTML = Util.StrToHTML(time_util.convertTimeColor(close_time) + "后失效")
					}
				}
			}
			this.button_label.x= this.btn_group.width / 2-this.button_label.contextWidth/2
			this.button_label.y= this.btn_group.height / 2-this.button_label.contextHeight/2
		}

		this.CancelOverTime = () => {
			if (this.over_timer_id_) {
				if (this.over_timer_id_) {
					GlobalTimerQuest.CancelQuest(this.over_timer_id_)
					this.over_timer_id_ = null
				}
			}
		}
	}

	public DeleteMe() {

		if (this.left_label_scroller) {
			this.left_label_scroller.DeleteMe()
			this.left_label_scroller = null
		}

		if (this.right_label_scroller) {
			this.right_label_scroller.DeleteMe()
			this.right_label_scroller = null
		}
		// this.ClearUIEffect(this.button_effect_group)
		this.CancelTime()
		this.CancelOverTime()
		super.DeleteMe()
	}


_Group1:Laya.Box
card_bg:Laya.Image
card_img:Laya.Image
card_name_img:Laya.Image
lv_up_img:Laya.Image
free_img:Laya.Image
privilege_group:Laya.Box
show_point_1:Laya.Image
show_point_2:Laya.Image
show_point_3:Laya.Image
show_label_1:Laya.HTMLDivElement
show_label_2:Laya.HTMLDivElement
show_label_3:Laya.HTMLDivElement
btn_group:Laya.Box
button_img:Laya.Image
button_label:Laya.HTMLDivElement
button_effect_group:Laya.Box
more_btn:Laya.Image
more_label:Laya.Label
offer_img:Laya.Image
red_dot:Laya.Image
price_group:Laya.Box
price_bg:Laya.Image
_Label1:Laya.Label
old_price_info:Laya.Label
_Image1:Laya.Image
line_img:Laya.Image
old_price_label:Laya.Label
_Label2:Laya.Label
_Image2:Laya.Image
now_price_label:Laya.Label
box_vip_exp:Laya.Box
image_vip_exp_bg:Laya.Image
lable_vip_1:Laya.Label
lable_vip_2:Laya.Label
lable_vip_4:Laya.Label
lable_level_des:Laya.HTMLDivElement
image_vip_exp_front:Laya.Image
image_little_vip_1:Laya.Image
image_little_vip_2:Laya.Image
image_little_vip_4:Laya.Image
lable_vip_exp_value:Laya.Label
_Group2:Laya.Box
image_bg_left:Laya.Image
image_title_left:Laya.Image
list_left:Laya.List
image_bg_right:Laya.Image
image_title_right:Laya.Image
list_right:Laya.List
public GetComponents() {
[
this._Group1,
this.card_bg,
this.card_img,
this.card_name_img,
this.lv_up_img,
this.free_img,
this.privilege_group,
this.show_point_1,
this.show_point_2,
this.show_point_3,
this.show_label_1,
this.show_label_2,
this.show_label_3,
this.btn_group,
this.button_img,
this.button_label,
this.button_effect_group,
this.more_btn,
this.more_label,
this.offer_img,
this.red_dot,
this.price_group,
this.price_bg,
this._Label1,
this.old_price_info,
this._Image1,
this.line_img,
this.old_price_label,
this._Label2,
this._Image2,
this.now_price_label,
this.box_vip_exp,
this.image_vip_exp_bg,
this.lable_vip_1,
this.lable_vip_2,
this.lable_vip_4,
this.lable_level_des,
this.image_vip_exp_front,
this.image_little_vip_1,
this.image_little_vip_2,
this.image_little_vip_4,
this.lable_vip_exp_value,
this._Group2,
this.image_bg_left,
this.image_title_left,
this.list_left,
this.image_bg_right,
this.image_title_right,
this.list_right,
]
 = this.GetChildrenByNames([

"_Group1",
"card_bg",
"card_img",
"card_name_img",
"lv_up_img",
"free_img",
"privilege_group",
"show_point_1",
"show_point_2",
"show_point_3",
"show_label_1",
"show_label_2",
"show_label_3",
"btn_group",
"button_img",
"button_label",
"button_effect_group",
"more_btn",
"more_label",
"offer_img",
"red_dot",
"price_group",
"price_bg",
"_Label1",
"old_price_info",
"_Image1",
"line_img",
"old_price_label",
"_Label2",
"_Image2",
"now_price_label",
"box_vip_exp",
"image_vip_exp_bg",
"lable_vip_1",
"lable_vip_2",
"lable_vip_4",
"lable_level_des",
"image_vip_exp_front",
"image_little_vip_1",
"image_little_vip_2",
"image_little_vip_4",
"lable_vip_exp_value",
"_Group2",
"image_bg_left",
"image_title_left",
"list_left",
"image_bg_right",
"image_title_right",
"list_right",
])
}
}
 window["VipCardItem"]= VipCardItem