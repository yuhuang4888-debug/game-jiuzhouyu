import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { CrossServerViewIndex } from "../commonController/BossController"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { UnrealDecomposeItem } from "./UnrealDecomposeItem"
import { UnrealRewardItem } from "./UnrealRewardItem"

export class UnrealDecomposeView extends BaseView1 {

    InitEvent
    LoadSuccess
    UpdateBag
    RefreshItem
    UpdateColorState
    GetCfgKeyValue
    GetDecomposeList
    UpdateDecomposeReward
    UpdateColorSelect

    unreal_bag_loop_mgr: LoopScrowViewMgr
    decompose_reward_loop_mgr: LoopScrowViewMgr
    public constructor() {
        super()
        this.base_file = "unreal"
        this.layout_file = "UnrealDecomposeView"
        this.layer_value = Enum_UILayer.Activity
        let model = UnrealModel.GetInstance(),
            local_Util = Util,
            local_UnrealModel = UnrealModel,
            goods_model = GoodsModel.GetInstance(),
            local_GoodsModel = GoodsModel,
            local_Message = Message,
            res_mgr = ResManager.GetInstance(),
            local_ColorType = ColorType,
            color_list_,
            // attr_goods_: eui.ArrayCollection,
            // attr_rewards_: eui.ArrayCollection,
            unreal_bag_,
            select_goods_dic_,
            decompose_reward_,
            decompose_reward_cache_
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.destroy_imm = true
        this.load_callback = function () {
            this.LoadSuccess()
        }
        this.close_callback = function () {
            unreal_bag_ = undefined
            select_goods_dic_ = undefined
            color_list_ = undefined
        }

        this.preload_server_config = {
            "config_decoration_attr": false,
            "config_decoration_kv": false,
            "config_goods_decompose": false,
            "config_soul_attr_num": false
        }

        this.destroy_callback = function () {
            if (this.unreal_bag_loop_mgr) {
                this.unreal_bag_loop_mgr.DeleteMe()
                this.unreal_bag_loop_mgr = null
            }
            if (this.decompose_reward_loop_mgr) {
                this.decompose_reward_loop_mgr.DeleteMe()
                this.decompose_reward_loop_mgr = null
            }
        }

        this.InitEvent = () => {
            for (let i = 0; i < 3; i++) {
                local_Util.AddClickEvent(this[`_img_hook_bg${i}`], () => {
                    let bool = !color_list_[i]
                    color_list_[i] = bool
                    this.UpdateColorState()
                    this.UpdateColorSelect(bool, i + local_UnrealModel.drop_base_color)
                    this.RefreshItem()
                }, this, true)
            }

            local_Util.AddClickEvent(this._img_close, () => {
                this.Close()
            }, this, true)

            let _time_id
            local_Util.AddClickEvent(this._gp_decompose, () => {
                if (_time_id) return
                let goods_list = this.GetDecomposeList()
                if (goods_list.length) {
                    let list = []
                    for (let key in unreal_bag_) {
                        let goods_vo = unreal_bag_[key]
                        if (select_goods_dic_[goods_vo.equip_info.goods_id]) {
                            list[key] = true
                        }
                    }

                    let now_index = {}
                    let len = this._dgp_goods_con.numChildren
                    for (let i = 0; i < len; i++) {
                        let item = <UnrealDecomposeItem>this._dgp_goods_con.getChildAt(i)
                        now_index[item["index"]] = { x: item.x, y: item.y - this._dgp_goods_con.scrollBar.value }
                    }

                    let register_protocals = false
                    for (let index in list) {
                        let pos = now_index[index]
                        if (pos) {
                            let group = new Laya.Box()
                            group.x = pos.x + 127 / 2
                            group.y = pos.y + 127 / 2
                            this._gp_effect.addChild(group)
                            // let call_back = () => {
                            Laya.Tween.clearAll(group)
                            this._gp_effect.removeChild(group)
                            if (register_protocals) {
                                register_protocals = true
                            }
                            // }
                            // this.AddUIEffect("ui_tunshi_glow", group, null, null, false, null, call_back, null, null, true)
                        }
                    }

                    _time_id = setTimeout(() => {
                        _time_id = undefined
                        decompose_reward_cache_ = decompose_reward_
                        goods_model.Fire(local_GoodsModel.RESOLVE_GOODS, goods_list)
                    }, 600)
                }
                else {
                    local_Message.show("请先选择需要分解的物品")
                }
            }, this, true)

            local_Util.AddClickEvent(this._gp_go_on, () => {
               // Message.show("敬请期待")
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Domain_Boss)
                // Kf1vnModel.GetInstance().Fire(Kf1vnEvent.KF1VN_OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Domain_Boss);
                this.Close()
            }, this, true)

            this.BindEvent(model, local_UnrealModel.SELECT_BREAK_DOWN_ITEM, (data) => {
                if (data.is_selected)
                    select_goods_dic_[data.equip_info.goods_id] = data.equip_info
                else
                    delete select_goods_dic_[data.equip_info.goods_id]

                this.UpdateDecomposeReward()
            })


            // this.BindEvent(goods_model, local_GoodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
            //     if (decompose_reward_cache_) {
            //         for (let obj of decompose_reward_cache_) {
            //             let goods_vo = goods_model.GetGoodsBasicByTypeId(obj.type_id)
            //             if (goods_vo) {
            //                 let color = ColorUtil.GetColorLight(goods_vo.color)
            //                 local_Message.show(`获得 <font color=${color}>${goods_vo.goods_name} x${obj.count}</font>`)
            //             }
            //         }
            //         decompose_reward_cache_ = undefined
            //     }
            // })

            this.BindEvent(goods_model, local_GoodsModel.CHANGE_UNREAL_BAG_LIST, () => {
                this.UpdateBag()
                select_goods_dic_ = {}
                for (let i in color_list_) {
                    this.UpdateColorSelect(color_list_[i], i + local_UnrealModel.drop_base_color)
                }
                this.RefreshItem()
            })
        }


