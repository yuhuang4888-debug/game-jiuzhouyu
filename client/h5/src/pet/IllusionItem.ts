import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, Trim, GlobalTimerQuest } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class IllusionItem extends BaseItem1 {
	bg: Laya.Image
	select_bg: Laya.Image
	group: Laya.Box
	_Group1: Laya.Box
	icon_bg: Laya.Image
	icon_image: Laya.Image
	icon_stage: Laya.Label
	click_bg: Laya.Image
	red_dot: Laya.Image
	res_name: Laya.HTMLDivElement
	state_text: Laya.HTMLDivElement
	using_tip: Laya.Image
	shadow_group: Laya.HBox
	star_group: Laya.HBox


	private show_red
	private illusion_name
	private goods_id
	private illusion_id
	private icon_id
	private picture
	// private illusion_stage
	private state
	private callback
	private need_refresh
	private select
	private usingflag
	private active_flag
	private type_id
	private select_state
	private active_timer
	private end_time
	private need_list = []
	private star_list = { }
	private shadow_list
	public model = OutWardBaseModel.GetInstance()

	public constructor(parent?) {
		super(parent)
		this.base_file = "pet"
		this.layout_file = "IllusionItem"
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

	}

	public LoadSuccess() {
		if (this.need_refresh) {
			this.need_refresh = false
			this.SetData(this.illusion_id, this.goods_id, this.illusion_name, this.type_id, this.show_red,this.picture)
			if (this.icon_id) {
				this.SetIconImage(this.icon_id)
			}
		}
	}

	public InitEvent() {
		let ClickCallback = () => {
			//SoundManager:GetInstance():PlaySoundEffect("2_dianji")
			if (this.type_id && this.illusion_id && !this.select_state) {
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.SELECT_ILLUSION_ITEM, this.type_id, this.illusion_id)
			}
		}
		Util.AddClickEvent(this.click_bg, ClickCallback, this, false)

		this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.SELECT_ILLUSION_ITEM, (type_id?, illusion_id?) => {
			if (type_id == this.type_id && illusion_id == this.illusion_id) {
				this.SetSelect(true)
			} else if (type_id == this.type_id && this.select_state == true) {
				this.SetSelect(false)
			}
		})
	}

	public SetData(id?, goods_id?, name?, type_id?, show_red?,pricture?) {
		this.illusion_id = id
		this.goods_id = goods_id
		this.illusion_name = name
		this.type_id = type_id
		this.show_red = show_red
		this.picture=pricture
		if (this.is_loaded) {
			this.need_refresh = false
			let goods_basic
			if (this.type_id == enum_OutWardType.Horse || this.type_id == enum_OutWardType.Partner) {//坐骑和伙伴是碎片激活
				goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.goods_id - 100)
			} else if (this.type_id == enum_OutWardType.Wings || this.type_id == enum_OutWardType.Artifact || this.type_id == enum_OutWardType.BackOrnament) {
				let s_goods_id = String(this.goods_id)
				s_goods_id = `${s_goods_id.slice(0, 5)}0${s_goods_id.slice(6, 8)}`
				this.goods_id = Number(s_goods_id)
				goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.goods_id)
			} else {
				goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.goods_id)
			}
			if (!goods_basic) { return }
			let color = goods_basic.color || 0
			// this.icon_bg.source = "common_json.com_goods_plate_" + color + "_png"

			ResManager.GetInstance().SetImageSpriteTrans(this, this.icon_bg, GameResPath.GetIcon("common", "com_goods_plate_" + color))
			if (this.type_id == 5) { //神兵特殊处理
				ResManager.GetInstance().SetTexture(this, this.icon_image, GameResPath.GetGoodsIconPath(pricture))
			}else{
				ResManager.GetInstance().SetTexture(this, this.icon_image, GameResPath.GetGoodsIconPath(goods_basic.goods_icon))
			}
			this.res_name.innerHTML = Util.StrToHTML("<font color='#2971e6'>" + Trim(this.illusion_name) + "</font>")
			if (this.select) {
				this.SetSelect(this.select)
			}
			if (this.usingflag) {
				this.SetUsing(this.usingflag)
			}
			if (this.active_flag != undefined) {
				this.SetActive(this.active_flag)
			}
			this.SetRedDot(this.show_red)
			if (this.icon_id) {
				this.SetIconImage(this.icon_id)
			}
		} else {
			this.need_refresh = true
		}
	}

	public SetSelect(bool?) {
		this.select_state = bool
		if (this.is_loaded) {
			this.select_bg.visible = bool
		} else {
			this.select = bool
		}
	}

	public SetUsing(bool?) {
		this.usingflag = bool
		if (this.is_loaded) {
			if (bool) {
				this.using_tip.visible = true
			} else {
				this.using_tip.visible = false
			}
		} else {
			this.usingflag = bool
		}
	}

	public SetRedDot(bool?) {
		if (this.is_loaded) {
			this.red_dot.visible = bool
		} else {
			this.show_red = bool
		}
	}

	public SetActive(active_flag?) {
		this.active_flag = active_flag
		if (this.is_loaded) {
			this.state_text.width=200
			if (this.active_flag != 0 && this.active_flag != false) {
				if (typeof (active_flag) == "number") {
					this.SetStar(active_flag)
					this.state_text.innerHTML = ""
				} else {
					this.state_text.innerHTML = Util.StrToHTML("<font color='#639c12'>" + this.active_flag + "</font>")
				}
				Util.SetImageGray(this.group, false)
			} else {
				this.star_group.visible = false
				this.shadow_group.visible = false
				this.state_text.innerHTML = Util.StrToHTML("<font color='#fe3638'>未激活</font>")
				// this.state_text.innerHTML = Util.StrToHTML("<font color='#ff4f50'>未激活</font>")
				Util.SetImageGray(this.group, true)
			}
		}
	}

	public SetIconImage(icon_id?) {
		this.icon_id = icon_id
		if (this.is_loaded) {
			let x = this.icon_id
			ResManager.GetInstance().SetTexture(this, this.icon_image, GameResPath.GetGoodsIconPath(this.icon_id))
		} else {
			this.need_refresh = true
		}
	}

	public SetTimer(end_time?) {
		this.CancelTimer()
		this.star_group.visible = false
		this.shadow_group.visible = false
		this.end_time = end_time
		this.active_timer = GlobalTimerQuest.AddPeriodQuest(this.IllusionTimer, 1)
		// this.active_timer.addEventListener(Laya.TimerEvent.TIMER, this.IllusionTimer, this)

		// this.active_timer.start()
		this.IllusionTimer()
	}

	public IllusionTimer() {
		let last_time = this.end_time - TimeUtil.getServerTime()
		if (this.state_text) {
			if (last_time > 0) {
				this.state_text.innerHTML = Util.StrToHTML("<font color='#639c12'>" + TimeUtil.convertTime(last_time) + "</font>")
				Util.SetImageGray(this.group, false)
			} else {
				this.CancelTimer()
				this.state_text.innerHTML = Util.StrToHTML("<font color='#ff4f50'>未激活</font>")
				Util.SetImageGray(this.group, true)
			}
		}
	}

	public CancelTimer() {
		if (this.active_timer) {
			GlobalTimerQuest.CancelQuest(this.active_timer)
			this.active_timer = null
		}
	}

	public SetStar(star?) {
		this.star_group.visible = true
		this.shadow_group.visible = true

		//显示图标类型 1-6 星星  7-11 月亮 12-16太阳
		let iconType = Math.floor((star - 2) / 5)
		let iconNum = star == 1 ? 0 : (star - 2) % 5 + 1
		let res
		let shadowRes
		if (!this.shadow_list) {
			this.shadow_list = { }
		}
		if (iconType < 1) {
			shadowRes = `pet_star_shadow`
		} else if (iconType == 1) {
			shadowRes = `pet_moon_shaow`
		} else {
			shadowRes = `pet_son_shadow`
		}
		for (let i = 0; i < 5; i++) {
			if (!this.star_list[i]) {
				let img = new Laya.Image()
				img.width = 20
				img.height = 20
				this.star_group.addChild(img)
				// this.star_group[i] = img
				this.star_list[i] = img
			}
			let star = <Laya.Image>this.star_group.getChildAt(i)
			if (i < iconNum) {
				if (iconType < 1) {
					res = `pet_star`
				} else if (iconType == 1) {
					res = `pet_moon`
				} else {
					res = `pet_son`
				}
				star.skin = GameResPath.GetPetPath(res)
				star.visible = true
			} else {
				star.visible = false
			}

			if (!this.shadow_list[i]) {
				let img = new Laya.Image()
				img.width = 20
				img.height = 20
				this.shadow_group.addChild(img)
				this.shadow_list[i] = img
			}

			let shadow = <Laya.Image>this.shadow_group.getChildAt(i)
			if (shadow) {
				shadow.skin = GameResPath.GetPetPath(shadowRes)
			}
		}
	}

	public DeleteMe() {
		this.CancelTimer()
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this.bg,
			this.select_bg,
			this.group,
			this._Group1,
			this.icon_bg,
			this.icon_image,
			this.icon_stage,
			this.click_bg,
			this.red_dot,
			this.res_name,
			this.state_text,
			this.using_tip,
			this.shadow_group,
			this.star_group,
		]
			= this.GetChildrenByNames([

				"bg",
				"select_bg",
				"group",
				"_Group1",
				"icon_bg",
				"icon_image",
				"icon_stage",
				"click_bg",
				"red_dot",
				"res_name",
				"state_text",
				"using_tip",
				"shadow_group",
				"star_group",
			])
		this.res_name.style.fontSize=22
		this.res_name.style.color="#6773a5"
		this.res_name.style.wordWrap = false
		this.state_text.style.fontSize=20
		this.state_text.style.color="#ffffff"
	}
}
window["IllusionItem"] = IllusionItem