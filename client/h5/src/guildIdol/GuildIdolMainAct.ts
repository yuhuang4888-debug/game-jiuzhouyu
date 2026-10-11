import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util, Trim, SetAnchoredPositionX, Color, HtmlColorTxt, SetHtmlCenter } from "../util/Util"
import { GuildIdolAttrItem } from "./GuildIdolAttrItem"
import { GuildIdolShowItem } from "./GuildIdolShowItem"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";

export class GuildIdolMainAct extends BaseItem1 {
	// Can_gp_left
	// Can_gp_right
	Can_img_arrow
	Emp_btn
	Emp_gp_btn
	InitEvent
	LoadSuccess
	Local_DeleteMe
	Out_lb_btn
	Scr_Scroller1
	Scr_Scroller2
	actEffect
	initAttr
	preload_server_config
	upEffect
	updateCost
	updateSelect
	tween_list = []
	_fight_show: FightingShowSmallItem;

	left_pos = 11
	right_pos = 266
	center_pos = 137
	durtime = 180
	cost_arr

	public constructor(parent?) {
		super(parent)

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolMainAct"
		this.layer_value = Enum_UILayer.UI
		let _model = GuildModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let _refresh = false
		let _god_id = 1
		let ACT = 0
		let UP = 1
		let state = ACT
		let local_GuildEvent = GuildEvent
		let click_time = 0
		let item_list = []
		let item_list2 = []
		let cost_list = []
		let left_show_item = null
		let right_show_item = null
		let can_up = true
		this.cost_arr=[]
		this.load_callback = () => {

			this._Scroller1.vScrollBarSkin = ""
			this._Scroller2.vScrollBarSkin = ""
			this.InitEvent()
			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_name.size  = 20
			// }
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_btn, () => {
				if(!this._red.visible){
					Alert.Show("物品不足，是否前往商店购买？", Alert_Type.Two, () => {
						OpenFun.OpenFunHandler(239,this.cost_arr[0]||0)
					}, null, "确定", "取消")
					return
				}

				//this.upEffect()
				if (TimeUtil.getServerTimeMs() - click_time < 1000) {
					return
				}
				if (!can_up) {
					Message.show('已达到最高级')
					return
				}
				click_time = TimeUtil.getServerTimeMs()
				_model.Fire(local_GuildEvent.REQUEST_PROTO, 40503, "h", _god_id)
			}
				, this, true)

			this.BindEvent(_model, local_GuildEvent.IDOL_UP, (lv?) => {
				if (lv == 1) {
					this.actEffect()
				} else {
					this.upEffect()
				}
			}
			)

			this.BindEvent(goods_model, GoodsModel.CHANGE_BAG_LIST, () => {
				if (!this.use_delete_method) {
					this.updateCost()
				}
			}
			)

			if (!this._fight_show) {
				this._fight_show = new FightingShowSmallItem(this._fight_con)
				this._fight_show.Load()
				this._fight_show.ExcuteCallback(() => {
				})
			}
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath("ui_Guild_bg2.jpg"), true)
			if (_refresh) {
				this.updateSelect(_god_id)
			}
		}

		this.Local_DeleteMe = () => {
			if (this.tween_list && this.tween_list.length > 0) {
				for (let _ in this.tween_list) {
					var tween_id = this.tween_list[_]
					SYTweenLite.Stop(tween_id)
				}
				this.tween_list = []
			}

			for (let key in item_list) {

				let item = item_list[key]
				item.DeleteMe()
			}
			item_list = []

			for (let key in item_list2) {

				let item = item_list2[key]
				item.DeleteMe()
			}
			item_list2 = []

			for (let key in cost_list) {

				let item = cost_list[key]
				item.DeleteMe()
			}
			cost_list = []

			if (left_show_item) {
				left_show_item.DeleteMe()
				left_show_item = null
			}
			if (right_show_item) {
				right_show_item.DeleteMe()
				right_show_item = null
			}

			if (this._fight_show) {
				this._fight_show.DeleteMe();
				this._fight_show = null;
			}
		}

		this.updateSelect = (god_id) => {
			_god_id = Number(god_id)
			if (!this.is_loaded) {
				_refresh = true
				return
			}

			ResManager.GetInstance().SetTexture(this, this._img, "resource/game/guildidol/texture/figure" + god_id + ".png")
			this._gp_left.alpha = 1;
			this._gp_left.x = this.left_pos
			this._gp_right.alpha = 1;
			this._gp_right.x = this.right_pos
			this._gp_right.visible = true
			this.initAttr()
		}

		this.initAttr = (is_anim?: false | true) => {
			this.PreHtml()
			let showRight = false
			let god_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_color
			let name_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god
			let cur_name_cfg = name_cfg[_god_id]
			let name = Trim(cur_name_cfg.name)
			let lv = _model.getIdolLv(_god_id)
			state = lv > 0 && UP || ACT
			let isAct = state == ACT
			let cur_cfg = god_cfg[_god_id + "@" + lv]
			let next_cfg = god_cfg[_god_id + "@" + (lv + 1)]
			can_up = next_cfg != null
			if (!cur_cfg) {
				return
			}
			//左边
			let data = (lv > 0 && (JSON.parse(cur_cfg.attr)) || (JSON.parse(next_cfg.attr)))
			let index = 0

			if (item_list) {
				for (let j = 0; j < item_list.length; j++) {
					let item = item_list[j]
					item.SetVisible(false)
				}
			}


			let ar_num=[]
			for (let key in data) {

				let info = data[key]
				let item = item_list[index]
				if (!item) {
					item = new GuildIdolAttrItem(this._left_list)
					item.SetType(0)
					item.Load()
					table.insert(item_list, item)
				}
				item.SetVisible(true)
				item.setData(info)
				ar_num.push(info[0])
				index = index + 1
			}


			if (!left_show_item) {
				left_show_item = new GuildIdolShowItem(this._gp_item)
				left_show_item.Load()
				left_show_item.setScale(0.75)
			}
			left_show_item.setData(cur_cfg.god_id, cur_cfg.color)
			let cur_color = cur_cfg.color == 6 && cur_cfg.color + 1 || cur_cfg.color
			this._lb_name.innerHTML = Util.HtmlColorTxt(name, ColorUtil.GetColorDark(cur_color))//ColorTxtToHTML(name, ColorUtil.GetColorDark(cur_color))
			SetHtmlCenter(this._lb_name, { x: 0, w: 217 })

			//右边
			if (!isAct) {
				if (next_cfg) {

					for (let j = 0; j < item_list2.length; j++) {
						let item = item_list2[j]
						item.SetVisible(false)
					}



					let data2 = JSON.parse(next_cfg.attr)
					index = 0
					for (let key in data2) {

						let info = data2[key]
						let item = item_list2[index]
						if (!item) {
							item = new GuildIdolAttrItem(this._right_list)
							item.SetType(1)
							item.Load()
							table.insert(item_list2, item)
						}
						item.SetVisible(true)
						let show=ar_num.indexOf(info[0])!=-1
						item.setData(info, !show, Enum_ColorUtil_Dark.GREEN)
						index = index + 1
					}

					if (!right_show_item) {
						right_show_item = new GuildIdolShowItem(this._gp_item2)
						right_show_item.Load()
						right_show_item.setScale(0.75)
					}
					right_show_item.setData(next_cfg.god_id, next_cfg.color)
					let next_color = next_cfg.color == 6 && next_cfg.color + 1 || next_cfg.color
					this._lb_name2.innerHTML = Util.HtmlColorTxt(name, ColorUtil.GetColorDark(next_color))
					SetHtmlCenter(this._lb_name2, { x: 0, w: 217 })
					showRight = true
				}
			}
			this._img_arrow.visible = showRight
			this._gp_right.visible = showRight

			this._lb_btn.stroke=2
			if (isAct) {
				//ResManager.GetInstance().SetImageSprite(this, this._img_title, "guildidol_asset", "uigh_074", true)
				this._lb_g5_txt.text="激活消耗"
				this._lb_btn.text = "激活"
				if (!is_anim) SetAnchoredPositionX(this._gp_left, this.center_pos)
			} else {
				this._lb_g5_txt.text="升品消耗"
				//ResManager.GetInstance().SetImageSprite(this, this._img_title, "guildidol_asset", "uigh_067", true)
				if (can_up) {
					if (!is_anim) SetAnchoredPositionX(this._gp_left, this.left_pos)
					this._lb_btn.text = "提升品质"
					
				} else {
					if (!is_anim) SetAnchoredPositionX(this._gp_left, this.center_pos)
					this._lb_btn.text = "已满级"
					this._lb_btn.stroke=0
				}
			}
			let gray_bool = !isAct && !can_up
			Util.SetImageGray(this._img_btn, gray_bool)
			//this.Out_lb_btn.effectColor = gray_bool && ColorUtilValue.GRAY || Color(211 / 255, 106 / 255, 36 / 255, 1)

			this._fight_show.Updatefighting(_model.getIdolPower(_god_id));

			this.updateCost()
		}


		this.updateCost = () => {
			let god_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_color
			//let god_cfg = Config.Guildgodcolor
			let lv = _model.getIdolLv(_god_id)
			let cur_cfg = god_cfg[_god_id + "@" + lv]


			if (cost_list) {
				for (let j = 0; j < cost_list.length; j++) {
					let item = cost_list[j]
					item.SetVisible(false)
				}
			}


			let num = 0
			let cur = 0
			let index = 0
			let count = 0
			this.cost_arr=[]
			if (can_up) {
				let count = 0
				let cost = JSON.parse(cur_cfg.cost)
				for (let key in cost) {

					let costInfo = cost[key]
					let item = cost_list[index]
					if (!item) {
						item = new BaseAwardItem(this._gp_cost)
						item.Load()
						item.SetScale(0.7)
						table.insert(cost_list, item)
					}
					item.SetVisible(true)
					let type_id, lock
					[type_id, lock] = goods_model.GetMappingTypeId(costInfo[0], costInfo[1])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						num = Number(costInfo[2])
						item.SetData(goods_vo.type_id, num, lock)
						//item:ForceSetNumber(num)
						cur = goods_model.GetBagGoodsNum(goods_vo.type_id)
						let color = (cur >= num && (Enum_ColorUtil_Light.GREEN) || (Enum_ColorUtil_Light.RED))
						item.ForceSetNumberInFlow(HtmlColorTxt(cur + "/" + num, color))
					}
					if (cur >= num) {
						count++
					}else{
						this.cost_arr.push(type_id)
					}
					index = index + 1
				}


				if(count >= index){
					let name_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god
					let cur_name_cfg = name_cfg[_god_id]
					let can = _model.checkGodCondition(cur_name_cfg, false)
					this._red.visible = can
				}else{
					this._red.visible = false
				}
				

			} else {
				this._red.visible = false
			}

			this._gp_cost.x = index == 1 ? 535 : 489
		}

		this.actEffect = () => {
			this.ClearAnim()
			//
			this._gp_right.alpha = 0
			this._gp_right.visible = false
			this.ClearUIEffect(this._gp_effect)
			this.AddUIEffect("UI_1102_jihuochenggong", this.layer_value, this._gp_effect)
			table.insert(this.tween_list, SYTweenLite.to(this, this._gp_left, SYTweenLite.UiAnimationType.POSX, this.left_pos, 0.15, () => {
				state = UP
				this.initAttr(true)
				// this.Can_img_arrow.alpha = 0
				// this.Can_gp_right.alpha = 0
				this._img_arrow.visible = true
				this._gp_right.visible = true
				// table.insert(this.tween_list, SYTweenLite.to(this, this.Can_img_arrow, SYTweenLite.UiAnimationType.ALPHA, 1, 0.15))
				table.insert(this.tween_list, SYTweenLite.to(this, this._gp_right, SYTweenLite.UiAnimationType.ALPHA, 1, 0.15))
			}))
		}

		this.upEffect = () => {
			this.ClearUpEff()

			let god_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_color
			let lv = _model.getIdolLv(_god_id)
			let next_cfg = god_cfg[_god_id + "@" + (lv + 1)]

			this._gp_left.alpha = 1;
			this._gp_left.x = this.left_pos
			this._gp_right.alpha = 1;
			this._gp_right.x = this.right_pos
			this._gp_right.visible = true
			if (next_cfg) {
				this.ClearUIEffect(this._gp_effect)
				this.AddUIEffect("UI_1102_jinshengchenggong", this.layer_value, this._gp_effect)

				//动画 
				this._img_arrow.visible=false
				Laya.Tween.to(this._gp_left, { alpha: 0}, this.durtime/2, Laya.Ease.linearIn)
				Laya.Tween.to(this._gp_right, {  x: this.left_pos }, this.durtime, Laya.Ease.linearIn, Laya.Handler.create(this, this.AnimPlayOver1))

			} else {
				//
				this.ClearUIEffect(this._gp_effect)
				this.AddUIEffect("UI_1102_jinshengchenggong", this.layer_value, this._gp_effect)
				this.initAttr(true)
				Laya.Tween.to(this._gp_right, { alpha: 0, x: this.center_pos }, this.durtime, Laya.Ease.backIn)
				Laya.Tween.to(this._gp_left, { x: this.center_pos }, this.durtime, Laya.Ease.backIn)
			}
		}


	}

	AnimPlayOver1() {
		this.initAttr(true)
		this._gp_left.alpha=1
		this._gp_right.x = this.right_pos
		this._gp_right.alpha=0
		Laya.Tween.to(this._gp_right, {  alpha:1 }, this.durtime, Laya.Ease.linearIn, Laya.Handler.create(this, this.AnimPlayOver2))
		
	}

	AnimPlayOver2() {
		this._img_arrow.visible=true
		// this.initAttr(true)
		// this._gp_right.visible
		// this._gp_right.x = this.right_pos
		// Laya.Tween.to(this._gp_left, { alpha: 1, x: this.left_pos }, this.durtime, Laya.Ease.backIn, Laya.Handler.create(this, () => {
		// 	Laya.Tween.to(this._gp_right, { alpha: 1, x: this.right_pos }, this.durtime, Laya.Ease.backIn)
		// }))
	}

	ClearUpEff() {
		Laya.Tween.clearAll(this._gp_left)
		Laya.Tween.clearAll(this._gp_right)
	}

	ClearAnim() {
		if (this.tween_list && this.tween_list.length > 0) {
			for (let _ in this.tween_list) {
				var tween_id = this.tween_list[_]
				SYTweenLite.Stop(tween_id)
			}
			this.tween_list = []
		}

	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}


	PreHtml() {
		this._lb_name.style.fontSize = 20
		this._lb_name.style.color = "#ffffff"
		this._lb_name.width = 180

		this._lb_name2.style.fontSize = 20
		this._lb_name2.style.color = "#ffffff"
		this._lb_name2.width = 180
	}


