import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MonBookCheckColor, MonBookModel } from "../commonModel/MonBookModel";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil } from "../util/ColorUtil";
import { Util } from "../util/Util";
import { MonBookCheckBox } from "./MonBookCheckBox";
import { MonBookDecomposeItem } from "./MonBookDecomposeItem";


export enum Decompose_type {
	orange = 4,
	red = 5,
	pink = 6
}
window["Decompose_type"] = Decompose_type
export class MonBookDecomposeView extends BaseView1 {

    InitEvent
    LoadSuccess
    InitCheckBox
    RefuseCheckBoxStatus
    CheckBoxHandle
    ClearCheckBoxEvent
    UpdateView
    RefuseDecomposeList
    SetCheckBoxStage
    RefuseHarvestList
    RefuseHarvest
    SetDecomposeMonbookList
    DeleteDecomposeItem

    check_box_orange
    check_box_red
    check_box_pink
    bag_loop_mgr: LoopScrowViewMgr
    goods_loop_mgr: LoopScrowViewMgr
    check_box_orange_selected
    check_box_red_selected
    check_box_pink_selected
    public constructor() {
        super();
        this.base_file = "monBook";
        this.layout_file = "MonBookDecomposeView";
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true;
        this.use_background = true;
        this.destroy_imm = true;
        this.click_bg_toClose = true;
        let model = MonBookModel.GetInstance(),
            local_MonBookModel = MonBookModel,
            goods_model = GoodsModel.GetInstance(),
            local_GoodsModel = GoodsModel,
            local_laya = Laya,
            local_Util = Util,
            res_mgr = ResManager.GetInstance(),
            item_list_,
            harvest_list_,
            decompose_monbook_list_ = [],
            delay_fire_obj_,
            is_open_first_ = true,
            check_box_num_ = 0,
            check_orange

        this.load_callback = function () {
            this.InitEvent();
            this.LoadSuccess();
        }

        this.close_callback = function () {
            is_open_first_ = true
            check_box_num_ = 0
            model.ClearColorList()
            // this.ClearCheckBoxEvent()
            this.ClearUIEffect(this._effect_gp)
            if (delay_fire_obj_) {
                clearTimeout(delay_fire_obj_)
                delay_fire_obj_ = null
            }
            if (decompose_monbook_list_ && decompose_monbook_list_.length > 0) {
                for (let i = 0; i < decompose_monbook_list_.length; i++) {
                    decompose_monbook_list_[i] = undefined
                }
                decompose_monbook_list_ = []
            }
            if (this.bag_loop_mgr) {
                this.bag_loop_mgr.DeleteMe()
                this.bag_loop_mgr = null
            }
            if (this.goods_loop_mgr) {
                this.goods_loop_mgr.DeleteMe()
                this.goods_loop_mgr = null
            }
            this.check_box_orange_selected = false
            this.check_box_red_selected = false
            this.check_box_pink_selected = false
        }
        // this.preload_server_config = {
        //     "config_goods_decompose": false
        // }
        this.preload_client_config = {
            "ClientMonBookDecomposeHarvestConfig": false
        }

        this.InitEvent = () => {
            this.BindEvent(model, local_MonBookModel.UPDATE_DECOMPOSE_VIEW, () => {
                this.UpdateView()
            })
            this.BindEvent(goods_model, local_GoodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
                this.ClearUIEffect(this._effect_gp)
                if (delay_fire_obj_) {
                    clearTimeout(delay_fire_obj_)
                    delay_fire_obj_ = null
                }
                delay_fire_obj_ = setTimeout(() => {
                    if (decompose_monbook_list_ && decompose_monbook_list_.length > 0) {
                        for (let i = 0; i < decompose_monbook_list_.length; i++) {
                            decompose_monbook_list_[i] = undefined
                        }
                        decompose_monbook_list_ = []
                    }
                    model.ClearColorList()
                    model.UpdateDecomposeItemList()
                    this.UpdateView()
                    model.Fire(local_MonBookModel.UPDATE_DECOMPOSE_VIEW, true)
                }, 1000)
                // this.AddUIEffect("ui_fenjiechenggong_glow", this._effect_gp)
            })

            this.BindEvent(model, local_MonBookModel.SELECT_ITEM, (select_stage: boolean, goods_vo) => {
                let goods_id = goods_vo.goods_id
                let goods_num = goods_vo.goods_num
                let type_id = goods_vo.type_id
                if (select_stage) {
                    decompose_monbook_list_.push({ goods_id: goods_id, goods_num: goods_num })
                    model.decompose_dir[type_id] = goods_vo
                } else {
                    this.DeleteDecomposeItem(goods_id)
                    if (model.decompose_dir[type_id]) {
                        delete model.decompose_dir[type_id]
                    }
                }
                this.RefuseHarvest()
            })

            local_Util.AddClickEvent(this.decompose_gp, () => {
                if (model.can_decompose_list && model.can_decompose_list.length > 0 && decompose_monbook_list_ && decompose_monbook_list_.length > 0)
                    goods_model.Fire(local_GoodsModel.RESOLVE_GOODS, decompose_monbook_list_)
                else
                    Message.show("当前没有选择可以分解的图谱")
            }, this, true)

            local_Util.AddClickEvent(this.close_img, () => {
                this.Close()
            }, this, true)

            this.BindEvent(MonBookModel.GetInstance(), MonBookModel.CLICK_DECOMPOSE_CHECK,(quality?,bool?) => {
				if (quality == Decompose_type.orange ) {
					this.check_box_orange_selected = bool
				} else if (quality == Decompose_type.red ) {
					this.check_box_red_selected = bool
				} else if (quality == Decompose_type.pink ) {
					this.check_box_pink_selected = bool
				}
				this.RefuseDecomposeList(quality)
			}
		)

            model.Fire(local_MonBookModel.SCMD_REQUEST, 44205)
        }

