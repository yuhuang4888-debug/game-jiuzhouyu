import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MaterialsTool } from "../common/MaterialsTool"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OnHookModel } from "../commonModel/OnHookModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class OnHookAdditionTips extends BaseView1 {
    _img_top_title: Laya.Image
    _gp_time: Laya.Box
    _lb_time: Laya.Label
    _scroller: Laya.Panel
    content: Laya.VBox

    loop_mgr
    InitView
    InitEvent
    UpdateView
    Local_DeleteMe
    data
    exp_goods_1
    exp_goods_2
    AddIcon
    public constructor() {
        super()


        this.base_file = "onHook"
        this.layout_file = "OnHookAdditionTips"
        this.is_load_res = false
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.destroy_imm = true
        this.append_to_ctl_queue = true;
        let icon_list_1
        let icon_list_2
        let model = OnHookModel.GetInstance()
        let goods_model = GoodsModel.GetInstance()

        this.preload_server_config = {

        }
        this.load_callback = () => {
            this.InitEvent()
            this.UpdateView()

        }

        this.close_callback = () =>{
            this.Local_DeleteMe()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._img_close, () => {
                this.Close()
            }, this, true)

            let UseOrGet = (id?) => {
                let goods_id = goods_model.GetOneGoodsByTypeId(id)
                if (goods_id > 0) {
                    let goods_vo = goods_model.GetGoodsVoByGoodsId(goods_id)
                    if (goods_vo) {
                        let outline_time = model.GetOnhookTime()
                        let recommend_num = Math.floor((model.max_outline_time - outline_time) / model.add_time[goods_vo.type_id])
                        if (goods_vo && goods_vo.goods_num) {
                            recommend_num = goods_vo.goods_num > recommend_num && recommend_num || goods_vo.goods_num

                        }
                        let min_num = recommend_num <= 0 && 0 || 1
                        recommend_num = recommend_num <= 0 && 1 || recommend_num
                        BagModel.GetInstance().Fire(BagModel.OPEN_VIEW, "BatchUseView", goods_vo, min_num, recommend_num, goods_vo.goods_num)
                    }
                } else {
                    MaterialsTool.GetInstance().materialsTips(id)
                }
            }

            Util.AddClickEvent(this.icon_1, () => {
                UseOrGet(37020001)
            }, this, true)

            Util.AddClickEvent(this.icon_2, () => {
                UseOrGet(37020002)
            }, this, true)

            this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_BAG_LIST, (goods_list?) => {
				if (!goods_list || goods_list.length == 0) {
					return
				}
				for (let i in goods_list) {
					var vo = goods_list[i]
					if (vo.type_id == 37020001 || vo.type_id == 37020002 ) {
						this.UpdateView()
						break
					}
				}
			})
        }


        this.UpdateView = () => {
            ResManager.GetInstance().SetTexture(this, this.bg, GameResPath.GetIcon("onHook", "ui_gj_05"))
            if (!this.exp_goods_1) {
                this.exp_goods_1 = new EquipmentItem(this.item_1)
                this.exp_goods_1.Load()
                this.exp_goods_1.SetItemSize(85, 85)
            }
            
            let number = goods_model.GetBagGoodsNum(37020001)
            this.exp_goods_1.SetData(37020001,number)  //1.5倍经验符
            if (number <= 0) {
                this.lb_1.text = "获取物品"
                this.icon_1.visible = false
                let goodsBasic = goods_model.GetGoodsBasicByTypeId(37020001)
                this.AddIcon(goodsBasic.getway_url,1)
            } else {
                this.lb_1.text = "使用"
                this.icon_1.visible = true
            }

            number = goods_model.GetBagGoodsNum(37020002)
            if (!this.exp_goods_2) {
                this.exp_goods_2 = new EquipmentItem(this.item_2)
                this.exp_goods_2.Load()
                this.exp_goods_2.SetItemSize(85, 85)
            }
            this.exp_goods_2.SetData(37020002,number)  //2倍经验符

            if (number <= 0) {
                this.lb_2.text = "获取物品"
                this.icon_2.visible = false
                let  goodsBasic = goods_model.GetGoodsBasicByTypeId(37020002)
                this.AddIcon(goodsBasic.getway_url)
            } else {
                this.lb_2.text = "使用"
                this.icon_2.visible = true
            }
            this.exp.text = WordManager.ConvertNum((model.exp_effect * 2 *60).toString())
        }

        this.AddIcon = (getway_url?,number?) =>{
            let way_attr = ErlangParser.GetInstance().Parse(getway_url)
            let count = 1
			if (way_attr && way_attr.length > 0) {
				if (! icon_list_1) {
                    icon_list_1 = []
				}
                if (! icon_list_2) {
                    icon_list_2 = []
				}
				let hasShop = false
				for (let i = 0; i < way_attr.length; i++) {
					let id = way_attr[i][0]
					id = Number(id)
					// //抢购商城在上面处理了
					// if (id == 87) {
					// 	continue
					// }
					//不需要重复添加商城图标
					if (id == 60 || (id >= 140 && id <= 145)) {
						if (hasShop) {
							continue
						}
						hasShop = true
					}
					//创建图标流程
                    let group
                    if(number ==1 ){
                        group =  icon_list_1[i]
                    }else{
                        group =  icon_list_2[i]
                    }
					if (!group) {
						group = new Laya.Box
                        if(number ==1 ){
                            this._gp_get_1.addChild(group)
                            icon_list_1[i] = group
                        }else{
                            this._gp_get_2.addChild(group)
                            icon_list_2[i] = group
                        }

						let icon = new Laya.Image
						group.addChild(icon)
						count += 1
						this._gp_get_1.refresh()
                        this._gp_get_2.refresh()
						icon.skin = OpenFun.OpenIcon(way_attr[i][0])
					}
					group.visible = true
					group.includeInLayout = true
					Util.AddClickEvent(group, () => {
						OpenFun.OpenFunHandler(way_attr[i][0], way_attr[i][1], way_attr[i][2])
                        model.Fire(OnHookModel.CLOSE_ONHOOK_TIPS)
						this.Close()
					}
						, this, true)

				}
            }
        }

        this.Local_DeleteMe = () => {
            if (this.exp_goods_1) {
                this.exp_goods_1.DeleteMe()
                this.exp_goods_1 = null
            }
            if (this.exp_goods_2) {
                this.exp_goods_2.DeleteMe()
                this.exp_goods_2 = null
            }
            if (icon_list_1 && icon_list_1.length > 0) {
				for (let _tmpi in icon_list_1) {
					var vo = icon_list_1[_tmpi]
					if (vo) {
						this._gp_get_1.removeChild(vo)
						vo = null
					}
				}
			}
			icon_list_1 = null
            if (icon_list_2 && icon_list_2.length > 0) {
				for (let _tmpi in icon_list_2) {
					var vo = icon_list_2[_tmpi]
					if (vo) {
						this._gp_get_2.removeChild(vo)
						vo = null
					}
				}
			}
			icon_list_2 = null
        }
    }

    public DeleteMe() {
        this.Local_DeleteMe()
        super.DeleteMe()
    }

    bg: Laya.Image
    _img_title: Laya.Image
    _img_close: Laya.Image
    _img_1: Laya.Image
    _img_2: Laya.Image
    item_1: Laya.Box
    item_2: Laya.Box
    exp: Laya.Label
    icon_1: Laya.Image
    icon_2: Laya.Image
    lb_2: Laya.Label
    lb_1: Laya.Label
    _gp_get_1:Laya.HBox
    _gp_get_2:Laya.HBox
    public GetComponents() {
        [
            this.bg,
            this._img_title,
            this._img_close,
            this._img_1,
            this._img_2,
            this.item_1,
            this.item_2,
            this.exp,
            this.icon_1,
            this.icon_2,
            this.lb_2,
            this.lb_1,
            this._gp_get_1,
            this._gp_get_2
        ]
            = this.GetChildrenByNames([

                "bg",
                "_img_title",
                "_img_close",
                "_img_1",
                "_img_2",
                "item_1",
                "item_2",
                "exp",
                "icon_1",
                "icon_2",
                "lb_2",
                "lb_1",
                "_gp_get_1",
                "_gp_get_2"
            ])
    }
}
window["OnHookAdditionTips"] = OnHookAdditionTips