        this.LoadSuccess = () => {
            this._list_decompose_reward.scrollBar.visible = false
            this._dgp_goods_con.scrollBar.visible = false

            // attr_goods_ = new eui.ArrayCollection()
            // this._dgp_goods_con.dataProvider = attr_goods_
            // this._dgp_goods_con.itemRenderer = UnrealDecomposeItem

            // attr_rewards_ = new eui.ArrayCollection()
            // this._list_decompose_reward.dataProvider = attr_rewards_
            // this._list_decompose_reward.itemRenderer = UnrealRewardItem

            select_goods_dic_ = {}

            this.InitEvent()
            this.UpdateColorState()
            this.UpdateBag()
            this.UpdateColorSelect(true, local_ColorType.BLUE)
            this.RefreshItem()
        }

        this.UpdateBag = () => {

            let list = []
            let unreal_bag = goods_model.unrealbag_goods_list
            let cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_attr", false)
            for (let equip_info of unreal_bag) {
                let attr_cfg = cfg[equip_info.type_id]
                if (attr_cfg && attr_cfg.stage < UnrealModel.DISMANTLE_STAGE)
                    list.push({ equip_info: equip_info, is_selected: false })
            }

            let sort_fun = (a, b) => {
                if (a.equip_info && b.equip_info) {
                    if (a.equip_info.color != b.equip_info.color) {
                        return b.equip_info.color - a.equip_info.color
                    } else {
                        return a.equip_info.type_id - b.equip_info.type_id
                    }
                }
            }
            list.sort(sort_fun)

            let len = list.length
            let max_len = this.GetCfgKeyValue(1)
            this._lb_big_capacity.text = `${len}/${max_len}`
            this._gp_empty.visible = list.length == 0
            this._scroll_bag_con.visible = list.length != 0

            unreal_bag_ = list

        }