        this.LoadSuccess = () => {
            this._havest_gp.scrollBar.visible = false
            this._item_gp.scrollBar.visible = false

            // res_mgr.SetTexture(this, this._bg_img, "resource/game/monBook/texture/uiboss_049.png")

            // item_list_ = new Laya.ArrayCollection()
            // this._item_gp.dataProvider = item_list_
            // this._item_gp.itemRenderer = MonBookDecomposeItem



            // harvest_list_ = new Laya.ArrayCollection()
            // this._havest_gp.dataProvider = harvest_list_
            // this._havest_gp.itemRenderer = MonBookDecomposeItem
        }

        this.InitCheckBox = () => {
            let max_quality = model.GetMaxActivatedQuality()
            for (let _tmpi in MonBookCheckColor) {
                var data = MonBookCheckColor[_tmpi]
                let a = this["check_box_" + data.key]
                if (!this["check_box_" + data.key] && data.quality <= max_quality) {
                    this["check_box_" + data.key] = new MonBookCheckBox(this.cb_gp)
                    let checkBox = this["check_box_" + data.key]
                    checkBox.SetData(data)
                    checkBox.Load()
                    if (data.quality == Decompose_type.orange) {
                        this["check_box_" + data.key + "_selected"] = true
                    }
                    check_box_num_ = check_box_num_ + 1
                }
            }
            check_orange = this.check_box_orange

            // let max_quality = model.GetMaxActivatedQuality()
            // for (let data of MonBookCheckColor) {
            //     if (!this[`check_box_${data.key}`] && data.quality <= max_quality) {
            //         this[`check_box_${data.key}`] = new Laya.CheckBox()
            //         this.cb_gp.addChild(this[`check_box_${data.key}`])
            //         let checkBox: Laya.CheckBox = this[`check_box_${data.key}`]
            //         checkBox.name = data.quality.toString()
            //         checkBox.skinName = "MonBookCheckBoxExml"
            //         checkBox.label = data.name
            //         checkBox.addEventListener(Laya.Event.CHANGE, this.CheckBoxHandle, this)
            //         let label: Laya.Label = checkBox.skin["labelDisplay"]
            //         label.textColor = ColorUtil.GetColorDark(data.quality)
            //         if (data.quality == 4)
            //             this[`check_box_${data.key}`].selected = true
            //         check_box_num_++
            //         if (data.quality == 4) {
            //             this.check_box_orange = checkBox
            //         } else if (data.quality == 5) {
            //             this.check_box_red = checkBox
            //         } else if (data.quality == 6) {
            //             this.check_box_pink = checkBox
            //         }
            //     }
            // }
            // check_orange = this.check_box_orange
        }

