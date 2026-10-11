import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest, HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"

import "../dungeonTower/DungeonTowerItem"
import { table } from "../common/table"
import { DungeonTowerItem } from "../dungeonTower/DungeonTowerItem"
import { Vector2 } from "../util/Vector2"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { ErlangParser } from "../util/ErlangParser"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { Config } from "../common/Config"
import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { RoleManager } from "../commonModel/RoleManager"
import { TimeUtil } from "../util/TimeUtil"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Vector3 } from "../util/Vector3"
import { Message } from "../sysInfo/SysInfoController"

export class DungeonTowerView extends BaseItem1 {
    InitView
    InitEvent
    ClearTime
    WhenAllItemLoad
    UpdateView
    cur_selete_dun_id
    all_data
    round_cfg
    model
    //GetTowerIds
    TransfReward
    CheckBeforeTower


    //设置挑战信息
    SetBoxInfo
    loop_mgr
    SetBoxChallenge
    _labelTimer
    big_item


    //初始化界面item
    InitBox
    list_item
    max_show   //最大多少个item在做展示
    need_mod    //循环补充数量
    /***一共9个位置 */
    fixed_poss  //位置
    ctrl_points //贝塞尔控制点
    GetBezierPoint
    GetDefaultChallengeIdx

    //循环标志
    tag_top
    tag_buttom

    //鼠标滑动
    is_press
    OnMouseDown
    OnMouseUp
    OnMouseMove
    OnMouseOut
    GetBezier_x

    //shake
    Shake1
    Shake2
    shake_tween_id1
    shake_tween_id2


    //页面改动
    OnChange
    OutStage
    new_buttom = 6
    new_top = 0
    GetBezierPointNew
    UpdateZOrder


    public constructor(parent?) {
        super(parent)

        this.base_file = "dungeonTower"
        this.layout_file = "DungeonTowerView"
        //this.layer_value = "UI"
        this.is_press = false
        this.list_item = []
        this.max_show = 5
        this.need_mod = 1
        this.tag_top = 0
        this.tag_buttom = 0
        this.model = BaseDungeonModel.GetInstance()
        this.cur_selete_dun_id = 0
        let time_list = []
        this._labelTimer = null

        //UI编辑器中的位置  [0]&&[len-1]是头尾位置，不显示给玩家
        this.fixed_poss = [[603, 78], [489, 104], [246, 148], [11, 282], [217, 384], [467, 439], [315, 615], [-235, 841], [-541, 905]]
        //控制点
        this.ctrl_points = [[563, 104], [393, 163], [108, 246], [93, 543], [439, 527], [646, 684], [185, 906], [-298, 901]]


        //初始化数据使用
        let item_count = 0
        let select_id  //下标从1开始  相当于第几关
        let is_show_anima
        let default_item_id //开始的item唯一id
        let is_all_item_load = false
       

        this.load_callback = () => {

            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_b_bg, GameResPath.GetIconOtherPath("dungeonTower", "tower_bg"))
            is_all_item_load = false
            SetHtmlStyle(this._html_desc, { c: "#ffffff", f: 22, w: 200, ww: false })
            SetHtmlStyle(this._html_desc2, { c: "#ffffff", f: 22, w: 200, ww: false })
            this.InitView()
            this.InitEvent()
            this.UpdateView(true)
        }

        this.InitView = () => {
            this._box_3.on(Laya.Event.MOUSE_DOWN, this, this.OnMouseDown)
            this._box_3.on(Laya.Event.MOUSE_UP, this, this.OnMouseUp)
            this._box_3.on(Laya.Event.MOUSE_OUT, this, this.OnMouseOut)
        }



        this.UpdateView = (is_show_anim) => {
            this.round_cfg = this.model.GetTowerInfoDatas()
            this.all_data = this.model.GetTowerIds(this.round_cfg)

            let sel_index = this.GetDefaultChallengeIdx()
            let item_index = (sel_index + 1) >= this.all_data.length ? this.all_data.length : sel_index + 1
            this.InitBox(item_index, sel_index, is_show_anim)
            this.SetBoxChallenge()
        }

