import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { GoodsModel } from "../commonModel/GoodsModel";
import { SkillManager } from "../skill/SkillManager";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util, Trim, RefGridLayout, PlayBigEffect, SetHtmlStyle, HtmlColorTxt, SetHtmlCenter, TransformCurrency } from "../util/Util";
import { PartnerAttrItem } from "./PartnerAttrItem";
import { PartnerItem } from "./PartnerItem";
import { PartnerModel } from "../commonModel/PartnerModel";
import { PartnerSkillItem } from "./PartnerSkillItem";
import { ErlangParser } from "../util/ErlangParser";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { VipModel } from "../commonModel/VipModel";
import { SoundManager } from "../common/SoundManager";
import { PartnerBiogTabItem } from "./PartnerBiogTabItem";
import { PlatformManager } from "../PlatformManager";

export class PartnerDetailsView extends BaseItem1 {


	model:PartnerModel
	goodsmodel
	res_mgr: ResManager

	attr_items
	skill_items
	nucleus_items
	cost_items
	skill_item
	goods_item
	item_ac

	info
	is_active
	is_playing
	is_request
	jump_id
	need_Ref_func
	select_data
	select_id
	timer_id
	tween
	tween_cache
	list_loop_mgr
	progress_max = 302
	attr_number
	attr_box_data = {}   //网格布局数据
	voice
	channel

