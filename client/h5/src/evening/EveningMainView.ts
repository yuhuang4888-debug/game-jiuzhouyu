import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GuildActEvent, GuildActivityModel } from "../commonModel/GuildActivityModel"
import { Util } from "../util/Util"
import { EveningMainBossGroup } from "./EveningMainBossGroup"
import { EveningMainConGameGroup } from "./EveningMainConGameGroup"
import { EveningMainConGroup } from "./EveningMainConGroup"
import { EveningMainItem } from "./EveningMainItem"

export class EveningMainView extends BaseItem1 {
	_ac_btn
	_cfg_list
	_cur_index
	_def_index
	_model:GuildActivityModel
	_tabDataList
	_viewList
	preload_client_config


	public constructor(parent?) {
		super(parent)

		this._viewList = [];
		this._def_index = 0;
		this._cur_index = -1;
		this.base_file = "evening"
		this.layout_file = "EveningMainView"
		this._model = GuildActivityModel.GetInstance()
		this.preload_client_config = { "ConfigGuildAct": false }
		this.load_callback = () => {
			let act_info = this._model.GetActInfo()
			if(act_info&&act_info.stage){
				if(act_info.stage<=3){
					this._def_index = 0
				}else if(act_info.stage>=5){
					this._def_index = 2
				}else{
					this._def_index = 1
				}
			}
			this.LoadSuccess()
		}
	}

	public DeleteMe() {

		// if (this._list_btn ) {
		// 	this._list_btn.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SelectItem, this)
		// }
		for (let _tmpi in this._viewList) {
			var subView = this._viewList[_tmpi]
			if (!subView) {
				break
			}
			subView.DeleteMe()
		}
		this._viewList = []
		if (this._ac_btn) {
			this._ac_btn.DeleteMe()
			this._ac_btn = null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {
		this.InitView()
		this.InitEvent()
	}

	public InitView() {

		this._tabDataList = [{ class: EveningMainConGroup }, { class: EveningMainConGameGroup }, { class: EveningMainBossGroup }]
		let GetClientCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigGuildAct", true)
		this._cfg_list = this._model.GetClientCfg(GetClientCfg, "evening_main_cfg")
		this._ac_btn = new LoopScrowViewMgr()
		this._ac_btn.SetData(this._list_btns, EveningMainItem, this._cfg_list, LoopScrCon.Horizontal, 1, (index?) => {
			this.SwitchView(index)
		},this._def_index)
		this._list_btns.scrollBar.touchScrollEnable = false
	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_go, () => {
			GuildActivityModel.GetInstance().Fire(GuildActEvent.REQUEST_PROTO, 40212)
		}
			, this, true)
	}


	public SwitchView(index?) {

		if (this._cur_index == index) {
			return
		}
		this._cur_index = index
		let data = this._tabDataList[index]
		let cell: any
		for (let i = 0; i < this._viewStack.numChildren; i++) {
			cell = this._viewStack.getChildAt(i)
			cell.visible = false
		}

		let subView = this._viewList[index]
		// let parent = this._viewStack.selectedChild
		// let parent = transform.GetChild(index - 1)
		// parent.visible = true
		cell = this._viewStack.getChildAt(index)
		cell.visible = true

		let view_class = data.class
		if ((!subView && cell) && view_class) {
			subView = new view_class(cell)
			subView.SetData(this._cfg_list[index])
			subView.Load()
			this._viewList[index] = subView
		}
	}



_Image1:Laya.Image
_img_1:Laya.Image
_img_2:Laya.Image
_btn_go:Laya.Box
_Image3:Laya.Image
_Label1:Laya.Label
_viewStack:Laya.Box
_Group1:Laya.Box
_Group2:Laya.Box
_Group3:Laya.Box
_list_btns:Laya.List
public GetComponents() {
[
this._Image1,
this._img_1,
this._img_2,
this._btn_go,
this._Image3,
this._Label1,
this._viewStack,
this._Group1,
this._Group2,
this._Group3,
this._list_btns,
]
 = this.GetChildrenByNames([

"_Image1",
"_img_1",
"_img_2",
"_btn_go",
"_Image3",
"_Label1",
"_viewStack",
"_Group1",
"_Group2",
"_Group3",
"_list_btns",
])
}
}
 window["EveningMainView"]= EveningMainView