
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { Config } from "../common/Config"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { HtmlColorTxt, RefBoxChildsLayout, SetHtmlCenter, SetHtmlStyle, TransformLevel, Util } from "../util/Util"
import { VipModel } from "../commonModel/VipModel"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ErlangParser } from "../util/ErlangParser"
import { ShopModel } from "../commonModel/ShopModel"
import { Alert, Alert_Type } from "../alert/Alert"
import { SceneManager } from "../scene/SceneManager"
import { TeamModel } from "../commonModel/TeamModel"
import { TaskModel } from "../commonModel/TaskModel"
import { StoryModel } from "../commonModel/StoryModel"
import { PlatformManager } from "../PlatformManager"


export class DungeonMaterialNewEnterItem extends BaseItemRenderer {
	public WIDTH = 270
	public HEIGT = 682

	InitEvent
	LoadSuccess
	SetStarNum

	AddImage
	SetReward
	SetSweepNum
	onListStart
	Sweepingfunc
	UpdateView
	updatePoint

	dungeon_data_ = null
	dungeon_model: BaseDungeonModel
	resmgr: ResManager
	dun_data
	dun_show_type
	reward_item_list_
	scroll_bar
	left_count_sweep
	left_count_challenge
	pre_difficult
	ShowArrow

	dun_cfg
	sewwp_cfg
	jin_event_id_
	public constructor(parent?) {
		super()

		this.base_file = "dungeonMaterial"
		this.layout_file = "DungeonMaterialNewEnterItem"
		this.dungeon_data_ = null
		this.dungeon_model = BaseDungeonModel.GetInstance()
		this.resmgr = ResManager.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		this.dun_data = null
		this.pre_difficult = null
		this.left_count_sweep = 0
		this.left_count_challenge = 0

		this.load_callback = () => {
			this._scroll_reward.hScrollBarSkin = ""
			this.scroll_bar = this._scroll_reward.hScrollBar
			SetHtmlStyle(this._text_challenge_num, { c: "#663915", f: 20, w: 254, ww: false })
			// SetHtmlStyle(this._lb_cost, { c: "#663915", f: 20, w: 254, ww: false })
			if(PlatformManager.IsEyouPlatform()){
			SetHtmlStyle(this._html_next_open, { c: "#ffffff", f: 16, ww: false, w: 152 })
			}else{
				SetHtmlStyle(this._html_next_open, { c: "#ffffff", f: 20, ww: false, w: 152 })
			}
			this.base_item.AddUIEffect("ui_anniu_5", this._box_eff, null, { x: 8, y: 10, z: 1 }, true)
			this.InitEvent()
		}


		this.InitEvent = () => {
			this.scroll_bar.on(Laya.Event.START, this, this.onListStart)

			let challenge_func = () => {
				if (!this.dun_data) return
				if (this.dun_show_type == BaseDungeonModel.TYPE_NEW_INLOCK) {
					Message.show(this.dungeon_model.GetNewDungeonOpenTips(this.dun_data.dun_id))
					return
				}


				if (SceneManager.GetInstance().IsSuitBossScene()) {
					Message.show("当前场景不能进入")
					return
				}

				//先退出队伍
				if (!this.dungeon_model.TryToEnterDungeon(this.dun_data.dun_id)) return

				if (this.dun_data) {

					if (this.dun_show_type == BaseDungeonModel.TYPE_NEW_DIFF_SHOW
						|| this.dun_show_type == BaseDungeonModel.TYPE_NEW_DUNGEON
						|| this.dun_show_type == BaseDungeonModel.TYPE_NORMAL_HAS_TIMES) {
						let open = this.dungeon_model.DungeonOpenCondition(this.dun_data.type)
						if (!open) {
							return
						}

						if (this.left_count_challenge <= 0) {
							Message.show("剩余副本挑战次数不足")
							return
						}


						this.dungeon_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61001, this.dun_data.dun_id)
					} else {
						this.Sweepingfunc()
					}

				}
			}

			this.BindEvent(this.dungeon_model, BaseDungeonModel.QUIT_DUNGEON_RETURN, (dun_id) => {
				if (this.dun_data && this.dun_data.dun_id == dun_id) {
					challenge_func()
				}
			})
			Util.AddClickEvent(this._gp_challenge, challenge_func, this, true)

			Util.AddClickEvent(this._img_quit, () => {
				if (this.pre_difficult) GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonMaterialNewPreviewView", this.pre_difficult)
			}, this, true)


			let update_view_func_1 = (dun_id?) => {
				if (this.dun_data && this.dun_data.dun_id == dun_id) {
					this.UpdateView()
				}
			}

			this.BindEvent(this.dungeon_model, BaseDungeonModel.UPDATE_DUNGEON_TIME, update_view_func_1)
			let update_view_func_2 = (dun_type?) => {
				if (this.dun_data && this.dun_data.type == dun_type) {
					this.UpdateView()
				}
			}

			this.BindEvent(this.dungeon_model, BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, update_view_func_2)
			this.BindEvent(this.dungeon_model, BaseDungeonModel.UPDATE_ACTIVITY, (base_type?, sub_type?) => {
				if (base_type && base_type == BaseDungeonModel.MORE_ACTIVITY || !base_type) {
					this.updatePoint()
				}
			}
			)
			this.BindVar(role_mgr.GetMainRoleVo(), "vip_flag", (event_name?, value?, old_value?) => {
				this.UpdateView()
			}
			)
			this.BindEvent(VipModel.GetInstance(), VipModel.UPDATE_NOBLE_STATE, () => {
				this.UpdateView()
			}
			)
			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				if (!this.data) return
				for (let _tmpi in goods_list) {
					var vo = goods_list[_tmpi]
					if (vo.type_id == this.sewwp_cfg[0]) {
						this.SetSweepNum()
						break
					}
				}
			}
			)


			this.BindEvent(this.dungeon_model, BaseDungeonModel.NEW_DUNGEON_UPDATE_NUM, () => {
				this.UpdateView()
			})


			let update_one = () => {
				this.SetSweepNum()
			}

			this.jin_event_id_ = role_mgr.mainRoleInfo.BindOne("jinLock", update_one)

		}


		this.updatePoint = () => {
			if (!this.data) return
			let point = this.dungeon_model.getPoint(Number(this.data.dun_type))
			this._point_icon.visible = point > 0
			if (this._point_icon.visible) {
				let img = (point == 2 && ("uifb_027") || ("ui_fb_001"))
				ResManager.GetInstance().SetImageSprite(this, this._point_icon, "dungeonMaterial", img)
			}
		}


		this.UpdateView = () => {
			this.dataChanged()
		}


		this.Sweepingfunc = () => {
			let dun_model = this.dungeon_model
			let goods_model = GoodsModel.GetInstance()
			let role_level_ = role_mgr.GetMainRoleVo().level
			let open = dun_model.DungeonOpenCondition(this.dun_data.type)
			if (!open) {
				return
			}
			let dun_data = this.dun_data
			if (!dun_data || Number(dun_data.level) > role_level_) {
				Message.show("关卡未开启~")
				return
			}
			if ((dun_data && Number(dun_data.sweep_lv) > role_level_)) {
				Message.show(dun_data && dun_data.sweep_lv + "级开启扫荡~")
				return
			}
			if (!dun_data.is_sweep) {
				Message.show("需要通关副本才能扫荡")
				return
			}
			if (this.left_count_sweep <= 0) {
				Message.show("剩余副本扫荡次数不足")
				return
			}
			let sweep_num = 1
			let ok_func = () => {
				dun_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61022, dun_data.dun_id, sweep_num)
			}

			let shop_model = ShopModel.GetInstance()
			let cost_cfg = this.sewwp_cfg
			if (cost_cfg[0] == 2) {


				//免费不弹
				if (cost_cfg[2] <= 0) {
					ok_func()
					return
				}

				let arr = shop_model.MoneyIsEnough(2, cost_cfg[2])
				if (!arr[0]) {
					let arr2 = shop_model.MoneyIsEnough(1, arr[1])
					if (arr2[0]) {
						let str = "当前绑玉数量不足，是否消耗<font color='#639c12'>" + arr[1] + "勾玉</font>代替？"
						let content = Util.StrToHTML(str)
						Alert.Show(content, Alert_Type.Two, ok_func, null, "确定", "取消")
						Alert.SetIsCharge(true)
						return
					} else {
						Message.show(arr[3])
						return
					}
				} else {
					ok_func()
				}
			} else {
				ok_func()
			}
		}

		this.onListStart = function () {
			//panel开始滚动时停止list的滚动事件 
			if (!this.parent || !this.parent._parent) return
			this.parent._parent.scrollBar.stopScroll()
		}



		this.SetStarNum = (num) => {
			for (let i = 1; i <= this._box_star.numChildren; i++) {
				if (i <= num) {
					this.resmgr.SetImageSprite(this, this["_img_star_" + i], "dungeonMaterial", "star2")
				} else {
					this.resmgr.SetImageSprite(this, this["_img_star_" + i], "dungeonMaterial", "star_empty")
				}
			}
		}


		this.AddImage = (i, item, dun_type) => {
			if (dun_type == 18 && i == 1)
				return
			if (item) {
				let img = new Laya.Image()
				ResManager.GetInstance().SetImageSprite(this, img, "common2", "zhouka", true)
				item.display_obj.addChild(img)
				img.scaleX = img.scaleY = 1.3
				img.x = 0
				img.y = 0

			}
		}


		this.SetReward = () => {
			let goods_model = GoodsModel.GetInstance()
			let reward_list = []
			if (this.dun_data.reward) {
				reward_list = JSON.parse(this.dun_data.reward) || []
			}
			if (!this.reward_item_list_) {
				this.reward_item_list_ = []
			}

			for (let i = 0; i < this.reward_item_list_.length; i++) {
				this.reward_item_list_[i].SetVisible(false)
			}

			let count = 0
			let size = 89
			for (let p = 0; p < reward_list.length; p++) {

				let vo = reward_list[p]
				let item: BaseAwardItem = this.reward_item_list_[p]
				if (!item) {
					item = new BaseAwardItem(this.Content)
					this.reward_item_list_[p] = item
					item.Load()
				}
				item.ExcuteCallback(() => {
					if (WeekCardModel.GetInstance().GetWeekCardData().is_activity == 1)
						this.AddImage(p, item, this.dun_data.type)

					count++
					if (count >= reward_list.length) {
						this.Content.width = size * reward_list.length
						RefBoxChildsLayout(this.Content, 0, size, true, "left")
					}
				})
				let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo[2], lock)
					item.SetVisible(true)
					item.SetItemSize(size, size)
				}
			}

		}


		//is_hide 扫荡次数为0的时候，是否隐藏消耗框
		this.SetSweepNum = () => {
			if (!this.data || !this.dun_data) return
			if (!this.sewwp_cfg) return

			if (this.dun_show_type == BaseDungeonModel.TYPE_NEW_DIFF_SHOW
				|| this.dun_show_type == BaseDungeonModel.TYPE_NEW_DUNGEON
				|| this.dun_show_type == BaseDungeonModel.TYPE_NORMAL_HAS_TIMES) {
				return
			}

			this._box_cost.visible = this.left_count_sweep > 0
			if (this.left_count_sweep <= 0) return

			this._lb_cost.visible = this._img_icon.visible = this._img_icon2.visible = true
			let num = Number(this.sewwp_cfg[2])
			let arr = ShopModel.GetInstance().MoneyIsEnough(2, num)

			let color = arr[0] ? ColorUtil.GetReplaceChar(Enum_ColorUtil_Light.GREEN) : ColorUtil.GetReplaceChar(Enum_ColorUtil_Light.RED)
			this._lb_cost.color = color

			this._img_icon.visible = num > 0
			this._lb_cost.text = num > 0 ? num + "" : "本次免费"
			RefBoxChildsLayout(this._box_cost, 2)
		}


		this.ShowArrow = () => {
			if (!this.dun_data) {
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._gp_challenge)
				return
			}
			if (!TaskModel.GetInstance().MainTaskIsNewMaterialDunTaskType(this.dun_data.type)) {
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._gp_challenge)
				return
			}

			if(TaskModel.GetInstance().IsCurrMainTaskHasFinish()){
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._gp_challenge)
				return
			}

			StoryModel.GetInstance().curr_view_story_step = 1
			let step_cfg = TaskModel.GetInstance().GetNowGuideCfg(false)
			if (!step_cfg) {
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._gp_challenge)
				return
			}
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._gp_challenge, "UI", null, null, null, null, step_cfg, true)
		}


		this.Load()
	}

	// { dun_type: dun_type, index: material_type_dic_[dun_type] }
	public dataChanged() {
		if (!super.dataChanged()) return
		if (!this.data) return
		this.resmgr.SetTexture(this, this._img_title, GameResPath.GetIconOtherPath("dungeonMaterial", `ui_dungeon_type_${this.data.dun_type}`))
		this.resmgr.SetTexture(this, this._img_bg, GameResPath.GetIconOtherPath("dungeonMaterial", `ui_dungeon_type_bg_${this.data.dun_type}`))

		let d_data = this.dungeon_model.GetCurDifficult(this.data.dun_type)
		this.dun_data = d_data[0]  //当前展示的副本信息
		if(!this.dun_data) return
		this.dun_show_type = d_data[1] //副本状态类型
		this.pre_difficult = d_data[2]
		let roleManager = RoleManager.GetInstance()
		this._img_tag.visible = false
		this._lb_cost.visible = this._img_icon.visible = this._img_icon2.visible = false
		this.dun_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon[this.dun_data.dun_id]

		//第N次扫荡的数据
		let sweep_times = this.dungeon_model.GetDungeonTimesData(this.dun_data.type, 2) + 1
		this.sewwp_cfg = this.dungeon_model.GetSweepCost(this.dun_data.dun_id, sweep_times)
		let str_sweep
		let color
		this._box_eff.visible = false

		// this.dungeon_model.IsNewDungeonOpen(this.dun_data.dun_id,true)


		if (this.dun_show_type == BaseDungeonModel.TYPE_NORMAL
			|| this.dun_show_type == BaseDungeonModel.TYPE_NEW_DIFF_HIDE) {
			//扫荡
			let sweep_times = this.dungeon_model.GetDungeonChallengeTimes(this.dun_data.type, 2) //总共扫荡次数
			let left_sweep = sweep_times - this.dungeon_model.GetDungeonTimesData(this.dun_data.type, 2) //剩余扫荡次数
			this.left_count_sweep = left_sweep > 0 ? left_sweep : 0
			this._Label2.text = "扫荡"
			this.SetSweepNum()
			this._box_eff.visible = this.left_count_sweep > 0 && this.dun_show_type != BaseDungeonModel.TYPE_NEW_INLOCK
			color = this.left_count_sweep <= 0 ? '"#ff0000"' : '"#0a953e"'
			str_sweep = HtmlColorTxt("" + this.left_count_sweep, color)
			this._text_challenge_num.innerHTML = `今日扫荡次数：${str_sweep}${HtmlColorTxt("/" + sweep_times, '"#0a953e"')}`
		} else {
			//挑战
			let challenge_times = this.dungeon_model.GetDungeonChallengeTimes(this.dun_data.type, 1) //总共挑战次数
			this.left_count_challenge = challenge_times - this.dungeon_model.GetDungeonTimesData(this.dun_data.type, 1)//剩余挑战次数
			this._box_eff.visible = this.left_count_challenge > 0 && this.dun_show_type != BaseDungeonModel.TYPE_NEW_INLOCK
			this._Label2.text = "挑战"
			color = this.left_count_challenge <= 0 ? '"#ff0000"' : '"#0a953e"'
			str_sweep = HtmlColorTxt("" + this.left_count_challenge, color)
			this._text_challenge_num.innerHTML = `今日挑战次数：${str_sweep}${HtmlColorTxt("/" + challenge_times, '"#0a953e"')}`
		}

		if (!this._box_eff.visible) {
			this.base_item.ClearUIEffect(this._box_eff)
		}


		//其他

		switch (this.dun_show_type) {
			case BaseDungeonModel.TYPE_NEW_DIFF_SHOW:
				this._img_tag.visible = true
				this.resmgr.SetImageSprite(this, this._img_tag, "dungeonMaterial", "ui_copy_zyfb_19_1")
				break;
			case BaseDungeonModel.TYPE_NEW_DUNGEON:
				this._img_tag.visible = true
				this.resmgr.SetImageSprite(this, this._img_tag, "dungeonMaterial", "ui_copy_zyfb_19")
				break;
			default:
				break
		}
		SetHtmlCenter(this._text_challenge_num, { x: 23, w: 254 })


		//推荐战力
		let fighting = roleManager.GetMainRoleVo().fighting
		if (this.dun_cfg) {
			this._text_fight.text = this.dun_cfg.recommend_power + ""
			let color = fighting >= this.dun_cfg.recommend_power ? Enum_ColorUtil_Dark.GREEN : Enum_ColorUtil_Dark.RED
			this._text_fight.color = ColorUtil.GetReplaceChar(color)
		}


		//当前难度
		let dun_name: String = this.dun_data.name
		let name2 = dun_name.slice(dun_name.indexOf("(") + 1, dun_name.length - 1)
		this._text_3.text = name2 + "："
		this._text_3.color = this.dungeon_model.GetTextColor(this.dun_data.dun_id)



		//下一预告(未达到开启条件的)
		this._html_next_open.visible = this._img_h_bg.visible = this._img_quit.visible = false
		this._gp_challenge.gray = false
		if (this.dun_show_type == BaseDungeonModel.TYPE_NEW_INLOCK) {
			this._html_next_open.innerHTML = this.dungeon_model.GetNewDungeonOpenTips(this.dun_data.dun_id,true)
			this._html_next_open.visible = this._img_h_bg.visible = this._img_quit.visible = true
			SetHtmlCenter(this._html_next_open, { x: 62, w: 151 })
			this._gp_challenge.gray = true
		} else {
			if (this.pre_difficult) {
				this._html_next_open.visible = this._img_h_bg.visible = this._img_quit.visible = true

				let dun_name_1: String = this.pre_difficult.name
				let pre_dif = dun_name_1.slice(dun_name_1.indexOf("(") + 1, dun_name_1.length - 1)
				let pre_color = this.dungeon_model.GetTextColor(this.pre_difficult.dun_id, true)

				if (this.dun_show_type == BaseDungeonModel.TYPE_NEW_DIFF_HIDE) {
					this._html_next_open.innerHTML = `下一难度：${HtmlColorTxt(pre_dif, pre_color)}`
				} else {
					this._html_next_open.innerHTML = `${TransformLevel(Number(this.pre_difficult.level))}级解锁${HtmlColorTxt(pre_dif, pre_color)}`
				}
				SetHtmlCenter(this._html_next_open, { x: 62, w: 151 })
			}
		}





		//设置星星
		this.SetStarNum(this.dungeon_model.GetValByKey(2, this.dun_data.rec_data))

		//设置奖励
		this.SetReward()


		//双倍奖励
		this.updatePoint()

		//设置引导
		this.ShowArrow()

	}

	public DeleteMe() {

		if (this.jin_event_id_) {
			RoleManager.GetInstance().mainRoleInfo.UnBind(this.jin_event_id_)
			this.jin_event_id_ = null
		}


		if (this.scroll_bar) {
			this.scroll_bar.off(Laya.Event.START, this, this.onListStart)
			this.scroll_bar = null
		}

		if (this.reward_item_list_) {
			for (let i = 0; i < this.reward_item_list_.length; i++) {
				this.reward_item_list_[i].DeleteMe()
				this.reward_item_list_[i] = null
			}
			this.reward_item_list_ = null
		}


		if (this._box_eff) {
			this.base_item.ClearUIEffect(this._box_eff)
		}

		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_img_little_bg2: Laya.Image
	_img_title: Laya.Image
	_img_tag: Laya.Image
	_img_h_bg: Laya.Image
	_img_quit: Laya.Image
	_html_next_open: Laya.HTMLDivElement
	_text_1: Laya.Text
	_text_2: Laya.Text
	_text_3: Laya.Text
	_text_fight: Laya.Text
	_text_challenge_num: Laya.HTMLDivElement
	_box_star: Laya.Box
	_img_star_1: Laya.Image
	_img_star_2: Laya.Image
	_img_star_3: Laya.Image
	_gp_challenge: Laya.Box
	_Image1: Laya.Image
	_Label2: Laya.Label
	_box_eff: Laya.Box
	_scroll_reward: Laya.Panel
	Content: Laya.Box
	_point_icon: Laya.Image
	_img_icon2: Laya.Image
	_box_cost: Laya.Box
	_img_icon: Laya.Image
	_lb_cost: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_little_bg2,
			this._img_title,
			this._img_tag,
			this._img_h_bg,
			this._img_quit,
			this._html_next_open,
			this._text_1,
			this._text_2,
			this._text_3,
			this._text_fight,
			this._text_challenge_num,
			this._box_star,
			this._img_star_1,
			this._img_star_2,
			this._img_star_3,
			this._gp_challenge,
			this._Image1,
			this._Label2,
			this._box_eff,
			this._scroll_reward,
			this.Content,
			this._point_icon,
			this._img_icon2,
			this._box_cost,
			this._img_icon,
			this._lb_cost,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_little_bg2",
				"_img_title",
				"_img_tag",
				"_img_h_bg",
				"_img_quit",
				"_html_next_open",
				"_text_1",
				"_text_2",
				"_text_3",
				"_text_fight",
				"_text_challenge_num",
				"_box_star",
				"_img_star_1",
				"_img_star_2",
				"_img_star_3",
				"_gp_challenge",
				"_Image1",
				"_Label2",
				"_box_eff",
				"_scroll_reward",
				"Content",
				"_point_icon",
				"_img_icon2",
				"_box_cost",
				"_img_icon",
				"_lb_cost",
			])
	}
}
window["DungeonMaterialNewEnterItem"] = DungeonMaterialNewEnterItem