        this.RefuseCheckBoxStatus = () => {
            for (let data of MonBookCheckColor) {
                if (this[`check_box_${data.key}`]) {
                    let checkBox: Laya.CheckBox = this[`check_box_${data.key}`]
                    checkBox.selected = false
                }
            }
        }

        // this.CheckBoxHandle = (evt: Laya.Event) => {
        //     let checkbox: Laya.CheckBox = evt.target
        //     this.RefuseDecomposeList(checkbox)
        // }

        // this.ClearCheckBoxEvent = () => {
        //     for (let data of MonBookCheckColor) {
        //         if (this[`check_box_${data.key}`]) {
        //             let checkBox: Laya.CheckBox = this[`check_box_${data.key}`]
        //             checkBox.removeEventListener(Laya.Event.CHANGE, this.CheckBoxHandle, this)
        //         }
        //     }
        // }

        this.UpdateView = () => {
            let list = model.GetDecomposeMonBookList()
            if (list)
                this.empty_gp.visible = list.length > 0 ? false : true
            // item_list_.replaceAll(list)

            if (!this.bag_loop_mgr) {
                this.bag_loop_mgr = new LoopScrowViewMgr()
                this.bag_loop_mgr.SetData(this._item_gp, MonBookDecomposeItem, list, LoopScrCon.Vertical, undefined)
            } else {
                this.bag_loop_mgr.replaceAll(list)
            }

            if (is_open_first_) {
                this.InitCheckBox()
                is_open_first_ = false
                this.RefuseDecomposeList()
            }
            this.RefuseHarvest()
        }

        this.RefuseDecomposeList = (quality) => {
            let decompose_dir = {}
            model.decompose_dir = {}
            this.SetCheckBoxStage(quality)
            let cb_orange = this.check_box_orange ? this.check_box_orange_selected : false
            let cb_red = this.check_box_red ? this.check_box_red_selected : false
            let cb_pink = this.check_box_pink ? this.check_box_pink_selected : false
            model.ClearDecomposeList()
            if (cb_orange)
                model.decompose_list = model.decompose_list.concat(model.orange_can_decompose_list)
            if (cb_red)
                model.decompose_list = model.decompose_list.concat(model.red_can_decompose_list)
            if (cb_pink)
                model.decompose_list = model.decompose_list.concat(model.pink_can_decompose_list)
            if (model.decompose_list && model.decompose_list.length > 0) {
                for (let i = 0; i < model.decompose_list.length; i++) {
                    let goods_vo = model.decompose_list[i]
                    decompose_dir[goods_vo.type_id] = goods_vo
                }
            }
            model.decompose_dir = decompose_dir
            this.SetDecomposeMonbookList()
            this.UpdateView()

        }

        this.SetCheckBoxStage = (quality) => {
            let cb_orange = this.check_box_orange ? this.check_box_orange_selected : false
            let cb_red = this.check_box_red ? this.check_box_red_selected : false
            let cb_pink = this.check_box_pink ? this.check_box_pink_selected : false
            if (quality == Decompose_type.red && cb_red){
                // this.check_box_orange.selected = true
                this.check_box_orange_selected = true
			    model.Fire(local_MonBookModel.REFUSE_DECOMPOSE_CHECK,Decompose_type.red, true)
            }
            if (quality == Decompose_type.pink && cb_pink) {
                // this.check_box_red.selected = true
                // this.check_box_orange.selected = true
                this.check_box_red_selected = true
                this.check_box_orange_selected = true
                model.Fire(local_MonBookModel.REFUSE_DECOMPOSE_CHECK,Decompose_type.orange, true)
                model.Fire(local_MonBookModel.REFUSE_DECOMPOSE_CHECK,Decompose_type.red, true)
            }
        }