        this.InitEvent = () => {
            let challenge_func=()=>{
                if (this.cur_selete_dun_id > 0) {
                    if (this.model.CheckTowerIsPass(this.cur_selete_dun_id)) {
                        Message.show("已通关")
                        return
                    }
                    if (this.CheckBeforeTower(this.cur_selete_dun_id)) {
                        //先退出队伍
                        if (!BaseDungeonModel.GetInstance().TryToEnterDungeon(this.cur_selete_dun_id)) return
                        this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61001, this.cur_selete_dun_id)
                    } else {
                        Message.show("请先通关前置关卡~")
                    }
                }
            }
            this.BindEvent(this.model, BaseDungeonModel.LIMIT_TIME_TOWER_ITEM_SELECT, (idx?) => {
                this.SetBoxInfo(idx)
            })


            this.BindEvent(this.model, BaseDungeonModel.LIMIT_TIME_TOWER_ITEM_ROUND, () => {
                this.UpdateView(true)
            })


            this.BindEvent(this.model, BaseDungeonModel.LIMIT_TIME_TOWER_UPDATE, () => {
                this.UpdateView(false)
            })


            Util.AddClickEvent(this._box_click, () => {
                let state = this.model.GetTowerRewardState()
                if (state == 2) {
                    Message.show("大奖已领取~")
                } else if (state == 0) {
                    Message.show("请先通关所有关卡噢")
                } else {
                    this.model.ToGetTowerBigReward()
                }
            }, this, true)

            Util.AddClickEvent(this._btn_c, () => {
                challenge_func()
            }, this, true)


