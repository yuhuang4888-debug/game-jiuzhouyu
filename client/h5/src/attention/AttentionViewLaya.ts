import { BaseView1 } from "../common/BaseView1";
import { EquipmentItem } from "../common/EquipmentItem";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { Message } from "../sysInfo/SysInfoController";
import { ClientConfig } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";


export class AttentionViewLaya extends BaseView1 {
	bg: Laya.Image
	title: Laya.Image
	bg1: Laya.Image
	link: Laya.Image
	bg3: Laya.Image
	Content: Laya.HBox
	bg2: Laya.Image
	des: Laya.HTMLDivElement
	copy: Laya.Box
	close: Laya.Image

	copyStr
	cfg
	item_list = []
	public constructor() {
		super()


		this.base_file = "attention"
		this.layout_file = "AttentionViewLaya"
		this.use_background = true
		this.is_center = true
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.preload_client_config = {
			"ClientAttention": false
		}
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}
		this.close_callback = () => {
			if (this.item_list && Util.TableSize(this.item_list) > 0) {
				for (let _tmpi in this.item_list) {
					var item = this.item_list[_tmpi]
					item.DeleteMe()
					item = null
				}
				this.item_list = []
			}

		}
		
		this.copyStr = (str: string) => {
			let success = false
			if (Util.IsWXGame()){
				let wx = window["wx"]
				let text = str
				
				wx.setClipboardData({
					data: text,
					success: () => {
						success = true
					},
					fail: () => {
	
					},
					complete: () => {
	
					}
				})
			}
			else{
				//方法一
				let inputElement = Laya.Browser.window.document.createElement("input");
				inputElement.setAttribute("id", "fuzhineirong");
				inputElement.value = str;
				Laya.Browser.window.document.getElementsByTagName("body")[0].appendChild(inputElement);
				Laya.Browser.window.document.getElementById("fuzhineirong").select();
				Laya.Browser.window.document.execCommand("copy");
				Laya.Browser.window.document.getElementById("fuzhineirong").remove();
				success = true
			}
			
			// //方法二
			// let input: string = str;
			// const el: any = window.document.createElement('textarea');
			// el.value = input;
			// el.setAttribute('readonly', '');
			// el.style.contain = 'strict';
			// el.style.position = 'absolute';
			// el.style.left = '-9999px';
			// el.style.fontSize = '12pt'; // Prevent zooming on iOS
			// // const selection: any = window.getSelection();
			// // let originalRange: any = false;
			// // if (selection.rangeCount > 0) {
			// // 	originalRange = selection.getRangeAt(0);
			// // }
			// window.document.body.appendChild(el);
			// el.select();
			// el.selectionStart = 0;
			// el.selectionEnd = input.length;
			// let success: boolean = false;
			// try {
			// 	success = window.document.execCommand('copy');
			// } catch (err) {

			// }
			// window.document.body.removeChild(el);
			// // if (originalRange) {
			// // 	selection.removeAllRanges();
			// // 	selection.addRange(originalRange);
			// // }


			
			return success;

		}

	}


	public LoadSuccess() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg,GameResPath.GetIcon("attention", "ui_gz_01"))
		ResManager.GetInstance().SetImageSprite(this, this.bg1,"attention", "ui_gz_03")
		ResManager.GetInstance().SetImageSprite(this, this.bg3,"attention", "ui_gz_02")
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2, GameResPath.GetIcon("common2", "com_line_5"))
		ResManager.GetInstance().SetImageSprite(this, this.title,"attention", "ui_gz_title")
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientAttention", true)
		let plat_name = ClientConfig.plat_name
		if (!cfg) return
		this.cfg = cfg[plat_name]
		if (this.cfg) {
			this.SetDes()
			this.AddReward()
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this.copy, () => {
			if (this.cfg && this.cfg.wx_name) {
				this.copyStr(this.cfg.wx_name)
				Message.show("复制成功")
			}
		}, this, true)
		Util.AddClickEvent(this.close, () => {
			this.Close()
		}, this, true)

	}


	public SetDes() {

		ResManager.GetInstance().SetImageSpriteTrans(this, this.link, GameResPath.GetIconJpg("attention", this.cfg.image))
		this.des.style.fontSize = 22
		this.des.style.color = "#663915"
		this.des.width = 555
		this.des.style.wordWrap = true
		this.des.style.lineHeight = 30
		this.des.innerHTML = this.cfg.des
	}
	public AddReward() {
		let list = this.cfg.reward
		if (list) {
			let item = null
			for (let i = 0; i < list.length; i++) {
				item = this.item_list[i]
				if (!item) {
					item = new EquipmentItem(this.Content)
					this.item_list[i] = item
					item.Load()
					item.SetItemSize(85, 85)
				}
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(list[i][0], list[i][1])
				item.SetData(type_id, list[i][2])
			}
		}
	}






	public GetComponents() {
		[
			this.bg,
			this.title,
			this.bg1,
			this.link,
			this.bg3,
			this.Content,
			this.bg2,
			this.des,
			this.copy,
			this.close
		]
			= this.GetChildrenByNames([

				"bg",
				"title",
				"bg1",
				"link",
				"bg3",
				"Content",
				"bg2",
				"des",
				"copy",
				"close"
			])
	}
}
window["AttentionViewLaya"] = AttentionViewLaya