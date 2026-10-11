import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { OperateManager } from "../operation/OperateManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { SkillManager } from "../skill/SkillManager"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { Mathf } from "../util/Mathf"
import { GetSizeDeltaX, Util, SetSizeDeltaX, Trim, SetHtmlStyle } from "../util/Util"
import { Vector2 } from "../util/Vector2"


export class SeaSceneTargetItem extends BaseItem1 {
    Dispose
    SetData
    SetIndex
    force_stop_find_way
    index
    model
    needRefresh
    posInfo
    timerId
    tmp_data
    towerId


    //寻路相关
    FindBestPath
    GetTowerCfg
    GetDoorList
    IsYaoSai2
    IsHaiShen

    FineSectino
    TransPoint
    GetTowerId
    StartFindWay

    cfg
    list_init = null
    cur_path = []//当前寻路路径

    //寻路盲区 特殊处理
    //地图右下角的三角形 
    block_area = [[3636, 4211], [6128, 5102], [4625, 6020]]

    //要塞和传送门之间的死角
    //[要塞位置，障碍点1，障碍点2]
    block_area_1 = [[5827, 1667], [4220, 80], [3871, 550]]
    block_area_2 = [[4637, 2869], [2090, 327], [1692, 612]]
    block_area_3 = [[3318, 4176], [702, 1437], [395, 1760]]


    CheckSpacialArea
    MathDot
    CalCos
    GetCosBy2pt
    GetAngle



