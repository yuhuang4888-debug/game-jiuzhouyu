import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LuaSoundManager } from "../common/SoundManager"
import { WordManager } from "../common/WordManager"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"

export class HolyBattleBuffView extends BaseView1 {
InitEvent
LoadSuccess
UpdateView
change_scene_close
click_bg_toClose
destroy_imm
is_center
show_open_movie
use_background

public constructor(){
super() 
	
	
	this.base_file = "holyBattle"
	this.layout_file = "HolyBattleBuffView"
	this.layer_value = Enum_UILayer.Activity
	this.destroy_imm = true
	this.is_center = true
	this.use_background = true
	this.click_bg_toClose = true
	this.show_open_movie = true
	this.change_scene_close = true
	
	let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()
	let local_HolyBattleModel = HolyBattleModel
	let local_WordManager = WordManager
	
	this.load_callback = () => {
		
		this.LoadSuccess()
	}
	
	this.LoadSuccess = () => {

		SetHtmlStyle(this._lb_tips,{w:548,lh:25,f:20,c:"#663915"})

		let color="'#d15e00'"
		let str1="1.当己方神道据点数量小于其他神道据点占领数量超过"
		let str2= "个时，将会触发士气祝福效果<br>2.被祝福的全体神道成员都将获得"
		this._lb_tips.innerHTML = `${str1}${HtmlColorTxt("2", color)}${str2}${ HtmlColorTxt("属性增强", color)}`

		this.UpdateView()
		this.InitEvent()
	}
	
	this.InitEvent = () => {
		this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.UPDATE_FIGHT_DATA,() => {
				this.UpdateView()
			}
		)
		Util.AddClickEvent(this._img_close,() => {
				this.Close()
			}
			, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
	}
	
	this.UpdateView = () => {
		let data = local_HolyBattleModel_Instance.GetFightData()
		if (data ) {
			let str = ""
			for (let _tmpi in data.buff_list) {
				var vo = data.buff_list[_tmpi]
				str = str + local_WordManager.GetProperties(vo.attr_id) + (" + ") + local_WordManager.ConvertToPercentValue(vo.attr_id, vo.value) + "\n"
			}
			if (str == "" ) {
				str = "暂无加成"
			}
			this._lb_attr.text = str
		}
	}

	this.destroy_callback=()=>{
		
	}
	
	
}

public DeleteMe(){
	super.DeleteMe()
}


_Image1:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_img_close:Laya.Image
_Image4:Laya.Image
_lb_tips:Laya.HTMLDivElement
_Label1:Laya.Label
_lb_attr:Laya.Label
public GetComponents() {
[
this._Image1,
this._Image2,
this._Image3,
this._img_close,
this._Image4,
this._lb_tips,
this._Label1,
this._lb_attr,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image2",
"_Image3",
"_img_close",
"_Image4",
"_lb_tips",
"_Label1",
"_lb_attr",
])
}
}
 window["HolyBattleBuffView"]= HolyBattleBuffView