            this.BindEvent(this.model, BaseDungeonModel.QUIT_DUNGEON_RETURN, (dun_id)=>{
                if(this.cur_selete_dun_id&&this.cur_selete_dun_id==dun_id){
                    challenge_func()
                    }
            })


        }

        /**检查前置关卡是否通关 */
        this.CheckBeforeTower = (dun_id) => {
            let temp = 0
            for (let i = 0; i < this.all_data.length; i++) {
                if (this.all_data[i].dun_id == dun_id) {
                    temp = i
                }
            }

            if (temp == 0) return true
            return this.model.CheckTowerIsPass(this.all_data[temp - 1].dun_id)
        }



        //默认选中处于可挑战状态的关卡（即已通关关卡数+1/第一关）；
        this.GetDefaultChallengeIdx = () => {
            let idx = 0
            for (let i = 0; i < this.all_data.length; i++) {
                if (this.model.CheckTowerIsPass(this.all_data[i].dun_id)) {
                    idx = this.all_data[i].idx
                }
            }
            if (idx >= this.all_data.length) {
                idx = this.all_data.length
            } else {
                idx = idx + 1
            }
            return idx
        }


        /**
         * item_index 调整界面中item的位置  中心位置
         * select_index 默认选中第几关
         * is_show_anima 是否展示初始化动画
         */
        this.InitBox = (item_index, select_index, is_show_anima1) => {

            let data = []
            let index1, index2
            let data_len = 6 //数据初始渲染数量
            if (item_index < 3) {
                index1 = 0
                index2 = data_len

            } else if (item_index > this.all_data.length - 2) {
                index1 = this.all_data.length - (data_len - 1)
                index2 = this.all_data.length
            } else {
                index1 = item_index - 3
                index2 = item_index + 3
            }
            index2 = index2 > this.all_data.length ? this.all_data.length : index2
            data = this.all_data.slice(index1, index2)

            //划标志
            this.tag_buttom = index1
            this.tag_top = index2 - 1
            select_id = select_index
            is_show_anima = is_show_anima1
            let len = (this.max_show + this.need_mod)
            item_count = 0

            //边界
            cur_top_item=null
            cur_buttom_item=null

            for (let i = len - 1; i >= 0; i--) {
                let item: DungeonTowerItem = this.list_item[i]

                let is_load = false //先设置数据再加载
                if (!item) {
                    item = new DungeonTowerItem(this._box_3)
                    //item.Load()
                    item.ExcuteCallback(() => {
                        item_count++
                        if (item_count >= (this.max_show + this.need_mod)) {
                            //所有item准备完毕
                            is_all_item_load = true
                            this.WhenAllItemLoad()
                        }
                    })
                    this.list_item[i] = item
                } else {
                    is_load = true
                }

                //设置唯一id
                item.SetID(i)

                if (i <= data_len - 1 && i >= 0) {
                    let cur_index = (data_len - 1) - i
                    let vvo = data[cur_index]
                    if (vvo && vvo.idx == select_index) {
                        default_item_id = i
                    }
                    item.SetData(vvo)

                    //设置上下初始边界
                    if (vvo&&vvo.idx==this.all_data[this.all_data.length-1].idx) {
                        cur_top_item = item
                    }
                    if (vvo&&vvo.idx==this.all_data[0].idx) {
                        cur_buttom_item = item
                    }

                } else {
                    item.SetData(null)
                }

                if (!is_load) {
                    item.Load()
                }

                //头部插入了占位数据  index需要+1
                item.SetPosition(this.fixed_poss[i + 1][0], this.fixed_poss[i + 1][1])
                item.SetCusScale(this.fixed_poss[i + 1][1], this.fixed_poss[1][1], this.fixed_poss[this.fixed_poss.length - 2][1])

            }

            //播放初始动画
            this.WhenAllItemLoad()

        }

        //当所有的item加载完毕开始调用
        this.WhenAllItemLoad = () => {

            if (!is_all_item_load) return

            //更新层级
            this.UpdateZOrder()
            //选中第几关
            this.model.Fire(BaseDungeonModel.LIMIT_TIME_TOWER_ITEM_SELECT, select_id, default_item_id)

            //做生成间隔动画
            this.ClearTime()
            if (is_show_anima) {
                let i = 0
                for (i = 0; i < this.list_item.length; i++) {
                    let item1 = this.list_item[i]
                    if (item1) item1.SetVisible(false)
                }


                for (i = 0; i < this.list_item.length; i++) {
                    let item = this.list_item[i]
                    if (item) {
                        let time = 0
                        if (i == 0 || i == 1) {
                            //不占用动画时间
                            time = 0
                        } else {
                            time = 150 * (i - 1)
                        }
                        let id = setTimeout(() => {
                            item.SetVisible(true)
                            item.PlayAnimation()
                        }, time);
                        table.insert(time_list, id)
                    }
                }
            }


        }

        this.ClearTime = () => {
            if (time_list && time_list.length > 0) {
                for (let i = 0; i < time_list.length; i++) {
                    clearTimeout(time_list[i])
                }
            }
        }

        //滑动
        this.OnMouseDown = (e) => {
            if (!this.is_press && is_all_item_load) {
                this.is_press = true
                base_mouse_y = Laya.stage.mouseY
                old_mouse_value = base_mouse_y
                this._box_3.on(Laya.Event.MOUSE_MOVE, this, this.OnMouseMove)
            } else {
                //console.warn("正在滑动")
            }

        }

        this.OnMouseUp = (e) => {
            if (!this.is_press) return
            this.is_press = false
            this.OutStage()
            this._box_3.off(Laya.Event.MOUSE_MOVE, this, this.OnMouseMove)
        }

        this.OnMouseOut = () => {
            if (!this.is_press) return
            this.is_press = false
            this.OutStage()
            this._box_3.off(Laya.Event.MOUSE_MOVE, this, this.OnMouseMove)
        }

        let on_move_distance = 0  //滑动的距离
        let old_move_dis = 0    //上一次滑动的距离
        let old_temp = 0    //求余特殊处理
        let slide_dir    //滑动方向
        let slide_dir_temp  //在滑动过程中变向 (鼠标不松开的变向)
        let old_slide_dir   //上一次的滑动方向
        let old_mouse_value = 0 //OnMouseMove 运行一次就记录一次鼠标的Y坐标
        let base_mouse_y = 0   //滑动的起始点
        let max_move_dis = 350 //每段滑行的间距  数值越大滑动越慢

        this.OnMouseMove = (e) => {
 
            if (this.is_press) {
                //滑动值
                let mouse_y = Laya.stage.mouseY
                if (mouse_y == base_mouse_y) return

                //滑动方向记录
                slide_dir = mouse_y > base_mouse_y
                slide_dir_temp = mouse_y > old_mouse_value
                old_mouse_value = mouse_y

                //在滑动过程中发生变向
                if (slide_dir != slide_dir_temp) {
                    this.OutStage()
                    base_mouse_y = mouse_y
                    //console.warn("---------------变向一次")
                    return
                }

                //对滑动值进行增减，避免出现item跳跃
                let move_dis = Math.abs(mouse_y - base_mouse_y)
                if (old_slide_dir != null && old_slide_dir != slide_dir) {
                    on_move_distance = move_dis + (max_move_dis - old_move_dis)
                } else {
                    on_move_distance = move_dis + old_move_dis
                }
                on_move_distance = Math.abs(on_move_distance)


                //求余特殊处理
                let temp = on_move_distance % max_move_dis
                if (temp < old_temp) {
                    temp = max_move_dis
                    old_temp = 0
                } else {
                    old_temp = temp
                }


                //检查是否到头到尾
                if (slide_dir 
                    && cur_top_item 
                    && cur_top_item.GetDataIdx()==this.all_data[this.all_data.length-1].idx
                    && cur_top_item.GetPoxY >= this.fixed_poss[2][1]) {
                    // if(slide_dir&&this.tag_top+1>(this.all_data.length-1)){
                    this.is_press = false
                    this.OutStage()
                    old_move_dis = max_move_dis
                    //console.warn("-----------到头了")
                    return
                }

                if (!slide_dir 
                    && cur_buttom_item 
                    && cur_buttom_item.GetDataIdx()==this.all_data[0].idx
                    && cur_buttom_item.GetPoxY <= this.fixed_poss[6][1]) {
                    //if(!slide_dir&&this.tag_buttom-1<0){
                    this.is_press = false
                    this.OutStage()
                    old_move_dis = max_move_dis
                   // console.warn("-----------到尾了")
                    return
                }

                //移动
                this.OnChange(temp, slide_dir)
            }
        }




        //鼠标离开滑动区域
        this.OutStage = () => {
            old_move_dis = on_move_distance % max_move_dis
            old_temp = 0
            old_slide_dir = slide_dir
        }


        this.OnChange = (value, dir) => {

            if (!is_all_item_load) return

            //防止滑动数值突然爆炸，造成乱序
            if (value > max_move_dis || value < 0) {
                console.warn("----------------滑动数值溢出", value)
                return
            }


            let arr, x, abs, cur_y
            for (let i = 0; i < this.list_item.length; i++) {
                arr = this.GetBezierPointNew(this.list_item[i], dir)
                x = this.GetBezier_x(value, max_move_dis, arr[0], arr[1], arr[2])
                abs = Math.abs(arr[2][1] - arr[0][1])

                let dir_temp = dir ? 1 : -1
                cur_y = arr[0][1] + (value / max_move_dis) * abs * dir_temp


                this.list_item[i].SetPosition(x, cur_y)
                this.list_item[i].SetCusScale(cur_y, this.fixed_poss[1][1], this.fixed_poss[this.fixed_poss.length - 2][1])
            }

        }


        let cur_top_item = null  //记录最顶上的item
        let cur_buttom_item = null //记录最底下的item
        //根据item的当前position Y值获取控制点和起始点，用于曲线运动
        this.GetBezierPointNew = (item: DungeonTowerItem, up: boolean) => {
            let pos_Y = item.GetPoxY
            let bz_start, bz_end, bz_ctrl  //目标起点  目标终点  两点之间的控制点
            let len = this.fixed_poss.length
            let index = 0

            if (up) {
                //第6关-->第5关
                for (let i = len - 1; i >= 0; i--) {
                    if (pos_Y >= this.fixed_poss[i][1]) {
                        index = i
                        break
                    }
                }

                if (index >= len - 2) {
                    index = 1 //超出了区间 重设
                    this.tag_top++
                    this.tag_buttom++
                    item.SetData(this.all_data[this.tag_top])
                    cur_top_item = item
                    this.UpdateZOrder()
                    //console.warn("测试：------------up")
                }
                bz_start = this.fixed_poss[index]
                bz_end = this.fixed_poss[index + 1]
                bz_ctrl = this.ctrl_points[index]
            } else {
                //第5关-->第6关
                for (let i = 0; i < len; i++) {
                    if (pos_Y <= this.fixed_poss[i][1]) {
                        index = i
                        break
                    }
                }

                if (index == 1) {
                    index = len - 2 //超出了区间 重设

                    //刚初始化完界面，会有一个空置item在干扰,特殊处理一下
                    if(item.GetDataIdx()!=-1) this.tag_top--
                    
                    this.tag_buttom--
                    item.SetData(this.all_data[this.tag_buttom])
                    cur_buttom_item = item
                    this.UpdateZOrder()
                    //console.warn("测试：------------down")
                }
                bz_start = this.fixed_poss[index]
                bz_end = this.fixed_poss[index - 1]
                bz_ctrl = this.ctrl_points[index - 1]
            }

            return [bz_start, bz_ctrl, bz_end]
        }

        //更新关卡的层级
        this.UpdateZOrder=()=>{
            for (let i = 0; i < this.list_item.length; i++) {
                let item :DungeonTowerItem= this.list_item[i]
                if (item){
                    if(item.GetDataIdx()!=-1){
                        item.display_obj.zOrder=1000-item.GetDataIdx()
                    }else{
                        item.display_obj.zOrder=99
                    }
                }
            }
            this._box_3.updateZOrder()
        }

      
        //is_up
        this.GetBezierPoint = (is_up, index) => {
            let bz_point1, bz_point2, bz_point3
            let index_temp = 0
            if (is_up) {
                //6变5    //8 7 6 5 4 3 2 
                index_temp = index + (this.fixed_poss.length - this.list_item.length)
                bz_point1 = this.fixed_poss[index_temp]
                bz_point3 = this.fixed_poss[index_temp - 1]
                bz_point2 = this.ctrl_points[index_temp - 1]

            } else {
                //5变6
                bz_point1 = this.fixed_poss[index]
                bz_point3 = this.fixed_poss[index + 1]
                bz_point2 = this.ctrl_points[index]
            }
            return [bz_point1, bz_point2, bz_point3]
        }


        //point1\point3 起始点  point2控制点
        this.GetBezier_x = (cur_y, max_y, point1, point2, point3) => {
            let x1 = point1[0]
            //let y1=point1.y1
            let x2 = point3[0]
            //let y2=point3.y1
            let cx = point2[0]
            //let cy=point2.y1
            let t = cur_y / max_y
            let x = Math.pow(1 - t, 2) * x1 + 2 * t * (1 - t) * cx + Math.pow(t, 2) * x2
            //let y = Math.pow(1-t,2)*y1+2*t*(1-t)*cy+Math.pow(t,2)*y2
            return x
        }



        //idx 下标从1开始 表示第几关
        this.SetBoxInfo = (idx) => {
            let gk_info = this.all_data[idx - 1] || null
            this.cur_selete_dun_id = 0

            this._btn_c.visible = gk_info != null
            if (gk_info) {
                //gk_info={ dun_id: Number(list[i]), is_max: is_max1, idx: (i + 1) }  
                this.cur_selete_dun_id = gk_info.dun_id
                let config_dun_reward = Config.PRELOAD_SERVER_CONFIG.config_dungeon_grade
                if (config_dun_reward) {
                    //关卡所有奖励
                    let rewards = this.model.GetTowerRewards(gk_info.dun_id, config_dun_reward)
                    let list = this.TransfReward(rewards)
                    if (this.loop_mgr) {
                        this.loop_mgr.replaceAll(list)
                    } else {
                        this.loop_mgr = new LoopScrowViewMgr(this.layer_value)
                        this.loop_mgr.SetData(this._list_rewards, CommonRewardItem, list, LoopScrCon.Horizontal)
                    }
                }


                let dun_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon[gk_info.dun_id]
                let fighting = RoleManager.GetInstance().GetMainRoleVo().fighting
                if (dun_cfg) {
                    this._lb_idx.text = `第${idx}关 ${dun_cfg.name}`
                    this._html_desc.innerHTML = `推荐战力：${HtmlColorTxt(dun_cfg.recommend_power, Enum_ColorUtil_Light.GREEN)}`

                    let color = fighting >= dun_cfg.recommend_power ? Enum_ColorUtil_Light.GREEN : Enum_ColorUtil_Light.RED
                    this._html_desc2.innerHTML = `我的战力：${HtmlColorTxt(fighting + "", color)}`
                }

                let is_pass = this.model.CheckTowerIsPass(gk_info.dun_id)     //是否已经通关
                let is_can_challenge = this.CheckBeforeTower(gk_info.dun_id)  //前置关卡是否通关
                this._btn_c.gray = is_pass || !is_can_challenge
                this.img_redAc.visible = !is_pass && (dun_cfg.recommend_power <= fighting) && is_can_challenge
            }

        }

        //稍微转下格式
        this.TransfReward = (rewards) => {
            let reward_list = []
            for (let _tmpi in rewards) {
                var vo = rewards[_tmpi]
                table.insert(reward_list, {
                    size: 85,
                    vo: {
                        style: vo[0],
                        typeId: vo[1],
                        count: vo[2]
                    }
                })
            }

            return reward_list
        }


        this.SetBoxChallenge = () => {
            let all_len = this.all_data.length
            let pass_list = this.model.dungeon_tower_scmd.pass_list || []
            let pass_len = pass_list.length
            this._lb_4.text = `第${pass_len}关`
            this._lb_2.text = `${pass_len}/${all_len}`
            this._progress_value.width = pass_len <= 0 ? 0 : 267 * (pass_len / all_len)

            //设置背景
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconOtherPath("dungeonTower", this.model.GetLimitTowerSkin(2)))


            //倒计时
            let over_time = this.model.dungeon_tower_scmd.over_time || 0
            let func = () => {
                let left_time = over_time - TimeUtil.getServerTime()
                if (left_time < 0) {
                    if (this._labelTimer) {
                        GlobalTimerQuest.CancelQuest(this._labelTimer)
                        this._labelTimer = null
                    }

                    //关闭爬塔界面  服务端说广播关闭
                    // GlobalEventSystem.Fire(EventName.CLOSE_VIEW,"DungeonTowerBaseView")
                } else {
                    this._lb_time2.changeText(`${TimeUtil.timeConvert(left_time, "hh-mm-ss")}`)
                }

            }

            if (this._labelTimer) {
                GlobalTimerQuest.CancelQuest(this._labelTimer)
                this._labelTimer = null
            }
            this._labelTimer = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
            func()


            //设置大奖
            if (!this.big_item) {
                this.big_item = new BaseAwardItem(this._box_item)
                this.big_item.Load()
                this.big_item.SetItemSize(89, 89)
            }
            let rewards = ErlangParser.GetInstance().parse(this.round_cfg.big_reward)
            let type_id, lock
            [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(rewards[0][0], rewards[0][1])
            let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
            if (goods_vo) {
                this.big_item.SetData(goods_vo.type_id, rewards[0][2], lock)
                this._lb_1.text = `通关${all_len}关即可获得极品奖励`
            }


            //设置大奖领取状态
            let state = this.model.GetTowerRewardState()
            this._box_click.visible = state != 0
            this._img_got.visible = state == 2
            this._img_receive.visible = state == 1
            this.Shake1()


        }

        let shake_init_y1 = 42
        let shake_init_y2 = 52
        let shake_time = 1
        this.Shake1 = () => {
            this._box_reward.y = shake_init_y1
            if (this.shake_tween_id1) SYTweenLite.Stop(this.shake_tween_id1)
            this.shake_tween_id1 = SYTweenLite.to(this.display_obj, this._box_reward, SYTweenLite.UiAnimationType.POSY, shake_init_y2,
                shake_time, () => {
                    this.Shake2()
                }, SYTweenFunc.LINEAR)
        }

        this.Shake2 = () => {
            this._box_reward.y = shake_init_y2
            if (this.shake_tween_id2) SYTweenLite.Stop(this.shake_tween_id2)
            this.shake_tween_id2 = SYTweenLite.to(this.display_obj, this._box_reward, SYTweenLite.UiAnimationType.POSY, shake_init_y1,
                shake_time, () => {
                    this.Shake1()
                }, SYTweenFunc.LINEAR)
        }



    }



    public DeleteMe() {
        if (this.shake_tween_id2) SYTweenLite.Stop(this.shake_tween_id2)
        if (this.shake_tween_id1) SYTweenLite.Stop(this.shake_tween_id1)
        if (this._labelTimer) {
            GlobalTimerQuest.CancelQuest(this._labelTimer)
            this._labelTimer = null
        }
        this.ClearTime()

        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe()
            this.loop_mgr = null
        }

        for (let i = 0; i < this.list_item.length; i++) {
            let item = this.list_item[i]
            item.DeleteMe()
            item = null
        }

        if (this._box_3) {
            this._box_3.off(Laya.Event.MOUSE_DOWN, this, this.OnMouseDown)
            this._box_3.off(Laya.Event.MOUSE_UP, this, this.OnMouseUp)
            this._box_3.off(Laya.Event.MOUSE_MOVE, this, this.OnMouseMove)
            this._box_3.off(Laya.Event.MOUSE_OUT, this, this.OnMouseOut)
        }

        this.list_item = []

        if (this.big_item) {
            this.big_item.DeleteMe()
            this.big_item = null
        }

        super.DeleteMe()
    }



