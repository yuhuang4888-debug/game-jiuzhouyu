import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { EquipModel, EquipDefine } from "../commonModel/EquipModel"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"

export class EquipSuitAttrItem extends BaseItem1 {
	_lb_num: Laya.Label
	attrText: Laya.Label
	_lb_title: Laya.Label

	countNum
	data
	default_height
	equipType
	height
	is_delay_callback
	item_list
	model
	need_refresh
	parent
	public constructor(parent?) {
		super(parent)
		this.parent = parent
		this.default_height = 35
		this.model = EquipModel.GetInstance()
		this.item_list = []
		this.base_file = "suit"
		this.layout_file = "EquipSuitAttrItem"
		this.is_load_res = false
		this.is_delay_callback = false

		this.load_callback = () => {
			if (this.need_refresh) {
				this.SetData(this.data, this.equipType)
				this.need_refresh = null
			}
		}
	}

	public DeleteMe() {

		this.item_list = []
		super.DeleteMe()
	}

	//equipType 套装类型 1 武防共鸣  2饰品共鸣
	public SetData(data: any, equipType: number) {
		this.data = data;
		this.equipType = equipType
		if (this.is_loaded) {

			// if (equipType == 1) {
			// 	this._lb_num.text = "【" + this.data.count + "件】 " + this.data.conf.slv + "阶" + "【" + EquipDefine.SUIT_NAME_CFG[this.data.conf.lv - 1] + "共鸣】"
			// } else {
			// 	this._lb_num.text = "【" + this.data.count + "件】 " + this.data.conf.slv + "阶 【饰品共鸣】"
			// }
			// let str: string = '';
			// let len: number = this.data.attrs.length;
			// for (let i = 0; i < len; i++) {
			// 	const attr = this.data.attrs[i];
			// 	str = str + WordManager.GetProperties(attr[0]) + (" + ") + WordManager.ConvertToPercentValue(attr[0], attr[1]) + (i == (len - 1) ? '' : "\n");
			// }

			// this.attrText.text = str;
			// this.height = this.default_height + (len * 25)
			// this.display_obj.height = this._lb_num.height + this.attrText.height;
			// this.parent.refresh();
			// this.attrText.y = this._lb_num.height + 8;

		}

		ResManager.GetInstance().LoadGameConfig(this, "config_equip_suit_item", false, null, (cfg) => {
			this.data = data;
			this.countNum = this.data.count;
			this.equipType = equipType;
			if (this.is_loaded) {
				this._lb_num.y = 5;
				if (this.data) {
					if (equipType == 1) {
						if (this.data.count == 2) { // 对低件数
							this._lb_title.text = "【" + EquipDefine.SUIT_NAME_CFG[this.data.conf.lv - 1] + "】" + this.data.conf.slv + "阶(" + this.data.curCount + '/' + this.data.conf.max_count + ')';
						}
						this._lb_num.text = "【" + this.data.count + "件】 " + this.data.conf.name; // this.data.conf.slv + "阶" + "【" + EquipDefine.SUIT_NAME_CFG[this.data.conf.lv - 1] + "共鸣】"
						this._lb_num.y = this._lb_title.y + this._lb_title.height + 8;
					} else {
						this._lb_num.text = "【" + this.data.count + "件】 " + this.data.conf.name;  // + "阶 【饰品共鸣】"
					}
					this._lb_num.color = "#0a953e"
					let str = ""
					// let attrCfg = cfg[equipType + "@" + this.data.suit_lv + "@" + this.data.suit_slv]
					let count = 0;
					let len: number = this.data.attrs.length;
					for (let i = 0; i < len; i++) {
						const attr = this.data.attrs[i];
						str = str + WordManager.GetProperties(attr[0]) + (" + ") + WordManager.ConvertToPercentValue(attr[0], attr[1]) + (i == (len - 1) ? '' : "\n");
					}
					// if (attrCfg) {
					// 	let attrList = JSON.parse(attrCfg.attr_list)

					// 	for (let k in attrList) {
					// 		var v = attrList[k]
					// 		if (Number(v[0]) == countNum) {
					// 			count = v[1].length
					// 			for (let _ in v[1]) {
					// 				var attr = v[1][_]
					// 				if (Number(_) != count) {
					// 					str = str + WordManager.GetProperties(attr[0]) + (" + ") + WordManager.ConvertToPercentValue(attr[0], attr[1]) + "\n"
					// 				} else {
					// 					str = str + WordManager.GetProperties(attr[0]) + (" + ") + WordManager.ConvertToPercentValue(attr[0], attr[1])
					// 				}
					// 			}
					// 			break
					// 		}
					// 	}
					// }
					this.attrText.text = str;
					this.height = this.default_height + (count * 22);
				} else {
					this._lb_num.text = "【" + this.countNum + "件】 未打造共鸣";
					this._lb_num.color = ColorUtil.TryParseHtmlString(Enum_ColorUtil_Dark.WHITE);
					this.height = this.default_height;
				}
				this.display_obj.height = this._lb_num.height + this.attrText.height + 5 + this._lb_title.height + 15;
				this.parent.refresh();
				this.attrText.y = this._lb_num.height + this._lb_num.y + 8;

				// SetSizeDeltaY(this.form, this.height)
				//UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this._group_attr)
			} else {
				this.need_refresh = true;
			}
			ResManager.GetInstance().DestoryGameConfig(this, "config_equip_suit_item")
		})

	}


	public GetComponents() {
		[
			this._lb_num,
			this.attrText,
			this._lb_title,
		]
			= this.GetChildrenByNames([

				"_lb_num",
				"attrText",
				"_lb_title",
			])
	}
}
window["EquipSuitAttrItem"] = EquipSuitAttrItem