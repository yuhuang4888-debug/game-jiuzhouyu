
import { BaseView1, CloseMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"
import { CheatModel } from "../commonModel/CheatModel"
import { ClientConfig } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { AtlasUrl, GlobalTimerQuest, RefGridLayout, Trim, Util } from "../util/Util"
export class CheatInputView extends BaseView1 {
	public cheatInput: Laya.TextInput;
	public okBtn: Laya.Box;
	public serachInput: Laya.TextInput;
	public serachBtn: Laya.Box;
	public TypeScrollView: Laya.Panel;
	public Content: Laya.VBox;
	public ScrollView: Laya.Panel;
	public Content1: Laya.Box;
	public time: Laya.Label;
	public platform: Laya.Label;
	public text: Laya.Label;
	public nameText: Laya.Label;
	public text_1: Laya.Label;
	public codetext: Laya.Label;
	public closeBtn: Laya.Image;
	public extra: Laya.Label;

	type_data
	scroll_content: Laya.Box;
	serachInputText: Laya.TextInput;
	select_index
	data
	change_scene_close
	hide_maincancas
	type_scroll_content: Laya.VBox;
	destroy_imm
	open_callback
	model
	timer_id
	item_list
	use_background
	item_type_list
	destroy_callback
	select_type
	close_mode
	background_alpha
	is_set_zdepth
	cheatInputText: Laya.TextInput;
	public constructor() {
		super()

		this.base_file = "cheat"
		this.layout_file = "CheatInputView"
		this.layer_value = Enum_UILayer.Top
		this.close_mode = CloseMode.CloseDestroy
		this.destroy_imm = true
		this.use_background = true
		this.hide_maincancas = false
		this.background_alpha = 0.5
		this.change_scene_close = true
		this.is_set_zdepth = true
		this.is_center = true

		this.model = CheatModel.GetInstance()
		this.item_list = []
		this.item_type_list = []
		this.data = null
		this.type_data = null
		this.select_type = null

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
		this.open_callback = () => {
			this.model.Fire(CheatModel.REQUEST_CHEAT_DATA)
			// KeyInput.CheatViewHasOpen = true
		}
		this.destroy_callback = () => {
			// KeyInput.CheatViewHasOpen = false
			this.DestorySuccess()
		}
	}
	public DestorySuccess() {


		this.CancelTimer()
		this.item_list = []
		this.item_type_list = []
		this.data = null
		this.type_data = null
		this.select_type = null
		this.select_index = null
	}

	public LoadSuccess() {
		this.cheatInputText = this.cheatInput
		// this.okBtn = this.GetChild("okBtn").gameObject
		this.serachInputText = this.serachInput
		// this.serachBtn = this.GetChild("serachBtn").gameObject
		this.scroll_content = this.Content1
		this.type_scroll_content = this.Content
		// this.platform = this.GetChild("platform").GetComponent("Text")
		// this.time = this.GetChild("time").GetComponent("Text")
		// this.nameText = this.GetChild("nameText").GetComponent("Text")
		// this.codetext = this.GetChild("codetext").GetComponent("Text")
		// this.closeBtn = this.GetChild("closeBtn").gameObject
		// this.extra = this.GetChild("extra").GetComponent("Text")

		this.platform.text = "platName : " + ClientConfig.plat_name
		// this.GetChild("cheatInput"):GetComponent("WebGLInputFieldHelper").InitRectInfo()
		// this.GetChild("serachInput"):GetComponent("WebGLInputFieldHelper").InitRectInfo()

		this.TypeScrollView.vScrollBarSkin = ""
		this.ScrollView.vScrollBarSkin = ""

		this.StartTimer()
		this.ShowTwInfo()
	}
	//繁体信息显示
	public ShowTwInfo() {

		// if (RuntimePlatform && Application && PlatformMgr.GetInstance().IsEyouPlatform() ) {
		// 	let str = "手机端：不知名端"
		// 	if (Application.platform == RuntimePlatform.IPhonePlayer ) { //蘋果手機
		// 		str = "手机端：IOS端"
		// 	} else if (Application.platform == RuntimePlatform.Android ) { //安卓
		// 		str = "手机端：Android端"
		// 	}
		// 	if (PlatformMgr.GetInstance().IsTWAreaCurrency() ) {//eyou非臺灣地區（澳門香港）
		// 		str = str + "  台湾地区"
		// 	}else{
		// 		str = str + "  非台湾地区"
		// 	}
		// 	if (PlatformMgr.GetInstance().IsMorePayShow() ) {
		// 		str = str + " 开启第三方"
		// 	}else{
		// 		str = str + " 不开启第三方"
		// 	}
		// 	this.extra.text = str
		// }
	}

	public InitEvent() {

		let ok_btn_func = () => {
			console.log("CheatInputView 秘籍的内容是===：", this.cheatInputText.text)
			this.model.Fire(CheatModel.SEND_CHEAT_TO_SERVER, this.cheatInputText.text)
		}
		Util.AddClickEvent(this.okBtn, ok_btn_func, null, true)

		let search_btn_func = () => {
			if (Trim(this.serachInputText.text) == "") {
				this.SetData()
				return
			}
			this.SetSearchData(this.serachInputText.text)
		}
		Util.AddClickEvent(this.serachBtn, search_btn_func, null, true)

		let close_btn_func = () => {
			this.Close()
		}
		Util.AddClickEvent(this.closeBtn, close_btn_func, null, true)

		let update_fun = () => {
			this.SetData()
		}
		this.BindEvent(this.model, CheatModel.UPDATE_CHEAT_INPUT_VIEW, update_fun)
	}

	public SetData() {
		this.CreateCheatTypeList()
		if (!this.select_type && !Util.IsTableEmpty(this.type_data)) {
			this.select_type = this.type_data[0]
		}
		if (this.select_type) {
			let cheat_list = this.model.GetCheatsDataByType(this.select_type)
			this.CreateCheatList(cheat_list)

			if (!Util.IsTableEmpty(this.data) && this.select_index) {
				this.nameText.text = this.data[this.select_index].command_name
			}
		}
	}

	public CreateCheatList(cheat_list?) {
		this.data = cheat_list
		let data = this.data

		let cheat_item = null
		for (let i = 0; i < this.item_list.length; i++) {
			cheat_item = this.item_list[i]
			cheat_item.visible = false
		}
		if (!Util.IsTableEmpty(data)) {
			for (let k = 0; k < data.length; k++) {
				var v = data[k]
				let item: Laya.Button = this.item_list[k]
				if (item == null) {
					item = new Laya.Button() // UiFactory.CreateChild(this.scroll_content, UIType.BigButton1, k)
					this.scroll_content.addChild(item)
					item.name = k.toString();
					this.item_list[k] = item
				}
				item.skin = AtlasUrl("common", "com_num_bg_1")
				item.size(145, 53)
				item.labelSize = 25
				item.label = v.command_name
				item.visible = true

				let ClickFun = (target?) => {
					this.select_index = Number(target.currentTarget.name)
					let temp = data[this.select_index]
					let command = temp.command
					let list = temp.args_list
					let is_default = false
					if (!Util.IsTableEmpty(temp.default_list)) {
						list = temp.default_list
						is_default = true
					}
					for (let i = 0; i < list.length; i++) {
						var vo = list[i]
						command = command + "_" + vo.args
					}

					this.cheatInputText.text = command
					this.nameText.text = temp.command_name

					if (is_default) {
						let code = temp.command
						for (let i = 0; i < temp.args_list.length; i++) {
							var vo = temp.args_list[i]
							code = code + "_" + vo.args
						}
						this.codetext.text = code
					} else {
						this.codetext.text = command
					}

				}
				Util.AddClickEvent(item, ClickFun, this)
			}
		}


		RefGridLayout(this.scroll_content,{
			column: 3,
			h_gap: 6,
			v_gap: 10,
			item_w: 145,
			item_h: 53
		})
	}

	public CreateCheatTypeList() {

		this.type_data = this.model.GetCheatsTypeList()
		let type_list_data = this.type_data
		let type_item = null

		for (let i = 0; i < this.item_type_list.length; i++) {
			type_item = this.item_type_list[i]
			type_item.visible = false
		}
		if (!Util.IsTableEmpty(type_list_data)) {
			for (let i = 0; i < type_list_data.length; i++) {
				let item: Laya.Button = this.item_type_list[i]
				if (item == null) {
					item = new Laya.Button() //UiFactory.CreateChild(this.type_scroll_content, UIType.BigButton2, i)
					// item.transform.sizeDelta = new Vector2(154, 70)
					item.name = i.toString();
					this.type_scroll_content.addChild(item)
					this.item_type_list[i] = item
				}
				let v = type_list_data[i]
				item.skin = AtlasUrl("common", "com_num_bg_1")
				item.size(141, 52)
				item.labelSize = 25
				item.label = v
				item.visible = true
				let ClickFun = (target?) => {
					let cheat_list = this.model.GetCheatsDataByType(v)
					this.select_type = v
					this.CreateCheatList(cheat_list)
				}
				Util.AddClickEvent(item, ClickFun, this)
			}
		}
	}

	public SetSearchData(text?) {

		let cheat_list = []
		let all_data = this.model.GetCheatData()
		if (!Util.IsTableEmpty(all_data)) {
			for (let k = 0; k < all_data.length; k++) {
				var f = all_data[k]
				for (let i = 0; i < f.func_commands.length; i++) {
					var v = f.func_commands[i]
					let is_find = v.command_name.indexOf(text) >= 0
					if (is_find) {
						table.insert(cheat_list, v)
					}
				}
			}
		}

		this.CreateCheatList(cheat_list)
	}

	public StartTimer() {


		var onTimer = () => {
			this.time.text = "服务器时间:" + (TimeUtil.timeConversion(TimeUtil.getServerTime(), "yyyy-mm-dd hh:MM:ss"))
		}
		this.timer_id = GlobalTimerQuest.AddPeriodQuest(onTimer, 1, 0)
		onTimer()
	}

	public CancelTimer() {

		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
	}

	public GetComponents() {
		[
			this.cheatInput,
			this.okBtn,
			this.serachInput,
			this.serachBtn,
			this.TypeScrollView,
			this.Content,
			this.ScrollView,
			this.Content1,
			this.time,
			this.platform,
			this.text,
			this.nameText,
			this.text_1,
			this.codetext,
			this.closeBtn,
			this.extra]
			= this.GetChildrenByNames([
				"cheatInput",
				"okBtn",
				"serachInput",
				"serachBtn",
				"TypeScrollView",
				"Content",
				"ScrollView",
				"Content1",
				"time",
				"platform",
				"text",
				"nameText",
				"text_1",
				"codetext",
				"closeBtn",
				"extra",
			])
	}

}
window["CheatInputView"] = CheatInputView