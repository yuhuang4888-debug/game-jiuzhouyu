import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { SceneManager } from "../scene/SceneManager"
import { TimeUtil } from "../util/TimeUtil"
import { GetSizeDeltaX, GlobalTimerQuest, Trim, Util } from "../util/Util"
import { Config } from "../common/Config";
import { SceneBaseType } from "../scene/SceneConfig"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"

export class SeaAssertTargetPanelItem extends BaseItemRenderer {
    cur_sorting_order
    effect
    is_attack
    lastBossId
    model
    progress_Width
    role_head
    showAttackEffect
    time
    timerId
    updateTimer

    WIDTH = 73
    HEIGT = 90

    timer1
    head1: CustomHeadItem
    circle_mask: Laya.Sprite

    public constructor() {
        super()
        this.progress_Width = 0
        this.time = 0
        this.model = SeaHegemonyModel.GetInstance()
        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertTargetPanelItem"

        this.load_callback = () => {
            this.InitMask()
            this.DrawMaskCircle(0)
            this.InitEvent()
            // this.cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
        }

        this.Load();


        this.updateTimer = () => {
            this.time = this.time - 1
            this._count_lb.text = TimeUtil.convertTime(this.time)
            if (this.time < 0) {
                //this.timer.stop()
                this._count_lb.visible = false
                this._progress_gp.visible = true
            }
        }
        this.is_attack = false
        this.showAttackEffect = (value?) => {
            if (value == this.is_attack) {
                return
            }
            this.is_attack = value
            if (value) {
                if (!this.effect) {
                    this.effect = true
                }
                // this.AddUIEffect("UI_2017", this._attack_effect_gp, null, null, true, { custom_sorting_order: this.cur_sorting_order, mask_id: 1 })
            } else {
                if (this.effect) {
                    // this.ClearUIEffect(this._attack_effect_gp)
                    this.effect = false
                }
            }
            if (this._attack_effect_gp.visible != value) {
                this._attack_effect_gp.visible = value
            }
        }
    }

    public InitEvent() {
        this.progress_Width = GetSizeDeltaX(this._progress_bar)
        this._gp_fighting.visible = false
        Util.AddClickEvent(this._gp_child, () => {
            if(this.data){
                this.model.Fire(SeaHegemonyModel.CHOSE_TARGET, this.data)
            }
        }, this, true)
    }

    public RemoveTimer() {

        if (this.timer1) {
            GlobalTimerQuest.CancelQuest(this.timer1)
            this.timer1 = null
            this.time = 0
        }
    }


