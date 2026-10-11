import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { RoleManager } from "../commonModel/RoleManager";
import { PlatformManager } from "../PlatformManager";
import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { SYTweenFunc } from "../util/SYTweenFunc";
import { SYTweenLite } from "../util/SYTweenLite";
import { Util } from "../util/Util";

export class TestActLoginView extends BaseItem1 {
	tltle: Laya.Image
	effect: Laya.Box
	_img_good: Laya.Image
	_lb_desc2: Laya.HTMLDivElement
	des_bg: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	_lb_desc3: Laya.HTMLDivElement
	_lb_desc4: Laya.HTMLDivElement

	
	InitEvent
	LoadSuccess
	updateView
	tween_id
	public constructor(parent) {
		super(parent);

		let _util = Util,
			_model = CustomActivityModel.GetInstance(),
			role_mgr = RoleManager.GetInstance()

		this.base_file = "testAct";
		this.layout_file = "TestActLoginView";
		this.load_callback = function () {
			this.InitEvent();
			this.LoadSuccess();
		}


		this.InitEvent = () => {

			this.BindVar(role_mgr.GetMainRoleVo(), "CHANGE_LEVEL", () => {
				if (this.is_loaded)
					this.updateView();
			})
		}

		this.DeleteMe = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}
			// this.ClearUIEffect(this._gp_effect);
			super.DeleteMe();
		}

		this.LoadSuccess = () => {

			this._lb_desc2.innerHTML = "公测使用同账号创建角色登录，"
			this._lb_desc3.innerHTML = "称号通过邮件发送至对应角色"
			this._lb_desc4.innerHTML = _util.StrToHTML(`${_util.HtmlColorTxt("（仅首个角色可获得）", Enum_ColorUtil_Dark.GREEN)}`);
			this.tween_id = SYTweenLite.to(this, this._img_good, SYTweenLite.UiAnimationType.POSY, this._img_good.y - 10, 1.5, null, SYTweenFunc.PINGPONG, true)
			// this.AddUIEffect("ui_5015_vip", this._gp_effect, null, null, true);
			this.updateView();
		}

		this.updateView = () => {

			let full_Platform = false;
			let now_ = role_mgr.GetMainRoleVo();
			if(this.reward_show_dic && this.reward_show_dic["show_item"]){
				ResManager.GetInstance().SetTexture(this,this._img_good,GameResPath.GetIcon("testAct",this.reward_show_dic["show_item"]),null,null,true)
			}
			if (this.reward_show_dic && this.reward_show_dic["source_list"]) {
				let Platform_name = PlatformManager.GetPlatformName();
				let Platform_list = this.reward_show_dic["source_list"];
				full_Platform = Platform_list.indexOf(Platform_name) != -1;
			}
			let need_lv = 250;
			if (this.reward_show_dic && this.reward_show_dic["login_lv"])
				need_lv = Number(this.reward_show_dic["login_lv"]);
			let level = role_mgr.GetMainRoleVo().level;
			let str = full_Platform && level >= need_lv ? "(已达成)" : "(未完成)";
			this._lb_desc.innerHTML = _util.StrToHTML(`条件:达到${_util.HtmlColorTxt(`${need_lv}级`, Enum_ColorUtil_Light.GREEN)}${str}`);
			this._lb_desc.x = 345 / 2 - this._lb_desc.contextWidth / 2
			this._lb_desc.y = 34 / 2 - this._lb_desc.contextHeight / 2
		}
	}

	private _reward_show_dic;
	private get reward_show_dic() {

		if (!this._reward_show_dic) {
			this._reward_show_dic = {};
			let act = CustomActivityModel.GetInstance().GetActInfo(77, 1);
			if (act) {
				let reward_show_list = ErlangParser.GetInstance().Parse(act.condition);
				for (let key in reward_show_list) {
					let reward_show = reward_show_list[key];
					this._reward_show_dic[reward_show[0]] = reward_show[1];
				}
			}
		}
		return this._reward_show_dic;
	}

	public GetComponents() {
		[
			this.tltle,
			this.effect,
			this._img_good,
			this._lb_desc2,
			this.des_bg,
			this._lb_desc,
			this._lb_desc3,
			this._lb_desc4
		]
			= this.GetChildrenByNames([

				"tltle",
				"effect",
				"_img_good",
				"_lb_desc2",
				"des_bg",
				"_lb_desc",
				"_lb_desc3",
				"_lb_desc4"
			])
		this._lb_desc.style.fontSize = 22
		this._lb_desc.style.color = "#ffffff"
		this._lb_desc.style.wordWrap = false
		this._lb_desc2.style.fontSize = 22
		this._lb_desc2.style.color = "#7f623c"
		this._lb_desc2.style.width = 350
		this._lb_desc2.style.align = "center"
		this._lb_desc2.style.valign = "middle"
		this._lb_desc3.style.fontSize = 22
		this._lb_desc3.style.color = "#7f623c"
		this._lb_desc3.style.wordWrap = false
		this._lb_desc4.style.fontSize = 22
		this._lb_desc4.style.color = "#7f623c"
		this._lb_desc4.style.wordWrap = false
	}
}
window["TestActLoginView"] = TestActLoginView