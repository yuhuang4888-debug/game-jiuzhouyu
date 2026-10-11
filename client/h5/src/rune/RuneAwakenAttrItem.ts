import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { ResManager } from "../common/ResManager";
import { WordManager } from "../common/WordManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { SkillManager } from "../skill/SkillManager";
import { Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { ErlangParser } from "../util/ErlangParser";
import { HtmlColorTxt, Util } from "../util/Util";


export class RuneAwakenAttrItem extends BaseItemRenderer {
	public WIDTH = 616
	public HEIGT = 48

	model = RuneModel.GetInstance()
	public constructor() {
		super();
		this.base_file = "rune"
		this.layout_file = `RuneAwakenAttrItem`
		this.Load()
	}

	public createChildren(){
		super.createChildren();

	}

	public load_callback(){
		this.BindEvent(this.model, RuneEvent.SELECT_AWAKE_MAT, (index) => {
			if (this.index == this.model.attr_select_index) {
				this.dataChanged()
			}
		})

		Util.AddClickEvent(this.click_bg, () => {
			
		}, this)
	}

	public DeleteMe(){
		super.DeleteMe();
	}

	public dataChanged(){
		if (super.dataChanged() && this.data) {
			let showRed = false
			let soul_attr_num_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_rune_wake_up", false);
			let soulLvCfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_rune_wake_up_lv", false)
			let soulExpCfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_rune_wake_up_exp", false)
			let awake_lv = this.data["awake_lv"];
			let config = soul_attr_num_cfg[`${this.data["quality"]}@${this.data[0]}@${awake_lv}`];
			let lastNum = WordManager.ConvertToPercentValue(this.data[0], 0);
			if (config) {
				let attr = JSON.parse(config.attr)[0];
				lastNum = WordManager.ConvertToPercentValue(this.data[0], Number(attr[1]));
			}
			//let awakeStr = awake_lv > 0 ? `<font color = ${Enum_ColorUtil_Dark.GREEN}>(觉醒${awake_lv}级)</font>` : `<font color = ${Enum_ColorUtil_Dark.RED}>(未觉醒)</font>`;
			let config_rune_skill = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_skill", false);
			let skillCfg = config_rune_skill[`${this.data.sub_type}`];
			if(skillCfg){
				let skillId:number = RuneModel.SkillId;
				let skillVo_ = SkillManager.GetInstance().getSkill(skillId);
				if(skillVo_ && skillVo_.basic){
					this._lb.text = `${skillVo_.basic.name}`;
					this._lb0.text = `Lv.${awake_lv + 1}`
				}
				this.lvLb.text = `Lv.${awake_lv + 1}`
			}else{
				this._lb.text = `${WordManager.GetProperties(this.data[0])}`;
				this._lb0.text = `${lastNum}`
				this.lvLb.text = `Lv.${awake_lv}`
			}
			
			let nextConfig = soul_attr_num_cfg[`${this.data["quality"]}@${this.data[0]}@${awake_lv + 1}`];
			let awakeStr = `<font color = ${Enum_ColorUtil_Dark.GREEN}></font>`;
			if (nextConfig) {
				let addExp = 0
				if (this.model.attr_select_index == this.index){
					for (let i in this.model.awakeSelect) {
						let goodsVo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(i)
						if (goodsVo && soulExpCfg[goodsVo.color]) {
							addExp += soulExpCfg[goodsVo.color].exp
						}
					}
				}
				let nextExp = soulLvCfg[awake_lv].exp
				let nextAttr = JSON.parse(nextConfig.attr)[0];
				// this._lb_next.text = Util.StrToHTML(` +${nextNum}${awakeStr}`);
				if(this.data.sub_type == 26 || this.data.sub_type == 27){
					this._lb_next.text = `Lv.${awake_lv + 2}`
				}else{
					let nextNum = WordManager.ConvertToPercentValue(this.data[0], Number(nextAttr[1]));
					this._lb_next.text = Util.StrToHTML(` +${nextNum}`);
				}
				this._lb_next.color = "#639c12"

				let showExp = (this.data.awake_exp || 0) + addExp
				this.expLb.text = `${showExp}/${nextExp}`
				this.expImg.width = Math.min(showExp / nextExp, 1) * 181
				showRed = RuneModel.GetInstance().RuneAttrCanAwake(awake_lv, this.data.awake_exp || 0, this.data["goods_id"], RuneModel.RuneAttrToSubType[this.data[0]] || this.data[0], soulExpCfg, soulLvCfg);
			} else {
				this._lb_next.color = "##ff4f50"
				this._lb_next.text = Util.StrToHTML("已满级");

				this.expImg.width = 181
				this.expLb.text = `已满级`
			}
			this._red.visible = !this.data["isBag"] && showRed
			this.select_bg.visible = this.model.attr_select_index == this.index
		}
	}


	bg: Laya.Image
	_lb: Laya.Label
	_lb0: Laya.Label
	_lb_next: Laya.Label
	lvLb: Laya.Label
	img1: Laya.Image
	select_bg: Laya.Image
	img2: Laya.Image
	expImg: Laya.Image
	expLb: Laya.Label
	_red: Laya.Image
	click_bg: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this._lb,
			this._lb0,
			this._lb_next,
			this.lvLb,
			this.img1,
			this.select_bg,
			this.img2,
			this.expImg,
			this.expLb,
			this._red,
			this.click_bg,
		]
			= this.GetChildrenByNames([

				"bg",
				"_lb",
				"_lb0",
				"_lb_next",
				"lvLb",
				"img1",
				"select_bg",
				"img2",
				"expImg",
				"expLb",
				"_red",
				"click_bg",
			])
	}
}
window["RuneAwakenAttrItem"] = RuneAwakenAttrItem