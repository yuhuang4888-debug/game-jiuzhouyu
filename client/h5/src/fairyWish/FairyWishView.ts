import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { FairyWishEvent, FairyWishModel } from "../commonModel/FairyWishModel";
import { RoleManager } from "../commonModel/RoleManager";
import { GameResPath } from "../util/GameResPath";
import { Trim, Util } from "../util/Util";
import { FairyWishAttrItem } from "./FairyWishAttrItem";
import { FairyWishNodeItem } from "./FairyWishNodeItem";
import { Config } from "../common/Config"
import { table } from "../common/table";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { PlatformManager } from "../PlatformManager";
import { Message } from "../sysInfo/SysInfoController";
import { Runner } from "../util/Runner";
import { FRAME_TYPE } from "../util/DeclareGlobalVar";
import { WordManager } from "../common/WordManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { VipModel } from "../commonModel/VipModel";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { FairyWishNodeItem2 } from "./FairyWishNodeItem2";
export class FairyWishView extends BaseView1 {
    // node_list
    role_info
    fairy_id
    moudle_id
    fairy_info
    node_lv
    is_fairy_max
    run_id
    max_loop_mgr
    small_loop_mgr

    InitEvent
    LoadSuccess
    InitViewInfo
    UpdateFairyInfo
    UpdateCultivateInfo
    UpdatePreviewInfo
    UpdateSmallCultivate
    UpdateBigCultivate
    UpdateFairyModel
    GetShowNodeList
    PlayTweenNode
    SetMaxSkillInfo
    SetFairyNodeInfo
    SetAllPower
    SetLimitPos
    Update
    UpdateSeleteData
    UpdateSpecialInfo
    StartPlayTween
    FairyCfg
    FairyNodeCfg

    //新的滑动结构
    UpdateNodeList
    OnPanelChange
    OnPanelChangeEnd
    OnPanelChangeStart
    OnTweenEnd
    node_loop_mgr: LoopScrowViewMgr
    last_scroll_value
    last_dir = 0 //-1 0 1
    is_roll_start = false //是否开始滑动
    is_roll_move = false  //是否产生滑动移动距离
    is_can_tween = false
    SlideByNodeId
    slide_speed = 4  //滑动速度

