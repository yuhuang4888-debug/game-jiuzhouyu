import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { HtmlColorTxt, Util } from "../util/Util"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { OpenFun } from "../common/OpenFun"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { TopVipShopItem } from "../topVip/TopVipShopItem"
import { AliveState } from "../sysInfo/MessageItem"


export class CarnivalMainItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_Image111: Laya.Image
	_img_over: Laya.Image
	_lb_title: Laya.HTMLDivElement
	_btn_go: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_btn_get: Laya.Box
	_Image1: Laya.Image
	_reddot: Laya.Image
	labelDisplay1: Laya.Label
	_Scroller1: Laya.Panel
	_gp_reward: Laya.HBox
	_lb_progress: Laya.HTMLDivElement
	VHS_Scroller1
	_Viewport1
	_canGet
	_enough
	_item_list
	_model
	parent_wnd
	fly_list
	is_request=false
	WIDTH = 698
	HEIGT = 163
	public static width = 698
	public static height = 163

	public constructor(parent) {
		super()


		this._item_list = []
		this._enough = false
		this._canGet = false
		this.base_file = "carnival"
		this.layout_file = "CarnivalMainItem"

		this._model = CustomActivityModel.GetInstance()
	
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {
		this._Scroller1.hScrollBar.visible = false
		this.InitEvent()
		ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg, GameResPath.GetIcon("activity", "cjgh_002"))
	}

	public DeleteMe() {

		for (let _tmpi in this._item_list) {
			var item = this._item_list[_tmpi]
			item.DeleteMe()
		}
		this._item_list = null
		super.DeleteMe()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this._lb_title.innerHTML = this.data.name
            let list= ErlangParser.GetInstance().Parse(this.data.reward)
			this.fly_list = CustomActivityModel.GetInstance().GetFlyRewardList(list)
            this.UpdateItems(list)
            if(this.data.status == 0 || this.data.status ==1){
                this.UpdateBtn()
                this._img_over.visible =false
            }else{
                this._img_over.visible = true
                this._btn_get.visible = false
                this._btn_go .visible = false
                this._lb_progress.innerHTML = ""
            }
		}else{
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_get, () => {
			
			let data = this.data
			if (this._canGet || (data.status == 0)) {
				this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, data.base_type, data.sub_type, data.grade)
				this.is_request = true
			}
			CustomActivityModel.GetInstance().SetActRedDot()
		}, this, true)

		Util.AddClickEvent(this._btn_go, () => {
			let cond = CustomActivityModel.GetInstance().GetActCondition(this.data.base_type, this.data.sub_type, "data", this.data.grade)
			if(cond && cond.jump_list && cond.jump_list[0]){
				OpenFun.OpenFunHandler(cond.jump_list[0])
			}
		}, this, true)



		this.BindEvent(this._model, CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?) => {
			if (this.data&&this.data.base_type == base_type && this.data.sub_type == sub_type&&this.data.grade==result_data.grade) {
				//飘字特效
				CustomActivityModel.GetInstance().ShowActFlyReward(this.fly_list, this._btn_get)
			}
		})


	}

	public UpdateItems(list?) {

		for (let i = 0; i < list.length; i++) {
			let info = list[i]
			let item = this._item_list[i]
			if (!item) {
				item = new EquipmentItem(this._gp_reward)
				item.SetItemSize(87, 87)
				item.Load()
				this._item_list[i] = item
			}
			let [type_id, _] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			item.SetData(type_id, info[2])
			item.SetVisible(true)
		}

		for (let i = list.length; i < this._item_list.length; i++) {
			this._item_list[i].SetVisible(false)
		}
	}

	public UpdateBtn(){
		let data = this.data
        let cond = CustomActivityModel.GetInstance().GetActCondition(data.base_type, data.sub_type, "data", data.grade)
        let progress =CustomActivityModel.GetInstance().GetCarnivalProgerss()
        if(!progress){
            return
        }
		if(progress.length>0){
			for(let key in progress){
				if(progress[key].grade == this.data.grade){
					if(progress[key].process >= Number(cond.task[1]) || (cond.task[0] == "dun_id" && progress[key].process==1)){
						if(cond.task[0] == "dun_id"){
							this._lb_progress.innerHTML = "<font color ='#0a953e'>( 1 / 1 )</font>"
						}else{
							this._lb_progress.innerHTML = "<font color ='#0a953e'>("+ progress[key].process + "/" + Number(cond.task[1]) + ")</font>"
						}
						this._btn_get.visible = true
						this._btn_go.visible = false
						this._reddot.visible = true
						this._canGet = true
					}else{
						if(cond.task[0] == "dun_id"){
							this._lb_progress.innerHTML = "<font color ='#ff0000'>( 0 / 1 )</font>"
						}else{
							this._lb_progress.innerHTML = "<font color ='#ff0000'>(" + progress[key].process + "/" + Number(cond.task[1]) + ")</font>"
						}
						this._btn_get.visible = false
						this._btn_go.visible = true
						this._reddot.visible = false
						this._canGet = false

					}
					this._lb_progress.x = 161/2 - this._lb_progress.contextWidth/2
					this._lb_progress.y = 35/2 - this._lb_progress.contextHeight/2
					break
				}
			}
		}else{
			if(cond.task[0] == "dun_id"){
				this._lb_progress.innerHTML = "<font color ='#ff0000'>(0 / 1 )</font>"
			}else{
				this._lb_progress.innerHTML = "<font color ='#ff0000'>(0/" + Number(cond.task[1]) + ")</font>"
			}
			this._lb_progress.x = 161/2 - this._lb_progress.contextWidth/2
			this._lb_progress.y = 35/2 - this._lb_progress.contextHeight/2
			this._btn_get.visible = false
			this._btn_go.visible = true
			this._reddot.visible = false
			this._canGet = false

		}
      

	}



	public GetComponents() {
		[
			this._img_bg,
			this._Image111,
			this._img_over,
			this._lb_title,
			this._btn_go,
			this._Image11,
			this.labelDisplay,
			this._btn_get,
			this._Image1,
			this._reddot,
			this.labelDisplay1,
			this._Scroller1,
			this._gp_reward,
			this._lb_progress
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image111",
				"_img_over",
				"_lb_title",
				"_btn_go",
				"_Image11",
				"labelDisplay",
				"_btn_get",
				"_Image1",
				"_reddot",
				"labelDisplay1",
				"_Scroller1",
				"_gp_reward",
				"_lb_progress"
			])
        this._lb_title.style.fontSize = 20
        this._lb_title.style.color = "#ffffff"
        this._lb_title.style.wordWrap = false
		this._lb_title.style.bold = true
        this._lb_progress.style.fontSize = 20
        this._lb_progress.style.color = "#ffffff"
        this._lb_progress.style.wordWrap = false
		this._lb_progress.style.bold = true
        this._Scroller1.hScrollBar.visible = false
	}
}
window["CarnivalMainItem"] = CarnivalMainItem