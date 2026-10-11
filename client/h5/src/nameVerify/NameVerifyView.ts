import { BaseView1 } from "../common/BaseView1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { PlatformManager } from "../PlatformManager"
import { EventName } from "../common/EventName"

export class NameVerifyView extends BaseView1 {

	model
	open_callback
	reward_data
	show_open_movie
	timer_out
	use_background
	item_list
	can_get_reward
	info
	is_click_go//是否前往实名
	plat_mrg
	public constructor() {
		super()

		this.item_list = [];
		this.can_get_reward = false;
		this.base_file = "nameVerify"
		this.layout_file = "NameVerifyView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_click_go = false
		this.plat_mrg=PlatformManager.GetInstance()
		this.model = CustomActivityModel.GetInstance()
		this.load_callback = () => {

			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("nameVerify", "uismrz_002"), true)
			this.InitEvent()
		}

		this.open_callback = () => { }
		this.destroy_callback = () => {
			for (let _tmpi in this.item_list) {
				var item = this.item_list[_tmpi]
				item.DeleteMe()
				item = null
			}
			this.item_list = []
			this.can_get_reward = false
			this.ClearTimeOut()
		}

	}

	public InitEvent() {

		let click_fun = () => {

			if (this.info && this.reward_data) {

				let finished_func=(ret?)=>{
					console.warn("NameVerify:Try to get reward")
					this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this.info.base_type, this.info.sub_type, this.reward_data.grade)
				}
				let unfinished_func=(type?)=>{
					if(type==1){
						this.is_click_go = true
						this.plat_mrg.GoToSHNameVerify()
					}
				}

				this.plat_mrg.CheckSHNameVerify(finished_func,unfinished_func)
			}

		}



		Util.AddClickEvent(this.getBtn, click_fun, this, true)

		Util.AddClickEvent(this.closeBtn, () => {
			this.Close()
		}
			, this, true)
		Util.AddClickEvent(this.has_got_btn, () => {

		}
			, this, true)

		let update_fun = (base_type?, sub_type?) => {
			if (base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.NAMEVERIFY) {
				this.SetData()
			}
		}

		this.BindEvent(this.model, CustomActivityDefine.EVENT.UPDATE_VIEW, update_fun)
		this.BindEvent(this.model, CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?, reward_data?) => {
			if (!this.info) {
				return
			}
			if (this.info.base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.NAMEVERIFY) {
				if (reward_data && reward_data.reward) {
					let rewards = ErlangParser.GetInstance().Parse(reward_data.reward)
					let view = new CongratulationObtainView(rewards, 60)
					view.Open()
				}
			}
		}
		)

		this.BindEvent(GlobalEventSystem, EventName.WINDOW_RESUME, () => {

			let finished_func=(ret?)=>{
				if (ret&& this.is_click_go) {
					this.is_click_go = false
					this.SendRewardStateProtocal()
					Message.show("实名成功，请点击按钮领取奖励")
				}
			}

			this.plat_mrg.CheckSHNameVerify(finished_func)
		}
		)


		this.SetData()
	}

	public SendRewardStateProtocal() {

		if (this.info) {
			this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33169)
			this.ClearTimeOut()
			this.timer_out = setTimeout(() => {
				if (!this.use_delete_method) {
					this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33104, this.info.base_type, this.info.sub_type)
				}
			}, 0.5)
		}
	}

	public ClearTimeOut() {

		if (this.timer_out) {
			clearTimeout(this.timer_out)
			this.timer_out = null
		}
	}

	public SetGetState(show?, show_dot?) {

		this.getBtn.visible = show
		this.red_dot.visible = show_dot
		this.has_got_btn.visible = !show
	}

	public SetActInfo(info?, parm?) {

		this.info = info
	}

	public SetData() {

		if (this.info) {
			// let test_data = {
			// 	base_type: 7,
			// 	reward_list: [
			// 		{
			// 			condition: "[{gold,200000}]",
			// 			desc: "累计充值200000钻石",
			// 			form_type: 1,
			// 			grade: 12,
			// 			name: "累计充值200000钻石",
			// 			receive_times: 0,
			// 			reward: "[{0,19030003,1},{0,6331305,1},{0,20010003,1},{0,18020002,5},{0,19020002,5}]",
			// 			status: 0
			// 		}
			// 	],
			// 	sub_type: 1
			// }
			let act_info = this.model.GetActData(this.info.base_type, this.info.sub_type)
			if (((act_info && act_info.reward_list) && act_info.reward_list[0]) && act_info.reward_list[0].reward) {
				this.reward_data = act_info.reward_list[0]
				let reward_list = ErlangParser.GetInstance().Parse(this.reward_data.reward)
				if (reward_list) {
					let item = null
					let length = reward_list.length
					for (let i = 0; i < length; i++) {
						item = this.item_list[i]
						if (!item) {
							item = new EquipmentItem(this["group" + i])
							item.Load()
							item.SetItemSize(82, 82)
						}
						this.item_list[i] = item
						let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward_list[i][0], reward_list[i][1])
						let goodsVo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
						if (goodsVo) {
							item.SetData(goods_id, reward_list[i][2])
							this["label" + i].textFlow = Util.StrToHTML("<font color=" + ColorUtil.GetColorDark(goodsVo.color) + ">" + goodsVo.goods_name + "</font>")
						}
					}
				}
				let show_get_btn = this.reward_data.status == 0 || this.reward_data.status == 1
				let show_dot = this.reward_data.status == 1
				this.can_get_reward = show_dot
				this.SetGetState(show_get_btn, show_dot)
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_Image1: Laya.Image
	closeBtn: Laya.Image
	testBtn: Laya.Image
	_Group1: Laya.Box
	label0: Laya.Label
	group0: Laya.Box
	_Group2: Laya.Box
	label1: Laya.Label
	group1: Laya.Box
	_Group3: Laya.Box
	label2: Laya.Label
	group2: Laya.Box
	_Group4: Laya.Box
	label3: Laya.Label
	group3: Laya.Box
	_Group5: Laya.Box
	label4: Laya.Label
	group4: Laya.Box
	getBtn: Laya.Image
	red_dot: Laya.Image
	has_got_btn: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this.closeBtn,
			this.testBtn,
			this._Group1,
			this.label0,
			this.group0,
			this._Group2,
			this.label1,
			this.group1,
			this._Group3,
			this.label2,
			this.group2,
			this._Group4,
			this.label3,
			this.group3,
			this._Group5,
			this.label4,
			this.group4,
			this.getBtn,
			this.red_dot,
			this.has_got_btn,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"closeBtn",
				"testBtn",
				"_Group1",
				"label0",
				"group0",
				"_Group2",
				"label1",
				"group1",
				"_Group3",
				"label2",
				"group2",
				"_Group4",
				"label3",
				"group3",
				"_Group5",
				"label4",
				"group4",
				"getBtn",
				"red_dot",
				"has_got_btn",
			])
	}
}
window["NameVerifyView"] = NameVerifyView