        this.RefreshItem = () => {
            if (this.unreal_bag_loop_mgr) {
                this.unreal_bag_loop_mgr.replaceAll(unreal_bag_)
            } else {
                this.unreal_bag_loop_mgr = new LoopScrowViewMgr()
                this.unreal_bag_loop_mgr.SetData(this._dgp_goods_con, UnrealDecomposeItem, unreal_bag_, LoopScrCon.Vertical)
            }
        }

        this.UpdateColorState = () => {
            if (!color_list_)
                color_list_ = [true, false, false]
            for (let i = 0; i < 3; i++) {
                let bool = color_list_[i]
                this[`_img_hook${i}`].visible = bool
            }
        }

        this.GetCfgKeyValue = (key) => {
            return res_mgr.GetGameConfigFromCache(this, "config_decoration_kv", false)[key].value
        }


        this.GetDecomposeList = () => {
            let list = []
            let vo
            for (let id in select_goods_dic_) {
                vo = select_goods_dic_[id]
                if (vo){
                    list.push({ goods_id: vo.goods_id, goods_num: 1})
                }
            }
            return list
        }

        this.UpdateDecomposeReward = () => {
            let list_dic = {}
            for (let key in select_goods_dic_) {
                let info = select_goods_dic_[key]
                if (info) {
                    let cfg = res_mgr.GetGameConfigFromCache(this, "config_goods_decompose", false)[info.type_id]
                    // let reward = JSON.parse(cfg.regular_mat)//[[0,14010004,3],[0,17010002,2],[0,20010001,1]]
                    let reward = JSON.parse(cfg[5])
                    for (let vo of reward) {
                        let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
                        if (list_dic[type_id]) {
                            list_dic[type_id] += vo[2]
                        }
                        else {
                            list_dic[type_id] = vo[2]
                        }
                    }
                }
            }

            let list = []
            for (let key in list_dic) {
                list.push({ type_id: key, count: list_dic[key] })
            }
            decompose_reward_ = list
            if (list.length == 0){
                list.push({ type_id: 38040018, count: 0})
            }

            if (this.decompose_reward_loop_mgr) {
                this.decompose_reward_loop_mgr.replaceAll(list)
            } else {
                this.decompose_reward_loop_mgr = new LoopScrowViewMgr(this.layer_value)
                this.decompose_reward_loop_mgr.SetData(this._list_decompose_reward, UnrealRewardItem, list, LoopScrCon.Horizontal)
            }


            // attr_rewards_.source = list
            // attr_rewards_.refresh()

        }

