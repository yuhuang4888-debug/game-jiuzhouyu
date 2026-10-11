import { BaseView1, OpenMode } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"

/**目测没有使用到这个类 */
export class BossFieldTiredAlert extends BaseView1 {



	have_all_num = 0
	use_num = 0
	vit = null
	max_vit = 0
	last_vit_time = null
	vit_add = 0
	now_vit = 0


	model: BossModel
	goods_model: GoodsModel
	reward_item

	public constructor() {
		super()


		this.base_file = "bossField"
		this.layout_file = "BossFieldTiredAlert"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.back_login_toClose = true
		this.model = BossModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()

		this.preload_server_config = {
			"config_boss_type_key_value": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
			if (this.reward_item) {
				this.reward_item.DeleteMe()
				this.reward_item = null
			}
		}
	}

	InitEvent = () => {

		this.BindEvent(GlobalEventSystem, GoodsModel.USE_BAG_GOODS_SUCCESS, (type_id?) => {
			if (type_id != BossModel.tired_goods_id) {
				return
			}
			let goods_vo = this.goods_model.GetGoodsBasicByTypeId(BossModel.tired_goods_id)
			if (goods_vo) {
				let num = this.goods_model.GetTypeGoodsNum(BossModel.tired_goods_id)
				this.have_all_num = num
				this.reward_item.SetData(goods_vo.type_id)
				//this._lb_num.visible = num > 0 
				// this._lb_num.text = "拥有：<font color=0x82AB20>" + num + "</font>"
				this._html_num.innerHTML = `拥有:<font color='82AB20'>${num}</font>`
				this._lb_count.text = "0"
				this.ShowVit()
			}
		})

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}
			, this, true)
		Util.AddClickEvent(this._box_canel, () => {
			this.Close()
		}
			, this, true)

		Util.AddClickEvent(this._box_use, () => {
			if (this.use_num <= 0) {
				Message.show("没有可使用的物品")
				return
			}
			let num = this.goods_model.GetTypeGoodsNum(BossModel.tired_goods_id)
			if (num > 0) {
				let goods_id = this.goods_model.GetOneGoodsByTypeId(BossModel.tired_goods_id)
				this.goods_model.Fire(GoodsModel.USE_BAG_GOODS, goods_id, this.use_num)
			} else {
				MaterialsTool.GetInstance().materialsTips(BossModel.tired_goods_id)
			}
		}, this, true)


		Util.AddClickEvent(this._img_sub, () => {
			if (this.have_all_num < 1 || !this.max_vit || this.max_vit == 0) {
				return
			}
			let num = Number(this.use_num) - 1
			if (num < 0) {
				Message.show("当前数量已是最小")
				return
			}
			this.use_num = num
			this.now_vit = this.now_vit - Number(this.vit_add)
			this.UpdateVit()
			// this._html_vit.innerHTML = `使用后体力:<font color='#4a3a32'>${this.now_vit}/${this.max_vit}</font>`
			// this._lb_vit.text = Util.StrToHTML("使用后体力：<font color=0x4a3a32>" + this.now_vit + "/" + this.max_vit + "</font>")
			this._lb_count.text = String(num)
		}, this, true)


		Util.AddClickEvent(this._img_add, () => {
			if (this.have_all_num < 1 || !this.max_vit || this.max_vit == 0) {
				return
			}
			let num = Number(this.use_num) + 1
			if (num > this.have_all_num) {
				Message.show("当前数量已是最大")
				return
			}
			//if (! this.ShowVit(null,null,null,true) ) {
			//Message.show("已达到最大可恢复体力")
			//return
			//}
			this.use_num = num
			this.now_vit = this.now_vit + Number(this.vit_add)
			this.UpdateVit()
			// this._html_vit.innerHTML = `使用后体力:<font color='#4a3a32'>${this.now_vit}/${this.max_vit}</font>`
			this._lb_count.text = String(num)
		}, this, true)

		this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_VIT_TIME, (scmd/**vit?, max_vit?, last_vit_time?*/) => {
			let num = this.goods_model.GetTypeGoodsNum(BossModel.tired_goods_id)
			this.have_all_num = num
			this.ShowVit(scmd.vit, scmd.max_vit, scmd.last_vit_time)
		}
		)
		BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46043, BossModel.BossType.field)
	}

	LoadSuccess() {
		this._html_num.style.fontSize = 20
		this._html_num.style.color = "#4a3a32"

		this._html_vit.style.fontSize = 24
		this._html_vit.style.color = "#93847d"


		let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
		this.vit_add = JSON.parse(BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "goods_add_vit_list", cfgs))[0][1]
		this._lb_content.text = Util.StrToHTML("今日世界BOSS体力已耗尽，于<font color=" + ColorUtil.GetColorDark(ColorType.GREEN) + ">每日4点重置</font>\n<font color=" + ColorUtil.GetColorDark(ColorType.RED) + ">（目前无法对BOSS造成伤害）</font>")
		if (!this.reward_item) {
			this.reward_item = new EquipmentItem(this._box_reward, null, this.layer_value)
			this.reward_item.Load()
			this.reward_item.SetScale(0.8)
			//this.reward_item.scaleX = 0.8
			//this.reward_item.scaleY = 0.8
		}
		let goods_vo = this.goods_model.GetGoodsBasicByTypeId(BossModel.tired_goods_id)
		if (goods_vo) {
			let num = this.goods_model.GetTypeGoodsNum(BossModel.tired_goods_id)
			this.have_all_num = num
			this.reward_item.SetData(goods_vo.type_id)
			//this._lb_num.visible = num > 0 
			this._html_num.innerHTML = `拥有:<font color='82AB20'>${num}</font>`
			this._lb_name.text = goods_vo.goods_name
			this._lb_name.color = ColorUtil.GetColorDark(goods_vo.color, false)
		}

		this.InitEvent()
	}

	ShowVit(vit?, max_vit?, last_vit_time?, not_change_text?) {
		this.vit = vit && vit || this.vit
		this.max_vit = max_vit && max_vit || this.max_vit
		this.last_vit_time = last_vit_time && last_vit_time || this.last_vit_time
		if (!this.vit || !this.max_vit || !this.last_vit_time) { return }
		let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
		let time = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_time", cfgs)

		//let can_use_num = 
		//if (this.vit == this.max_vit ) {
		//this._lb_vit.text = "当前满体力"
		//this.now_vit = this.max_vit
		//return false
		//}else{
		let add_vit = Math.floor((TimeUtil.getServerTime() - this.last_vit_time) / time)
		//if (this.vit + add_vit >= this.max_vit ) {
		//this._lb_vit.text = "当前满体力"
		//this.now_vit = this.max_vit
		//return false
		//}else{
		let real_vit = 0
		if (this.vit > this.max_vit) {
			real_vit = this.vit
		} else {
			real_vit = Math.min(this.max_vit, this.vit + add_vit)
		}
		let need_vit = null
		let num = null
		if (!not_change_text) {
			need_vit = this.max_vit - real_vit
			if (need_vit < 0) {
				need_vit = 0
			}
			num = Math.floor(need_vit / Number(this.vit_add))
			num = String(Math.min(num, this.have_all_num))
			this.now_vit = real_vit + num * Number(this.vit_add)
			this._lb_count.text = String(Math.min(num, this.have_all_num))
			this.UpdateVit()
			this.use_num = num
		} else {
			need_vit = this.max_vit - this.now_vit
			num = Math.floor(need_vit / Number(this.vit_add))
		}
		return num > 0
		//}
		//}
	}

	UpdateVit(){
		this._html_vit.innerHTML = `使用后体力:<font color='#4a3a32'>${this.now_vit}/${this.max_vit}</font>`
		this._html_vit.style.width = 400
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_close: Laya.Image
	_lb_title: Laya.Label
	_lb_content: Laya.Label
	_box_canel: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	_box_use: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	_box_reward: Laya.Box
	_lb_name: Laya.Label
	_lb_tips: Laya.Label
	_box_count: Laya.Box
	_img_sub: Laya.Image
	_img_add: Laya.Image
	_img_count_bg: Laya.Image
	_lb_count: Laya.Label
	_html_num: Laya.HTMLDivElement
	_html_vit: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_close,
			this._lb_title,
			this._lb_content,
			this._box_canel,
			this._Image1,
			this.labelDisplay1,
			this._box_use,
			this._Image111,
			this.labelDisplay,
			this._box_reward,
			this._lb_name,
			this._lb_tips,
			this._box_count,
			this._img_sub,
			this._img_add,
			this._img_count_bg,
			this._lb_count,
			this._html_num,
			this._html_vit,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_close",
				"_lb_title",
				"_lb_content",
				"_box_canel",
				"_Image1",
				"labelDisplay1",
				"_box_use",
				"_Image111",
				"labelDisplay",
				"_box_reward",
				"_lb_name",
				"_lb_tips",
				"_box_count",
				"_img_sub",
				"_img_add",
				"_img_count_bg",
				"_lb_count",
				"_html_num",
				"_html_vit",
			])
	}
}
window["BossFieldTiredAlert"] = BossFieldTiredAlert