_box_3:Laya.Panel
_box_1:Laya.Box
_img_bg:Laya.Image
_img_title:Laya.Image
_lb_1:Laya.Label
_progress_bg:Laya.Image
_progress_value:Laya.Image
_lb_2:Laya.Label
_lb_3:Laya.Label
_lb_4:Laya.Label
_lb_time1:Laya.Label
_lb_time2:Laya.Label
_box_reward:Laya.Box
_box_item:Laya.Box
_img_receive:Laya.Image
_box_click:Laya.Box
_img_got:Laya.Image
_box_2:Laya.Box
_img_b_bg:Laya.Image
_img_btn_bg:Laya.Image
_lb_idx:Laya.Label
_html_desc:Laya.HTMLDivElement
_html_desc2:Laya.HTMLDivElement
_btn_c:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
img_redAc:Laya.Image
_list_rewards:Laya.List
public GetComponents() {
[
this._box_3,
this._box_1,
this._img_bg,
this._img_title,
this._lb_1,
this._progress_bg,
this._progress_value,
this._lb_2,
this._lb_3,
this._lb_4,
this._lb_time1,
this._lb_time2,
this._box_reward,
this._box_item,
this._img_receive,
this._box_click,
this._img_got,
this._box_2,
this._img_b_bg,
this._img_btn_bg,
this._lb_idx,
this._html_desc,
this._html_desc2,
this._btn_c,
this._Image1,
this.labelDisplay,
this.img_redAc,
this._list_rewards,
]
 = this.GetChildrenByNames([

"_box_3",
"_box_1",
"_img_bg",
"_img_title",
"_lb_1",
"_progress_bg",
"_progress_value",
"_lb_2",
"_lb_3",
"_lb_4",
"_lb_time1",
"_lb_time2",
"_box_reward",
"_box_item",
"_img_receive",
"_box_click",
"_img_got",
"_box_2",
"_img_b_bg",
"_img_btn_bg",
"_lb_idx",
"_html_desc",
"_html_desc2",
"_btn_c",
"_Image1",
"labelDisplay",
"img_redAc",
"_list_rewards",
])
}
}
 window["DungeonTowerView"]= DungeonTowerView