import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { DepositModel } from "../commonModel/DepositModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TopPkDefine } from "../commonModel/TopPkModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DepositSettingTopPk extends BaseView1 {

	model: DepositModel
	food_cost
	data
	setting = []
	current_show_num = 0
	is_select=false

	init_select =false
	init_show_num =0
	public constructor() {
		super()

		this.base_file = "deposit"
		this.layout_file = "DepositSettingTopPk"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.preload_server_config = {
			"config_gfeast": false,
		}
		this.model = DepositModel.GetInstance()


		this.load_callback = () => {
				
			this.InitEvent()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Clear()
		}
	}

	public Open(data?) {
		this.data = data
		super.Open()
		
	}

	private UpdateView() {
		let deposit_data = this.model.GetDepositData(this.data.module_id, this.data.sub_module)

		if(!deposit_data||deposit_data.behaviour_list.length==0){
			this.init_select =false
			this.SetShowNum(0)
			this.SetSelete(false)
			return
		}

		var dpt_data = deposit_data.behaviour_list[0]
		this.init_select =dpt_data.b_select_time>0
		this.SetSelete(this.init_select)
		this.init_show_num = dpt_data.times||0
		this.SetShowNum(this.init_show_num)
	}


	private SetSelete(boo){
		this.is_select = boo
		let url = boo?"com_ui_gx1":"com_ui_gx"
		ResManager.GetInstance().SetImageSprite(this,this._img_select,"common",url)
	}


	private SetShowNum(num){
		this.current_show_num = num
		this.cur_show_num.text =num+""
		this.txt_money.text = (num*TopPkDefine.BUY_COST)+""
	}



	private InitEvent() {
		var onClickBtnHandler = (target) => {
			let btn = target.currentTarget
			if (btn == this.close || btn == this.cancle || btn == this.ok) {
				if (this.init_select!=this.is_select||this.init_show_num!=this.current_show_num) {
					if (this.is_select) {
						this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19204, this.data.module_id, this.data.sub_module, 1,this.current_show_num)
					} else {
						this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19205, this.data.module_id, this.data.sub_module, 1)
					}
				}
				this.Close()
			}
		}
		Util.AddClickEvent(this.close, onClickBtnHandler, this, true)
		Util.AddClickEvent(this.ok, onClickBtnHandler, this, true)
		Util.AddClickEvent(this.cancle, onClickBtnHandler, this, true)

		Util.AddClickEvent(this._select_box, ()=>{
			this.SetSelete(!this.is_select)
		}, this, true)


		Util.AddClickEvent(this.max_btn, ()=>{
			this.SetShowNum(TopPkDefine.DAILT_BUY_COUNT)
		}, this, true)

		Util.AddClickEvent(this.minus_one, ()=>{
			if(this.current_show_num>0){
				this.current_show_num--
				this.SetShowNum(this.current_show_num)
			}
		}, this, true)

		Util.AddClickEvent(this.add_one, ()=>{
			if(this.current_show_num<TopPkDefine.DAILT_BUY_COUNT){
				this.current_show_num++
				this.SetShowNum(this.current_show_num)
			}
		}, this, true)

	}

	public Clear() {


	}

bg:Laya.Image
close:Laya.Image
_Image3:Laya.Image
title_img:Laya.Label
txt2:Laya.Label
_box_top_pk:Laya.Box
_img_Image2:Laya.Image
minus_one:Laya.Box
_Label3:Laya.Label
show_conta:Laya.Box
cur_show_num:Laya.Label
add_one:Laya.Box
_Label4:Laya.Label
max_btn:Laya.Box
txt3:Laya.Label
Select:Laya.Image
txt_money:Laya.Label
nameLb:Laya.Label
_select_box:Laya.Box
_img_select:Laya.Image
ok:Laya.Box
txt:Laya.Label
cancle:Laya.Box
img111:Laya.Image
txt1:Laya.Label
public GetComponents() {
[
this.bg,
this.close,
this._Image3,
this.title_img,
this.txt2,
this._box_top_pk,
this._img_Image2,
this.minus_one,
this._Label3,
this.show_conta,
this.cur_show_num,
this.add_one,
this._Label4,
this.max_btn,
this.txt3,
this.Select,
this.txt_money,
this.nameLb,
this._select_box,
this._img_select,
this.ok,
this.txt,
this.cancle,
this.img111,
this.txt1,
]
 = this.GetChildrenByNames([

"bg",
"close",
"_Image3",
"title_img",
"txt2",
"_box_top_pk",
"_img_Image2",
"minus_one",
"_Label3",
"show_conta",
"cur_show_num",
"add_one",
"_Label4",
"max_btn",
"txt3",
"Select",
"txt_money",
"nameLb",
"_select_box",
"_img_select",
"ok",
"txt",
"cancle",
"img111",
"txt1",
])
}
}
 window["DepositSettingTopPk"]= DepositSettingTopPk