	///传记
	switch_type = 2
	public constructor(parent?) {
		super(parent)

		this.base_file = "partner"
		this.layout_file = "PartnerDetailsView"
		this.layer_value = Enum_UILayer.UI
		this.model = PartnerModel.GetInstance()
		this.goodsmodel = GoodsModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.tween_cache = []
		this.is_request = false
		this.attr_box_data = {
			h_gap: 0,
			v_gap: 0,
			column: 2,
			item_w: 350,
			item_h: 28
		}
		this.channel = null
		this.voice = ["NPC_Voice02b", "NPC_Voice18b", "NPC_Voice03b", "Pet_Voice14b", "NPC_Voice10b", "NPC_Voice34b", "NPC_Voice17b", "NPC_Voice31b", "NPC_Voice27b", "NPC_Voice21b", "NPC_Voice07b", "NPC_Voice04b"]
		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this.desc.pos(15,272)
				this.desc.width = 117
				this.desc.height = 51
				this.desc.wordWrap = true
				this.desc.leading = 0.1
			}
			this.Load_callback()
		}
	}

	public Load_callback() {

		this.exchange.style.fontSize = 22
		this.exchange.style.color = "#0a953e"

		this.skill_desc.style.fontSize = 22
		this.skill_desc.style.color = "#ffffff"

		this.souredesc.style.fontSize = 20
		this.souredesc.style.color = "#00fa64"
		this.goods_name.style.fontSize = 22
		this.goods_name.style.color = "#fe1a1a"

		this.name_res.style.fontSize = 20
		this.name_res.style.color = "#ffffff"
		this.name_res.style.wordWrap =false
		this.itemScroll.scrollBar.visible = false

		SetHtmlStyle(this._html_biog_title, { c: "#d15e00", f: 24, ww: false, w: 650 })
		SetHtmlStyle(this._html_biog_desc, { c: "#663915", f: 20, w: 685, lh: 30 })
		this._panel_biog.vScrollBarSkin = ""


		this.LoadSuccess()
		this.InitEvent()
		this.InitView()

		this.SwitchView()
	}

	public InitEvent() {

		Util.AddClickEvent(this.souredesc_box, () => {
			if (this.jump_id && this.jump_id != 0) {
				OpenFun.OpenFunHandler(this.jump_id)
			}
		}, this)

		Util.AddClickEvent(this._img_biog_lock, () => {
			if(this.current_biog_state==1&&this.biog_data){
				this.model.Fire(PartnerModel.REQUSET_SCMD, 14207, this.select_data.id,this.biog_data.id)
			}
		}, this)

		Util.AddClickEvent(this.click_box, () => {
			if (this.select_data) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "ExchangeViewOne", 7, this.select_data.exchange)
			}
		}, this, true)

		Util.AddClickEvent(this.btn, () => {
			if (!this.select_data) { return }
			if (!this.is_active) { // 未激活
				if (this.model.GetRed(this.select_data.id, 1)) {
					this.model.Fire(PartnerModel.REQUSET_SCMD, 14204, this.select_data.id)
				} else if (this.model.IsSpecialActive(this.select_data.id)) {
					Message.show("条件不足")
				} else {
					Message.show("材料不足")
				}
			} else { // 升星;每发一次协议，最多升5%
				if (PartnerModel.Is_Requeste) {
					PartnerModel.Is_Requeste = false
					this.RefBtnText()
					this.RefRed() //提升中，按键不显示红点
				} else {
					PartnerModel.Is_Requeste = true
					this.Request_up_star()
					this.RefRed() //提升中，按键不显示红点
				}

			}
		}, this, true)


		this.BindEvent(this.model, PartnerModel.UNLOCK_BIOG, (scmd) => {
			if (this.select_data) {
				this.SetBiog()
			}
		})

		this.BindEvent(this.model, PartnerModel.SELECTE_ID, () => {
			if (this.select_data) {
				PartnerModel.Is_Requeste = false
				this.RefView()
				this.SetBiog()
			}
		})

		this.BindEvent(this.model, PartnerModel.UPDATE_UP_ACT, () => {
			this.RefRed()
		})

		this.BindEvent(this.model, PartnerModel.UPDATE_VIEW, (scmd_id?, scmd?) => {
			this.RefView()
		})

		this.BindEvent(this.model, PartnerModel.UP_LV_ANIMATION, (scmd?, old_info?) => {
			this.PlayAnim(scmd, old_info)
		})

		this.BindEvent(this.model, PartnerModel.UPDATE_STATE, () => {
			PlayBigEffect("ui_shengxingchengong")
		})

		this.BindEvent(this.model, PartnerModel.UPDATE_BIOG_RED, () => {
			this.UpdateBiogTab()
		})


		this.BindEvent(this.model, PartnerModel.REF_REQUEST_STATUS, () => {
			this.RefBtnText()
			this.RefRed()
		})

		let change_bag = (list?) => {
			if (list) {
				for (let k in list) {
					let v = list[k]
					let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(v.type_id)
					if (basic && basic.type == 22) {
						this.RefCost()
						this.RefRed()
						if (!this.is_active) {
							this.RefPro()
						}
						//this:RefExchange()
						return
					}
				}
			}
		}
		this.BindEvent(this.goodsmodel, GoodsModel.CHANGE_BAG_LIST, change_bag)

		let exchan_func = (scmd?) => {
			if (scmd.type == 7) {
				this.RefExchange()
			}
		}
		this.BindEvent(this.goodsmodel, GoodsModel.UPDATE_GOODS_EXCHANGE_DATA, exchan_func)

		/*VipModel缺失
		this.BindEvent(VipModel.GetInstance(), VipModel.UPDATE_ALL_RECHARGE, () => {
			this.RefPro()
		})
		*/
	}

	public LoadSuccess() {
		this.attr_items = []
		this.skill_items = []
		this.nucleus_items = []
		this.cost_items = []
		this.exchange.width = 109
		this.res_mgr.SetTexture(this, this.skillbg, GameResPath.GetIcon("partner", "ui_witch_02"))
		// this.progress.skin = GameResPath.GetPetPath("uiwg_021png")// "pet_json.uiwg_021png_png"
		// this.res_mgr.SetTexture(this, this.name_bg, GameResPath.GetIcon("partner", "uirw_093"),null,null,true)

		// this.progress.mask = new Laya.Rectangle(0, 0, this.progress.width, this.progress.height)

		this.exchange.innerHTML = "<a href=''>碎片兑换</a>" //Util.StrToHTML("<font u=true>碎片兑换</font>")
		this.skill_desc.style.leading = 1
	}

	public InitView() {
		this.goodsmodel.Fire(GoodsModel.REQUEST_EXCHANGE_GOODS, 7)
		this.InitItem()
	}


	public InitItem() {
		this.info = this.model.GetInfo()
		if (!this.info) { return }
		let list = this.model.GetPartnerList()

		let index = 0
		let is_red = false
		if (!this.select_id) {
			for (let k in list) {
				let v = list[k]
				is_red = this.model.GetRed(v.id)
				if (is_red) {
					break
				}
				index = index + 1
			}

			if (!is_red) {
				index = 0
			}
		} else {
			index = this.select_id - 1
			this.select_id = undefined
		}

		if (list) {
			this.list_loop_mgr = new LoopScrowViewMgr()
			this.list_loop_mgr.SetData(this.itemScroll, PartnerItem, list, LoopScrCon.Horizontal, null, (e) => {
				if (this.channel) {
					SoundManager.GetInstance().StopSoundEffect(this.channel)
				}
				this.channel = SoundManager.GetInstance().PlaySoundEffect(this.voice[e], true, null, "npc")
				this.SelectItem(e)
			})
			this.itemScroll.selectedIndex = index
			this.SelectItem(index)
		}
		// }
	}

	public SelectItem(e) {
		if (!this.list_loop_mgr.parent._array) return
		if (this.select_data == this.list_loop_mgr.parent._array[e]) { return }
		this.select_data = this.list_loop_mgr.parent._array[e]
		this.model.Fire(PartnerModel.SELECTE_ID, this.select_data)
	}


	public RefView() {

		if (!this.select_data) { return }
		let info = this.model.GetInfoByID(this.select_data.id)
		this.is_active = info.is_active == 1
		this.RefSource()
		this.RefSkill()
		this.RefBtnText()
		this.RefPro()
		this.RefAttr()
		this.RefRed()
		this.RefCost()
		this.RefExchange()
	}

	//碎片兑换
	public RefExchange() {
		if (this.select_data) {
			let exchange_info = this.goodsmodel.GetGoodsExchangeData(7)
			if (exchange_info && this.is_active && !this.model.IsMaxLv(this.select_data.id)) {
				for (let k in exchange_info) {
					let v = exchange_info[k]
					if (v.id == this.select_data.exchange && v.can_exchange == 1) {
						if (v.can_exchange == 1) {
							this.click_box.visible = true
							return
						}
						break
					}
				}
			}

		}
		this.click_box.visible = false
	}

	//来源
	public RefSource() {
		this.source.visible = !this.is_active
		if(PlatformManager.IsEyouPlatform()){
			this.skill_desc.width = 430
			this.source_skill.height = 80
			this.skillbg.height = 99
			this.skillbg.y = 28
		}else{
		this.skill_desc.width = 350
		}
		this.souredesc.width = 400
		if (!this.is_active) {
			let data = this.select_data
			let cond = data.condition
			if (cond && cond == 0) {
				this.source.visible = false
			} else {
				this.jump_id = data.jump
				let desc = cond
				this.souredesc.innerHTML = Util.StrToHTML(`<a href='1' >${desc}</a>`)
				this.souredesc.x = 720 / 2 - this.souredesc.contextWidth / 2
				if (!this.skill_item) {
					this.skill_item = new PartnerSkillItem(this.skill)
					this.skill_item.Load()
				}
				let skill_list = data.skill_list
				if (skill_list) {
					skill_list = JSON.parse(skill_list)
				}
				this.skill_item.ExcuteCallback(() => {
					this.skill_item.SetData(skill_list[0], data.id, true)
				})
				let skill_cfg = SkillManager.GetInstance().getSkillFromConfig(Number(skill_list[0]))
				let lv_data = JSON.parse(skill_cfg.lv_data)
				let desc1 = lv_data[0].desc
				let sd: string = ""
				if (desc1) {
					// let desc2 = desc1.replace("639C12", "b3ff48")
					if (window["ChatModel"]) {
						desc1 = window["ChatModel"].GetInstance().FormatColorTag(desc1);
					}
					this.source_skill.y=38
					this.source_skill.height = 78
					this.skill_desc.innerHTML = Util.StrToHTML(skill_cfg.name + "<font color='#ff4f50'>未激活</font>" + "<br/>" + desc1)
					this.skill_desc.y = this.source_skill.height / 2 - this.skill_desc.contextHeight / 2
				}

			}
		}
	}

	//技能
	public RefSkill() {
		this.gp_skill.visible = this.is_active
		if (this.is_active) {
			let data = this.select_data
			let skill_list = data.skill_list
			if (skill_list) {
				skill_list = JSON.parse(skill_list)
				for (let k in skill_list) {
					let v = skill_list[k]
					let item = this.skill_items[k]
					if (!item) {
						item = new PartnerSkillItem(this.gp_skill)
						item.Load()
						this.skill_items[k] = item
					}
					item.SetData(v, data.id, null, k)
				}
			}
		}
	}

	public RefRed() {

		let red = this.model.GetRed(this.select_data.id, 1) || this.model.GetRed(this.select_data.id, 2)
		this.btnred.visible = red && !PartnerModel.Is_Requeste
	}


	public RefCost() {
		this.goods_name.width = 400
		if (!this.goods_item) {
			this.goods_item = new BaseAwardItem(this.item)
			this.goods_item.SetItemSize(87, 87)
			this.goods_item.Load()
		}
		let type_id = this.select_data.goods_id
		this.goods_item.ExcuteCallback(() => {
			let num = this.goodsmodel.GetTypeGoodsNum(type_id)
			this.goods_item.SetData(type_id, num)
		})
		let basic = this.goodsmodel.GetGoodsBasicByTypeId(type_id)
		if (basic) {
			let color = ColorUtil.GetColorLight(basic.color)
			let x = 233
			let bool = true
			if (!this.is_active && this.model.IsSpecialActive(this.select_data.id)) { //充值激活伙伴
				this.goods_name.innerHTML = "累计充值" + this.model.GetSpecialActiveCost(this.select_data.id) / 10 + "元即可激活"
				x = 153
				bool = false
			} else {
				this.goods_name.innerHTML = Util.StrToHTML("<font color=" + color + ">" + basic.goods_name + "</font>"
				)
			}
			this.goods_name.x = x
			this.item.visible = bool
		}
	}

	//属性
	public RefAttr() {
		let next_cfg
		let attr_list
		let data = this.select_data
		let info = this.model.GetInfoByID(this.select_data.id)
		if (!this.is_active) {
			attr_list = info.attr
		} else {
			let key = data.id + "@" + info.stage + "@" + info.star
			let stage_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_companion_stage", false)
			let cur_cfg = Config.GetConfigVo("config_companion_stage", key, false, stage_cfgs)
			if (cur_cfg) {
				cur_cfg = ErlangParser.GetInstance().Parse(cur_cfg.attr)
				key = data.id + "@" + info.stage + "@" + (info.star + 1)
				let cur_stage_cfg = Config.GetConfigVo("config_companion_stage", key, false, stage_cfgs)
				if (!cur_stage_cfg) {
					key = data.id + "@" + (info.stage + 1) + "@1"
					cur_stage_cfg = Config.GetConfigVo("config_companion_stage", key, false, stage_cfgs)
				}
				if (cur_stage_cfg) {
					next_cfg = ErlangParser.GetInstance().Parse(cur_stage_cfg.attr)
				}
				if (next_cfg) {
					for (let k in next_cfg) {
						let v = next_cfg[k]
						for (let k1 in cur_cfg) {
							let v1 = cur_cfg[k1]
							if (v[0] == v1[0]) {
								v[1] = Number(v[1]) - Number(v1[1])
							}
						}
					}
				}
			}
			attr_list = info.attr
		}
		this.attr_number = attr_list.length
		let count = 0
		for (let k in attr_list) {
			let v = attr_list[k]
			let item = this.attr_items[k]
			if (!item) {
				item = new PartnerAttrItem(this.gp_attrs)
				item.Load()
				this.attr_items[k] = item
			}
			item.ExcuteCallback(() => {
				count++
				if (count == this.attr_number) {
					RefGridLayout(this.gp_attrs, this.attr_box_data)
				}
				item.SetData(k, v, next_cfg)
				item.visible = true
			})
		}
		let len1 = this.attr_items.length
		let len2 = attr_list.length
		if (len1 > len2) {
			for (let i = len2; i < len1; i++) {
				this.attr_items[i].visible = false
			}
		}
	}

	public RefBtnText() {
		let desc = "激活消耗:"
		let btn_text = "激活"
		let res = "uian_010b"
		let outcolor = "#c95b37"
		if (this.is_active && this.select_data) {
			if (this.model.IsMaxLv(this.select_data.id)) {
				btn_text = "已满级"
			} else {
				btn_text = "升星"
			}
			desc = "升星消耗:"

			if (PartnerModel.Is_Requeste) {
				btn_text = "停止提升"
				res = "uian_001a"
				outcolor = "#3e9298"
			}
		}
		this.desc.text = desc
		this.btn_text.text = btn_text
		this.btn_text.strokeColor = outcolor
		this._img_btn.skin = GameResPath.GetIcon("common", `${res}`)// `common_json.${res}_png`
	}

	//经验或祝福值
	public RefPro() {
		if (this.is_playing) { // 播放动画时跳过
			this.need_Ref_func = true
			return
		}
		let data = this.select_data
		if (!data) { return }
		let info = this.model.GetInfoByID(this.select_data.id)
		if (!info) { return }
		this.name_res.width = 300
		if (PlatformManager.IsEyouEnPlatform()) {
			this.name_res.innerHTML = Util.StrToHTML(data.name + "&nbsp;"+ "G" + info.stage)
		}else{
				this.name_res.innerHTML = Util.StrToHTML(data.name + "&nbsp;" + + info.stage + "阶")
		}
		SetHtmlCenter(this.name_res,{x:204,w:300})
		let have_num = 0
		let need_num = 0
		let bg_width = 304
		let width = 302
		let bg_x = 233
		let x = 234
		let value_x = 47
		if (this.is_active) {
			have_num = info.blessing
			let key = data.id + "@" + info.stage + "@" + info.star
			let stage_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_companion_stage", false)
			let cur_stage_cfg = Config.GetConfigVo("config_companion_stage", key, false, stage_cfgs)
			if (cur_stage_cfg) {
				if (info) {
					need_num = cur_stage_cfg.need_blessing
				}
			}
		} else {
			if (this.model.IsSpecialActive(data.id)) { //充值激活伙伴
				have_num = VipModel.GetInstance().all_recharge_record
				need_num = this.model.GetSpecialActiveCost(data.id)
				bg_width = 404
				bg_x = 143
				width = 402
				x = 144
				value_x = 0
			} else {
				have_num = this.goodsmodel.GetTypeGoodsNum(data.goods_id)
				need_num = data.goods_num
			}
		}
		this.progress_max = width
		this.progressbg.width = bg_width
		// this.progress.width = width
		this.progressbg.x = bg_x
		this.progress.x = x
		// this.progerssvalue.horizontalCenter = value_x
		if (this.model.IsMaxLv(data.id)) {
			this.progerssvalue.text = "已满级"
			this.progress.width = this.progress_max
		} else {
			if ((have_num / need_num) >= 1) {
				this.progress.width = this.progress_max
			} else {
				this.progress.width = (have_num / need_num) * this.progress_max
			}
			if (!this.is_active && this.model.IsSpecialActive(this.select_data.id)) { //充值激活伙伴
				this.progerssvalue.text = `${TransformCurrency(have_num)}/${TransformCurrency(need_num)}`
			} else {
				this.progerssvalue.text = have_num + "/" + need_num
			}

		}
	}

	//经验动画
	public PlayAnim(scmd?, old_info?) {
		let data = this.select_data
		if (!data) { return }
		let info = old_info
		let stage_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_companion_stage", false)
		let cfg = Config.GetConfigVo("config_companion_stage", `${data.id}@${info.stage}@${info.star}`, false, stage_cfgs)
		if (info && cfg) {
			let tween_func
			let func = () => {
				if (this.progress.width != this.progress_max || Util.IsTableEmpty(this.tween_cache)) {
					this.Request_up_star()
				}
				this.is_playing = false
				Laya.Tween.clearAll(this.progress)
				this.tween = null
				if (this.tween_cache[0]) {
					tween_func(this.tween_cache[0])
					this.tween_cache.splice(0, 1)
				} else if (this.need_Ref_func) {
					this.need_Ref_func = false
					this.RefPro()
				}
			}
			tween_func = (value?) => {
				if (!this.tween) {
					this.is_playing = true
					let blessing = value[0]
					let max_blessing = value[1]
					if (this.progress.width == this.progress_max) {
						this.progress.width = 0
					}
					if (!this.is_active && this.model.IsSpecialActive(this.select_data.id)) { //充值激活伙伴
						this.progerssvalue.text = blessing / 10 + "/" + max_blessing / 10
					} else {
						this.progerssvalue.text = blessing + "/" + max_blessing
					}
					// Laya.Tween.get(this.progress.mask).to({ width: (blessing / max_blessing) * this.progress.width }, 200).call(func)
					let width =
						this.tween = Laya.Tween.to(this.progress, { width: (blessing / max_blessing) * this.progress_max }, 200, undefined, Laya.Handler.create(this, () => {
							func()
						}))
				} else {
					if (!this.tween_cache) { this.tween_cache = [] }
					this.tween_cache.push(value)
				}
			}
			let up_level = scmd.star != info.star || scmd.stage != info.stage
			if (up_level) {
				let value = Number(cfg.need_blessing)
				tween_func([value, value])
				let next_cfg = stage_cfgs[data.id + "@" + scmd.stage + "@" + scmd.star]
				if (next_cfg) {
					value = Number(next_cfg.need_blessing)
					tween_func([scmd.blessing, value])
				}
			} else {
				tween_func([scmd.blessing, Number(cfg.need_blessing)])
			}
		}
	}


	public SwitchView() {
		this.switch_type = this.switch_type == 2 ? 1 : 2
		if (this.is_loaded) {
			this._box_att.visible = this.switch_type == 1
			this._box_biog.visible = this.switch_type == 2
		}
	}

	biog_list_loop: LoopScrowViewMgr
	current_biog_index_ = 0
	current_partner_id_ = -1
	biog_list_
	current_biog_state = 0
	biog_data
	public SetBiog() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_biog_tbg, GameResPath.GetIconOtherPath("partner", "ui_witch_20"))

		let cfg =  Config.PRELOAD_CLIENT_CONFIG.ConfigCompanionBiog
		this.biog_list_ = cfg && cfg[this.select_data.id] || []

		//把当前选中的伙伴id赋值给子节点
		for(let i = 0;i<this.biog_list_.length;i++){
			this.biog_list_[i]["temp_companion_id"] = this.select_data.id
		}


		if (this.biog_list_loop) this.biog_list_loop.SetSelectIndex(-1) //引起渲染
		if (!this.biog_list_loop) {
			this.current_partner_id_ = this.select_data.id
			this.biog_list_loop = new LoopScrowViewMgr()
			this.biog_list_loop.SetData(this._list_biog_tab, PartnerBiogTabItem, this.biog_list_, LoopScrCon.Horizontal, 1, (index) => {
				if (index == -1) return
				this.current_biog_index_ = index
				this.biog_data = this.biog_list_[index]
				if(!this.biog_data)return
				this.UpdateBiogTab(true)
			}, this.current_biog_index_)
		} else {
			this.biog_list_loop.replaceAll(this.biog_list_)
			if (this.current_partner_id_ != this.select_data.id) {
				this.current_partner_id_ = this.select_data.id
				this.current_biog_index_ = 0
			}
			this.biog_list_loop.SetSelectIndex(this.current_biog_index_)
		}

		let info = this.model.GetInfoByID(this.select_data.id)
		let key = this.select_data.id + "@" + info.stage + "@" + info.star
		let stage_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_companion_stage", false)
		let cur_cfg = Config.GetConfigVo("config_companion_stage", key, false, stage_cfgs)
	}


	private UpdateBiogTab(is_rolltotop?){
		let status = PartnerModel.GetInstance().CheckIsUnlockBiog(this.select_data.id,this.biog_data.id)
		this.current_biog_state = status
		this._img_biog_lock.visible=this._panel_biog.visible=false

		let type_id = this.select_data.goods_id
		let name = this.select_data.name
		let arr,un_lock_str,basic

		//检查传记的状态 0未解锁  1 待解锁 2解锁
		switch (status) {
			case 0:
				basic = this.goodsmodel.GetGoodsBasicByTypeId(type_id)
				name = this.select_data.name
				if (basic) {
					let color = ColorUtil.GetColorLight(basic.color)
					name = Util.StrToHTML("<font color=" + color + ">" + basic.goods_name + "</font>")
				}
				arr = PartnerModel.GetInstance().GetBiogUnLockData(this.select_data.id,this.biog_data.id)
				un_lock_str = `${arr[0]}阶${arr[1]}星`
				this._html_biog_title.innerHTML = `${name}达到${HtmlColorTxt(un_lock_str,Enum_ColorUtil_Dark.RED)}解锁`

				this._img_biog_lock.visible=true
				this._box_biog_eff.visible=false
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_biog_lock, GameResPath.GetIconOtherPath("partner", "ui_witch_22"))
				break
			case 1:
				basic = this.goodsmodel.GetGoodsBasicByTypeId(type_id)
				name = this.select_data.name
				if (basic) {
					let color = ColorUtil.GetColorLight(basic.color)
					name = Util.StrToHTML("<font color=" + color + ">" + basic.goods_name + "</font>")
				}
				arr = PartnerModel.GetInstance().GetBiogUnLockData(this.select_data.id,this.biog_data.id)
				un_lock_str = `${arr[0]}阶${arr[1]}星`
				this._html_biog_title.innerHTML = `${name}达到${HtmlColorTxt(un_lock_str,Enum_ColorUtil_Dark.RED)}解锁`


				this._img_biog_lock.visible=true
				this._box_biog_eff.visible=true
				this.AddUIEffect("effect_ui_fengyinjiechu_01",this._box_biog_eff,null,7,true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_biog_lock, GameResPath.GetIconOtherPath("partner", "ui_witch_21"))
				break;
			case 2:
				this._box_biog_eff.visible=false
				this._panel_biog.visible=true
				this._html_biog_title.innerHTML = this.biog_data.title
				this._html_biog_desc.innerHTML = this.biog_data.desc
				this._html_biog_desc.style.width = 685
				this._panle_sub_box.height = this._html_biog_desc.contextHeight

				if(is_rolltotop){
					this._panel_biog.vScrollBar.value = 0
				}
				break;
		}

		this._img_title_bg.width = this._html_biog_title.contextWidth+53
	}



	public Request_up_star() {
		if (!this.select_data || !PartnerModel.Is_Requeste) { return }
		if (this.model.IsMaxLv(this.select_data.id)) {
			Message.show("已满阶")
			PartnerModel.Is_Requeste = false
		} else {
			let have_num = this.goodsmodel.GetTypeGoodsNum(this.select_data.goods_id)
			if (have_num > 0) {
				this.model.Fire(PartnerModel.REQUSET_SCMD, 14205, this.select_data.id)
			} else {
				Message.show("材料不足")
				PartnerModel.Is_Requeste = false
			}
		}
		this.RefBtnText()
	}


	public SetData(id?) {
		if (id) {
			this.select_id = id
		}
	}

	public DeleteMe() {
		this.ClearUIEffect(this._box_biog_eff)
		if (this.attr_items && !Util.IsTableEmpty(this.attr_items)) {
			for (let k in this.attr_items) {
				let v = this.attr_items[k]
				v.DeleteMe()
			}
			this.attr_items = null
		}
		if (this.skill_items && !Util.IsTableEmpty(this.skill_items)) {
			for (let k in this.skill_items) {
				let v = this.skill_items[k]
				v.DeleteMe()
			}
			this.skill_items = null
		}
		if (this.skill_item) {
			this.skill_item.DeleteMe()
			this.skill_item = null
		}
		if (this.goods_item) {
			this.goods_item.DeleteMe()
			this.goods_item = null
		}
		// this.Content.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SelectItem, this)
		// Laya.Tween.removeTweens(this.progress.mask)
		Laya.Tween.clearAll(this.progress)
		this.tween_cache = null
		PartnerModel.Is_Requeste = false

		if (this.channel) {
			SoundManager.GetInstance().StopSoundEffect(this.channel)
			this.channel = null
		}
		super.DeleteMe()
	}


