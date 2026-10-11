import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { FashionModel } from "../commonModel/FashionModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { FasBagItemRenderer } from "./FasBagItemRenderer"

export class FashionLevelView extends BaseView1 {
	bg_img: Laya.Image
	bg_img_1: Laya.Image
	Separate_img1: Laya.Image
	Separate_img2: Laya.Image
	_Group1: Laya.HBox
	_Image2: Laya.Image
	top_img: Laya.Image
	_Image3: Laya.Image
	_Group2: Laya.Box
	_Image4: Laya.Image
	flv_img: Laya.Image
	flv_level_label: Laya.Label
	_Group3: Laya.Box
	exp_bg_image: Laya.Image
	exp_num_image: Laya.Image
	exp_label: Laya.Label
	flv_attrs_group: Laya.Box
	flv_att1_1_label: Laya.Label
	flv_att1_2_label: Laya.Label
	flv_att1_3_label: Laya.Label
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	flv_attr_dec0_label: Laya.Label
	flv_att0_1_label: Laya.Label
	flv_attr_dec1_label: Laya.Label
	flv_att0_2_label: Laya.Label
	flv_attr_dec2_label: Laya.Label
	flv_att0_3_label: Laya.Label
	_Label1: Laya.Label
	_lb_1: Laya.Label
	flv_add_exp_label: Laya.Label
	flv_devour_but: Laya.Box
	_Image8: Laya.Image
	_Label2: Laya.Label
	_Image9: Laya.Image
	tips_label: Laya.Label
	_Image10: Laya.Image
	tips_label1: Laya.Label
	flv_closebut_image: Laya.Image
	flv_scroller: Laya.List
	effect_group: Laya.Box
	_lb_name: Laya.Label

	CreateLevelViewList
	DevourCallBack
	GetSourceArr
	InitEvent
	UpdateView
	OpenViewShowExp
	PlayAnim
	PlayExpAnim
	Scrflv_scroller
	ShowAtt
	ShowExp
	ShowFahisonLevelDetails
	click_bg_toClose
	close_callback
	flv_list
	getCost
	is_center
	is_up
	open_callback
	show_open_movie
	tween_id
	use_background
	pos_id