    public constructor(parent?) {
        super(parent)

        this.model = SeaHegemonyModel.GetInstance()
        this.base_file = "seaHegemony"
        this.layout_file = "SeaSceneTargetItem"
        let scene = Scene.GetInstance()

        let endPos = null
        let needNext = false
        let found_array = null
        let findWay
        let record_end_pos

        var IsFoundWay = (way_pos) => {
            if (found_array) {
                for (let _ = 0; _ < found_array.length; _++) {
                    var found_pos = found_array[_]
                    if (way_pos.x == found_pos.x && way_pos.y == found_pos.y) {
                        return true
                    }
                }
            }
            return false
        }
        
        findWay = () => {
            if (this.timerId) {
                clearTimeout(this.timerId)
                this.timerId = null
            }
        
            needNext = false
            let LogicRealRatio_X = SceneObj.GetLogicRealRatio().x
            let LogicRealRatio_Y = SceneObj.GetLogicRealRatio().y
            for (let i = 0; i < this.cur_path.length; i++) {
                let wayss = this.cur_path[i]
                let temp_endPos = { x: Math.floor(wayss[0] / LogicRealRatio_X), y: Math.floor(wayss[1] / LogicRealRatio_Y) }
                if (!IsFoundWay(temp_endPos)) {
                    endPos = temp_endPos
                    needNext = i < (this.cur_path.length - 1)
                    table.insert(found_array, temp_endPos)
                    break
                }
            }


            if (endPos) {
                record_end_pos = endPos
                scene.MainRoleMove(endPos, 0, (id?) => {
                    if (this.force_stop_find_way) {
                        this.force_stop_find_way = false
                        return
                    }

                    if (needNext) {
                        if (this.timerId) {
                            clearTimeout(this.timerId)
                            this.timerId = null
                        }
                        //this.timerId = setTimeout(findWay, 0)
                        findWay()
                    } else {
                        let boss = Scene.GetInstance().FindNearestMonsters(this.towerId)
                        if (boss) {
                            Scene.GetInstance().SetClickTarget(boss)
                            AutoFightManager.GetInstance().SetAutoFight(true)
                        }
                    }
                }, null, null, true)
            }
        }

        let OnClickFindWay = () => {
            if (this.posInfo) {
                this.force_stop_find_way = false
                AutoFightManager.GetInstance().SetAutoFight(false)
                scene.SetClickTarget(null)
                scene.CancelClickTarget()
                this.StartFindWay(this.towerId)
            }
        }

        let InitItem = () => {
            let res = (this.index == 3 && ("mainui_adventure_pro_bg3") || ("mainui_adventure_pro_bg"))
            ResManager.GetInstance().SetImageSprite(this, this.hpImg, "mainUI", res, true)
            if (this.needRefresh) {
                this.SetData()
            }

            Util.AddClickEvent(
                this._Group1, () => {
                    OnClickFindWay()
                },
                this,
                true
            )
            let scene_changed_func = () => {
                this.SetData()
            }

            this.BindEvent(
                this.model,
                SeaHegemonyModel.START_FIGHT, () => {
                    if (this.index == 1) {
                        OnClickFindWay()
                    }
                }
            )


            this.BindEvent(
                this.model,
                SeaHegemonyModel.MOVE_THOURHGT_DOOR, () => {
                    //穿过传送门后继续寻路
                    // OperateManager.Instance.ClearSrcOper()
                    // OperateManager.Instance.StopMove()
                    if(!this.force_stop_find_way){
                        findWay()
                    }
                   
                }
            )


            this.BindEvent(
                this.model,
                SeaHegemonyModel.UPDATE_MONSTER, () => {
                    this.SetData()
                    if (this.index == 3 && !Scene.GetInstance().GetClickTarget()) {
                        let id = this.model.GetAttackId(this.cfg)
                        if (id && this.towerId == id && AutoFightManager.GetInstance().GetAutoFightState()) {
                            //打完一个哨塔之后 自动去寻路进行攻打要塞
                            OnClickFindWay()
                        }
                    }
                }
            )

            this.BindEvent(GlobalEventSystem, SceneEventType.SCENE_CHANGED, scene_changed_func)
            var StopFindway = () => {
                this.force_stop_find_way = true
            }

            SceneManager.GetInstance().BindOne("curr_joystick_dir", StopFindway)
            SceneManager.GetInstance().BindOne("curr_click_move_pos", StopFindway)
        }



        this.load_callback = () => {
            SetHtmlStyle(this.tarLb, { c: "#5a1c20", f: 18, w: 120, lh: 20 })
            InitItem()
        }


        this.SetIndex = (index?) => {
            this.index = index
        }

        this.SetData = () => {
            if (this.is_loaded) {
                this.cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seacraft_construction", false)
                if (this.cfg) {
                    let curId = null
                    let monsterData = null
                    let world = "防守目标"
                    if (this.index == 1 && this.model.fightCurId) {
                        // 测试
                        //this.model.fightCurId = 4900107

                        curId = this.GetTowerId(this.model.fightCurId)// this.model.fightCurId + "@" + sceneId
                        monsterData = this.model.GetMonsterData(this.model.fightCurId)
                        this.towerId = this.model.fightCurId
                    }
                    else if (this.index == 2 && this.model.fightBeforeId) {
                        world = "修复目标"
                        curId = this.GetTowerId(this.model.fightBeforeId)//this.model.fightBeforeId + "@" + sceneId
                        monsterData = this.model.GetMonsterData(this.model.fightBeforeId)
                        this.towerId = this.model.fightBeforeId
                    }
                    else if (this.index == 3) {
                        let id = this.model.GetAttackId(this.cfg)
                        if (id) {
                            this.towerId = id
                            curId = this.GetTowerId(id)//id + "@" + sceneId
                            monsterData = this.model.GetMonsterData(id)
                            world = "进攻目标"
                        }
                    }
                    // [ts2lua]cfg下标访问可能不正确
                    let data = this.cfg[curId]
                    this.tmp_data = data
                    if (data && monsterData) {
                        let res = "ui_shzb_066"
                        if (data.type == 2) {
                            res = "ui_shzb_099"
                        }
                        else if (data.type == 3) {
                            res = "ui_shzb_067"
                        }
                        ResManager.GetInstance().SetImageSprite(this, this.targetImg, "seaHegemony", res, true)
                        this.hpImg.width = (monsterData.hp / monsterData.hp_max) * 112
                        this.hpLb.text = Mathf.Round(monsterData.hp / monsterData.hp_max * 100) + "%"
                        this.tarLb.innerHTML = `${world}:<br>${data.name}`
                        this.tarLb.style.width = 120
                        let LogicRealRatio_X = SceneObj.GetLogicRealRatio().x
                        let LogicRealRatio_Y = SceneObj.GetLogicRealRatio().y

                        this.posInfo = { x: data.x / LogicRealRatio_X, y: data.y / LogicRealRatio_Y }
                    }
                }
                this.needRefresh = false
            } else {
                this.needRefresh = true
            }
        }

        this.Dispose = () => {
            found_array = []
            if (this.timerId) {
                clearTimeout(this.timerId)
                this.timerId = null
            }
        }

        //[4900101/哨塔（外）,4900102/哨塔（中）,4900103/哨塔（内),4900104/要塞（外）,4900105/要塞（中）,4900106/要塞（内）,4900107/海神城堡]
        //游戏中哨塔外到海神城堡的路径顺序
        //哨塔外》要塞外》哨塔中》要塞中》哨塔内》要塞内》海神城堡   （如果要塞没有被毁坏，则需要走传送阵）
        //let path_all = [4900101, 4900104, 4900102, 4900105, 4900103, 4900106, 4900107]


        //需要最佳的路径  （防守方专用）
        //target_id 目标id
        this.FindBestPath = (target_id) => {
            let main_role = Scene.GetInstance().main_role
            if (!main_role) return []
            let chuizu_y
            let ys_data

            //在计算盲区内，将位置归置指定的位置
            if (this.CheckSpacialArea(this.block_area_1)) {
                ys_data = this.GetTowerCfg(SeaHegemonyModel.towerPoslist[5])
                chuizu_y = this.model.GetPlayerChuizu(this.cfg, [ys_data.x - 100, ys_data.y - 100])
            } else if (this.CheckSpacialArea(this.block_area_2)) {
                ys_data = this.GetTowerCfg(SeaHegemonyModel.towerPoslist[3])
                chuizu_y = this.model.GetPlayerChuizu(this.cfg, [ys_data.x - 100, ys_data.y - 100])
            } else if (this.CheckSpacialArea(this.block_area) || this.CheckSpacialArea(this.block_area_3)) {
                ys_data = this.GetTowerCfg(SeaHegemonyModel.towerPoslist[1])
                chuizu_y = this.model.GetPlayerChuizu(this.cfg, [ys_data.x - 100, ys_data.y - 100])
            } else {
                chuizu_y = this.model.GetPlayerChuizu(this.cfg, [main_role.real_pos.x, main_role.real_pos.y])
            }

            //let [chuizu_x, chuizu_y] = this.model.GetPlayerChuizu(this.cfg, [main_role.real_pos.x, main_role.real_pos.y])

            let section_list = []

            let cur_target_cfg = this.GetTowerCfg(target_id)
            //目标的垂足  用垂足进行判断 比较准确点
            let t_y = this.model.GetPlayerChuizu(this.cfg, [cur_target_cfg.x, cur_target_cfg.y])

            //判断玩家的相对位置
            let type = chuizu_y > t_y ? 1 : 0//1 方向：哨塔外>海神城堡   0方向：海神城堡>哨塔外
            section_list = this.FineSectino(chuizu_y, target_id, type)
            let path1 = this.TransPoint(section_list, type)

            return path1
        }


        //将导航区间的点  转成路径点格式[[x,y],....]
        this.TransPoint = (list, type) => {
            let seaListy = SeaHegemonyModel.GetInstance().monsterData
            let points = []
            let data

            for (let i = 0; i < list.length; i++) {
                let id = list[i]
                data = this.GetTowerCfg(id)
                let offset_value = 110

                //判断要塞是否被破坏
                if (this.IsYaoSai2(id)) {
                    //如果要塞是目的地，不将要塞转成对应的传送阵目标点
                    if (i == list.length - 1) {

                        if (seaListy[id] && seaListy[id].hp == 0) {
                            table.insert(points, [data.x, data.y])
                        } else {
                            //如果要塞还没有被破坏，要塞相当于障碍点，是无法寻路过去的
                            //加入偏移
                            if (type == 1) {
                                table.insert(points, [data.x - offset_value, data.y + offset_value])
                            } else {
                                table.insert(points, [data.x + offset_value, data.y - offset_value])
                            }
                        }

                    } else {
                        if (this.model.fightType == 0) {
                            if (seaListy[id] && seaListy[id].hp == 0) {
                                //要塞被破坏，直接省略这个路径点
                            } else {
                                //防守方  如果要塞没被破坏，只能走传送阵
                                table.insert(points, this.GetDoorList(type, id))
                            }
                        } else {
                            //加入偏移
                            if (type == 1) {
                                table.insert(points, [data.x - offset_value, data.y + offset_value])
                            } else {
                                table.insert(points, [data.x + offset_value, data.y - offset_value])
                            }
                        }

                    }

                } else {
                    //加入偏移
                    if (type == 1) {
                        table.insert(points, [data.x - offset_value, data.y + offset_value])
                    } else {
                        table.insert(points, [data.x + offset_value, data.y - offset_value])
                    }
                }

            }

            return points
        }

        //查找导航区间 所有的位置点
        this.FineSectino = (chuizu_y, target_id, type) => {
            let i = 0
            let data
            let section_list = []
            let path_all = SeaHegemonyModel.towerPoslist
            if (type == 1) {
                //方向：哨塔外>海神城堡
                for (i = 0; i < path_all.length; i++) {
                    if (target_id == path_all[i]) {
                        table.insert(section_list, target_id)
                        break
                    }
                    data = this.GetTowerCfg(path_all[i])
                    //目标的垂足  用垂足进行判断 比较准确点
                    let t_y = this.model.GetPlayerChuizu(this.cfg, [data.x, data.y])
                    if (t_y > chuizu_y) continue
                    table.insert(section_list, path_all[i])
                }
            } else {
                //方向：海神城堡>哨塔外
                for (i = path_all.length - 1; i >= 0; i--) {
                    if (target_id == path_all[i]) {
                        table.insert(section_list, target_id)
                        break
                    }
                    data = this.GetTowerCfg(path_all[i])
                    //目标的垂足  用垂足进行判断 比较准确点
                    let t_y = this.model.GetPlayerChuizu(this.cfg, [data.x, data.y])
                    if (t_y < chuizu_y) continue
                    table.insert(section_list, path_all[i])
                }
            }

            //丢掉不是很重要的路径点  如果需要经过哨塔外到要塞外，直接丢掉哨塔外
            let filts_list = []
            for (i = 0; i < section_list.length; i++) {
                if (section_list[i] != target_id) {
                    if (this.IsYaoSai2(section_list[i])) {
                        table.insert(filts_list, section_list[i])
                    }
                } else {
                    table.insert(filts_list, section_list[i])
                }
            }

            return filts_list
        }




        //获取要塞对应的传送阵的路径  (49004地图为例)要塞内4900106对应传动阵19和传送阵20  根据寻路方向取值
        //is_bt 玩家是否位于目标下方  
        //要塞id  4900104 4900105 4900106
        //从上到下  19 20 21 22 23 24
        this.GetDoorList = (type, ys_id) => {
            let door_cfg_list = SceneManager.GetInstance().GetSceneDoors()
            if (!door_cfg_list || door_cfg_list.length == 0) return [[0, 0], [0, 0]]


            //每个要塞对应两个传送阵
            let index = ys_id % 10 - 4 //转成 0 1 2
            let temp_list
            let s
            let len

            index = 2 - index
            s = index * 2
            len = (index + 1) * 2
            temp_list = door_cfg_list.slice(s, len)


            //取方向
            let temp_index = type == 0 ? 0 : 1
            return [temp_list[temp_index].pixel_x, temp_list[temp_index].pixel_y]
        }

        //目标是否是要塞
        this.IsYaoSai2 = (id) => {
            let data = this.GetTowerCfg(id)
            return data.type == 2
        }

        //目标是否是海神城堡
        this.IsHaiShen = (id) => {
            let data = this.GetTowerCfg(id)
            return data.type == 3
        }

        this.GetTowerId = (id) => {
            let sceneId = SceneManager.GetInstance().GetSceneId()
            let key = id + "@" + sceneId
            return key
        }

        this.GetTowerCfg = (id) => {
            return this.model.GetTowerCfg(this.cfg, id)
        }

        this.StartFindWay = (target_id) => {
            found_array = []
            this.cur_path = this.FindBestPath(target_id)
            findWay()
        }


        //寻路盲区  判断玩家在盲区内还是盲区外
        //p 玩家位置[x,y]
        this.CheckSpacialArea = (block_area) => {
            let main_role = Scene.GetInstance().main_role
            if (!main_role) return []
            let p = [main_role.real_pos.x, main_role.real_pos.y]
            let angle = 0
            //[a-[3636, 4211], b-[6128, 5102], c-[4625, 6020]]   
            let a = block_area[0]
            let b = block_area[1]
            let c = block_area[2]
            angle += this.GetAngle(p, a, b)
            angle += this.GetAngle(p, a, c)
            angle += this.GetAngle(p, c, a)
            angle += this.GetAngle(p, c, b)
            angle += this.GetAngle(p, b, c)
            angle += this.GetAngle(p, b, a)
            //console.warn(`测试${Math.floor(angle)}`)
            return Math.floor(angle) >= 710
        }

        //点积  a[x,y]
        this.CalCos = (a, b) => {
            let dotProduct = a[0] * b[0] + a[1] * b[1];
            let d = Math.sqrt(a[0] * a[0] + a[1] * a[1]) * Math.sqrt(b[0] * b[0] + b[1] * b[1]);
            return dotProduct / d;
        }

        //c 原点 
        this.GetCosBy2pt = (c, a, b) => {
            let a1 = [a[0] - c[0], a[1] - c[1]];
            let b1 = [b[0] - c[0], b[1] - c[1]];
            return this.CalCos(a1, b1);
        }

        //c 原点 
        this.GetAngle = (c, a, b) => {
            const radian = this.GetCosBy2pt(c, a, b);
            let angle = Math.acos(radian) * 180 / Math.PI;

            angle = Math.abs(angle)
            return angle;
        }


        //代入直线方程  检查是否在线段的上方
        // this.CheckLine = (player_x,player_y) => {
        //     let data2 = this.GetTowerCfg(SeaHegemonyModel.towerPoslist[5])

        //     //两个基点
        //     let A = [4021,536]
        //     let B = [data2.x,data2.y]

        //     let k= (A[1]-B[1])/(A[0]-B[0])
        //     let b = A[1]-k*A[0]

        //     let y = k * player_x+b
        //     console.warn(y)
        //     return player_y>y
        // }

    }



    public DeleteMe() {
        this.list_init = null
        this.Dispose()
        super.DeleteMe()
    }



    _Group1: Laya.Box
    _image1: Laya.Image
    targetImg: Laya.Image
    _Image3: Laya.Image
    hpImg: Laya.Image
    hpLb: Laya.Label
    tarLb: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._Group1,
            this._image1,
            this.targetImg,
            this._Image3,
            this.hpImg,
            this.hpLb,
            this.tarLb,
        ]
            = this.GetChildrenByNames([

                "_Group1",
                "_image1",
                "targetImg",
                "_Image3",
                "hpImg",
                "hpLb",
                "tarLb",
            ])
    }
}
window["SeaSceneTargetItem"] = SeaSceneTargetItem