    move_speed = 100
    model
    public constructor() {
        super();
        this.base_file = 'fairyWish';
        this.layout_file = 'FairyWishView';
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.is_center = true
        this.destroy_imm = true
        this.model = CustomActivityModel.GetInstance()
        let is_preview
        let is_preview_touch
        let dir
        let node_info
        let select_data
        let hide_num = 2
        let update_list
        //this.node_list = []
        let fairy_model = FairyWishModel.GetInstance()
        this.fairy_info = {}
        this.is_fairy_max = false
        let center_angle = 90 //中心node的角度
        let node_space_angle = 40 //两个node 之间的角度差
        let max_angle = center_angle + 2 * node_space_angle //坐标最大可移动的角度 
        let min_angle = center_angle - 2 * node_space_angle //右边最小可移动的角度
        let angle_change_max_value = 0 //当次点击事件 需要移动最大的角度
        let list_
        this.load_callback = () => {
            this._tip_bg1.visible = this._lb_tip.visible = false;
            ResManager.GetInstance().LoadFont(this, "view_fight_normal", this._lb_fighting, null, false);
            ResManager.GetInstance().LoadFont(this, "fighting_font", this._fight_num, null, false);
            ResManager.GetInstance().LoadFont(this, "fighting_font", this._big_fight_num, null, false);
            ResManager.GetInstance().LoadFont(this, "fighting_font", this._max_fight_num, null, false);

            this.LoadSuccess()
            this.InitEvent()
        }

        this.LoadSuccess = () => {
            this._node_list.y = 454
            ResManager.GetInstance().SetTexture(this, this._top_bg, GameResPath.GetIcon("fairyWish", "ui_xlzf_016"), undefined, undefined, true)
            ResManager.GetInstance().SetTexture(this, this._bottom_bg, GameResPath.GetIcon("fairyWish", "ui_xlzf_015"), undefined, undefined, true)
            this.FairyCfg = Config.PRELOAD_SERVER_CONFIG.config_fairy
            this.FairyNodeCfg = Config.PRELOAD_SERVER_CONFIG.config_fairy_node
            if (!this.fairy_id || !this.FairyCfg || !this.FairyNodeCfg) return
            this.role_info = RoleManager.GetInstance().mainRoleInfo
            this.moudle_id = this.FairyCfg[this.fairy_id].module
            let fairy_cfg = this.FairyCfg[`${this.fairy_id}`]
            this._fairy_name.text = fairy_cfg.name
            this.UpdateFairyInfo()
            this.UpdateFairyModel()
        }

        this.UpdateFairyInfo = (is_tween?) => {
            this.node_lv = fairy_model.getFairyCurNodeLv(this.fairy_id) //当前选中仙灵节点
            this.fairy_info = fairy_model.getFairyInfoById(this.fairy_id) //仙灵信息
            this.is_fairy_max = fairy_model.judgeFairyIsMax(this.fairy_id) //仙灵是否最高等级
            is_preview = !this.fairy_info.is_buy || this.is_fairy_max

            is_preview_touch = false
            // if (this.node_list.length > 0) {
            //     for (let item of this.node_list) {
            //         item.DeleteMe()
            //     }
            //     this.node_list = []
            // }

            this.InitViewInfo()
            //this.SetFairyNodeInfo()
            this.UpdateNodeList()
            this.SlideByNodeId(this.node_lv, is_tween)
        }
        this.InitEvent = () => {
            this.BindEvent(fairy_model, FairyWishEvent.SELECT_NODE, (data) => { //选中节点后操作
                // if (Runner.GetInstance().HasRunObj(this.hashCode)) return //预览或者运动中不给点
                select_data = data
                let node = data
                this.node_lv = node.node_id

                if (is_preview && !is_preview_touch && !fairy_model.req_cache_) {

                    this._img_back.visible = is_preview_touch = true
                    //     if (this.node_lv == node.node_id) {
                    //         this.node_lv = node.node_id
                    //         this.InitViewInfo()
                    //     } else {
                    //         this.node_lv = node.node_id
                    //         this.StartPlayTween()
                    //     }
                    // } else {
                    //     if (this.node_lv == node.node_id)
                    //         return
                    //     this.node_lv = node.node_id
                    //     this.StartPlayTween()
                }
                fairy_model.req_cache_ = false
                this.InitViewInfo()
            })
            //节点更新
            this.BindEvent(fairy_model, FairyWishEvent.UPDATE_NODE, (node_id?) => {
                if (Runner.GetInstance().HasRunObj(this.hashCode)) return
                if (node_id) {  //当前选中仙灵节点
                    this.is_fairy_max = fairy_model.judgeFairyIsMax(this.fairy_id) //仙灵是否最高等级
                    if (!is_preview) is_preview = this.is_fairy_max
                    if (this.is_fairy_max) {
                        this.InitViewInfo()
                        this.SetFairyNodeInfo()
                    } else {
                        this.node_lv = node_id + 1
                        // for (let item of this.node_list) {
                        //     if (item.node.node_id == this.node_lv) {
                        //         select_item = item
                        //         break
                        //     }
                        // }
                        // if (select_item) {
                        //     this.StartPlayTween()
                        // }

                        this.UpdateNodeList()
                        this.SlideByNodeId(this.node_lv, true)
                    }
                }

            })
            this.BindEvent(fairy_model, FairyWishEvent.UPDATE_FAIRY_BUY, () => {
                this.UpdateFairyInfo(true)
            })
            Util.AddClickEvent(this._img_close, () => {
                this.Close()
            }, this, true)
            Util.AddClickEvent(this._img_back, () => {
                this.node_lv = fairy_model.getFairyCurNodeLv(this.fairy_id) //当前选中仙灵节点
                is_preview_touch = this._img_back.visible = false
                this.InitViewInfo()
                this.SetFairyNodeInfo()
            }, this, true)
            let OperateFunc = () => { //操作---购买或者激活
                if (!this._node_list.mouseEnabled) return
                if (this.is_fairy_max) return
                if (!this.fairy_info.is_buy) { //未购买
                    let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                    let cfg = Config.PRELOAD_SERVER_CONFIG.config_recharge_product
                    let fairy = this.FairyCfg[`${this.fairy_id}`]
                    let product_info_ = cfg[fairy.recharge_id]
                    if (hasNum >= product_info_.money) {
                        VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', fairy.recharge_id)
                    } else {
                        if (product_info_) {
                            PlatformManager.GetInstance().PayRequest(product_info_.money, { id: product_info_.product_id, pay_title: product_info_.product_name })
                        }
                    }
                } else {
                    if (Runner.GetInstance().HasRunObj(this.hashCode)) return
                    if (fairy_model.checkNodeIsCanActive(this.fairy_id, this.node_lv)) {
                        fairy_model.Fire(FairyWishEvent.REQUEST_UPDATE_PROTO, 51301, this.fairy_id, this.node_lv)
                    } else {
                        Message.show("激活条件未达到")
                    }
                }

            }
            Util.AddClickEvent(this._btn_operate, OperateFunc, undefined, true)
        }

        this.StartPlayTween = () => {
            // if (this.node_lv < 3) {
            //     hide_num = this.node_lv == 1 ? 0 : 1
            // } else if (list_.length - this.node_lv < 2) {
            //     hide_num = this.node_lv == list_.length ? 4 : 3
            // } else {
            //     hide_num = 2
            // }
            // if (select_item.pos == 0 || select_item.pos == 4) { //转两格
            //     angle_change_max_value = node_space_angle * 2
            // } else {
            //     angle_change_max_value = node_space_angle * 1
            // }
            // dir = select_item.pos > 2 ? 1 : -1
            // update_list = this.GetShowNodeList()
            // this.run_id = Runner.GetInstance().AddRunObj(this, 1, FRAME_TYPE.total)
        }
        /**初始化界面时 显示节点*/
        this.SetFairyNodeInfo = () => {
            // let show_list = this.GetShowNodeList()
            // if (this.node_lv < 3) {
            //     hide_num = this.node_lv == 1 ? 1 : 0
            // } else if (list_.length - this.node_lv < 2) {
            //     hide_num = this.node_lv == list_.length ? 3 : 4
            // } else {
            //     hide_num = 2
            // }
            // for (let i = 0, l = show_list.length; i < l; i++) {
            //     let item: FairyWishNodeItem = this.node_list[i]
            //     if (!item) {
            //         item = new FairyWishNodeItem(this._node_box)
            //         this.node_list[i] = item
            //         item.Load()
            //     }
            //     if (hide_num != 2) {
            //         if (hide_num < 2 && i <= hide_num) {
            //             item.SetVisible(false)
            //         }
            //         if (hide_num > 2 && i >= hide_num) {
            //             item.SetVisible(false)
            //         }
            //     }
            //     item.SetData(show_list[i], show_list[i].node_id - 1)
            //     item.pos = i
            //     item.angle = center_angle + (2 - i) * node_space_angle
            // }

        }

        this.Update = (now_time, update_elapse_time) => {
            this.PlayTweenNode(update_elapse_time)
        }

        //更新选中状态的显示数据 和槽位数据
        this.UpdateSeleteData = () => {
            // if (select_item) {
            //     let start_node = select_item.curr_list_index - 2
            //     let info
            //     let node_index = 0
            //     let item: FairyWishNodeItem
            //     let j
            //     let list_len = list_.length
            //     for (let i = start_node; i < start_node + 5; i++) {
            //         j = i
            //         if (i < 0) {
            //             j = list_len + i
            //         } else if (i >= list_len) {
            //             j = i - list_len
            //         }
            //         info = list_[j]
            //         item = this.node_list[node_index]
            //         if (item) {
            //             item.SetData(info, j)
            //             item.pos = node_index
            //             item.angle = center_angle + (2 - node_index) * node_space_angle
            //         }
            //         node_index++;
            //     }
            // }
        }

        this.PlayTweenNode = (time) => {
            // let node: FairyWishNodeItem
            // let curr_frame_angle_change = time * this.move_speed
            // if (angle_change_max_value >= curr_frame_angle_change) {
            //     angle_change_max_value -= curr_frame_angle_change
            // } else {
            //     angle_change_max_value = 0
            //     curr_frame_angle_change = angle_change_max_value
            // }
            // let _angle

            // for (let i = 0; i < 5; i++) {
            //     node = this.node_list[i]
            //     _angle = node.angle + curr_frame_angle_change * dir
            //     if (dir == 1 && _angle >= (max_angle + node_space_angle * 0.4)) //(左) node_space_angle * 0.4给他一个缓冲 边界node运动一半后在换位置
            //     {
            //         node.angle = min_angle - node_space_angle + (_angle - max_angle)
            //         this.node_list.shift()
            //         if (select_item.pos == 4) { //数据更新 0-3 1-4
            //             node.SetData(update_list[3 + node.pos], update_list[3 + node.pos].node_id - 1)
            //         } else {  // 0-4
            //             node.SetData(update_list[4], update_list[4].node_id - 1)
            //         }
            //         this.node_list.push(node)
            //         if (hide_num == 2 || this.node_lv < 3) {
            //             node.SetVisible(true)
            //             continue
            //         }
            //         this.SetLimitPos(node, 4, 3)
            //         continue
            //     } else if (dir == -1 && _angle <= (min_angle - node_space_angle * 0.4)) {//(右)
            //         node.angle = max_angle + node_space_angle - (min_angle - _angle)
            //         this.node_list.pop()
            //         if (select_item.pos == 0) { //数据更新 3-0 4-1
            //             node.SetData(update_list[node.pos - 3], update_list[node.pos - 3].node_id - 1)
            //         } else {
            //             node.SetData(update_list[0], update_list[0].node_id - 1)
            //         }
            //         this.node_list.unshift(node)
            //         if (hide_num == 2 || this.node_lv > 3) {
            //             node.SetVisible(true)
            //             continue
            //         }
            //         this.SetLimitPos(node, 0, 1)
            //         continue
            //     } else {
            //         node.angle = _angle
            //     }

            // }
            // if (angle_change_max_value == 0) {
            //     this.UpdateSeleteData() //更新选中状态的显示数据
            //     this.InitViewInfo() //更新界面
            //     if (this.run_id) {
            //         Runner.GetInstance().RemoveRunObj(this.run_id)
            //         this.run_id = null
            //     }
            // }
        }

        this.SetLimitPos = (node, pos, num) => {
            // if (node.GetVisible() && hide_num != 2) {
            //     node.SetVisible(false)
            //     if (hide_num == num && select_item.pos == pos) {
            //         node.SetVisible(true)
            //         hide_num = 0
            //     }
            // } else {
            //     if (hide_num == num) {
            //         hide_num -= dir
            //         node.SetVisible(true)
            //     }
            // }
        }
        this.GetShowNodeList = () => {
            let leftNode = this.node_lv - 3
            let show_list = []
            let len = list_.length
            let node_pos
            for (let i = leftNode, l = leftNode + 5; i < l; i++) {
                node_pos = i
                if (i < 0) {
                    node_pos = len + i
                } else if (i >= len) {
                    node_pos = i - len
                }
                show_list.push(list_[node_pos])
            }
            return show_list
        }

        this.SetAllPower = (is_full) => {
            let combat = fairy_model.getNodeCombat(this.fairy_id, is_full)
            this._lb_fighting.text = `${combat}`
            this._gp_fight_h.refresh()
        }

        /**信息更新触发 */
        this.InitViewInfo = () => {
            list_ = fairy_model.getNodeInfoByFairyId(this.fairy_id) //当前仙灵的所有节点
            table.sort(list_, (a?, b?) => {
                return a.node_id < b.node_id
            })

            if (list_.length > 0) {
                for (let item of list_) {
                    item.type = this.FairyNodeCfg[`${this.fairy_id}@${item.node_id}`].type || 1
                    item.fairy_id = this.fairy_id
                    if (item.node_id == this.node_lv) {
                        node_info = item
                    }
                }
            }
            let power_title = is_preview ? "com_fight_label_3" : "com_fight_label_2"
            let power_base = is_preview ? "fairyWish" : "common"
            this._img_fight_title.skin = GameResPath.GetIcon(power_base, power_title)
            this._max_group.visible = (is_preview && !is_preview_touch) || this.node_lv == 1
            this._lab_original.visible = this._img_original.visible = !this.fairy_info.is_buy && !is_preview_touch
            this._small_group.visible = !this._max_group.visible && node_info.type == 1
            this._big_group.visible = !this._max_group.visible && !this._small_group.visible
            this._tip_bg1.visible = this._lb_tip.visible = !this.fairy_info.is_buy;
            this._tip_accu.visible = !this.fairy_info.is_buy
            if (is_preview && !is_preview_touch) {
                let fairy_cfg = this.FairyCfg[`${this.fairy_id}`]
                this.node_lv = this.is_fairy_max ? this.node_lv : 3
                this.SetAllPower(is_preview_touch)
                this.UpdatePreviewInfo() //预览 未购买与满级
                this.btn_lb.text = this.is_fairy_max ? "已满级" : `￥${fairy_cfg.price}`
                this._lab_original.text = `原价：￥${fairy_cfg.show_price}`
                this._img_red.visible = false
                Util.SetImageGray(this._btn_operate, false)

                this._img_box_max.visible = this.box_max.visible = this.node_lv == 1
                if (this.node_lv == 1) {
                    this._max_fight_num.text = `${node_info && node_info.combat ? node_info.combat : 0}`
                }
            } else {
                this.SetAllPower(!is_preview)
                this.UpdateCultivateInfo(node_info)
            }

        }



        this.UpdateNodeList = () => {

            if (!this.node_loop_mgr) {

                //新的滑动结构
                list_ = fairy_model.getNodeInfoByFairyId(this.fairy_id) //当前仙灵的所有节点
                table.sort(list_, (a?, b?) => {
                    return a.node_id < b.node_id
                })

                //前后两端压入两个假数据
                let fake_list = [{ "fake": 1 }, { "fake": 1 }]
                let new_list = []
                new_list = fake_list.concat(list_).concat(fake_list)


                this.node_loop_mgr = new LoopScrowViewMgr()
                this.node_loop_mgr.SetData(this._node_list, FairyWishNodeItem2, new_list, LoopScrCon.Horizontal)
                this._node_list.scrollBar.mouseWheelEnable = false;

                let len = new_list.length
                this._node_list.scrollBar.min = 0
                this._node_list.scrollBar.max = (len - 5) * (FairyWishNodeItem2.ITEM_WIDTH + this._node_list.spaceX)

                this._node_list.scrollBar.on(Laya.Event.CHANGE, this, this.OnPanelChange)
                this._node_list.scrollBar.on(Laya.Event.END, this, this.OnPanelChangeEnd)
                this._node_list.scrollBar.on(Laya.Event.START, this, this.OnPanelChangeStart)
                this._node_list.scrollBar.rollRatio = 0
                this.OnPanelChange()
                this.SlideByNodeId(this.node_lv)

            }
            // else {
            //     this.node_loop_mgr.replaceAll(new_list)
            //     let len = new_list.length
            //     this._node_list.scrollBar.min = 0
            //     this._node_list.scrollBar.max = (len - 5) * (FairyWishNodeItem2.ITEM_WIDTH + this._node_list.spaceX)
            // }
        }

        /**
         * dir 滑动方向 -1 0 1  0不滑动
         */
        this.SlideByNodeId = (node_id, is_tween?) => {
            let new_value = (this.node_lv - 1) * FairyWishNodeItem2.ITEM_WIDTH + (this.node_lv - 1) * this._node_list.spaceX
            let content: Laya.Box = this._node_list.getChildAt(0) as Laya.Box
            if (!content) return

            let center_item_
            for (let i = 0; i < content.numChildren; i++) {
                let item: FairyWishNodeItem2 = content.getChildAt(i) as FairyWishNodeItem2
                if (item) {
                    item.SetBg(false, false)
                    if (node_id && item.GetItemNodeId() == node_id) {
                        item.SetBg(true)
                        center_item_ = item
                        this.node_lv = item.GetItemNodeId()
                        this.InitViewInfo()
                    }
                }
            }

            if (!is_tween) {
                this._node_list.scrollBar.value = new_value
            } else {
                Laya.Tween.clearAll(this._node_list.scrollBar)
                let tween_time = Math.abs(new_value - this._node_list.scrollBar.value) * this.slide_speed

                //设置mouseEnabled是因为滚动条在tween的同时点击list会造成停止的现象
                this._node_list.mouseEnabled = false
                Laya.Tween.to(this._node_list.scrollBar, { value: new_value }, tween_time, null, Laya.Handler.create(this,
                    this.OnTweenEnd, [center_item_])
                    , 0, true)
            }

        }


        this.OnPanelChangeStart = () => {
            this.is_roll_start = true
        }

        /**list滑动完毕 */
        this.OnPanelChangeEnd = () => {
            if (!this.is_roll_start) return //滑动还没开始
            this.is_roll_start = false


            if (!this._node_list || !this._node_list.scrollBar) return
            let slide_value = this._node_list.scrollBar.value

            let content: Laya.Box = this._node_list.getChildAt(0) as Laya.Box
            if (!content) return


            let min_v = slide_value
            let max_v = slide_value + this._node_list.width  //690是list的长度
            let center_x = (max_v - FairyWishNodeItem2.ITEM_WIDTH + min_v) / 2
            let center_abs_dis//离中心点最近的绝对值距离
            let center_item_: FairyWishNodeItem2 = null

            for (let i = 0; i < content.numChildren; i++) {
                let item: FairyWishNodeItem2 = content.getChildAt(i) as FairyWishNodeItem2
                if (item) {

                    let item_pos_x = item.GetItemPos()
                    if (this.last_dir > 0) {
                        if (item_pos_x < center_x) continue;
                    }

                    if (this.last_dir < 0) {
                        if (item_pos_x > center_x) continue;
                    }

                    let min_dis = item_pos_x - center_x
                    let min_abs_dis = Math.abs(min_dis)
                    if (!center_abs_dis) {
                        center_item_ = item
                        center_abs_dis = min_abs_dis
                    } else {
                        if (min_abs_dis < center_abs_dis) {
                            center_item_ = item
                            center_abs_dis = min_abs_dis
                        }
                    }
                }
            }


            if (center_abs_dis) {
                let tween_dis = this.last_dir == 0 ? slide_value : (this.last_dir > 0 ? slide_value + center_abs_dis : slide_value - center_abs_dis)
                tween_dis = Math.ceil(tween_dis * 100) / 100
                if (tween_dis != slide_value) {
                    let tween_time = center_abs_dis * this.slide_speed
                    if (tween_dis < 0) return

                    //设置mouseEnabled是因为滚动条在tween的同时点击list会造成停止的现象
                    this._node_list.mouseEnabled = false
                    Laya.Tween.to(this._node_list.scrollBar, { value: tween_dis }, tween_time, null, Laya.Handler.create(this,
                        this.OnTweenEnd, [center_item_])
                        , 0, true)
                } else {
                    this.OnTweenEnd(center_item_)
                }
            }

        }

        this.OnTweenEnd = (center_item_: FairyWishNodeItem2) => {
            this._node_list.mouseEnabled = true
            //is_preview = false
            if (!center_item_) return
            center_item_.SetBg(true, true)
        }


        this.OnPanelChange = () => {

            if (this.is_roll_start) {
                //手动滑直接设置为false
                fairy_model.req_cache_ = false
            }


            let slide_value = this._node_list.scrollBar.value
            let content: Laya.Box = this._node_list.getChildAt(0) as Laya.Box
            if (!content) return
            if (!this.last_scroll_value) {
                this.last_scroll_value = slide_value
                this.last_dir = 0
            } else {
                //slide_value>this.last_scroll_value  滑到后面 反之前面
                this.last_dir = slide_value == this.last_scroll_value ? 0 : (slide_value > this.last_scroll_value ? 1 : -1)
                this.last_scroll_value = slide_value
            }

            let min_v = slide_value
            let max_v = slide_value + this._node_list.width  //690是list的长度
            let gap_v = (max_v - min_v) / 2 //中心点左右间距

            let center_x = (max_v - FairyWishNodeItem2.ITEM_WIDTH + min_v) / 2 //中心点x  157一FairyWishNodeItem2宽度
            let pos_obj = {
                "min_v": min_v,
                "max_v": max_v,
                "gap_v": gap_v,
                "center_x": center_x,
                "spaceX": this._node_list.spaceX,
                "slide_value": slide_value
            }

            for (let i = 0; i < content.numChildren; i++) {
                let item: FairyWishNodeItem2 = content.getChildAt(i) as FairyWishNodeItem2
                if (item) {
                    if (this.last_dir != 0) item.SetBg(false, false)
                    item.UpdateItemPos(pos_obj)
                }
            }
        }

        /**大节点 小节点信息更新 */
        this.UpdateCultivateInfo = (node_info) => {
            let fairy_cfg = this.FairyCfg[`${this.fairy_id}`]
            let node = this.FairyNodeCfg[`${this.fairy_id}@${this.node_lv}`]
            let is_can_active = false
            let is_active = node_info.is_activate == 1 //是否已激活
            let condition = JSON.parse(node.condition)
            let condition_desc
            for (let key in condition) {
                let c = condition[key]
                if (c[0] == "lv") { //等级条件 后面根据策划与数值进行修改
                    is_can_active = Number(this.role_info.level) >= Number(c[1]) //是否满足激活条件
                    condition_desc = `等级到达${c[1] > 370 && "神创" + ((Number(c[1]) - 370)) || "Lv." + c[1]}`
                }
            }

            if (is_preview_touch) {
                this.btn_lb.text = this.is_fairy_max ? "已满级" : `￥${fairy_cfg.price}`
                this._img_red.visible = this.preview_image.visible = false
            } else {
                this.btn_lb.text = is_active ? "已激活" : "激活"
                this._img_red.visible = !is_active && is_can_active
                Util.SetImageGray(this._btn_operate, !is_active && !is_can_active)
                this.preview_image.visible = !is_active
                this.preview_image.skin = GameResPath.GetIcon("fairyWish", is_can_active ? "ui_xlzf_007" : "ui_xlzf_016")
            }
            let color = !is_active && !is_can_active ? "#ce4343" : "#663915"
            if (this.node_lv == 1) {
                this.UpdateSpecialInfo(node, node_info)
                return
            }
            if (node.type == 1) {
                this._small_condition.color = color
                this._small_condition.text = condition_desc
                this.UpdateSmallCultivate(node) //养成 小节点
            } else {
                Util.SetImageGray(this._big_skill_icon, !is_active && !is_can_active)
                this._big_condition.color = color
                this._big_condition.text = condition_desc
                this.UpdateBigCultivate(node)////养成 大节点
            }
        }

        /**更新模型 刚进来的时候执行展示 界面更新不更新 */
        this.UpdateFairyModel = () => {
            let cfg = Config.PRELOAD_CLIENT_CONFIG.UIModelParameter["FairyWishView"]
            if (!cfg) return
            this.model.ShowViewModel(this, "FairyWishView", [UI_MODEL_TYPE.GHOST, `${this.fairy_id}`], this.res, null, null, null)

        }

        /**未够买或满级预览信息*/
        this.UpdatePreviewInfo = () => {
            this.preview_image.visible = !this.is_fairy_max
            this.preview_image.skin = GameResPath.GetIcon("fairyWish", "ui_xlzf_017")
            let attr_data = {}
            let ord_data = []
            let max_skill
            for (let i = 1; ; i++) { //i作为等级 如果没有找到下一级则退出
                let cfg = this.FairyNodeCfg[`${this.fairy_id}@${i}`]
                if (!cfg) break
                if (cfg.type == 2) {
                    max_skill = this.FairyNodeCfg[`${this.fairy_id}@${i}`].skill
                    continue
                }
                let list = JSON.parse(cfg.attr)
                for (let key in list) {
                    let v = list[key]
                    if (!attr_data[v[0]]) { //属性累加
                        attr_data[v[0]] = v[1]
                    } else {
                        attr_data[v[0]] += v[1]
                    }
                }
            }
            for (let key in attr_data) {
                table.insert(ord_data, {
                    attr: WordManager.GetProperties(Number(key)),
                    value: WordManager.ConvertToPercentValue(Number(key), attr_data[key])
                })
            }
            if (!this.max_loop_mgr) {
                this.max_loop_mgr = new LoopScrowViewMgr()
                this.max_loop_mgr.SetData(this._max_attr, FairyWishAttrItem, ord_data, LoopScrCon.Vertical, 2)
            } else {
                this.max_loop_mgr.replaceAll(ord_data)
            }
            this.SetMaxSkillInfo(max_skill)
        }

        /**未购买或满级技能信息 */
        this.SetMaxSkillInfo = (skill) => {
            let skill_id
            let skill_list = JSON.parse(skill)
            for (let key in skill_list) {
                let max = skill_list[key]
                skill_id = max[0]
            }
            ResManager.GetInstance().SetOutsideImageSprite(this, this._max_skill_icon, "resource/game/skillIcon/" + skill_id + ".png")
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_skill[skill_id]
            this._max_skill_name.text = `${cfg.name} Lv.Max`
            this._max_skill_desc.style.fontSize = 20
            this._max_skill_desc.style.color = "#763320"
            let lv_data = JSON.parse(cfg.lv_data)
            for (let _tmpi in lv_data) {
                let data = lv_data[_tmpi]
                let detail = window["ChatModel"].GetInstance().FormatColorTag(data.desc, false);
                this._max_skill_desc.innerHTML = Util.StrToHTML(Trim(detail))
            }
            this._max_skill_desc.style.width = 350
        }

        /**小节点信息 */
        this.UpdateSmallCultivate = (small_node) => {
            let data = {}
            let ord_data = []
            let list = JSON.parse(small_node.attr)
            this._fight_num.text = `${node_info && node_info.combat ? node_info.combat : 0}`
            for (let key in list) {
                let v = list[key]
                data[v[0]] = v[1]
            }
            for (let key in data) {
                table.insert(ord_data, {
                    attr: WordManager.GetProperties(Number(key)),
                    value: WordManager.ConvertToPercentValue(Number(key), data[key])
                })
            }
            if (!this.small_loop_mgr) {
                this.small_loop_mgr = new LoopScrowViewMgr()
                this.small_loop_mgr.SetData(this._small_attr, FairyWishAttrItem, ord_data, LoopScrCon.Vertical, 2)
            } else {
                this.small_loop_mgr.replaceAll(ord_data)
            }
        }

        /**大节点信息 */
        this.UpdateBigCultivate = (big_node) => {
            let skill = JSON.parse(big_node.skill)
            let skill_id = skill[0][0]
            let skill_lv = skill[0][1] - 1
            ResManager.GetInstance().SetOutsideImageSprite(this, this._big_skill_icon, "resource/game/skillIcon/" + skill_id + ".png")
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_skill[skill_id]
            this._big_skill_name.text = `${cfg.name} Lv.${skill[0][1]}`
            this._big_skill_desc.style.fontSize = 20
            this._big_skill_desc.style.color = "#763320"
            let lv_data = JSON.parse(cfg.lv_data)
            let data = lv_data[skill_lv]
            let last_data = lv_data[skill_lv - 1]
            let detail = window["ChatModel"].GetInstance().FormatColorTag(data.desc, false);
            this._big_fight_num.text = `${Number(data.power) - Number(!!last_data ? last_data.power : 0)}`
            this._big_skill_desc.innerHTML = Util.StrToHTML(Trim(detail))
            this._big_skill_desc.style.width = 350
        }

        /**特殊节点信息 */
        this.UpdateSpecialInfo = (special_node, node_info) => {
            let data = {}
            let ord_data = []
            let list = JSON.parse(special_node.attr)
            for (let key in list) {
                let v = list[key]
                data[v[0]] = v[1]
            }
            for (let key in data) {
                table.insert(ord_data, {
                    attr: WordManager.GetProperties(Number(key)),
                    value: WordManager.ConvertToPercentValue(Number(key), data[key])
                })
            }
            if (!this.max_loop_mgr) {
                this.max_loop_mgr = new LoopScrowViewMgr()
                this.max_loop_mgr.SetData(this._max_attr, FairyWishAttrItem, ord_data, LoopScrCon.Vertical, 2)
            } else {
                this.max_loop_mgr.replaceAll(ord_data)
            }
            let skill = JSON.parse(special_node.skill)
            let skill_id = skill[0][0]
            let skill_lv = skill[0][1] - 1
            ResManager.GetInstance().SetOutsideImageSprite(this, this._max_skill_icon, "resource/game/skillIcon/" + skill_id + ".png")
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_skill[skill_id]
            this._max_skill_name.text = `${cfg.name} Lv.${skill[0][1]}`
            this._max_skill_desc.style.fontSize = 20
            this._max_skill_desc.style.color = "#763320"
            let lv_data = JSON.parse(cfg.lv_data)
            let skill_data = lv_data[skill_lv]
            let detail = window["ChatModel"].GetInstance().FormatColorTag(skill_data.desc, false);
            this._max_skill_desc.innerHTML = Util.StrToHTML(Trim(detail))
            this._max_skill_desc.style.width = 350

            this._img_box_max.visible = this.box_max.visible = true
            this._max_fight_num.text = `${node_info && node_info.combat ? node_info.combat : 0}`
        }

        this.destroy_callback = () => {
            if (this.max_loop_mgr) {
                this.max_loop_mgr.DeleteMe()
                this.max_loop_mgr = null
            }

            if (this.small_loop_mgr) {
                this.small_loop_mgr.DeleteMe()
                this.small_loop_mgr = null
            }


            if (this.node_loop_mgr) {
                Laya.Tween.clearAll(this._node_list.scrollBar)
                this._node_list.scrollBar.off(Laya.Event.START, this, this.OnPanelChangeStart)
                this._node_list.scrollBar.off(Laya.Event.CHANGE, this, this.OnPanelChange)
                this._node_list.scrollBar.off(Laya.Event.END, this, this.OnPanelChangeEnd)
                this.node_loop_mgr.DeleteMe()
                this.node_loop_mgr = null
            }

            if (this.run_id) {
                Runner.GetInstance().RemoveRunObj(this.run_id)
                this.run_id = null
            }
            // for (let item of this.node_list) {
            //     item.DeleteMe()
            // }
            // this.node_list = []
        }

        this.Open = (...new_args) => {
            let parms = new_args
            if (parms && parms.length > 0) {
                this.fairy_id = parms[0] //仙灵id
            }
            super.Open()
        }



    }