_img_bg:Laya.Image
_main_box:Laya.Box
_img_bottom:Laya.Image
_Group5:Laya.Box
_img_g5_title:Laya.Image
_lb_g5_txt:Laya.Label
_img_icon_222:Laya.Image
_gp_btn:Laya.Box
_btn_up:Laya.Box
_img_btn:Laya.Image
_lb_btn:Laya.Label
_red:Laya.Image
_gp_cost:Laya.HBox
_img_split:Laya.Image
_img_arrow:Laya.Image
_gp_right:Laya.Box
_Image3:Laya.Image
_lb_name2:Laya.HTMLDivElement
_Scroller2:Laya.Panel
_right_list:Laya.VBox
_gp_item2:Laya.Box
_gp_left:Laya.Box
_Image4:Laya.Image
_lb_name:Laya.HTMLDivElement
_Scroller1:Laya.Panel
_left_list:Laya.VBox
_gp_item:Laya.Box
_gp_ef_up1:Laya.Box
_gp_ef_up2:Laya.Box
_img:Laya.Image
_gp_effect:Laya.Box
_fight_con: Laya.HBox;
public GetComponents() {
[
this._img_bg,
this._main_box,
this._img_bottom,
this._Group5,
this._img_g5_title,
this._lb_g5_txt,
this._img_icon_222,
this._gp_btn,
this._btn_up,
this._img_btn,
this._lb_btn,
this._red,
this._gp_cost,
this._img_split,
this._img_arrow,
this._gp_right,
this._Image3,
this._lb_name2,
this._Scroller2,
this._right_list,
this._gp_item2,
this._gp_left,
this._Image4,
this._lb_name,
this._Scroller1,
this._left_list,
this._gp_item,
this._gp_ef_up1,
this._gp_ef_up2,
this._img,
this._gp_effect,
this._fight_con
]
 = this.GetChildrenByNames([

"_img_bg",
"_main_box",
"_img_bottom",
"_Group5",
"_img_g5_title",
"_lb_g5_txt",
"_img_icon_222",
"_gp_btn",
"_btn_up",
"_img_btn",
"_lb_btn",
"_red",
"_gp_cost",
"_img_split",
"_img_arrow",
"_gp_right",
"_Image3",
"_lb_name2",
"_Scroller2",
"_right_list",
"_gp_item2",
"_gp_left",
"_Image4",
"_lb_name",
"_Scroller1",
"_left_list",
"_gp_item",
"_gp_ef_up1",
"_gp_ef_up2",
"_img",
"_gp_effect",
"_fight_con"
])
}
}
 window["GuildIdolMainAct"]= GuildIdolMainAct