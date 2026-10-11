import { BaseView1 } from "../common/BaseView1";
import { EquipmentItem } from "../common/EquipmentItem";
import { ResManager } from "../common/ResManager";
import { AttentionEvent, AttentionModel } from "../commonModel/AttentionModel";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { PlatformManager } from "../PlatformManager";
import { Message } from "../sysInfo/SysInfoController";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { Util } from "../util/Util";

export class AttentionView extends BaseView1 {
	item_list
	model:AttentionModel
	last_click_time
	public constructor() {
		super()
		this.base_file = "attention"
		this.layout_file = "AttentionView"
		this.model = AttentionModel.GetInstance()

		this.is_center = true
		this.use_background = true
		this.change_scene_close = true
		this.click_bg_toClose = true
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.destroy_callback = () =>{
			this.Remove()
		}
	}

	public Remove() {
		for (let _tmpi in this.item_list) {
			var item = this.item_list[_tmpi]
			item.DeleteMe()
			item = null
		}
		this.item_list = []
	}

	public LoadSuccess() {
		this._panel_reward.hScrollBarSkin = ""

		//"resource/game/attention/other/ui_gzhd_01.png"
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("attention", "ui_gzhd_01"))

		this.UpdateReward()
		this.UpdateRed()
		this.UpdateAttention()
		this.InitEvents()
	}

	public InitEvents() {

		this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.ANSWER_TARGET, ()=>{
			this.UpdateReward()
		})


		this.BindEvent(this.model, AttentionEvent.SDK_ATTENTION_RED_STATE, ()=>{
			this.UpdateRed()
		})

		let click_func = () =>{
			if(this.last_click_time && TimeUtil.getClientTime() < this.last_click_time){
				return
			}
			this.last_click_time = TimeUtil.getClientTime() + 1

			let sdk_attention_state = this.model.sdk_attention_state
			if(sdk_attention_state){
				let reward_state = this.model.activity_reward_state
				if(reward_state){
					Message.show("已领取")
				}
				else{
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, AttentionModel.ActivityBaseType, AttentionModel.ActivitySubType, 1)
				}
			}
			else{
				let sdk_name = PlatformManager.GetInstance().sdk_name
				var params = { apiType: 'askShow' };
				window[sdk_name].subscribe(params, (data) => {
					console.log("------------subscribe@askShow", data)
					if(data.cpStatus == 0){
						Message.show("调起失败")
					}
				});
			}
			
		}
		Util.AddClickEvent(this._box_attention, click_func, this, true)
	}

	public UpdateReward() {

		let reward_data = CustomActivityModel.GetInstance().GetAwardDataById(AttentionModel.ActivityBaseType, AttentionModel.ActivitySubType, 1)
		if(!this.item_list){
			this.item_list = []
		}

		let list = []
		if(reward_data){
			list = ErlangParser.GetInstance().Parse(reward_data.reward)
		}
	
		if (list) {
			for (let i = 0; i < list.length; i++) {
				var item = this.item_list[i]
				var data = list[i]
				if (!item) {
					item = new EquipmentItem(this._hbox_reward)
					this.item_list[i] = item
					item.Load()
					item.SetItemSize(85, 85)
				}
				var [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1])
				item.SetData(type_id, data[2])
			}
		}
	}

	public UpdateAttention(){
		let sdk_attention_state = this.model.sdk_attention_state
		if(sdk_attention_state){
			let reward_state = this.model.activity_reward_state
			if(reward_state){
				this._lb_attention.text = "已领取"
			}
			else{
				this._lb_attention.text = "领取"
			}
		}
		else{
			this._lb_attention.text = "领取"
		}
	}

	public UpdateRed(){
		this._img_attention_red.visible = this.model.GetSdkAttentionRedState()
	}

	_img_bg: Laya.Image
	_panel_reward: Laya.Panel
	_hbox_reward: Laya.HBox
	_box_attention: Laya.Box
	_img_attention_bg: Laya.Image
	_lb_attention: Laya.Label
	_img_attention_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._panel_reward,
			this._hbox_reward,
			this._box_attention,
			this._img_attention_bg,
			this._lb_attention,
			this._img_attention_red
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_panel_reward",
				"_hbox_reward",
				"_box_attention",
				"_img_attention_bg",
				"_lb_attention",
				"_img_attention_red"
			])
	}
}
window["AttentionView"] = AttentionView