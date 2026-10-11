import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityController } from "../commonController/CustomActivityController"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { VipModel } from "../commonModel/VipModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Color, Util } from "../util/Util"

export class DailyLogInItem extends BaseItem1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb_desc: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_gp_btn: Laya.Box
	_btn_draw: Laya.Box
	_Image: Laya.Image
	labelDisplay: Laya.Label
	_img_red: Laya.Image
	_img_is_draw: Laya.Image
    _img_next_day: Laya.Image
	Scr_Scroller1
	_gp_item
	base_type
	curr_sorting_order
	effect_color
	info
	reward_item_list
	sub_type
    vip_level
    day
    condition_list
	public constructor(parent?) {
		super(parent)


		this.reward_item_list = [];
		this.base_file = "dailylogin"
		this.layout_file = "DailyLogInItem"
		this.layer_value = Enum_UILayer.UI
		this.load_callback = () => {
			this._Scroller1.hScrollBar.visible = false
            this.vip_level=VipModel.GetInstance().GetVipLevel()
			this.LoadSuccess()
			this.InitEvent()
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("dailylogin", "uidlsl_005"))
		}
	}

	public InitEvent() {

		let DrawOnClick = () => {
			if (!this.base_type || !this.sub_type) { return }
			let act_info = CustomActivityModel.GetInstance().GetActInfo(this.base_type, this.sub_type)
			if (act_info && act_info.etime - TimeUtil.getServerTime() <= 0) {
				Message.show("活动已过期")
				return
			}
			if (this.info.status == 1 && Number(this.condition_list[1][1]) <= this.vip_level) {
				CustomActivityModel.GetInstance().RequireGetAward(this.base_type, this.sub_type, this.info.grade)
			} else if(this.vip_level <this.condition_list[1][1] ){
                let ok_func=()=>{
					if(this.vip_level>=4){
						OpenFun.OpenFunHandler(140)
					}else{
						OpenFun.OpenFunHandler(23)
					}

                }
				// let is_jump = CustomActivityModel.GetInstance().getKeyDicValue(this.info.base_type, this.info.sub_type, "is_jump" + this.info.grade)
				// let check_func = () => {
				// 	CustomActivityModel.GetInstance().setKeyDicValue(this.info.base_type, this.info.sub_type, "is_jump" + this.info.grade, true)
				// }
				// if(is_jump){
				// 	ok_func()
				// }else{
				Alert.Show("领取奖励需要<font color='#639c12'>VIP"+this.condition_list[1][1]+"</font>，是否前往提升VIP", Alert_Type.AlertTypeCheckBox, ok_func,null, null, null, null, null,null, null, null, null, null, null, null, null, null, null, null,true )
				// }
                return
            }
		}

		Util.AddClickEvent(this._gp_btn, DrawOnClick, this, true)
	}

	public LoadSuccess() {

		
	}

	public setData(info?, base_type?, sub_type?, sort_order?,day?) {

		this.info = info
        this.day=day
        this.condition_list =  ErlangParser.GetInstance().Parse(this.info.condition)
		if (!info) { return }
		let reward = CustomActivityModel.GetInstance().GetActReward(base_type, sub_type, info.form_type, info.reward)
		this.base_type = base_type
		this.sub_type = sub_type
		this.curr_sorting_order = sort_order
		let info_ = CustomActivityModel.GetInstance().GetActInfo(base_type, sub_type)
		this.setDescLabel(info.name)
		this.setBtn(info.status)
		this.RefreshReward(reward)

	}

	public setDescLabel(name?) {
        let day = this.info.name
        day=day.replace("第","")
        day = day.replace("天","")
        if(this.day == Number(day) && this.condition_list[1][1] != "0"){
            this._lb_desc.text = "VIP"+ this.condition_list[1][1] +"可额外领取"
        }else if( this.day == Number(day)){
            this._lb_desc.text = "今日登录可领取"
        }else{
            this._lb_desc.text = "明天可领取"
        }
	}

	public setBtn(status?) {
		this._gp_btn.visible = (status < 2 && (true || (false)))
		if (status == 1 && this.condition_list[1][1] == "0") {
            this._img_red.visible=true
		}else if(status == 1 && this.condition_list[1][1] <= this.vip_level) {
            this._img_red.visible=true
        }else if( this.day+1 == this.condition_list[0][1]) {
            this._btn_draw.visible=false
            this._img_next_day.visible=true
        }
		this._img_is_draw.visible = (status >= 2 && (true || (false)))
	}

	public RefreshReward(rewards?) {
		if (!rewards) {
			return
		}
		if (this.reward_item_list.length > 0) {
			for (let index in this.reward_item_list) {
				if (this.reward_item_list[index]) {
					this.reward_item_list[index].display_obj.visible = false
				}
			}
		}
		let count = 0
		for (let index in rewards) {

			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(rewards[index][0], rewards[index][1])
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (!basic) {
				return
			}
			let goods_num = (basic && basic.max_overlap == 0 && (1) || (rewards[index][2]))
			let create_num = (basic && basic.max_overlap == 0 && (rewards[index][2]) || (1))
			let i = 0
			do {
				let item: BaseAwardItem = this.reward_item_list[count]
				if (!item) {
					item = new BaseAwardItem(this.Content)
					// item.SetCacheSortOrder(this.curr_sorting_order)
					// item.SetMaskId(2)
					// item.SetMaskRect(this.mask_corners)
					item.Load()
					item.SetItemSize(85, 85)
					table.insert(this.reward_item_list, item)
				}
				item.SetData(type_id, goods_num, lock, null, null, false)
				item.ExcuteCallback(() => {
					item.display_obj.visible = true

				}
				)
				count = count + 1
				i = i + 1
			} while ((i < create_num))
		}
		
	}

	public DeleteMe() {

		if (this.reward_item_list.length > 0) {
			for (let index in this.reward_item_list) {
				this.reward_item_list[index].DeleteMe()
			}
			this.reward_item_list = []
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._lb_desc,
			this._Scroller1,
			this.Content,
			this._gp_btn,
			this._btn_draw,
			this._Image,
			this.labelDisplay,
			this._img_red,
			this._img_is_draw,
            this._img_next_day
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_lb_desc",
				"_Scroller1",
				"Content",
				"_gp_btn",
				"_btn_draw",
				"_Image",
				"labelDisplay",
				"_img_red",
				"_img_is_draw",
                "_img_next_day"
			])
	}
}
window["DailyLogInItem"] = DailyLogInItem