        this.UpdateColorSelect = (bool, color) => {
            let attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_attr", false)
            for (let _tmpi in unreal_bag_) {
                var data = unreal_bag_[_tmpi]
                if ((color == ColorType.BLUE && data.equip_info.color <= color) || data.equip_info.color == color) {
                    let cfg = model.GetUnrealData(data.equip_info.type_id, attr_cfg)
                    let wear_equip = model.GetWearEquipByPos(data.equip_info.equip_type)
                    if (cfg
                        && wear_equip
                        && wear_equip.color >= data.equip_info.color
                        && !model.CheckUnrealQuality(data.equip_info.type_id, wear_equip.type_id, attr_cfg)
                        && (color < ColorType.ORANGE || (color == ColorType.ORANGE && cfg.star == 1))
                    ) {

                        if (bool) {
                            data.is_selected = true
                            select_goods_dic_[data.equip_info.goods_id] = data.equip_info
                        } else {
                            data.is_selected = false
                            if (select_goods_dic_[data.equip_info.goods_id]) {
                                select_goods_dic_[data.equip_info.goods_id] = null
                            }
                        }
                    }
                }
            }
            // if (bool) {
            //     let attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_attr", false)
            //     for (let data of unreal_bag_) {
            //         if (data.equip_info.color == color) {
            //             let cfg = attr_cfg[data.equip_info.type_id]
            //             if (!cfg || (color == local_ColorType.ORANGE && cfg.star > 1)) {
            //                 continue
            //             }
            //             data.is_selected = true
            //             select_goods_dic_[data.equip_info.goods_id] = data.equip_info
            //         }
            //     }
            // }
            // else {
            //     for (let data of unreal_bag_) {
            //         if (data.equip_info.color == color) {
            //             data.is_selected = false
            //             if (select_goods_dic_[data.equip_info.goods_id])
            //                 delete select_goods_dic_[data.equip_info.goods_id]
            //         }
            //     }
            // }
            this.UpdateDecomposeReward()
        }
    }

    _Image1: Laya.Image
    _Image2: Laya.Image
    _Group1: Laya.HBox
    _Image3: Laya.Image
    _Label1: Laya.Label
    _Image4: Laya.Image
    _Image5: Laya.Image
    _scroll_bag_con: Laya.Panel
    _dgp_goods_con: Laya.List
    _Group2: Laya.HBox
    _Label2: Laya.Label
    _lb_big_capacity: Laya.Label
    _Label3: Laya.Label
    Scroller1: Laya.Panel
    _list_decompose_reward: Laya.List
    _Group3: Laya.Box
    _img_hook_bg0: Laya.Image
    _Label4: Laya.Label
    _img_hook0: Laya.Image
    _Group4: Laya.Box
    _img_hook_bg1: Laya.Image
    _Label5: Laya.Label
    _img_hook1: Laya.Image
    _Group5: Laya.Box
    _img_hook_bg2: Laya.Image
    _Label6: Laya.Label
    _img_hook2: Laya.Image
    _img_close: Laya.Image
    _Image7: Laya.Image
    _gp_decompose: Laya.Box
    _Image8: Laya.Image
    _Label8: Laya.Label
    _gp_empty: Laya.Box
    _Image9: Laya.Image
    _Label9: Laya.Label
    _gp_go_on: Laya.Box
    _Image10: Laya.Image
    _Label10: Laya.Label
    scroll2: Laya.Panel
    _gp_effect: Laya.Box
    tip_con: Laya.HBox
    _Image6: Laya.Image
    _Label7: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._Group1,
            this._Image3,
            this._Label1,
            this._Image4,
            this._Image5,
            this._scroll_bag_con,
            this._dgp_goods_con,
            this._Group2,
            this._Label2,
            this._lb_big_capacity,
            this._Label3,
            this.Scroller1,
            this._list_decompose_reward,
            this._Group3,
            this._img_hook_bg0,
            this._Label4,
            this._img_hook0,
            this._Group4,
            this._img_hook_bg1,
            this._Label5,
            this._img_hook1,
            this._Group5,
            this._img_hook_bg2,
            this._Label6,
            this._img_hook2,
            this._img_close,
            this._Image7,
            this._gp_decompose,
            this._Image8,
            this._Label8,
            this._gp_empty,
            this._Image9,
            this._Label9,
            this._gp_go_on,
            this._Image10,
            this._Label10,
            this.scroll2,
            this._gp_effect,
            this.tip_con,
            this._Image6,
            this._Label7,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_Group1",
                "_Image3",
                "_Label1",
                "_Image4",
                "_Image5",
                "_scroll_bag_con",
                "_dgp_goods_con",
                "_Group2",
                "_Label2",
                "_lb_big_capacity",
                "_Label3",
                "Scroller1",
                "_list_decompose_reward",
                "_Group3",
                "_img_hook_bg0",
                "_Label4",
                "_img_hook0",
                "_Group4",
                "_img_hook_bg1",
                "_Label5",
                "_img_hook1",
                "_Group5",
                "_img_hook_bg2",
                "_Label6",
                "_img_hook2",
                "_img_close",
                "_Image7",
                "_gp_decompose",
                "_Image8",
                "_Label8",
                "_gp_empty",
                "_Image9",
                "_Label9",
                "_gp_go_on",
                "_Image10",
                "_Label10",
                "scroll2",
                "_gp_effect",
                "tip_con",
                "_Image6",
                "_Label7",
            ])
    }
}

window["UnrealDecomposeView"] = UnrealDecomposeView