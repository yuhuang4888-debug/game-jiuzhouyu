import { BaseView1 } from "../common/BaseView1"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { RechargeView } from "../vip/RechargeView"
import { TestActLoginView} from "./TestActLoginView"
import { TestActRecharge } from "./TestActRecharge"

class TestActBaseView extends BaseView1 {


	Clear
	LoadSuccess
	InitEvent
	OpenView
	SelectBtn
	Remove
	login_veiw
	recharge_view
	GetCondition

	public constructor() {
		super()
		let	_info

		let model = CustomActivityModel.GetInstance(),
			res_mgr = ResManager.GetInstance()

		this.base_file = "testAct"
		this.layout_file = "TestActBaseView"
		this.is_center = true
		this.show_open_movie = true
		this.use_background = true
		this.not_show_main_msg = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.background_alpha = 0.8

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.OpenView()
		}

		this.close_callback = () => {
			this.Remove()
		}


		this.Remove = () => {
			if(this.login_veiw){
				this.login_veiw.DeleteMe()
				this.login_veiw = null
			}
			if(this.recharge_view){
				this.recharge_view.DeleteMe()
				this.recharge_view = null
			}
		}

		this.LoadSuccess = () => {
			res_mgr.SetTexture(this, this._img_bg, GameResPath.GetIcon("testAct", "uifcxl_009"),null,null,true)
			// res_mgr.SetTexture(this, this._img_person, GameResPath.GetIcon("testAct", ""))
			_info = model.GetActInfoByShowID(77, 0)
			if (_info) {
				model.CloseACTRed(_info.base_type, _info.sub_type)
			}
			this.InitEvent()
			this.SelectBtn(1)
		}


		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.btn_1, () => {
				this.SelectBtn(1)
			}, this, true)

			Util.AddClickEvent(this.btn_2, () => {
				this.SelectBtn(2)
			}, this, true)
		}

		this.OpenView = () => {

		}

		this.GetCondition = () => {
			if(!_info){
				return
			}
			let conditon_dic = ErlangParser.GetInstance().Parse(_info.condition)
			for (let key in conditon_dic) {
				let vo = conditon_dic[key]
				if(vo[0] && vo[0] == "return"){
					return Number(vo[1])
				}
			}
		}

		this.SelectBtn = (index?) => {
			this.loginGp.visible = false
			this.rechargeGp.visible = false
			if (index == 1) {
				this.btn_2.y = 590
				this.btn_1.y = 605
				this.loginGp.visible = true
				this.img_btn_1.skin = GameResPath.GetIcon("testAct","uifcxl_004")
				this.img_btn_2.skin = GameResPath.GetIcon("testAct","uifcxl_005")
				if (!this.login_veiw) {
					this.login_veiw = new TestActLoginView(this.loginGp)
					this.login_veiw.Load()
				}
			} else {
				this.btn_1.y = 590
				this.btn_2.y = 605
				this.rechargeGp.visible = true
				this.img_btn_1.skin = GameResPath.GetIcon("testAct","uifcxl_005")
				this.img_btn_2.skin = GameResPath.GetIcon("testAct","uifcxl_004")
				if (!this.recharge_view) {
					this.recharge_view = new TestActRecharge(this.rechargeGp)
					this.recharge_view.Load()
					this.recharge_view.SetData(this.GetCondition())
				}
			}
		}
	}

	loginGp: Laya.Box
	rechargeGp: Laya.Box
	btn_1: Laya.Box
	img_btn_1: Laya.Image
	btn_2: Laya.Box
	img_btn_2: Laya.Image
	_btn_close: Laya.Image
	_img_bg: Laya.Image
	public GetComponents() {
		[
			this.loginGp,
			this.rechargeGp,
			this.btn_1,
			this.img_btn_1,
			this.btn_2,
			this.img_btn_2,
			this._btn_close,
			this._img_bg,
		]
			= this.GetChildrenByNames([

				"loginGp",
				"rechargeGp",
				"btn_1",
				"img_btn_1",
				"btn_2",
				"img_btn_2",
				"_btn_close",
				"_img_bg",
			])
	}
}
window["TestActBaseView"] = TestActBaseView