        this.RefuseHarvestList = () => {
            let list = []
            let cfg = res_mgr.GetGameConfigFromCache(this, "ClientMonBookDecomposeHarvestConfig", true)
            for (let key in cfg) {
                let id = cfg[key]
                list.push({ type_id: id, goods_num: 0 })
            }
            return list
        }

        this.RefuseHarvest = () => {
            // let config_goods_decompose = res_mgr.GetGameConfigFromCache(this, "config_goods_decompose", false)
            let harvest_list = this.RefuseHarvestList()
            let list = model.GetDecomposeHarvest(harvest_list)
            for (let i = list.length - 1; i >= 0; i--) {
                if (i > check_box_num_ - 1)
                    list.splice(i, 1)
            }
            // harvest_list_.replaceAll(list)
            if (!this.goods_loop_mgr) {
                this.goods_loop_mgr = new LoopScrowViewMgr()
                this.goods_loop_mgr.SetData(this._havest_gp, MonBookDecomposeItem, list, LoopScrCon.Horizontal, undefined)
            } else {
                this.goods_loop_mgr.replaceAll(list)
            }
        }

        this.SetDecomposeMonbookList = () => {
            if (decompose_monbook_list_ && decompose_monbook_list_.length > 0) {
                for (let i = 0; i < decompose_monbook_list_.length; i++) {
                    decompose_monbook_list_[i] = undefined
                }
                decompose_monbook_list_ = []
            }
            if (model.decompose_list && model.decompose_list.length > 0) {
                for (let i = 0; i < model.decompose_list.length; i++) {
                    let goods_vo = model.decompose_list[i]
                    decompose_monbook_list_.push({ goods_id: goods_vo.goods_id, goods_num: goods_vo.goods_num })
                }
            }
        }
        this.DeleteDecomposeItem = (goods_id) => {
            if (decompose_monbook_list_ && decompose_monbook_list_.length > 0) {
                for (let i = decompose_monbook_list_.length - 1; i >= 0; i--) {
                    let vo = decompose_monbook_list_[i]
                    if (vo.goods_id == goods_id)
                        decompose_monbook_list_.splice(i, 1)
                }
            }
        }
    }


    _bg_img: Laya.Image
    _Group1: Laya.Box
    _Image1: Laya.Image
    _img_title0: Laya.Label
    _Image4: Laya.Image
    _item_gp: Laya.List
    empty_gp: Laya.HBox
    _Image5: Laya.Image
    _Label1: Laya.Label
    cb_gp: Laya.HBox
    _Image6: Laya.Image
    _Group2: Laya.Box
    label2: Laya.Label
    _havest_gp: Laya.List
    decompose_gp: Laya.Box
    _Image8: Laya.Image
    _Label2: Laya.Label
    _effect_gp: Laya.Box
    close_img: Laya.Image
    public GetComponents() {
        [
            this._bg_img,
            this._Group1,
            this._Image1,
            this._img_title0,
            this._Image4,
            this._item_gp,
            this.empty_gp,
            this._Image5,
            this._Label1,
            this.cb_gp,
            this._Image6,
            this._Group2,
            this.label2,
            this._havest_gp,
            this.decompose_gp,
            this._Image8,
            this._Label2,
            this._effect_gp,
            this.close_img,
        ]
            = this.GetChildrenByNames([

                "_bg_img",
                "_Group1",
                "_Image1",
                "_img_title0",
                "_Image4",
                "_item_gp",
                "empty_gp",
                "_Image5",
                "_Label1",
                "cb_gp",
                "_Image6",
                "_Group2",
                "label2",
                "_havest_gp",
                "decompose_gp",
                "_Image8",
                "_Label2",
                "_effect_gp",
                "close_img",
            ])
    }
}

window["MonBookDecomposeView"] = MonBookDecomposeView