    public dataChanged() {
        if (super.dataChanged()) {
            if (!this.data) return
            let data = this.data
            if (data._type && data._type == SceneBaseType.Monster || (!data._type && !data.role_id) && this.index == 0) {
                this._head.visible = false
                this._head_img.visible = true
                if (data._type) {
                    if (data.vo) {
                        this._name_lb.text = data.vo.name
                        this._lv_lb.text = "Lv." + data.vo.level
                        //SetSizeDeltaX(this._progress_mask,data.vo.hp / data.vo.maxHp * this.progress_width)
                        let source = ((data.vo.hp / data.vo.maxHp) <= 0.3) && "uizdpz_016a" || "uizdpz_016"
                        ResManager.GetInstance().SetImageSpriteTrans(this, this._progress_bar, GameResPath.GetIcon('seaHegemony', 'uizdpz_016a'))
                        this.DrawMaskCircle(data.vo.hp / data.vo.maxHp)
                        ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, GameResPath.GetMonsterHeadPath(data.vo.cfg_data.icon))
                    }
                    this._count_lb.visible = false
                    this._progress_gp.visible = true

                    this.RemoveTimer()
                    // this.ShowSufferedEffect(!this.is_attack && this.boss_scene_mgr.IsSuffered(data.id))
                } else {
                    this._name_lb.text = data.name

                    this._progress_gp.visible = false
                    if (this.lastBossId != data.vo.type_id) {
                        this.time = Math.max(data.reborn_time - TimeUtil.getServerTime(), 0)
                    } else {
                        this.time = this.time > 0 && this.time || Math.max(data.reborn_time - TimeUtil.getServerTime(), 0)
                    }
                    this._count_lb.visible = Boolean(this.time);
                    this._count_lb.text = TimeUtil.convertTime(this.time)


                    if (!this.timer1) {
                        let loop_func = () => {
                            this.time = this.time - 1
                            this._count_lb.text = TimeUtil.convertTime(this.time)
                            if (this.time < 0) {
                                this.RemoveTimer()
                                this._count_lb.visible = false
                                this._progress_gp.visible = true
                            }
                        }
                        this.timer1 = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
                        loop_func()
                    }
                    // this.ShowSufferedEffect(false)

                    let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.vo.type_id, false)
                    if (bossVo) {
                        //等级由服务端确定
                        if (data.mon_lv && data.mon_lv != 0) {
                            this._lv_lb.text = "Lv." + data.mon_lv
                        } else {
                            this._lv_lb.text = "Lv." + bossVo.lv
                        }
                        ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, GameResPath.GetMonsterHeadPath(bossVo.icon))
                    }
                    this.lastBossId = data.vo.type_id
                }
                this._gp_attribution.visible = false
            } else if (data && (data.vo_type && data.vo_type == SceneBaseType.Role)) {
                this._head.visible = true;
                this._head_img.visible = false;
                this._gp_attribution.visible = data.boss_flag == 1;
                let is_mask = data.mask_id != 0 && SceneManager.GetInstance().CanMaskScene();
                this._name_lb.text = is_mask && "蒙面人" || data.name;
                let lv = data.level > 370 && "神创" + ((data.level - 370)) || "Lv." + data.level;
                this._lv_lb.text = is_mask && "" || lv;
                this._count_lb.visible = false;
                this._progress_gp.visible = true;
                let source = ((data.hp / data.maxHp) <= 0.3) && "uizdpz_016a" || "uizdpz_016";
                let role = Scene.GetInstance().GetRole(data.role_id);
                let hpUrl = (role && role.vo.camp == RoleManager.GetInstance().GetMainRoleVo().camp) ? "uizdpz_016" : "uizdpz_016a";
                ResManager.GetInstance().SetImageSpriteTrans(this, this._progress_bar, GameResPath.GetIcon('seaHegemony', hpUrl))
                this.DrawMaskCircle(data.hp / data.maxHp)
                // let picture_source = data.career + "001"
                // let picture_id = data.picture
                // if (picture_id && Trim(String(picture_id)) != "") {
                //     let picture_cfg = Config.PRELOAD_SERVER_CONFIG.config_picture[picture_id]
                //     if (picture_cfg) {
                //         picture_source = picture_cfg.resource
                //     }
                // }
                // this.ShowBool(data)
                if (this.head1 == null) {
                    this.head1 = new CustomHeadItem(this._head)
                    this.head1.SetActiveFrame(false)
                    this.head1.SetActiveLevel(false)
                    this.head1.SetActiveBg(false)

                    this.head1.CloseClick()
                    this.head1.SetScale(0.75)
                    this.head1.Load()
                }
                this.head1.SetActiveBg(false)
                this.head1.SetRoleVoData(is_mask && { career: data.career } || data)
                this.head1.SetActiveBg2(false)


            } else if (data.role_id == RoleManager.GetInstance().GetMainRoleId()) {
                this._head.visible = true
                this._head_img.visible = false
                this._gp_attribution.visible = data.boss_flag == 1

                let is_mask = data.mask_id != 0 && SceneManager.GetInstance().CanMaskScene()
                this._name_lb.text = is_mask && "蒙面人(自己)" || data.name

                let lv = data.level > 370 && "神创" + (data.level - 370) || "Lv." + data.level
                this._lv_lb.text = is_mask && "" || lv
                this._count_lb.visible = false
                this._progress_gp.visible = true
                let source = ((data.hp / data.maxHp) <= 0.3) && "uizdpz_016a" || "uizdpz_016";
                let hpUrl = data._type == SceneBaseType.MainRole ? "uizdpz_016" : "uizdpz_016a";
                ResManager.GetInstance().SetImageSpriteTrans(this, this._progress_bar, GameResPath.GetIcon('seaHegemony', hpUrl))
                this.DrawMaskCircle(data.hp / data.maxHp)
                // let picture_source = data.career + "001"
                // let picture_id = data.picture
                // if (picture_id && Trim(String(picture_id)) != "") {
                //     let picture_cfg = Config.PRELOAD_SERVER_CONFIG.config_picture[Number(picture_id)]
                //     if (picture_cfg) {
                //         picture_source = picture_cfg.resource
                //     }
                // }
                //lua_resM:SetOutsideImageSprite(this, this._head_img, GameResPath.GetIcon("head",picture_source))
                // this.ShowBool(data)
                if (this.head1 == null) {
                    this.head1 = new CustomHeadItem(this._head)
                    this.head1.SetScale(0.75)
                    this.head1.Load()
                }
                this.head1.SetRoleVoData(data)
                this.head1.SetActiveBg(false)
                this.head1.CloseClick()
                this.head1.ExcuteCallback(() => {
                    this.head1.SetActiveBg(false)
                    this.head1.SetActiveFrame(false)
                    this.head1.SetActiveLevel(false)
                    this.head1.SetScale(0.75)
                })
            }
            if (this.head1) {
                this.head1.SetActiveLevel(false)
                this.head1.SetPosition(-3, -4)
            }

            // let boo = data == this.boss_scene_mgr.GetAttackTarget() && !this.boss_scene_mgr.GetAttackTarget().is_dead
            // this.ShowAttackEffect(boo)
        }

    }

  /*   public ShowBool(data?) {

        let canAttack = SceneManager.GetInstance().IsCanAttackByMainRole(data.vo, false)
        if (canAttack) {
            ResManager.GetInstance().SetImageSprite(this, this._progress_bar, 'boss', "uizdpz_016a")
        } else {
            ResManager.GetInstance().SetImageSprite(this, this._progress_bar, 'boss', "uizdpz_016")
        }
    } */


    // public dataChanged() {
    //     if (super.dataChanged()) {
    //         if (!this.data) { return }

    //         if (this.timerId) {
    //             GlobalTimerQuest.CancelQuest(this.timerId)
    //             this.timerId = null
    //         }
    //         let vo = this.data
    //         let showLock = false
    //         if (this.role_head) {
    //             this.role_head.SetVisible(false)
    //         }
    //         // if (!vo._type) {
    //         //     let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, vo.vo.type_id, false)
    //         //     this._name_lb.text = bossVo.name
    //         //     this._lv_lb.text = ""
    //         //     this._progress_gp.visible = false
    //         //     this._count_lb.visible = true
    //         //     if (this.lastBossId != vo.vo.type_id) {
    //         //         this.time = Mathf.Max(vo.reborn_time - TimeUtil.getServerTime(), 0)
    //         //     } else {
    //         //         // [ts2lua]lua中0和空字符串也是true，此处this.time > 0需要确认
    //         //         this.time = this.time > 0 ? (this.time) : (Mathf.Max(vo.reborn_time - TimeUtil.getServerTime(), 0))
    //         //     }
    //         //     this._count_lb.text = TimeUtil.convertTime(this.time)
    //         //     if (!this.timerId) {
    //         //         this.timerId = GlobalTimerQuest.AddPeriodQuest(() => {
    //         //             this.updateTimer()
    //         //         }, 1)
    //         //     }
    //         //     // this.showSufferedEffect(false)
    //         //     let icon = bossVo && bossVo.icon
    //         //     if (icon) {
    //         //         ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, "resource/game/monsterHead/" + bossVo.icon + ".png")
    //         //     }
    //         //     this.lastBossId = vo.vo.type_id
    //         //     this._gp_attribution.visible = false
    //         // }
    //         // else
    //         if (vo._type == SceneBaseType.Monster) {


    //             if (this.lastBossId != vo.vo.type_id) {
    //                 this.time = Mathf.Max(vo.reborn_time - TimeUtil.getServerTime(), 0)
    //             } else {
    //                 // [ts2lua]lua中0和空字符串也是true，此处this.time > 0需要确认
    //                 this.time = this.time > 0 ? (this.time) : (Mathf.Max(vo.reborn_time - TimeUtil.getServerTime(), 0))
    //             }


    //             {
    //                 let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, vo.vo.type_id, false)
    //                 this._name_lb.text = bossVo.name
    //                 this._lv_lb.text = ""
    //                 this._progress_gp.visible = false
    //                 this._count_lb.visible = true
    //                 if (this.lastBossId != vo.vo.type_id) {
    //                     this.time = Mathf.Max(vo.reborn_time - TimeUtil.getServerTime(), 0)
    //                 } else {
    //                     // [ts2lua]lua中0和空字符串也是true，此处this.time > 0需要确认
    //                     this.time = this.time > 0 ? (this.time) : (Mathf.Max(vo.reborn_time - TimeUtil.getServerTime(), 0))
    //                 }
    //                 this._count_lb.text = TimeUtil.convertTime(this.time)
    //                 if (!this.timerId) {
    //                     this.timerId = GlobalTimerQuest.AddPeriodQuest(() => {
    //                         this.updateTimer()
    //                     }, 1)
    //                 }
    //                 // this.showSufferedEffect(false)
    //                 let icon = bossVo && bossVo.icon
    //                 if (icon) {
    //                     ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, "resource/game/monsterHead/" + bossVo.icon + ".png")
    //                 }
    //                 this.lastBossId = vo.vo.type_id
    //                 this._gp_attribution.visible = false
    //             }


    //             {
    //                 this._name_lb.text = vo.name
    //                 this._lv_lb.text = ""
    //                 //this._progress_bar.width = vo.hp / vo.maxHp * this.progress_Width
    //                 //SetSizeDeltaX(this._progress_bar, vo.hp / vo.maxHp * this.progress_Width)
    //                 this._progress_bar.width = vo.hp / vo.maxHp
    //                 this._count_lb.visible = false
    //                 this._progress_gp.visible = true
    //                 this.UpdateHpState(vo)

    //                 ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, "resource/game/monsterHead/" + vo.vo.monster_res + ".png")
    //                 // TODO dxj 未移植
    //                 //this.showSufferedEffect(! this.is_attack && this.secret.isSuffered(vo.instance_id))
    //                 this._gp_attribution.visible = false
    //             }



    //         }
    //         else if (vo._type == SceneBaseType.Role) {
    //             this._gp_attribution.visible = vo.boss_flag == 1
    //             this._name_lb.text = vo.name
    //             if (vo.level > 370) {
    //                 this._lv_lb.text = "神创" + (vo.level - 370)
    //             } else {
    //                 this._lv_lb.text = "Lv." + vo.level
    //             }
    //             this._count_lb.visible = false
    //             this._progress_gp.visible = true
    //             //this._progress_bar.width = vo.hp / vo.maxHp * this.progress_Width
    //             //SetSizeDeltaX(this._progress_bar, vo.hp / vo.maxHp * this.progress_Width)
    //             this._progress_bar.width = vo.hp / vo.maxHp

    //             if (!this.role_head) {
    //                 this.role_head = new CustomHeadItem(this._head)
    //                 this.role_head.SetActiveFrame(false)
    //                 this.role_head.SetActiveLevel(false)
    //                 this.role_head.CloseClick()
    //                 this.role_head.SetScale(0.65)
    //                 this.role_head.Load()
    //             }
    //             this.role_head.SetRoleVoData(vo)
    //             this.role_head.SetVisible(true)

    //             let attack_bool = !this.is_attack
    //             this.UpdateHpState(vo)
    //         }

    //         let curr_attack_target = Scene.GetInstance().GetClickTarget() //SceneManager:GetInstance().curr_attack_target
    //         let auto_state = AutoFightManager.GetInstance().GetAutoFightState()
    //         // [ts2lua]lua中0和空字符串也是true，此处auto_state && curr_attack_target需要确认
    //         let bool = (auto_state && curr_attack_target && (curr_attack_target.GetVo() == vo && vo.hp != 0) || (false))
    //         this.showAttackEffect(bool)
    //     }


    // }

    public DrawMaskCircle(angle) {
        angle = 1 - angle
        let value = 90
        this.circle_mask.graphics.clear();
        this.circle_mask.graphics.drawPie(0, 0, 50, value, 360 + value - angle * 360, 0x000000)
    }

    public InitMask() {
        this.circle_mask = new Laya.Sprite()
        this.circle_mask.x = this._progress_bar.width / 2
        this.circle_mask.y = this._progress_bar.height / 2
        this._progress_bar.mask = this.circle_mask
    }

    public DeleteMe() {

        if (this.timerId) {
            GlobalTimerQuest.CancelQuest(this.timerId)
            this.timerId = null
            this.time = 0
        }
        if (this.role_head) {
            this.role_head.DeleteMe()
            this.role_head = null
        }

        this.RemoveTimer()
        if (this.head1) {
            this.head1.DeleteMe()
            this.head1 = null
        }

        if (this.circle_mask) {
            this.circle_mask.removeSelf()
            this.circle_mask.destroy()
            this.circle_mask = null
        }

        super.DeleteMe();
    }



    _gp_child: Laya.Box
    _gp_state: Laya.Box
    _lb_state: Laya.Label
    _Group1: Laya.Box
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Imag: Laya.Image
    _head_img: Laya.Image
    _head: Laya.Box
    _count_lb: Laya.Label
    _progress_gp: Laya.Box
    _Image3: Laya.Image
    _progress_bar: Laya.Image
    _lv_lb: Laya.Label
    _name_lb: Laya.Label
    _gp_attribution: Laya.Image
    seaTypeGp: Laya.Box
    seaTypeImg: Laya.Image
    seaTypeLb: Laya.Label
    _gp_fighting: Laya.Box
    _Image4: Laya.Image
    _bl_fighting: Laya.Label
    _suffer_effect_gp: Laya.Box
    _attack_effect_gp: Laya.Box
    public GetComponents() {
        [
            this._gp_child,
            this._gp_state,
            this._lb_state,
            this._Group1,
            this._Image1,
            this._Image2,
            this._Imag,
            this._head_img,
            this._head,
            this._count_lb,
            this._progress_gp,
            this._Image3,
            this._progress_bar,
            this._lv_lb,
            this._name_lb,
            this._gp_attribution,
            this.seaTypeGp,
            this.seaTypeImg,
            this.seaTypeLb,
            this._gp_fighting,
            this._Image4,
            this._bl_fighting,
            this._suffer_effect_gp,
            this._attack_effect_gp,
        ]
            = this.GetChildrenByNames([

                "_gp_child",
                "_gp_state",
                "_lb_state",
                "_Group1",
                "_Image1",
                "_Image2",
                "_Imag",
                "_head_img",
                "_head",
                "_count_lb",
                "_progress_gp",
                "_Image3",
                "_progress_bar",
                "_lv_lb",
                "_name_lb",
                "_gp_attribution",
                "seaTypeGp",
                "seaTypeImg",
                "seaTypeLb",
                "_gp_fighting",
                "_Image4",
                "_bl_fighting",
                "_suffer_effect_gp",
                "_attack_effect_gp",
            ])
    }
}
window["SeaAssertTargetPanelItem"] = SeaAssertTargetPanelItem