    public DeleteMe() {
        super.DeleteMe()
    }



    _top_bg: Laya.Image
    _bottom_bg: Laya.Image
    preview_image: Laya.Image
    _fairy_name: Laya.Label
    _gp_fight: Laya.Box
    _gp_fight_h: Laya.HBox
    _img_fight_title: Laya.Image
    _lb_fighting: Laya.Label
    res: Laya.Box
    _node_box: Laya.Box
    _node_list: Laya.List
    _img_close: Laya.Image
    _img_back: Laya.Image
    _max_group: Laya.Box
    _max_attr: Laya.List
    _skill: Laya.Box
    _max_skill_icon: Laya.Image
    _max_skill_name: Laya.Label
    _max_skill_desc: Laya.HTMLDivElement
    _img_box_max: Laya.Image
    box_max: Laya.HBox
    _max_fight_num: Laya.Label
    _small_group: Laya.Box
    _small_condition: Laya.Label
    _small_attr: Laya.List
    _fight_num: Laya.Label
    _big_group: Laya.Box
    _big_condition: Laya.Label
    _big_skill: Laya.Box
    _big_skill_icon: Laya.Image
    _big_skill_name: Laya.Label
    _big_skill_desc: Laya.HTMLDivElement
    _big_fight_num: Laya.Label
    _btn_operate: Laya.Box
    btn_lb: Laya.Label
    _img_red: Laya.Image
    _lab_original: Laya.Label
    _img_original: Laya.Image
    _tip_accu: Laya.Image
    _tip_bg1: Laya.Image
    _lb_tip: Laya.Label
    public GetComponents() {
        [
            this._top_bg,
            this._bottom_bg,
            this.preview_image,
            this._fairy_name,
            this._gp_fight,
            this._gp_fight_h,
            this._img_fight_title,
            this._lb_fighting,
            this.res,
            this._node_box,
            this._node_list,
            this._img_close,
            this._img_back,
            this._max_group,
            this._max_attr,
            this._skill,
            this._max_skill_icon,
            this._max_skill_name,
            this._max_skill_desc,
            this._img_box_max,
            this.box_max,
            this._max_fight_num,
            this._small_group,
            this._small_condition,
            this._small_attr,
            this._fight_num,
            this._big_group,
            this._big_condition,
            this._big_skill,
            this._big_skill_icon,
            this._big_skill_name,
            this._big_skill_desc,
            this._big_fight_num,
            this._btn_operate,
            this.btn_lb,
            this._img_red,
            this._lab_original,
            this._img_original,
            this._tip_accu,
            this._tip_bg1,
            this._lb_tip,
        ]
            = this.GetChildrenByNames([

                "_top_bg",
                "_bottom_bg",
                "preview_image",
                "_fairy_name",
                "_gp_fight",
                "_gp_fight_h",
                "_img_fight_title",
                "_lb_fighting",
                "res",
                "_node_box",
                "_node_list",
                "_img_close",
                "_img_back",
                "_max_group",
                "_max_attr",
                "_skill",
                "_max_skill_icon",
                "_max_skill_name",
                "_max_skill_desc",
                "_img_box_max",
                "box_max",
                "_max_fight_num",
                "_small_group",
                "_small_condition",
                "_small_attr",
                "_fight_num",
                "_big_group",
                "_big_condition",
                "_big_skill",
                "_big_skill_icon",
                "_big_skill_name",
                "_big_skill_desc",
                "_big_fight_num",
                "_btn_operate",
                "btn_lb",
                "_img_red",
                "_lab_original",
                "_img_original",
                "_tip_accu",
                "_tip_bg1",
                "_lb_tip",
            ])
    }
}
window["FairyWishView"] = FairyWishView