	public constructor() {
		super()
		this.base_file = "fashion"
		this.layout_file = "FashionLevelView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		this.tween_id = []

		let model = FashionModel.GetInstance()
		let local_FashionModel = FashionModel
		let local_Message = Message
		let role_mgr = RoleManager.GetInstance()
		let local_Number = Number
		let wordList_ = ["时装", "武器", "发饰"]
		let source_list_ = null
		let add_exp_ = 0
		let current_index_ = null
		let exp_data_list_ = []
		let time_interval_ = 0.5
		let is_ani_exp_ = false
		let old_level_ = 0
		let max_num_ = null
		let lv_ = null
		let exp_value_ = null
		let all_cost_ = 0

		let _end_width = 533
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.Separate_img1, "resource/game/common2/texture/com_line_5.png", true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.Separate_img2, "resource/game/common2/texture/com_line_5.png", true)
			this.InitEvent()
			this.ShowFahisonLevelDetails()
			this.CreateLevelViewList()
			old_level_ = lv_
		}

		this.open_callback = () => {
			this.UpdateView(this.pos_id)
			this.OpenViewShowExp()
		}

		this.close_callback = () => {
			this.Destory()
		}

		this.InitEvent = () => {
			let UpLevelCallBack = (pos_id?) => {
				if (pos_id != null && pos_id != this.pos_id) {
					return
				}
				this.ShowFahisonLevelDetails()
				this.CreateLevelViewList()
				this.ShowExp()
			}

			this.BindEvent(model, local_FashionModel.UPDATELEVEL, UpLevelCallBack)

			let UpViewCallBack = (pos_id?) => {
				if (pos_id != null && pos_id != this.pos_id) {
					return
				}
				this.ShowFahisonLevelDetails()
				this.CreateLevelViewList()
			}
			this.BindEvent(model, local_FashionModel.UPDATEVIEW, UpViewCallBack)

			let DevourButFunc = () => {
				this.DevourCallBack()
			}

			Util.AddClickEvent(this.flv_devour_but, DevourButFunc, this, true)
			let CloseButFunc = () => {
				this.Close()
			}

			Util.AddClickEvent(this.flv_closebut_image, CloseButFunc, this, true)

			let ShowEffect = (pos_id?, type_id?) => {
				if (pos_id != this.pos_id) {
					return
				}
				if (2 == type_id) {
					//this:AddUIEffect2("ui_tunshichenggong_glow", this.effect_group, null, null, false)
				}
			}

			this.BindEvent(model, local_FashionModel.SUCCESSOPERATE, ShowEffect)

			let ListTouchFunc = (item?) => {
				let index = item.index
				let vo = source_list_[index]
				if (vo[0] != 0) {
					let _status = -vo[3]
					vo[3] = _status
					add_exp_ = add_exp_ + _status * vo[2] * vo[1]
					item.RefStatus()
					this.flv_add_exp_label.text = add_exp_.toString()
				}
			}

			this.BindEvent(model, local_FashionModel.SELECTADD, ListTouchFunc)
		}

		this.UpdateView = () => {
			this.top_img.visible = false

			this.flv_attr_dec0_label.text = wordList_[this.pos_id - 1] + "攻击"
			this.flv_attr_dec1_label.text = wordList_[this.pos_id - 1] + "防御"
			this.flv_attr_dec2_label.text = wordList_[this.pos_id - 1] + "生命"
			this.tips_label.text = "吞噬多余" + wordList_[this.pos_id - 1] + "可提升" + wordList_[this.pos_id - 1] + "等级"
			this.tips_label1.text = "未升至满阶的" + wordList_[this.pos_id - 1] + "不能进行吞噬"
			if(PlatformManager.IsEyouEnPlatform()){
				this.tips_label.text = "Devour excess " + wordList_[pos_id - 1] + " Upgradable " + wordList_[pos_id - 1] + " Level"
				this.tips_label1.text = "Not fully upgraded " + wordList_[pos_id - 1] + " cannot be devoured"
			}
		}

		this.CreateLevelViewList = () => {
			let list = this.GetSourceArr()
			if (!this.flv_list) {
				this.flv_list = new LoopScrowViewMgr()
				this.flv_list.SetData(this.flv_scroller, FasBagItemRenderer, list, LoopScrCon.Vertical, 4)
			} else {
				this.flv_list.replaceAll(list)
			}

		}

		this.DevourCallBack = () => {
			let _goods_list = []
			for (let _tmpi in source_list_) {
				var good = source_list_[_tmpi]
				if (good[3] == 1) {
					let _good = [0, 0]
					_good[0] = good[4]
					_good[1] = good[1]
					table.insert(_goods_list, _good)
				}
			}
			if (_goods_list.length > 0) {
				model.Fire(local_FashionModel.SCMD_REQUEST, 41305, this.pos_id, _goods_list)
			} else {
				if (max_num_ == 0) {
					local_Message.show("已满级")
					return
				}
				local_Message.show("材料不足")
			}
		}

		this.GetSourceArr = () => {
			all_cost_ = this.getCost(0)
			let grade_list = model.fashion_level_red_dic && model.fashion_level_red_dic[this.pos_id]
			let lenght = 0
			if(grade_list){
				for(let i in grade_list){
					lenght += Util.TableSize(grade_list[i], true)
				}
			}
			let source_list = []
			if (lenght <= 8) {
				let i = 0
				do {
					let source = [0, 0, 0, -1, 0]
					table.insert(source_list, source)
					i = i + 1
				} while ((i < 8)
				)
			} else {
				let _num = Math.ceil(lenght - 8 / 4) * 4 + 8
				let i = 0
				do {
					let source = [0, 0, 0, -1, 0]
					table.insert(source_list, source)
					i = i + 1
				} while ((i < _num)
				)
			}
			let len = 0
			if (lenght != 0 && max_num_ != 0) {
				let career = role_mgr.GetMainRoleVo().career
				let sex = role_mgr.GetMainRoleVo().sex

				let need_exp = this.getCost(lv_) - exp_value_
				if(grade_list){
					for (let fashion_id in grade_list) {
						if(!grade_list[fashion_id]) continue
						var color_dic = grade_list[fashion_id]
						for(let color_id in color_dic){
							if(!color_dic[color_id]) continue
							var local_goods_id
							if(Number(color_id) == 0){
								local_goods_id = fashion_id
							}
							else{
								var cfgs = Config.PRELOAD_SERVER_CONFIG.config_fashion_color
								var key = `${this.pos_id}@${fashion_id}@${color_id}@1`
								var cfg = cfgs[key]
								var cost
								if(cfg && cfg.active_cost != "[]"){
									cost = JSON.parse(cfg.active_cost)
								}
								if(cost){
									for(let vo of cost){
										local_goods_id = vo[1]
											break
									}
								}
							}

							source_list[len][0] = local_Number(local_goods_id)
							source_list[len][1] = GoodsModel.GetInstance().GetTypeGoodsNum(local_goods_id)
							
							let dic = model.fashion_current_user_model_dic[this.pos_id + "@" + fashion_id + "@" + career + "@" + sex + "@0"]
							if (dic) {
								let _exp = dic.exp
								source_list[len][2] = _exp
								source_list[len][3] = 1
								source_list[len][4] = GoodsModel.GetInstance().GetOneGoodsByTypeId(local_goods_id)
								add_exp_ = add_exp_ + _exp * source_list[len][1]
								if (add_exp_ >= need_exp) {
									let needless_exp = add_exp_ - need_exp
									add_exp_ = need_exp
									let needless_num = Math.floor(needless_exp / _exp)
									source_list[len][1] = source_list[len][1] - needless_num
									break
								}
								len = len + 1
							}
						}
					}
				}
			} else {
				add_exp_ = 0
			}
			this.flv_add_exp_label.text = add_exp_.toString()
			source_list_ = source_list
			return source_list
		}

		this.getCost = (star_lv?) => {
			let cost = 0
			for (let index in model.config_fashion_pos) {
				if (model.config_fashion_pos[index].pos_id == this.pos_id) {
					if (model.config_fashion_pos[index].pos_lv >= star_lv) {
						cost = cost + local_Number(model.config_fashion_pos[index].cost)
					}
				}
			}
			return cost
		}

		this.ShowFahisonLevelDetails = () => {
			let _info = model.fashion_info_dic[this.pos_id]
			if (!_info) {
				return
			}
			let _level = _info["pos_lv"]
			let _pos_list = model.config_fashion_pos
			let _pos = _pos_list[this.pos_id + "@" + _level]
			if (!_pos) {
				return
			}
			let _next_pos = _pos_list[this.pos_id + "@" + (_level + 1)]
			let source = this.pos_id == 1 && "shizhuangdengji" || "uitc_027b"
			ResManager.GetInstance().SetImageSprite(this, this.flv_img, "fashion_asset", source)
			this._lb_1.text = wordList_[this.pos_id - 1] + "等级："
			this.flv_level_label.text = "Lv." + _level
			max_num_ = _pos["cost"]
			if ((lv_ && _level > lv_) || (exp_value_ && _info["pos_upgrade_num"] > exp_value_)) {
				this.is_up = true
			} else {
				this.is_up = false
			}
			lv_ = _level
			exp_value_ = _info["pos_upgrade_num"]
			this.ShowAtt(_pos, _next_pos)
		}

		this.OpenViewShowExp = () => {
			if (max_num_ != undefined && exp_value_ != undefined) {
				if (max_num_ == 0) {
					exp_value_ = 0
					this.exp_label.text = "已满级"
					this.exp_num_image.width = 533
				} else {
					this.exp_label.text = exp_value_ + "/" + max_num_
					this.exp_num_image.width = exp_value_ / max_num_ * 533
				}
			}
		}

		this.ShowExp = () => {
			let persent = exp_value_ / max_num_
			let tb = { 
				persent: persent, 
				level: lv_, 
				exp: exp_value_, 
				exp_lim: max_num_ 
			}

			if (tb.exp > tb.exp_lim) {
				tb.exp = tb.exp_lim
			}
			table.insert(exp_data_list_, tb)
			let len = exp_data_list_.length
			time_interval_ = len > 0 && (0.5 / len) || 0
			this.PlayExpAnim()
		}

		this.PlayExpAnim = () => {
			if (!is_ani_exp_ && this.exp_num_image) {
				let vo = exp_data_list_.shift()
				if (vo) {
					this.PlayAnim(vo)
				}
			}
		}

		this.PlayAnim = (tb?) => {
			this.exp_label.text = tb.exp + " / " + tb.exp_lim
			if (tb.exp_lim == 0) {
				tb.exp = 0
				this.exp_label.text = "已满阶"
			}
			// if (! this.is_ip ) {
			// 	this.exp_num_image.fillAmount = tb.exp / tb.exp_lim
			// 	old_level_ = tb.level
			// 	return 
			// }
			let endValue
			endValue = _end_width * local_Number(tb.persent)
			if (endValue < 0) {
				endValue = 0
			} else if (endValue > _end_width) {
				endValue = _end_width
			}
			let AnimFunc = (endValue?, time?, callback?) => {
				let id = SYTweenLite.to(this, this.exp_num_image, SYTweenLite.UiAnimationType.WIDTH, endValue, time, callback)
				table.insert(this.tween_id, id)
			}
			if (tb.level > old_level_) {
				let onComleted = () => {
					if (!endValue && endValue != 0) return
					this.exp_num_image.width = 0
					let onCom = () => {
						is_ani_exp_ = false
						this.PlayExpAnim()
					}
					AnimFunc(endValue, time_interval_, onCom)
				}

				is_ani_exp_ = true
				AnimFunc(_end_width, time_interval_, onComleted)
			} else {
				let onComleted = () => {
					is_ani_exp_ = false
					this.PlayExpAnim()
				}

				is_ani_exp_ = true
				AnimFunc(endValue, time_interval_, onComleted)
			}
			old_level_ = tb.level
		}

		this.ShowAtt = (_pos?, _next_pos?) => {
			let _attr = JSON.parse(_pos["attr_add_list"])
			this.flv_att0_1_label.text = _attr[0][1] + "%"
			this.flv_att0_2_label.text = _attr[1][1] + "%"
			this.flv_att0_3_label.text = _attr[2][1] + "%"
			if (_next_pos) {
				let _next_attr = JSON.parse(_next_pos["attr_add_list"])
				this.flv_att1_1_label.text = _next_attr[0][1] + "%"
				this.flv_att1_2_label.text = _next_attr[1][1] + "%"
				this.flv_att1_3_label.text = _next_attr[2][1] + "%"
			} else {
				this.flv_attrs_group.visible = false
				Util.SetImageGray(this._Image8, true)
				this._Label2.color = "#adadad"
			}
		}


	}

	public Destory() {

		if (this.tween_id.length > 0) {
			for (let k in this.tween_id) {
				var v = this.tween_id[k]
				SYTweenLite.Stop(v)
			}
			this.tween_id = []
		}
		super.Destroy()
	}

	public Open(pos_id?) {
		this.pos_id = pos_id
		super.Open()
	}



	public GetComponents() {
		[
			this.bg_img,
			this.bg_img_1,
			this.Separate_img1,
			this.Separate_img2,
			this._Group1,
			this._Image2,
			this.top_img,
			this._Image3,
			this._Group2,
			this._Image4,
			this.flv_img,
			this._lb_1,
			this.flv_level_label,
			this._Group3,
			this.exp_bg_image,
			this.exp_num_image,
			this.exp_label,
			this.flv_attrs_group,
			this.flv_att1_1_label,
			this.flv_att1_2_label,
			this.flv_att1_3_label,
			this._Image5,
			this._Image6,
			this._Image7,
			this.flv_attr_dec0_label,
			this.flv_att0_1_label,
			this.flv_attr_dec1_label,
			this.flv_att0_2_label,
			this.flv_attr_dec2_label,
			this.flv_att0_3_label,
			this._Label1,
			this.flv_add_exp_label,
			this.flv_devour_but,
			this._Image8,
			this._Label2,
			this._Image9,
			this.tips_label,
			this._Image10,
			this.tips_label1,
			this.flv_closebut_image,
			this.flv_scroller,
			this.effect_group,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"bg_img",
				"bg_img_1",
				"Separate_img1",
				"Separate_img2",
				"_Group1",
				"_Image2",
				"top_img",
				"_Image3",
				"_Group2",
				"_Image4",
				"flv_img",
				"_lb_1",
				"flv_level_label",
				"_Group3",
				"exp_bg_image",
				"exp_num_image",
				"exp_label",
				"flv_attrs_group",
				"flv_att1_1_label",
				"flv_att1_2_label",
				"flv_att1_3_label",
				"_Image5",
				"_Image6",
				"_Image7",
				"flv_attr_dec0_label",
				"flv_att0_1_label",
				"flv_attr_dec1_label",
				"flv_att0_2_label",
				"flv_attr_dec2_label",
				"flv_att0_3_label",
				"_Label1",
				"flv_add_exp_label",
				"flv_devour_but",
				"_Image8",
				"_Label2",
				"_Image9",
				"tips_label",
				"_Image10",
				"tips_label1",
				"flv_closebut_image",
				"flv_scroller",
				"effect_group",
				"_lb_name",
			])
		this.flv_scroller.scrollBar.visible = false
	}
}
window["FashionLevelView"] = FashionLevelView