bg:Laya.Image
Image:Laya.Image
itemScroll:Laya.List
_box_att:Laya.Box
skillbg:Laya.Image
gp_skill:Laya.HBox
source:Laya.Box
souredesc_box:Laya.Box
souredesc:Laya.HTMLDivElement
source_skill:Laya.HBox
skill:Laya.Box
skill_desc:Laya.HTMLDivElement
name_bg:Laya.Image
name_res:Laya.HTMLDivElement
gp_attrs:Laya.Box
desc:Laya.Label
item:Laya.Box
progressbg:Laya.Image
progress:Laya.Image
progerssvalue:Laya.Label
goods_name:Laya.HTMLDivElement
btn:Laya.Box
_img_btn:Laya.Image
btn_text:Laya.Label
btnred:Laya.Image
click_box:Laya.Box
exchange:Laya.HTMLDivElement
_box_biog:Laya.Box
_img_biog_tbg:Laya.Image
_img_title_bg:Laya.Image
_img_biog_lock:Laya.Image
_html_biog_title:Laya.HTMLDivElement
_box_biog_eff:Laya.Box
_list_biog_tab:Laya.List
_panel_biog:Laya.Panel
_panle_sub_box:Laya.Box
_html_biog_desc:Laya.HTMLDivElement
public GetComponents() {
[
this.bg,
this.Image,
this.itemScroll,
this._box_att,
this.skillbg,
this.gp_skill,
this.source,
this.souredesc_box,
this.souredesc,
this.source_skill,
this.skill,
this.skill_desc,
this.name_bg,
this.name_res,
this.gp_attrs,
this.desc,
this.item,
this.progressbg,
this.progress,
this.progerssvalue,
this.goods_name,
this.btn,
this._img_btn,
this.btn_text,
this.btnred,
this.click_box,
this.exchange,
this._box_biog,
this._img_biog_tbg,
this._img_title_bg,
this._img_biog_lock,
this._html_biog_title,
this._box_biog_eff,
this._list_biog_tab,
this._panel_biog,
this._panle_sub_box,
this._html_biog_desc,
]
 = this.GetChildrenByNames([

"bg",
"Image",
"itemScroll",
"_box_att",
"skillbg",
"gp_skill",
"source",
"souredesc_box",
"souredesc",
"source_skill",
"skill",
"skill_desc",
"name_bg",
"name_res",
"gp_attrs",
"desc",
"item",
"progressbg",
"progress",
"progerssvalue",
"goods_name",
"btn",
"_img_btn",
"btn_text",
"btnred",
"click_box",
"exchange",
"_box_biog",
"_img_biog_tbg",
"_img_title_bg",
"_img_biog_lock",
"_html_biog_title",
"_box_biog_eff",
"_list_biog_tab",
"_panel_biog",
"_panle_sub_box",
"_html_biog_desc",
])
}
}
 window["PartnerDetailsView"]= PartnerDetailsView